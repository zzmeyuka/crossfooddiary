// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get about => 'О Приложении';

  @override
  String get appTitle => 'Дневник Питания';

  @override
  String get credits => 'Авторы';

  @override
  String get darkMode => 'Тёмная Тема';

  @override
  String get developers => 'Разработано Рахметовой Ульданой и Сыздыковой Маликой в рамках курса \"Кроссплатформенная разработка\" в Astana IT University.\n\nПреподаватель: Ассистент-профессор Абзал Кызырканов';

  @override
  String get english => 'Английский';

  @override
  String get foodDiaryApp => 'Приложение Дневник Питания';

  @override
  String get foodDiaryDescription => 'Приложение помогает пользователям отслеживать, что они едят в течение дня. Оно способствует осознанному питанию и поддержке здорового образа жизни.';

  @override
  String get kazakh => 'Казахский';

  @override
  String get language => 'Язык';

  @override
  String get russian => 'Русский';

  @override
  String get todaysMeals => 'Приёмы пищи сегодня';

  @override
  String get noMealsToday => 'Сегодня приёмов пищи не было';

  @override
  String get settings => 'Настройки';
}
