/// Built-in content: task cards, routine icons and collectible stickers.
///
/// Artwork is Twemoji (CC-BY 4.0), copied into `assets/` under these ids.
/// `tool/asset_map.json` records which emoji each file came from.
library;

enum CardGroup { morning, school, care, home }

class BuiltInCard {
  const BuiltInCard(this.id, this.group, {required this.en, required this.vi});

  final String id;
  final CardGroup group;
  final String en;
  final String vi;

  String get asset => 'assets/cards/$id.svg';

  String label(String languageCode) => languageCode == 'vi' ? vi : en;
}

const List<BuiltInCard> builtInCards = [
  // Morning
  BuiltInCard('wake_up', CardGroup.morning, en: 'Wake up', vi: 'Thức dậy'),
  BuiltInCard(
    'make_bed',
    CardGroup.morning,
    en: 'Make the bed',
    vi: 'Dọn giường',
  ),
  BuiltInCard(
    'toilet',
    CardGroup.morning,
    en: 'Use the toilet',
    vi: 'Đi vệ sinh',
  ),
  BuiltInCard(
    'brush_teeth',
    CardGroup.morning,
    en: 'Brush teeth',
    vi: 'Đánh răng',
  ),
  BuiltInCard('wash_face', CardGroup.morning, en: 'Wash face', vi: 'Rửa mặt'),
  BuiltInCard(
    'get_dressed',
    CardGroup.morning,
    en: 'Get dressed',
    vi: 'Thay quần áo',
  ),
  BuiltInCard('comb_hair', CardGroup.morning, en: 'Comb hair', vi: 'Chải tóc'),
  BuiltInCard(
    'breakfast',
    CardGroup.morning,
    en: 'Eat breakfast',
    vi: 'Ăn sáng',
  ),
  BuiltInCard(
    'drink_milk',
    CardGroup.morning,
    en: 'Drink milk',
    vi: 'Uống sữa',
  ),

  // School
  BuiltInCard('pack_bag', CardGroup.school, en: 'Pack my bag', vi: 'Soạn cặp'),
  BuiltInCard(
    'put_on_shoes',
    CardGroup.school,
    en: 'Put on shoes',
    vi: 'Mang giày',
  ),
  BuiltInCard('wear_hat', CardGroup.school, en: 'Put on a hat', vi: 'Đội mũ'),
  BuiltInCard(
    'go_to_school',
    CardGroup.school,
    en: 'Go to school',
    vi: 'Đi học',
  ),
  BuiltInCard(
    'homework',
    CardGroup.school,
    en: 'Do homework',
    vi: 'Làm bài tập',
  ),
  BuiltInCard('read_book', CardGroup.school, en: 'Read a book', vi: 'Đọc sách'),
  BuiltInCard('draw', CardGroup.school, en: 'Draw a picture', vi: 'Vẽ tranh'),
  BuiltInCard(
    'practice_music',
    CardGroup.school,
    en: 'Practice music',
    vi: 'Tập đàn',
  ),
  BuiltInCard('say_hello', CardGroup.school, en: 'Say hello', vi: 'Chào hỏi'),

  // Meals & care
  BuiltInCard('wash_hands', CardGroup.care, en: 'Wash hands', vi: 'Rửa tay'),
  BuiltInCard('eat_lunch', CardGroup.care, en: 'Eat lunch', vi: 'Ăn trưa'),
  BuiltInCard('eat_dinner', CardGroup.care, en: 'Eat dinner', vi: 'Ăn tối'),
  BuiltInCard('eat_fruit', CardGroup.care, en: 'Eat fruit', vi: 'Ăn trái cây'),
  BuiltInCard(
    'drink_water',
    CardGroup.care,
    en: 'Drink water',
    vi: 'Uống nước',
  ),
  BuiltInCard('take_bath', CardGroup.care, en: 'Take a bath', vi: 'Tắm'),
  BuiltInCard('wash_hair', CardGroup.care, en: 'Wash hair', vi: 'Gội đầu'),
  BuiltInCard(
    'take_medicine',
    CardGroup.care,
    en: 'Take medicine',
    vi: 'Uống thuốc',
  ),
  BuiltInCard('nap', CardGroup.care, en: 'Take a nap', vi: 'Ngủ trưa'),

  // Home & bedtime
  BuiltInCard(
    'tidy_toys',
    CardGroup.home,
    en: 'Tidy up toys',
    vi: 'Dọn đồ chơi',
  ),
  BuiltInCard(
    'water_plants',
    CardGroup.home,
    en: 'Water the plants',
    vi: 'Tưới cây',
  ),
  BuiltInCard(
    'feed_pet',
    CardGroup.home,
    en: 'Feed the pet',
    vi: 'Cho thú cưng ăn',
  ),
  BuiltInCard(
    'set_table',
    CardGroup.home,
    en: 'Set the table',
    vi: 'Dọn bàn ăn',
  ),
  BuiltInCard(
    'laundry_basket',
    CardGroup.home,
    en: 'Laundry in the basket',
    vi: 'Bỏ đồ vào giỏ',
  ),
  BuiltInCard(
    'play_outside',
    CardGroup.home,
    en: 'Play outside',
    vi: 'Chơi ngoài trời',
  ),
  BuiltInCard('exercise', CardGroup.home, en: 'Exercise', vi: 'Tập thể dục'),
  BuiltInCard(
    'screen_time',
    CardGroup.home,
    en: 'Screen time',
    vi: 'Xem ti vi',
  ),
  BuiltInCard(
    'story_time',
    CardGroup.home,
    en: 'Story time',
    vi: 'Nghe kể chuyện',
  ),
  BuiltInCard('hug', CardGroup.home, en: 'Give a hug', vi: 'Ôm ba mẹ'),
  BuiltInCard(
    'turn_off_light',
    CardGroup.home,
    en: 'Lights off',
    vi: 'Tắt đèn',
  ),
  BuiltInCard('go_to_sleep', CardGroup.home, en: 'Go to sleep', vi: 'Đi ngủ'),
];

