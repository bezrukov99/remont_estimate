// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Сметочка';

  @override
  String get defaultProjectName => 'Мой ремонт';

  @override
  String get export => 'Экспорт';

  @override
  String get projectSettings => 'Настройки проекта';

  @override
  String projectsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count проекта',
      many: '$count проектов',
      few: '$count проекта',
      one: '1 проект',
    );
    return '$_temp0';
  }

  @override
  String get myProjects => 'Мои проекты';

  @override
  String get myProjectsHint => 'Ведите сметы для разных квартир или домов.';

  @override
  String get newProject => 'Новый проект';

  @override
  String get newProjectHint => 'например, Дача';

  @override
  String get enterProjectName => 'Введите название проекта';

  @override
  String get create => 'Создать';

  @override
  String deleteProjectTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get deleteProjectMessage =>
      'Будут удалены все комнаты, материалы и данные бюджета этого проекта.';

  @override
  String projectSummary(int rooms, int materials, String spent) {
    return '$rooms комн. · $materials мат. · $spent';
  }

  @override
  String get projectName => 'Название проекта';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get currency => 'Валюта';

  @override
  String get targetBudget => 'Целевой бюджет';

  @override
  String get exportPdfExcel => 'Экспорт PDF / Excel';

  @override
  String get save => 'Сохранить';

  @override
  String get resetAllData => 'Сбросить все данные';

  @override
  String get resetProjectTitle => 'Сбросить проект?';

  @override
  String get resetProjectMessage =>
      'Будут удалены все комнаты, материалы и данные бюджета. Это действие нельзя отменить.';

  @override
  String get cancel => 'Отмена';

  @override
  String get reset => 'Сбросить';

  @override
  String get materialsTotal => 'Сумма материалов';

  @override
  String get totalSpent => 'Потрачено';

  @override
  String get editBudget => 'Изменить бюджет';

  @override
  String get setBudget => 'Задать бюджет';

  @override
  String ofTarget(String amount) {
    return 'из $amount цели';
  }

  @override
  String overBudgetBy(String amount) {
    return 'Превышение на $amount';
  }

  @override
  String percentRemaining(String percent) {
    return 'осталось $percent%';
  }

  @override
  String get setBudgetHint =>
      'Нажмите «Задать бюджет», чтобы отслеживать лимит ремонта';

  @override
  String get rooms => 'Комнаты';

  @override
  String get add => 'Добавить';

  @override
  String get addRoomFirstSnack => 'Сначала добавьте комнату, затем материалы';

  @override
  String get noRoomsYet => 'Пока нет комнат';

  @override
  String get noRoomsHint => 'Начните с комнат: кухня,\nванная, гостиная.';

  @override
  String get addFirstRoom => 'Добавить первую комнату';

  @override
  String get targetBudgetTitle => 'Целевой бюджет';

  @override
  String get budgetAmount => 'Сумма бюджета';

  @override
  String get budgetAmountHint => 'например, 1500000';

  @override
  String get saveBudget => 'Сохранить бюджет';

  @override
  String get removeBudgetLimit => 'Убрать лимит бюджета';

  @override
  String get enterValidBudget => 'Введите корректную сумму бюджета';

  @override
  String get editRoom => 'Редактировать комнату';

  @override
  String get addRoom => 'Добавить комнату';

  @override
  String get roomName => 'Название комнаты';

  @override
  String get roomNameHint => 'например, Кухня';

  @override
  String get icon => 'Иконка';

  @override
  String get saveRoom => 'Сохранить комнату';

  @override
  String get enterRoomName => 'Введите название комнаты';

  @override
  String get quickAdd => 'Быстрое добавление';

  @override
  String get addMaterial => 'Добавить материал';

  @override
  String get addMaterialSubtitle => 'Плитка, краска, сантехника…';

  @override
  String get addRoomSubtitle => 'Кухня, ванная, спальня…';

  @override
  String get exportEstimate => 'Экспорт сметы';

  @override
  String materialsAcrossRooms(int materials, int rooms) {
    return '$materials материалов в $rooms комнатах';
  }

  @override
  String get addRoomsToExport => 'Добавьте комнаты для экспорта';

  @override
  String get exportPdf => 'Экспорт PDF';

  @override
  String get exportPdfSubtitle => 'Отчёт A4 с фото и итогами по комнатам';

  @override
  String get exportExcel => 'Экспорт Excel';

  @override
  String get exportExcelSubtitle => '.xlsx с формулами для рабочих';

  @override
  String get addRoomBeforeExport =>
      'Добавьте хотя бы одну комнату перед экспортом.';

  @override
  String exportFailed(String error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String get pdfReady => 'PDF готов';

  @override
  String get excelReady => 'Excel готов';

  @override
  String get share => 'Поделиться';

  @override
  String get openFile => 'Открыть файл';

  @override
  String get openFileFailed =>
      'Не удалось открыть файл. Нажмите «Поделиться», чтобы отправить в другое приложение.';

  @override
  String get openingFile => 'Открываем…';

  @override
  String get saveToGallery => 'Сохранить в галерею';

  @override
  String get photoSavedToGallery => 'Фото сохранено в галерею';

  @override
  String get photoShared => 'Открыто меню «Поделиться»';

  @override
  String photoActionFailed(String error) {
    return 'Не удалось выполнить действие: $error';
  }

  @override
  String get addRoomBeforeMaterials =>
      'Сначала добавьте комнату, затем материалы.';

  @override
  String get editMaterial => 'Редактировать материал';

  @override
  String get materialName => 'Название материала';

  @override
  String get materialNameHint => 'например, Керамическая плитка';

  @override
  String get dimensionsOptional => 'Размеры (необязательно)';

  @override
  String get dimensionsHint => 'например, 120×60 см';

  @override
  String get materialDetails => 'Данные о товаре';

  @override
  String get materialBrand => 'Бренд';

  @override
  String get materialBrandHint => 'например, Kerama Marazzi';

  @override
  String get materialArticle => 'Артикул';

  @override
  String get materialArticleHint => 'например, KM-12345';

  @override
  String get materialStore => 'Магазин';

  @override
  String get materialStoreHint => 'например, Леруа Мерлен';

  @override
  String get materialArticleShort => 'арт.';

  @override
  String get quantityAndUnit => 'Количество и единица';

  @override
  String pricePerUnit(String unit) {
    return 'Цена за $unit';
  }

  @override
  String get totalPrice => 'Итоговая цена';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get saveMaterial => 'Сохранить материал';

  @override
  String get deleteMaterial => 'Удалить материал';

  @override
  String get deleteMaterialTitle => 'Удалить материал?';

  @override
  String get deleteMaterialMessage => 'Это действие нельзя отменить.';

  @override
  String selectedMaterialsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count',
      many: 'Выбрано $count',
      few: 'Выбрано $count',
      one: 'Выбран 1',
      zero: 'Ничего не выбрано',
    );
    return '$_temp0';
  }

  @override
  String deleteMaterialsTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить $count материала?',
      many: 'Удалить $count материалов?',
      few: 'Удалить $count материала?',
      one: 'Удалить 1 материал?',
    );
    return '$_temp0';
  }

  @override
  String get deleteMaterialsMessage =>
      'Выбранные материалы будут удалены без возможности восстановления.';

  @override
  String get delete => 'Удалить';

  @override
  String get room => 'Комната';

  @override
  String get selectRoom => 'Выберите комнату';

  @override
  String get enterMaterialName => 'Введите название материала';

  @override
  String get enterValidPrice => 'Введите корректную цену за единицу';

  @override
  String get quantityMustBePositive => 'Количество должно быть больше нуля';

  @override
  String couldNotLoadImage(String error) {
    return 'Не удалось загрузить изображение: $error';
  }

  @override
  String get materialPhotos => 'Фото';

  @override
  String materialPhotosHint(int max) {
    return 'До $max фото с камеры или из галереи';
  }

  @override
  String photosCount(int count, int max) {
    return '$count из $max';
  }

  @override
  String maxPhotosReached(int max) {
    return 'Не больше $max фото на материал';
  }

  @override
  String get tapToChangePhoto => 'Нажмите, чтобы сменить фото';

  @override
  String get tapToAddPhoto => 'Нажмите, чтобы сделать фото';

  @override
  String get cameraOrGallery => 'Камера или галерея';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get removePhoto => 'Удалить фото';

  @override
  String get roomNotFound => 'Комната не найдена';

  @override
  String get materialPurchased => 'Куплено';

  @override
  String get materials => 'Материалы';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позиции',
      many: '$count позиций',
      few: '$count позиции',
      one: '1 позиция',
      zero: 'Пока нет материалов',
    );
    return '$_temp0';
  }

  @override
  String get noMaterialsYet => 'Пока нет материалов';

  @override
  String get roomSubtotal => 'Итого по комнате';

  @override
  String get roomPurchasedSubtotal => 'Потрачено по комнате';

  @override
  String materialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count материала',
      many: '$count материалов',
      few: '$count материала',
      one: '1 материал',
    );
    return '$_temp0';
  }

  @override
  String get noMaterialsInRoom => 'В этой комнате нет материалов';

  @override
  String get noMaterialsInRoomHint =>
      'Нажмите +, чтобы добавить плитку, краску или сантехнику';

  @override
  String get addMaterialFab => 'Добавить материал';

  @override
  String deleteRoomTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get deleteRoomMessage =>
      'Все материалы в этой комнате также будут удалены.';

  @override
  String get roomKitchen => 'Кухня';

  @override
  String get roomBathroom => 'Ванная';

  @override
  String get roomLivingRoom => 'Гостиная';

  @override
  String get roomBedroom => 'Спальня';

  @override
  String get roomHallway => 'Коридор';

  @override
  String get roomBalcony => 'Балкон';

  @override
  String get roomOther => 'Другое';

  @override
  String get exportRenovationReport => 'Сметочка — смета ремонта';

  @override
  String exportProject(String name) {
    return 'Проект: $name';
  }

  @override
  String exportGenerated(String date) {
    return 'Создано: $date';
  }

  @override
  String exportMaterialsTotal(String amount) {
    return 'Сумма материалов: $amount';
  }

  @override
  String exportPurchasedTotal(String amount) {
    return 'Потрачено (куплено): $amount';
  }

  @override
  String exportRoomPurchased(String amount) {
    return 'Потрачено: $amount';
  }

  @override
  String exportTargetBudget(String amount) {
    return 'Целевой бюджет: $amount';
  }

  @override
  String get exportBudgetSummary => 'Сводка по бюджету';

  @override
  String get exportGrandTotal => 'Итого';

  @override
  String get exportGrandTotalSpent => 'Потрачено';

  @override
  String exportPageOf(int page, int total) {
    return 'Стр. $page из $total';
  }

  @override
  String get exportNoMaterialsInRoom => 'В комнате нет материалов';

  @override
  String get exportNoRoomsYet => 'Комнаты ещё не добавлены';

  @override
  String get exportNoMaterials => 'Нет материалов';

  @override
  String get exportRoomSubtotal => 'Итого по комнате';

  @override
  String get exportColMaterial => 'Материал';

  @override
  String get exportColBrand => 'Бренд';

  @override
  String get exportColArticle => 'Артикул';

  @override
  String get exportColStore => 'Магазин';

  @override
  String get exportColDimensions => 'Размеры';

  @override
  String get exportColQty => 'Кол-во';

  @override
  String get exportColUnit => 'Ед.';

  @override
  String get exportColPrice => 'Цена';

  @override
  String get exportColPricePerUnit => 'Цена/ед.';

  @override
  String get exportColTotal => 'Сумма';

  @override
  String get exportColPhoto => 'Фото';

  @override
  String get exportPhotoOnFile => 'В файле';

  @override
  String exportPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фото',
      many: '$count фото',
      few: '$count фото',
      one: '1 фото',
    );
    return '$_temp0';
  }

  @override
  String exportPhotosExtra(int count) {
    return '(+$count)';
  }

  @override
  String get unitPcs => 'шт';

  @override
  String get unitSqm => 'м²';

  @override
  String get unitPack => 'уп';

  @override
  String get unitMeters => 'м';

  @override
  String get unitLiters => 'л';

  @override
  String get unitKg => 'кг';

  @override
  String get account => 'Аккаунт и облако';

  @override
  String get accountSubtitle => 'Резервная копия сметы в облаке';

  @override
  String get accountHint =>
      'Войдите, чтобы сохранять проекты, комнаты, материалы и фото в облаке. Данные останутся после переустановки приложения.';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get signInWithEmail => 'Войти по email';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get haveAccountSignIn => 'Уже есть аккаунт? Войти';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get passwordResetSent => 'Письмо для сброса пароля отправлено';

  @override
  String get signOut => 'Выйти';

  @override
  String get signedIn => 'Вы вошли';

  @override
  String get signInToBackup => 'Войдите, чтобы сохранить смету в облаке';

  @override
  String get cloudSyncUnavailable =>
      'Облако не настроено в этой сборке. См. docs/FIREBASE_SETUP.md.';

  @override
  String get syncInProgress => 'Синхронизация…';

  @override
  String get syncedToCloud => 'Сохранено в облаке';

  @override
  String get syncError => 'Ошибка синхронизации — потяните вниз для обновления';

  @override
  String get syncIdle => 'Резервное копирование включено';
}
