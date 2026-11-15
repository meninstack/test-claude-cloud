import 'package:flutter_test/flutter_test.dart';
import 'package:little_steps/data/app_repository.dart';
import 'package:little_steps/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  const data = AppData(
    routines: [
      Routine(
        id: 'r1',
        name: 'Buổi sáng',
        iconId: 'sun',
        items: [RoutineItem(id: 'i1', cardId: 'brush_teeth')],
      ),
    ],
    progress: DayProgress(
      date: '2026-11-14',
      done: {
        'r1': {'i1'},
      },
      rewarded: {'r1'},
    ),
    stickers: ['panda'],
    totalStars: 1,
  );

  test('has nothing to load on first launch', () async {
    final repository = await PrefsAppRepository.open();

    expect(repository.load(), isNull);
  });

  test('loads what was saved after the app restarts', () async {
    await (await PrefsAppRepository.open()).save(data);

    final restored = (await PrefsAppRepository.open()).load()!;

    expect(restored.routines.single.name, 'Buổi sáng');
    expect(restored.routines.single.items.single.cardId, 'brush_teeth');
    expect(restored.isDone('r1', 'i1'), isTrue);
    expect(restored.progress.rewarded, {'r1'});
    expect(restored.stickers, ['panda']);
    expect(restored.totalStars, 1);
  });

  test('starts fresh when the stored document is damaged', () async {
    await SharedPreferencesAsync().setString(
      PrefsAppRepository.storageKey,
      '{"routines": [{"id": 7',
    );

    final repository = await PrefsAppRepository.open();

    expect(repository.load(), isNull);
  });

  test('starts fresh when the stored document has the wrong shape', () async {
    await SharedPreferencesAsync().setString(
      PrefsAppRepository.storageKey,
      '{"routines": "not a list"}',
    );

    final repository = await PrefsAppRepository.open();

    expect(repository.load(), isNull);
  });
}
