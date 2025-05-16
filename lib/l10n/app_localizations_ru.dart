// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get about => 'О приложении';

  @override
  String get appTitle => 'Дневник питания';

  @override
  String get credits => 'Авторы';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get developers => 'Разработано Рахметовой Улданой и Сыздыковой Маликой в рамках курса \"Кроссплатформенная разработка\" в Astana IT University.\n\nПреподаватель: Ассистент-профессор Абзал Кызырканов';

  @override
  String get english => 'Английский';

  @override
  String get foodDiaryApp => 'Приложение Дневник Питания';

  @override
  String get foodDiaryDescription => 'Приложение помогает пользователям отслеживать, что они едят в течение дня. Оно способствует осознанному питанию и поддержанию здорового образа жизни.';

  @override
  String get kazakh => 'Казахский';

  @override
  String get language => 'Язык';

  @override
  String get russian => 'Русский';

  @override
  String get settings => 'Настройки';

  @override
  String get addMeal => 'Добавить блюдо';

  @override
  String get mealName => 'Название блюда';

  @override
  String get kcal => 'Калории';

  @override
  String get pickTime => 'Выбрать время';

  @override
  String get pickImage => 'Выбрать изображение';

  @override
  String get fillFieldsError => '⚠ Пожалуйста, заполните все поля';

  @override
  String get save => 'Сохранить';

  @override
  String get greeting => 'Привет, Малика и Дана 👋';

  @override
  String get home => 'Главная';

  @override
  String get todaysMeals => 'Блюда на сегодня';

  @override
  String get noMealsToday => 'Сегодня нет блюд';
  @override
  String get login => 'Войти';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  // TODO: implement email
  String get email => throw UnimplementedError();

  @override
  // TODO: implement password
  String get password => throw UnimplementedError();

}
