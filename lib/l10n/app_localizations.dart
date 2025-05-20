import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @titleApp.
  ///
  /// In id, this message translates to:
  /// **'StoryApp'**
  String get titleApp;

  /// No description provided for @landingText.
  ///
  /// In id, this message translates to:
  /// **'Tangkap dan bagikan momenmu\ndengan foto yang menakjubkan'**
  String get landingText;

  /// No description provided for @loginButtonText.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginButtonText;

  /// No description provided for @registerButtonText.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerButtonText;

  /// No description provided for @signInWithGoogleButtonText.
  ///
  /// In id, this message translates to:
  /// **'Masuk dengan Google'**
  String get signInWithGoogleButtonText;

  /// No description provided for @registerHaveNoAccount.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun?'**
  String get registerHaveNoAccount;

  /// No description provided for @emailLabelText.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get emailLabelText;

  /// No description provided for @emailHintText.
  ///
  /// In id, this message translates to:
  /// **'Masukkan email kamu'**
  String get emailHintText;

  /// No description provided for @passwordLabelText.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get passwordLabelText;

  /// No description provided for @passwordHintText.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi kamu'**
  String get passwordHintText;

  /// No description provided for @usernameLabelText.
  ///
  /// In id, this message translates to:
  /// **'Nama Pengguna'**
  String get usernameLabelText;

  /// No description provided for @usernameHintText.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama pengguna kamu'**
  String get usernameHintText;

  /// No description provided for @descriptionLabelText.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get descriptionLabelText;

  /// No description provided for @descriptionHintText.
  ///
  /// In id, this message translates to:
  /// **'Masukkan deskripsi'**
  String get descriptionHintText;

  /// No description provided for @accountCreateSuccess.
  ///
  /// In id, this message translates to:
  /// **'Akun berhasil dibuat'**
  String get accountCreateSuccess;

  /// No description provided for @messageNotFound.
  ///
  /// In id, this message translates to:
  /// **'Data tidak ditemukan'**
  String get messageNotFound;

  /// No description provided for @messageTryAgain.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get messageTryAgain;

  /// No description provided for @messageUsernameEmpty.
  ///
  /// In id, this message translates to:
  /// **'Nama pengguna tidak boleh kosong'**
  String get messageUsernameEmpty;

  /// No description provided for @messageImageLoadingError.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat gambar'**
  String get messageImageLoadingError;

  /// No description provided for @messagePasswordEmpty.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi kamu'**
  String get messagePasswordEmpty;

  /// No description provided for @messagePasswordTooShort.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi harus lebih dari 8 karakter'**
  String get messagePasswordTooShort;

  /// No description provided for @messageEmailEmpty.
  ///
  /// In id, this message translates to:
  /// **'Email tidak boleh kosong'**
  String get messageEmailEmpty;

  /// No description provided for @messageDescriptionEmpty.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi tidak boleh kosong'**
  String get messageDescriptionEmpty;

  /// No description provided for @messageFavoriteNotFound.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada favorit ditemukan'**
  String get messageFavoriteNotFound;

  /// No description provided for @messageSelectImage.
  ///
  /// In id, this message translates to:
  /// **'Pilih gambar'**
  String get messageSelectImage;

  /// No description provided for @messageBackToExit.
  ///
  /// In id, this message translates to:
  /// **'Tekan lagi untuk keluar'**
  String get messageBackToExit;

  /// No description provided for @titleSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get titleSettings;

  /// No description provided for @settingsDarkmode.
  ///
  /// In id, this message translates to:
  /// **'Mode Gelap'**
  String get settingsDarkmode;

  /// No description provided for @settingsLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settingsLanguage;

  /// No description provided for @titleRegister.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get titleRegister;

  /// No description provided for @titleLogin.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get titleLogin;

  /// No description provided for @titleHome.
  ///
  /// In id, this message translates to:
  /// **'Daftar Cerita'**
  String get titleHome;

  /// No description provided for @titleFavorite.
  ///
  /// In id, this message translates to:
  /// **'Favorit'**
  String get titleFavorite;

  /// No description provided for @titleDetail.
  ///
  /// In id, this message translates to:
  /// **'Cerita'**
  String get titleDetail;

  /// No description provided for @titleAdd.
  ///
  /// In id, this message translates to:
  /// **'Posting Baru'**
  String get titleAdd;

  /// No description provided for @addButtonText.
  ///
  /// In id, this message translates to:
  /// **'Kirim Cerita'**
  String get addButtonText;

  /// No description provided for @labelHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get labelHome;

  /// No description provided for @labelFavorite.
  ///
  /// In id, this message translates to:
  /// **'Favorit'**
  String get labelFavorite;

  /// No description provided for @labelAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get labelAdd;

  /// No description provided for @labelSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get labelSettings;

  /// No description provided for @labelSignOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get labelSignOut;

  /// No description provided for @messageMapLoadingError.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat peta'**
  String get messageMapLoadingError;

  /// No description provided for @messageLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get messageLoading;

  /// No description provided for @messageAddressNotFound.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat menemukan alamat'**
  String get messageAddressNotFound;

  /// No description provided for @messageGetAddress.
  ///
  /// In id, this message translates to:
  /// **'Ketuk marker untuk menemukan alamat'**
  String get messageGetAddress;

  /// No description provided for @titleSelectLocation.
  ///
  /// In id, this message translates to:
  /// **'Pilih Lokasi'**
  String get titleSelectLocation;

  /// No description provided for @locationLabelText.
  ///
  /// In id, this message translates to:
  /// **'Lokasi'**
  String get locationLabelText;

  /// No description provided for @locationHintText.
  ///
  /// In id, this message translates to:
  /// **'Masukkan alamat atau koordinat lintang, bujur'**
  String get locationHintText;

  /// No description provided for @messageLocationNotFound.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat menemukan lokasi terkini'**
  String get messageLocationNotFound;

  /// No description provided for @messageUsingCoordinate.
  ///
  /// In id, this message translates to:
  /// **'Menggunakan koordinat'**
  String get messageUsingCoordinate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
