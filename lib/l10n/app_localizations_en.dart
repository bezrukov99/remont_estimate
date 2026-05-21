// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smetochka';

  @override
  String get defaultProjectName => 'My Renovation';

  @override
  String get export => 'Export';

  @override
  String get projectSettings => 'Project Settings';

  @override
  String projectsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projects',
      one: '1 project',
    );
    return '$_temp0';
  }

  @override
  String get myProjects => 'My Projects';

  @override
  String get myProjectsHint =>
      'Track budgets for different apartments or houses.';

  @override
  String get newProject => 'New project';

  @override
  String get newProjectHint => 'e.g. Country house';

  @override
  String get enterProjectName => 'Enter a project name';

  @override
  String get create => 'Create';

  @override
  String deleteProjectTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get deleteProjectMessage =>
      'All rooms, materials, and budget data in this project will be removed.';

  @override
  String projectSummary(int rooms, int materials, String spent) {
    return '$rooms rooms · $materials materials · $spent';
  }

  @override
  String get projectName => 'Project name';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Russian';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get currency => 'Currency';

  @override
  String get targetBudget => 'Target budget';

  @override
  String get exportPdfExcel => 'Export PDF / Excel';

  @override
  String get save => 'Save';

  @override
  String get resetAllData => 'Reset all data';

  @override
  String get resetProjectTitle => 'Reset project?';

  @override
  String get resetProjectMessage =>
      'This will delete all rooms, materials, and budget data. This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get materialsTotal => 'Materials total';

  @override
  String get totalSpent => 'Spent';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get setBudget => 'Set budget';

  @override
  String ofTarget(String amount) {
    return 'of $amount target';
  }

  @override
  String overBudgetBy(String amount) {
    return 'Over budget by $amount';
  }

  @override
  String percentRemaining(String percent) {
    return '$percent% remaining';
  }

  @override
  String get setBudgetHint =>
      'Tap \"Set budget\" to track your renovation limit';

  @override
  String get rooms => 'Rooms';

  @override
  String get add => 'Add';

  @override
  String get addRoomFirstSnack => 'Add a room first, then add materials';

  @override
  String get noRoomsYet => 'No rooms yet';

  @override
  String get noRoomsHint =>
      'Start by adding rooms like Kitchen,\nBathroom, or Living Room.';

  @override
  String get addFirstRoom => 'Add your first room';

  @override
  String get targetBudgetTitle => 'Target Budget';

  @override
  String get budgetAmount => 'Budget amount';

  @override
  String get budgetAmountHint => 'e.g. 15000';

  @override
  String get saveBudget => 'Save Budget';

  @override
  String get removeBudgetLimit => 'Remove budget limit';

  @override
  String get enterValidBudget => 'Enter a valid budget amount';

  @override
  String get editRoom => 'Edit room';

  @override
  String get addRoom => 'Add Room';

  @override
  String get roomName => 'Room name';

  @override
  String get roomNameHint => 'e.g. Kitchen';

  @override
  String get icon => 'Icon';

  @override
  String get saveRoom => 'Save Room';

  @override
  String get enterRoomName => 'Please enter a room name';

  @override
  String get quickAdd => 'Quick Add';

  @override
  String get addMaterial => 'Add Material';

  @override
  String get addMaterialSubtitle => 'Log tiles, paint, fixtures…';

  @override
  String get addRoomSubtitle => 'Kitchen, bathroom, bedroom…';

  @override
  String get exportEstimate => 'Export Estimate';

  @override
  String materialsAcrossRooms(int materials, int rooms) {
    return '$materials materials across $rooms rooms';
  }

  @override
  String get addRoomsToExport => 'Add rooms to enable export';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get exportPdfSubtitle => 'A4 report with photos & room totals';

  @override
  String get exportExcel => 'Export Excel';

  @override
  String get exportExcelSubtitle => '.xlsx with formulas for workers';

  @override
  String get addRoomBeforeExport => 'Add at least one room before exporting.';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get pdfReady => 'PDF ready';

  @override
  String get excelReady => 'Excel ready';

  @override
  String get share => 'Share';

  @override
  String get openFile => 'Open file';

  @override
  String get openFileFailed =>
      'Could not open the file. Use Share to send it to another app.';

  @override
  String get openingFile => 'Opening…';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get photoSavedToGallery => 'Photo saved to gallery';

  @override
  String get photoShared => 'Share sheet opened';

  @override
  String photoActionFailed(String error) {
    return 'Could not complete action: $error';
  }

  @override
  String get addRoomBeforeMaterials => 'Add a room before adding materials.';

  @override
  String get editMaterial => 'Edit Material';

  @override
  String get materialName => 'Material name';

  @override
  String get materialNameHint => 'e.g. Ceramic tiles';

  @override
  String get dimensionsOptional => 'Dimensions / size (optional)';

  @override
  String get dimensionsHint => 'e.g. 120×60 cm';

  @override
  String get materialDetails => 'Product details';

  @override
  String get materialBrand => 'Brand';

  @override
  String get materialBrandHint => 'e.g. Kerama Marazzi';

  @override
  String get materialArticle => 'Article / SKU';

  @override
  String get materialArticleHint => 'e.g. KM-12345';

  @override
  String get materialStore => 'Store';

  @override
  String get materialStoreHint => 'e.g. Leroy Merlin';

  @override
  String get materialArticleShort => 'art.';

  @override
  String get quantityAndUnit => 'Quantity & unit';

  @override
  String pricePerUnit(String unit) {
    return 'Price per $unit';
  }

  @override
  String get totalPrice => 'Total price';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveMaterial => 'Save Material';

  @override
  String get deleteMaterial => 'Delete material';

  @override
  String get deleteMaterialTitle => 'Delete material?';

  @override
  String get deleteMaterialMessage => 'This action cannot be undone.';

  @override
  String selectedMaterialsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
      zero: 'None selected',
    );
    return '$_temp0';
  }

  @override
  String deleteMaterialsTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count materials?',
      one: 'Delete 1 material?',
    );
    return '$_temp0';
  }

  @override
  String get deleteMaterialsMessage =>
      'Selected materials will be permanently removed. This cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get room => 'Room';

  @override
  String get selectRoom => 'Please select a room';

  @override
  String get enterMaterialName => 'Enter a material name';

  @override
  String get enterValidPrice => 'Enter a valid price per unit';

  @override
  String get quantityMustBePositive => 'Quantity must be greater than zero';

  @override
  String couldNotLoadImage(String error) {
    return 'Could not load image: $error';
  }

  @override
  String get materialPhotos => 'Photos';

  @override
  String materialPhotosHint(int max) {
    return 'Add up to $max photos from camera or gallery';
  }

  @override
  String photosCount(int count, int max) {
    return '$count of $max';
  }

  @override
  String maxPhotosReached(int max) {
    return 'Maximum $max photos per material';
  }

  @override
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get tapToAddPhoto => 'Tap to take photo / add image';

  @override
  String get cameraOrGallery => 'Camera or gallery';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get roomNotFound => 'Room not found';

  @override
  String get materialPurchased => 'Purchased';

  @override
  String get materials => 'Materials';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get noMaterialsYet => 'No materials yet';

  @override
  String get roomSubtotal => 'Room subtotal';

  @override
  String get roomPurchasedSubtotal => 'Spent in room';

  @override
  String materialsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count materials',
      one: '1 material',
    );
    return '$_temp0';
  }

  @override
  String get noMaterialsInRoom => 'No materials in this room';

  @override
  String get noMaterialsInRoomHint => 'Tap + to add tiles, paint, or fixtures';

  @override
  String get addMaterialFab => 'Add material';

  @override
  String deleteRoomTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get deleteRoomMessage =>
      'All materials in this room will also be removed.';

  @override
  String get roomKitchen => 'Kitchen';

  @override
  String get roomBathroom => 'Bathroom';

  @override
  String get roomLivingRoom => 'Living Room';

  @override
  String get roomBedroom => 'Bedroom';

  @override
  String get roomHallway => 'Hallway';

  @override
  String get roomBalcony => 'Balcony';

  @override
  String get roomOther => 'Other';

  @override
  String get exportRenovationReport => 'Smetochka — renovation estimate';

  @override
  String exportProject(String name) {
    return 'Project: $name';
  }

  @override
  String exportGenerated(String date) {
    return 'Generated: $date';
  }

  @override
  String exportMaterialsTotal(String amount) {
    return 'Materials total: $amount';
  }

  @override
  String exportPurchasedTotal(String amount) {
    return 'Spent (purchased): $amount';
  }

  @override
  String exportRoomPurchased(String amount) {
    return 'Spent: $amount';
  }

  @override
  String exportTargetBudget(String amount) {
    return 'Target budget: $amount';
  }

  @override
  String get exportBudgetSummary => 'Budget summary';

  @override
  String get exportGrandTotal => 'Grand total';

  @override
  String get exportGrandTotalSpent => 'Spent';

  @override
  String exportPageOf(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String get exportNoMaterialsInRoom => 'No materials in this room';

  @override
  String get exportNoRoomsYet => 'No rooms added yet';

  @override
  String get exportNoMaterials => 'No materials';

  @override
  String get exportRoomSubtotal => 'Room subtotal';

  @override
  String get exportColMaterial => 'Material';

  @override
  String get exportColBrand => 'Brand';

  @override
  String get exportColArticle => 'Article';

  @override
  String get exportColStore => 'Store';

  @override
  String get exportColDimensions => 'Dimensions';

  @override
  String get exportColQty => 'Qty';

  @override
  String get exportColUnit => 'Unit';

  @override
  String get exportColPrice => 'Price';

  @override
  String get exportColPricePerUnit => 'Price/Unit';

  @override
  String get exportColTotal => 'Total';

  @override
  String get exportColPhoto => 'Photo';

  @override
  String get exportPhotoOnFile => 'On file';

  @override
  String exportPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String exportPhotosExtra(int count) {
    return '(+$count)';
  }

  @override
  String get unitPcs => 'Pcs';

  @override
  String get unitSqm => 'Sq.m';

  @override
  String get unitPack => 'Pack';

  @override
  String get unitMeters => 'Meters';

  @override
  String get unitLiters => 'Liters';

  @override
  String get unitKg => 'Kg';

  @override
  String get account => 'Account & cloud sync';

  @override
  String get accountSubtitle => 'Back up your estimates online';

  @override
  String get accountHint =>
      'Sign in to save projects, rooms, materials, and photos to the cloud. Your data will stay after reinstalling the app.';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signInWithEmail => 'Sign in with email';

  @override
  String get createAccount => 'Create account';

  @override
  String get haveAccountSignIn => 'Already have an account? Sign in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get passwordResetSent => 'Password reset email sent';

  @override
  String get passwordResetCheckSpam =>
      'Check your inbox and spam folder. The link opens in your browser.';

  @override
  String get enterEmailForReset =>
      'Enter your email above, then tap «Forgot password?»';

  @override
  String get authInvalidEmail => 'Invalid email address';

  @override
  String get authUserNotFound =>
      'No account with this email. Create an account or check the address.';

  @override
  String get authWrongPassword => 'Wrong password';

  @override
  String get authEmailAlreadyInUse => 'This email is already registered';

  @override
  String get authWeakPassword => 'Password must be at least 6 characters';

  @override
  String get authTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authNetworkError => 'Network error. Check your connection.';

  @override
  String get signOut => 'Sign out';

  @override
  String get signedIn => 'Signed in';

  @override
  String get signInToBackup => 'Sign in to back up your estimate to the cloud';

  @override
  String get cloudSyncUnavailable =>
      'Cloud sync is not configured in this build. See docs/FIREBASE_SETUP.md.';

  @override
  String get syncInProgress => 'Syncing…';

  @override
  String get syncedToCloud => 'Backed up to cloud';

  @override
  String get syncError => 'Sync error — pull to refresh';

  @override
  String get syncIdle => 'Cloud backup enabled';
}
