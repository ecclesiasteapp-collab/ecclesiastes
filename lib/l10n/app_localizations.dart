import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ln.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_tl.dart';

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
    Locale('fr'),
    Locale('ko'),
    Locale('ln'),
    Locale('sw'),
    Locale('tl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ecclésiastes'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboard;

  /// No description provided for @reports.
  ///
  /// In fr, this message translates to:
  /// **'Rapports'**
  String get reports;

  /// No description provided for @members.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get members;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @socialHub.
  ///
  /// In fr, this message translates to:
  /// **'Hub Social'**
  String get socialHub;

  /// No description provided for @library.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque'**
  String get library;

  /// No description provided for @calendar.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier'**
  String get calendar;

  /// No description provided for @hierarchy.
  ///
  /// In fr, this message translates to:
  /// **'Hiérarchie'**
  String get hierarchy;

  /// No description provided for @hello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get hello;

  /// No description provided for @quickNavigation.
  ///
  /// In fr, this message translates to:
  /// **'NAVIGATION RAPIDE'**
  String get quickNavigation;

  /// No description provided for @recentActivity.
  ///
  /// In fr, this message translates to:
  /// **'ACTIVITÉ RÉCENTE'**
  String get recentActivity;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get seeAll;

  /// No description provided for @pastoralAnalysis.
  ///
  /// In fr, this message translates to:
  /// **'ANALYSE PASTORALE'**
  String get pastoralAnalysis;

  /// No description provided for @bible.
  ///
  /// In fr, this message translates to:
  /// **'SAINTE BIBLE'**
  String get bible;

  /// No description provided for @commissions.
  ///
  /// In fr, this message translates to:
  /// **'COMMISSIONS'**
  String get commissions;

  /// No description provided for @security.
  ///
  /// In fr, this message translates to:
  /// **'SÉCURITÉ'**
  String get security;

  /// No description provided for @biometrics.
  ///
  /// In fr, this message translates to:
  /// **'Verrouillage Biométrique'**
  String get biometrics;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notifications;

  /// No description provided for @appearance.
  ///
  /// In fr, this message translates to:
  /// **'APPARENCE'**
  String get appearance;

  /// No description provided for @accessibility.
  ///
  /// In fr, this message translates to:
  /// **'ACCESSIBILITÉ'**
  String get accessibility;

  /// No description provided for @privacy.
  ///
  /// In fr, this message translates to:
  /// **'CONFIDENTIALITÉ'**
  String get privacy;

  /// No description provided for @syncAndBackup.
  ///
  /// In fr, this message translates to:
  /// **'SYNCHRONISATION & SAUVEGARDE'**
  String get syncAndBackup;

  /// No description provided for @exportData.
  ///
  /// In fr, this message translates to:
  /// **'Exporter mes données (RGPD)'**
  String get exportData;

  /// No description provided for @deleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get deleteAccount;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'interface'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode Sombre'**
  String get darkMode;

  /// No description provided for @fontSize.
  ///
  /// In fr, this message translates to:
  /// **'Taille de police'**
  String get fontSize;

  /// No description provided for @autoBackup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde Automatique'**
  String get autoBackup;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'fr',
        'ko',
        'ln',
        'sw',
        'tl'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ko':
      return AppLocalizationsKo();
    case 'ln':
      return AppLocalizationsLn();
    case 'sw':
      return AppLocalizationsSw();
    case 'tl':
      return AppLocalizationsTl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