final Map<String, BuiltInCard> builtInCardsById = {
  for (final card in builtInCards) card.id: card,
};

List<BuiltInCard> builtInCardsIn(CardGroup group) => [
  for (final card in builtInCards)
    if (card.group == group) card,
];

/// Icons a parent can give a routine.
const List<String> routineIconIds = [
  'sun',
  'moon',
  'school',
  'house',
  'star',
  'rainbow',
  'rocket',
  'balloon',
];

const String defaultRoutineIconId = 'star';

String routineIconAsset(String iconId) => routineIconIds.contains(iconId)
    ? 'assets/icons/$iconId.svg'
    : 'assets/icons/$defaultRoutineIconId.svg';

/// An animal friend a child collects by finishing a routine.
class Sticker {
  const Sticker(this.id, {required this.en, required this.vi});

  final String id;
  final String en;
  final String vi;

  String get asset => 'assets/stickers/$id.svg';

  String label(String languageCode) => languageCode == 'vi' ? vi : en;
}

const List<Sticker> stickers = [
  Sticker('dog', en: 'Puppy', vi: 'Chó con'),
  Sticker('cat', en: 'Kitten', vi: 'Mèo con'),
  Sticker('rabbit', en: 'Bunny', vi: 'Thỏ'),
  Sticker('panda', en: 'Panda', vi: 'Gấu trúc'),
  Sticker('fox', en: 'Fox', vi: 'Cáo'),
  Sticker('bear', en: 'Bear', vi: 'Gấu'),
  Sticker('koala', en: 'Koala', vi: 'Koala'),
  Sticker('tiger', en: 'Tiger', vi: 'Hổ'),
  Sticker('lion', en: 'Lion', vi: 'Sư tử'),
  Sticker('cow', en: 'Cow', vi: 'Bò'),
  Sticker('pig', en: 'Piggy', vi: 'Heo'),
  Sticker('frog', en: 'Frog', vi: 'Ếch'),
  Sticker('monkey', en: 'Monkey', vi: 'Khỉ'),
  Sticker('chick', en: 'Chick', vi: 'Gà con'),
  Sticker('penguin', en: 'Penguin', vi: 'Chim cánh cụt'),
  Sticker('owl', en: 'Owl', vi: 'Cú mèo'),
  Sticker('unicorn', en: 'Unicorn', vi: 'Kỳ lân'),
  Sticker('turtle', en: 'Turtle', vi: 'Rùa'),
  Sticker('dolphin', en: 'Dolphin', vi: 'Cá heo'),
  Sticker('whale', en: 'Whale', vi: 'Cá voi'),
  Sticker('butterfly', en: 'Butterfly', vi: 'Bướm'),
  Sticker('ladybug', en: 'Ladybug', vi: 'Bọ rùa'),
  Sticker('dinosaur', en: 'Dinosaur', vi: 'Khủng long'),
  Sticker('elephant', en: 'Elephant', vi: 'Voi'),
];

final Map<String, Sticker> stickersById = {
  for (final sticker in stickers) sticker.id: sticker,
};
