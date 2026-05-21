import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smetochka'**
  String get appTitle;

  /// No description provided for @defaultProjectName.
  ///
  /// In en, this message translates to:
  /// **'My Renovation'**
  String get defaultProjectName;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @projectSettings.
  ///
  /// In en, this message translates to:
  /// **'Project Settings'**
  String get projectSettings;

  /// No description provided for @projectsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 project} other{{count} projects}}'**
  String projectsCount(int count);

  /// No description provided for @myProjects.
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get myProjects;

  /// No description provided for @myProjectsHint.
  ///
  /// In en, this message translates to:
  /// **'Track budgets for different apartments or houses.'**
  String get myProjectsHint;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get newProject;

  /// No description provided for @newProjectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Country house'**
  String get newProjectHint;

  /// No description provided for @enterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Enter a project name'**
  String get enterProjectName;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @deleteProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteProjectTitle(String name);

  /// No description provided for @deleteProjectMessage.
  ///
  /// In en, this message translates to:
  /// **'All rooms, materials, and budget data in this project will be removed.'**
  String get deleteProjectMessage;

  /// No description provided for @projectSummary.
  ///
  /// In en, this message translates to:
  /// **'{rooms} rooms · {materials} materials · {spent}'**
  String projectSummary(int rooms, int materials, String spent);

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @targetBudget.
  ///
  /// In en, this message translates to:
  /// **'Target budget'**
  String get targetBudget;

  /// No description provided for @exportPdfExcel.
  ///
  /// In en, this message translates to:
  /// **'Export PDF / Excel'**
  String get exportPdfExcel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @resetAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get resetAllData;

  /// No description provided for @resetProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset project?'**
  String get resetProjectTitle;

  /// No description provided for @resetProjectMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all rooms, materials, and budget data. This cannot be undone.'**
  String get resetProjectMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @materialsTotal.
  ///
  /// In en, this message translates to:
  /// **'Materials total'**
  String get materialsTotal;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get totalSpent;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @setBudget.
  ///
  /// In en, this message translates to:
  /// **'Set budget'**
  String get setBudget;

  /// No description provided for @ofTarget.
  ///
  /// In en, this message translates to:
  /// **'of {amount} target'**
  String ofTarget(String amount);

  /// No description provided for @overBudgetBy.
  ///
  /// In en, this message translates to:
  /// **'Over budget by {amount}'**
  String overBudgetBy(String amount);

  /// No description provided for @percentRemaining.
  ///
  /// In en, this message translates to:
  /// **'{percent}% remaining'**
  String percentRemaining(String percent);

  /// No description provided for @setBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Set budget\" to track your renovation limit'**
  String get setBudgetHint;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addRoomFirstSnack.
  ///
  /// In en, this message translates to:
  /// **'Add a room first, then add materials'**
  String get addRoomFirstSnack;

  /// No description provided for @noRoomsYet.
  ///
  /// In en, this message translates to:
  /// **'No rooms yet'**
  String get noRoomsYet;

  /// No description provided for @noRoomsHint.
  ///
  /// In en, this message translates to:
  /// **'Start by adding rooms like Kitchen,\nBathroom, or Living Room.'**
  String get noRoomsHint;

  /// No description provided for @addFirstRoom.
  ///
  /// In en, this message translates to:
  /// **'Add your first room'**
  String get addFirstRoom;

  /// No description provided for @targetBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Budget'**
  String get targetBudgetTitle;

  /// No description provided for @budgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Budget amount'**
  String get budgetAmount;

  /// No description provided for @budgetAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15000'**
  String get budgetAmountHint;

  /// No description provided for @saveBudget.
  ///
  /// In en, this message translates to:
  /// **'Save Budget'**
  String get saveBudget;

  /// No description provided for @removeBudgetLimit.
  ///
  /// In en, this message translates to:
  /// **'Remove budget limit'**
  String get removeBudgetLimit;

  /// No description provided for @enterValidBudget.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid budget amount'**
  String get enterValidBudget;

  /// No description provided for @editRoom.
  ///
  /// In en, this message translates to:
  /// **'Edit room'**
  String get editRoom;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get addRoom;

  /// No description provided for @roomName.
  ///
  /// In en, this message translates to:
  /// **'Room name'**
  String get roomName;

  /// No description provided for @roomNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Kitchen'**
  String get roomNameHint;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @saveRoom.
  ///
  /// In en, this message translates to:
  /// **'Save Room'**
  String get saveRoom;

  /// No description provided for @enterRoomName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a room name'**
  String get enterRoomName;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @addMaterial.
  ///
  /// In en, this message translates to:
  /// **'Add Material'**
  String get addMaterial;

  /// No description provided for @addMaterialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log tiles, paint, fixtures…'**
  String get addMaterialSubtitle;

  /// No description provided for @addRoomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kitchen, bathroom, bedroom…'**
  String get addRoomSubtitle;

  /// No description provided for @exportEstimate.
  ///
  /// In en, this message translates to:
  /// **'Export Estimate'**
  String get exportEstimate;

  /// No description provided for @materialsAcrossRooms.
  ///
  /// In en, this message translates to:
  /// **'{materials} materials across {rooms} rooms'**
  String materialsAcrossRooms(int materials, int rooms);

  /// No description provided for @addRoomsToExport.
  ///
  /// In en, this message translates to:
  /// **'Add rooms to enable export'**
  String get addRoomsToExport;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A4 report with photos & room totals'**
  String get exportPdfSubtitle;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get exportExcel;

  /// No description provided for @exportExcelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'.xlsx with formulas for workers'**
  String get exportExcelSubtitle;

  /// No description provided for @addRoomBeforeExport.
  ///
  /// In en, this message translates to:
  /// **'Add at least one room before exporting.'**
  String get addRoomBeforeExport;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @pdfReady.
  ///
  /// In en, this message translates to:
  /// **'PDF ready'**
  String get pdfReady;

  /// No description provided for @excelReady.
  ///
  /// In en, this message translates to:
  /// **'Excel ready'**
  String get excelReady;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @openFile.
  ///
  /// In en, this message translates to:
  /// **'Open file'**
  String get openFile;

  /// No description provided for @openFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the file. Use Share to send it to another app.'**
  String get openFileFailed;

  /// No description provided for @openingFile.
  ///
  /// In en, this message translates to:
  /// **'Opening…'**
  String get openingFile;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @photoSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo saved to gallery'**
  String get photoSavedToGallery;

  /// No description provided for @photoShared.
  ///
  /// In en, this message translates to:
  /// **'Share sheet opened'**
  String get photoShared;

  /// No description provided for @photoActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete action: {error}'**
  String photoActionFailed(String error);

  /// No description provided for @addRoomBeforeMaterials.
  ///
  /// In en, this message translates to:
  /// **'Add a room before adding materials.'**
  String get addRoomBeforeMaterials;

  /// No description provided for @editMaterial.
  ///
  /// In en, this message translates to:
  /// **'Edit Material'**
  String get editMaterial;

  /// No description provided for @materialName.
  ///
  /// In en, this message translates to:
  /// **'Material name'**
  String get materialName;

  /// No description provided for @materialNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ceramic tiles'**
  String get materialNameHint;

  /// No description provided for @dimensionsOptional.
  ///
  /// In en, this message translates to:
  /// **'Dimensions / size (optional)'**
  String get dimensionsOptional;

  /// No description provided for @dimensionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 120×60 cm'**
  String get dimensionsHint;

  /// No description provided for @materialDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get materialDetails;

  /// No description provided for @materialBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get materialBrand;

  /// No description provided for @materialBrandHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Kerama Marazzi'**
  String get materialBrandHint;

  /// No description provided for @materialArticle.
  ///
  /// In en, this message translates to:
  /// **'Article / SKU'**
  String get materialArticle;

  /// No description provided for @materialArticleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. KM-12345'**
  String get materialArticleHint;

  /// No description provided for @materialStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get materialStore;

  /// No description provided for @materialStoreHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Leroy Merlin'**
  String get materialStoreHint;

  /// No description provided for @materialArticleShort.
  ///
  /// In en, this message translates to:
  /// **'art.'**
  String get materialArticleShort;

  /// No description provided for @quantityAndUnit.
  ///
  /// In en, this message translates to:
  /// **'Quantity & unit'**
  String get quantityAndUnit;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price per {unit}'**
  String pricePerUnit(String unit);

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get totalPrice;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saveMaterial.
  ///
  /// In en, this message translates to:
  /// **'Save Material'**
  String get saveMaterial;

  /// No description provided for @deleteMaterial.
  ///
  /// In en, this message translates to:
  /// **'Delete material'**
  String get deleteMaterial;

  /// No description provided for @deleteMaterialTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete material?'**
  String get deleteMaterialTitle;

  /// No description provided for @deleteMaterialMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteMaterialMessage;

  /// No description provided for @selectedMaterialsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None selected} =1{1 selected} other{{count} selected}}'**
  String selectedMaterialsCount(num count);

  /// No description provided for @deleteMaterialsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 material?} other{Delete {count} materials?}}'**
  String deleteMaterialsTitle(num count);

  /// No description provided for @deleteMaterialsMessage.
  ///
  /// In en, this message translates to:
  /// **'Selected materials will be permanently removed. This cannot be undone.'**
  String get deleteMaterialsMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @selectRoom.
  ///
  /// In en, this message translates to:
  /// **'Please select a room'**
  String get selectRoom;

  /// No description provided for @enterMaterialName.
  ///
  /// In en, this message translates to:
  /// **'Enter a material name'**
  String get enterMaterialName;

  /// No description provided for @enterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price per unit'**
  String get enterValidPrice;

  /// No description provided for @quantityMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than zero'**
  String get quantityMustBePositive;

  /// No description provided for @couldNotLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Could not load image: {error}'**
  String couldNotLoadImage(String error);

  /// No description provided for @materialPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get materialPhotos;

  /// No description provided for @materialPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Add up to {max} photos from camera or gallery'**
  String materialPhotosHint(int max);

  /// No description provided for @photosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max}'**
  String photosCount(int count, int max);

  /// No description provided for @maxPhotosReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} photos per material'**
  String maxPhotosReached(int max);

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to take photo / add image'**
  String get tapToAddPhoto;

  /// No description provided for @cameraOrGallery.
  ///
  /// In en, this message translates to:
  /// **'Camera or gallery'**
  String get cameraOrGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get roomNotFound;

  /// No description provided for @materialPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get materialPurchased;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemsCount(int count);

  /// No description provided for @noMaterialsYet.
  ///
  /// In en, this message translates to:
  /// **'No materials yet'**
  String get noMaterialsYet;

  /// No description provided for @roomSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Room subtotal'**
  String get roomSubtotal;

  /// No description provided for @roomPurchasedSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Spent in room'**
  String get roomPurchasedSubtotal;

  /// No description provided for @materialsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 material} other{{count} materials}}'**
  String materialsCount(int count);

  /// No description provided for @noMaterialsInRoom.
  ///
  /// In en, this message translates to:
  /// **'No materials in this room'**
  String get noMaterialsInRoom;

  /// No description provided for @noMaterialsInRoomHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add tiles, paint, or fixtures'**
  String get noMaterialsInRoomHint;

  /// No description provided for @addMaterialFab.
  ///
  /// In en, this message translates to:
  /// **'Add material'**
  String get addMaterialFab;

  /// No description provided for @deleteRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteRoomTitle(String name);

  /// No description provided for @deleteRoomMessage.
  ///
  /// In en, this message translates to:
  /// **'All materials in this room will also be removed.'**
  String get deleteRoomMessage;

  /// No description provided for @roomKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get roomKitchen;

  /// No description provided for @roomBathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get roomBathroom;

  /// No description provided for @roomLivingRoom.
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get roomLivingRoom;

  /// No description provided for @roomBedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get roomBedroom;

  /// No description provided for @roomHallway.
  ///
  /// In en, this message translates to:
  /// **'Hallway'**
  String get roomHallway;

  /// No description provided for @roomBalcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get roomBalcony;

  /// No description provided for @roomOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get roomOther;

  /// No description provided for @exportRenovationReport.
  ///
  /// In en, this message translates to:
  /// **'Smetochka — renovation estimate'**
  String get exportRenovationReport;

  /// No description provided for @exportProject.
  ///
  /// In en, this message translates to:
  /// **'Project: {name}'**
  String exportProject(String name);

  /// No description provided for @exportGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated: {date}'**
  String exportGenerated(String date);

  /// No description provided for @exportMaterialsTotal.
  ///
  /// In en, this message translates to:
  /// **'Materials total: {amount}'**
  String exportMaterialsTotal(String amount);

  /// No description provided for @exportPurchasedTotal.
  ///
  /// In en, this message translates to:
  /// **'Spent (purchased): {amount}'**
  String exportPurchasedTotal(String amount);

  /// No description provided for @exportRoomPurchased.
  ///
  /// In en, this message translates to:
  /// **'Spent: {amount}'**
  String exportRoomPurchased(String amount);

  /// No description provided for @exportTargetBudget.
  ///
  /// In en, this message translates to:
  /// **'Target budget: {amount}'**
  String exportTargetBudget(String amount);

  /// No description provided for @exportBudgetSummary.
  ///
  /// In en, this message translates to:
  /// **'Budget summary'**
  String get exportBudgetSummary;

  /// No description provided for @exportGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get exportGrandTotal;

  /// No description provided for @exportGrandTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get exportGrandTotalSpent;

  /// No description provided for @exportPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String exportPageOf(int page, int total);

  /// No description provided for @exportNoMaterialsInRoom.
  ///
  /// In en, this message translates to:
  /// **'No materials in this room'**
  String get exportNoMaterialsInRoom;

  /// No description provided for @exportNoRoomsYet.
  ///
  /// In en, this message translates to:
  /// **'No rooms added yet'**
  String get exportNoRoomsYet;

  /// No description provided for @exportNoMaterials.
  ///
  /// In en, this message translates to:
  /// **'No materials'**
  String get exportNoMaterials;

  /// No description provided for @exportRoomSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Room subtotal'**
  String get exportRoomSubtotal;

  /// No description provided for @exportColMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get exportColMaterial;

  /// No description provided for @exportColBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get exportColBrand;

  /// No description provided for @exportColArticle.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get exportColArticle;

  /// No description provided for @exportColStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get exportColStore;

  /// No description provided for @exportColDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get exportColDimensions;

  /// No description provided for @exportColQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get exportColQty;

  /// No description provided for @exportColUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get exportColUnit;

  /// No description provided for @exportColPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get exportColPrice;

  /// No description provided for @exportColPricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price/Unit'**
  String get exportColPricePerUnit;

  /// No description provided for @exportColTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get exportColTotal;

  /// No description provided for @exportColPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get exportColPhoto;

  /// No description provided for @exportPhotoOnFile.
  ///
  /// In en, this message translates to:
  /// **'On file'**
  String get exportPhotoOnFile;

  /// No description provided for @exportPhotoCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String exportPhotoCount(int count);

  /// No description provided for @exportPhotosExtra.
  ///
  /// In en, this message translates to:
  /// **'(+{count})'**
  String exportPhotosExtra(int count);

  /// No description provided for @unitPcs.
  ///
  /// In en, this message translates to:
  /// **'Pcs'**
  String get unitPcs;

  /// No description provided for @unitSqm.
  ///
  /// In en, this message translates to:
  /// **'Sq.m'**
  String get unitSqm;

  /// No description provided for @unitPack.
  ///
  /// In en, this message translates to:
  /// **'Pack'**
  String get unitPack;

  /// No description provided for @unitMeters.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get unitMeters;

  /// No description provided for @unitLiters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get unitLiters;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get unitKg;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account & cloud sync'**
  String get account;

  /// No description provided for @accountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Back up your estimates online'**
  String get accountSubtitle;

  /// No description provided for @accountHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save projects, rooms, materials, and photos to the cloud. Your data will stay after reinstalling the app.'**
  String get accountHint;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get signInWithEmail;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @haveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get haveAccountSignIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetSent;

  /// No description provided for @passwordResetCheckSpam.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox and spam folder. The link opens in your browser.'**
  String get passwordResetCheckSpam;

  /// No description provided for @enterEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email above, then tap «Forgot password?»'**
  String get enterEmailForReset;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get authInvalidEmail;

  /// No description provided for @authUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account with this email. Create an account or check the address.'**
  String get authUserNotFound;

  /// No description provided for @authWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get authWrongPassword;

  /// No description provided for @authEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get authEmailAlreadyInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authWeakPassword;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authTooManyRequests;

  /// No description provided for @authNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get authNetworkError;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @signInToBackup.
  ///
  /// In en, this message translates to:
  /// **'Sign in to back up your estimate to the cloud'**
  String get signInToBackup;

  /// No description provided for @cloudSyncUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is not configured in this build. See docs/FIREBASE_SETUP.md.'**
  String get cloudSyncUnavailable;

  /// No description provided for @syncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncInProgress;

  /// No description provided for @syncedToCloud.
  ///
  /// In en, this message translates to:
  /// **'Backed up to cloud'**
  String get syncedToCloud;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error — pull to refresh'**
  String get syncError;

  /// No description provided for @syncIdle.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup enabled'**
  String get syncIdle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
