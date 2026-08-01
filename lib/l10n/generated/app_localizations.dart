import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ms'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Umrah Trip Planner'**
  String get appTitle;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome Onboards, {userName}!'**
  String welcomeUser(String userName);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @diyUmrahBuddy.
  ///
  /// In en, this message translates to:
  /// **'DIY Umrah Buddy'**
  String get diyUmrahBuddy;

  /// No description provided for @umrahTripPlannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Umrah Trip Planner'**
  String get umrahTripPlannerSubtitle;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @worshipPlaces.
  ///
  /// In en, this message translates to:
  /// **'Worship Places'**
  String get worshipPlaces;

  /// No description provided for @mustVisitPlace.
  ///
  /// In en, this message translates to:
  /// **'Must Visit Place'**
  String get mustVisitPlace;

  /// No description provided for @umrahBasicNeeds.
  ///
  /// In en, this message translates to:
  /// **'Umrah Basic Needs'**
  String get umrahBasicNeeds;

  /// No description provided for @exploreSaudi.
  ///
  /// In en, this message translates to:
  /// **'Explore things to do in Saudi Arabia'**
  String get exploreSaudi;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with your first trip and plan your itinerary'**
  String get startJourney;

  /// No description provided for @exploreHere.
  ///
  /// In en, this message translates to:
  /// **'Explore here'**
  String get exploreHere;

  /// No description provided for @checkOutSights.
  ///
  /// In en, this message translates to:
  /// **'Check out must-see sights and activities'**
  String get checkOutSights;

  /// No description provided for @exploreMakkah.
  ///
  /// In en, this message translates to:
  /// **'Explore Makkah'**
  String get exploreMakkah;

  /// No description provided for @exploreMadinah.
  ///
  /// In en, this message translates to:
  /// **'Explore Madinah'**
  String get exploreMadinah;

  /// No description provided for @makkahHolyCity.
  ///
  /// In en, this message translates to:
  /// **'Makkah (The Holy City)'**
  String get makkahHolyCity;

  /// No description provided for @worshipAndZiyarat.
  ///
  /// In en, this message translates to:
  /// **'Worship and Ziyarat Places'**
  String get worshipAndZiyarat;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTrips;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @personaliseMyTrips.
  ///
  /// In en, this message translates to:
  /// **'Personalise My Trips'**
  String get personaliseMyTrips;

  /// No description provided for @letsStartJourney.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start your Umrah journey with us'**
  String get letsStartJourney;

  /// No description provided for @diyTravelPlan.
  ///
  /// In en, this message translates to:
  /// **'DIY Travel\nPlan'**
  String get diyTravelPlan;

  /// No description provided for @personalisedBudgets.
  ///
  /// In en, this message translates to:
  /// **'Personalised all your budgets and planning by yourself.'**
  String get personalisedBudgets;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @noSavedItems.
  ///
  /// In en, this message translates to:
  /// **'No saved items'**
  String get noSavedItems;

  /// No description provided for @itemsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Items you save will appear here'**
  String get itemsWillAppearHere;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String selected(int count);

  /// No description provided for @dateNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Date (Newest First)'**
  String get dateNewestFirst;

  /// No description provided for @nameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get nameAZ;

  /// No description provided for @deleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Delete Trip'**
  String get deleteTrip;

  /// No description provided for @areYouSureDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this trip?'**
  String get areYouSureDelete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @tripDeleted.
  ///
  /// In en, this message translates to:
  /// **'Trip deleted'**
  String get tripDeleted;

  /// No description provided for @selectedTripsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Selected trips deleted'**
  String get selectedTripsDeleted;

  /// No description provided for @editTripName.
  ///
  /// In en, this message translates to:
  /// **'Edit Trip Name'**
  String get editTripName;

  /// No description provided for @enterTripName.
  ///
  /// In en, this message translates to:
  /// **'Enter trip name'**
  String get enterTripName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get profileDetails;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @profilePictureRemoved.
  ///
  /// In en, this message translates to:
  /// **'Profile picture removed'**
  String get profilePictureRemoved;

  /// No description provided for @galleryPickerNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Gallery picker will be implemented here'**
  String get galleryPickerNotImplemented;

  /// No description provided for @cameraNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Camera functionality will be implemented here'**
  String get cameraNotImplemented;

  /// No description provided for @loggedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccessfully;

  /// No description provided for @areYouSureLogOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogOut;

  /// No description provided for @insertTripName.
  ///
  /// In en, this message translates to:
  /// **'Insert your Umrah Trip Name'**
  String get insertTripName;

  /// No description provided for @tripNameHint.
  ///
  /// In en, this message translates to:
  /// **'ian\'s trip'**
  String get tripNameHint;

  /// No description provided for @insertAge.
  ///
  /// In en, this message translates to:
  /// **'Insert your age'**
  String get insertAge;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'30 years old'**
  String get ageHint;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @insertJourneyBudget.
  ///
  /// In en, this message translates to:
  /// **'Insert your journey budget'**
  String get insertJourneyBudget;

  /// No description provided for @minBudgetWarning.
  ///
  /// In en, this message translates to:
  /// **'Minimum amount of budget is RM4,000.00'**
  String get minBudgetWarning;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @insertJourneyDuration.
  ///
  /// In en, this message translates to:
  /// **'Insert your journey duration'**
  String get insertJourneyDuration;

  /// No description provided for @daysInMakkah.
  ///
  /// In en, this message translates to:
  /// **'No. of days in Makkah'**
  String get daysInMakkah;

  /// No description provided for @daysInMadinah.
  ///
  /// In en, this message translates to:
  /// **'No. of days in Madinah'**
  String get daysInMadinah;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total days: {days}'**
  String totalDays(int days);

  /// No description provided for @durationWarning.
  ///
  /// In en, this message translates to:
  /// **'The minimum days is 5 days and maximum days is 14 days'**
  String get durationWarning;

  /// No description provided for @chooseHotelPref.
  ///
  /// In en, this message translates to:
  /// **'Choose your hotel preferences'**
  String get chooseHotelPref;

  /// No description provided for @hotelPref.
  ///
  /// In en, this message translates to:
  /// **'Hotel preferences'**
  String get hotelPref;

  /// No description provided for @pickHotelPref.
  ///
  /// In en, this message translates to:
  /// **'Pick your hotel preferences'**
  String get pickHotelPref;

  /// No description provided for @hotelDist.
  ///
  /// In en, this message translates to:
  /// **'Hotel distance to Masjidil Haram'**
  String get hotelDist;

  /// No description provided for @pickHotelDist.
  ///
  /// In en, this message translates to:
  /// **'Pick your hotel distance'**
  String get pickHotelDist;

  /// No description provided for @luxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get luxury;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @economy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get economy;

  /// No description provided for @veryNear.
  ///
  /// In en, this message translates to:
  /// **'Very Near'**
  String get veryNear;

  /// No description provided for @near.
  ///
  /// In en, this message translates to:
  /// **'Near'**
  String get near;

  /// No description provided for @far.
  ///
  /// In en, this message translates to:
  /// **'Far'**
  String get far;

  /// No description provided for @chooseTransportPref.
  ///
  /// In en, this message translates to:
  /// **'Choose your transport preferences'**
  String get chooseTransportPref;

  /// No description provided for @transportPref.
  ///
  /// In en, this message translates to:
  /// **'Transportation preference'**
  String get transportPref;

  /// No description provided for @pickTransportPref.
  ///
  /// In en, this message translates to:
  /// **'Pick your transportation preferences'**
  String get pickTransportPref;

  /// No description provided for @comfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get comfortable;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @minimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get minimal;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @generalInfo.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get generalInfo;

  /// No description provided for @featuresPlanning.
  ///
  /// In en, this message translates to:
  /// **'Features & Itinerary Planning'**
  String get featuresPlanning;

  /// No description provided for @technicalUsage.
  ///
  /// In en, this message translates to:
  /// **'Technical & Usage'**
  String get technicalUsage;

  /// No description provided for @developerName.
  ///
  /// In en, this message translates to:
  /// **'\'Irfan (Apps Developer)'**
  String get developerName;

  /// No description provided for @contactUsDesc.
  ///
  /// In en, this message translates to:
  /// **'You can leave any enquiry below if there are any problems or bugs experienced while using our apps!'**
  String get contactUsDesc;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get yourEmail;

  /// No description provided for @enquiries.
  ///
  /// In en, this message translates to:
  /// **'Enquiries'**
  String get enquiries;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @inquirySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Inquiry submitted successfully!'**
  String get inquirySubmitted;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Could not send email to fanzr24@gmail.com. Please check your email client settings or try again later.'**
  String get emailError;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get enterEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmail;

  /// No description provided for @enterEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Please enter your enquiry'**
  String get enterEnquiry;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @phoneNo.
  ///
  /// In en, this message translates to:
  /// **'Phone No.'**
  String get phoneNo;

  /// No description provided for @passwords.
  ///
  /// In en, this message translates to:
  /// **'Passwords'**
  String get passwords;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully!'**
  String get profileSaved;

  /// No description provided for @errorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile'**
  String get errorSavingProfile;

  /// No description provided for @chooseFlightPref.
  ///
  /// In en, this message translates to:
  /// **'Choose your flight preferences'**
  String get chooseFlightPref;

  /// No description provided for @flightPref.
  ///
  /// In en, this message translates to:
  /// **'Flight preference'**
  String get flightPref;

  /// No description provided for @pickFlightPref.
  ///
  /// In en, this message translates to:
  /// **'Pick your flight preferences'**
  String get pickFlightPref;

  /// No description provided for @airlineServiceType.
  ///
  /// In en, this message translates to:
  /// **'Airline Service Type'**
  String get airlineServiceType;

  /// No description provided for @pickServiceType.
  ///
  /// In en, this message translates to:
  /// **'Full Service or Low Cost'**
  String get pickServiceType;

  /// No description provided for @direct.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get direct;

  /// No description provided for @transit.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get transit;

  /// No description provided for @fullService.
  ///
  /// In en, this message translates to:
  /// **'Full Service'**
  String get fullService;

  /// No description provided for @lowCost.
  ///
  /// In en, this message translates to:
  /// **'Low Cost'**
  String get lowCost;

  /// No description provided for @dailyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Daily expenses'**
  String get dailyExpenses;

  /// No description provided for @selectDailyLimit.
  ///
  /// In en, this message translates to:
  /// **'Select your daily limit'**
  String get selectDailyLimit;

  /// No description provided for @foodDrink.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get foodDrink;

  /// No description provided for @simcardInternet.
  ///
  /// In en, this message translates to:
  /// **'Simcard & Internet'**
  String get simcardInternet;

  /// No description provided for @souvenirs.
  ///
  /// In en, this message translates to:
  /// **'Souvenirs'**
  String get souvenirs;

  /// No description provided for @miscellaneous.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get miscellaneous;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @generateItinerary.
  ///
  /// In en, this message translates to:
  /// **'Generate Itinerary'**
  String get generateItinerary;

  /// No description provided for @dailyExpensesPrefTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your daily expenses preferences'**
  String get dailyExpensesPrefTitle;

  /// No description provided for @dailyExpensesPrefLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily expenses preference'**
  String get dailyExpensesPrefLabel;

  /// No description provided for @pickDailyExpensesPref.
  ///
  /// In en, this message translates to:
  /// **'Pick your expenses preferences'**
  String get pickDailyExpensesPref;

  /// No description provided for @yourTripPreferences.
  ///
  /// In en, this message translates to:
  /// **'Your Trip Preferences'**
  String get yourTripPreferences;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @tripName.
  ///
  /// In en, this message translates to:
  /// **'Trip Name'**
  String get tripName;

  /// No description provided for @hotelAllocation.
  ///
  /// In en, this message translates to:
  /// **'Hotel Allocation Budget Breakdown'**
  String get hotelAllocation;

  /// No description provided for @flightAllocation.
  ///
  /// In en, this message translates to:
  /// **'Flight Allocation Budget Breakdown'**
  String get flightAllocation;

  /// No description provided for @transportAllocation.
  ///
  /// In en, this message translates to:
  /// **'Transport Allocation Budget Breakdown'**
  String get transportAllocation;

  /// No description provided for @expensesAllocation.
  ///
  /// In en, this message translates to:
  /// **'Expenses Allocation Budget Breakdown'**
  String get expensesAllocation;

  /// No description provided for @totalCostBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Total Cost Breakdown'**
  String get totalCostBreakdown;

  /// No description provided for @optimizingBudget.
  ///
  /// In en, this message translates to:
  /// **'Optimizing your budget...'**
  String get optimizingBudget;

  /// No description provided for @optimizedBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall optimised budget\nbased on your current\npreferences.'**
  String get optimizedBudgetTitle;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get overBudget;

  /// No description provided for @bestPossiblePrice.
  ///
  /// In en, this message translates to:
  /// **'Best Possible Price'**
  String get bestPossiblePrice;

  /// No description provided for @hotelNameMakkah.
  ///
  /// In en, this message translates to:
  /// **'Hotel Name (Makkah)'**
  String get hotelNameMakkah;

  /// No description provided for @hotelNameMadinah.
  ///
  /// In en, this message translates to:
  /// **'Hotel Name (Madinah)'**
  String get hotelNameMadinah;

  /// No description provided for @hotelRatings.
  ///
  /// In en, this message translates to:
  /// **'Hotel Ratings'**
  String get hotelRatings;

  /// No description provided for @hotelDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Hotel Distance'**
  String get hotelDistanceLabel;

  /// No description provided for @totalDaysStay.
  ///
  /// In en, this message translates to:
  /// **'Total days of stay'**
  String get totalDaysStay;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @airline.
  ///
  /// In en, this message translates to:
  /// **'Airline'**
  String get airline;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @transportType.
  ///
  /// In en, this message translates to:
  /// **'Transport Type'**
  String get transportType;

  /// No description provided for @fixedTransportCost.
  ///
  /// In en, this message translates to:
  /// **'Fixed Transport Cost'**
  String get fixedTransportCost;

  /// No description provided for @dailyCommute.
  ///
  /// In en, this message translates to:
  /// **'Daily commute around city'**
  String get dailyCommute;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @tier.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get tier;

  /// No description provided for @dailyCost.
  ///
  /// In en, this message translates to:
  /// **'Daily Cost'**
  String get dailyCost;

  /// No description provided for @totalDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Days'**
  String get totalDaysLabel;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @makkahHotel.
  ///
  /// In en, this message translates to:
  /// **'Makkah Hotel'**
  String get makkahHotel;

  /// No description provided for @madinahHotel.
  ///
  /// In en, this message translates to:
  /// **'Madinah Hotel'**
  String get madinahHotel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @congratsTitle.
  ///
  /// In en, this message translates to:
  /// **'Congrats! You have\npersonalised Umrah trips\nonboards!'**
  String get congratsTitle;

  /// No description provided for @congratsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Now you can have a wonderful Umrah\njourney insights.'**
  String get congratsSubtitle;

  /// No description provided for @goToSavedTrips.
  ///
  /// In en, this message translates to:
  /// **'Go to saved trips'**
  String get goToSavedTrips;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @tripSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Trip saved successfully!'**
  String get tripSavedSuccess;

  /// No description provided for @tripAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'Trip already saved!'**
  String get tripAlreadySaved;

  /// No description provided for @errorSavingTrip.
  ///
  /// In en, this message translates to:
  /// **'Error saving trip: {error}'**
  String errorSavingTrip(String error);

  /// No description provided for @errorSharingTrip.
  ///
  /// In en, this message translates to:
  /// **'Error sharing trip: {error}'**
  String errorSharingTrip(String error);

  /// No description provided for @masjidAlHaram.
  ///
  /// In en, this message translates to:
  /// **'Masjid al-Haram'**
  String get masjidAlHaram;

  /// No description provided for @jabalAlNour.
  ///
  /// In en, this message translates to:
  /// **'Jabal al-Nour (Cave of Hira)'**
  String get jabalAlNour;

  /// No description provided for @jabalThawr.
  ///
  /// In en, this message translates to:
  /// **'Jabal Thawr'**
  String get jabalThawr;

  /// No description provided for @jannatAlMualla.
  ///
  /// In en, this message translates to:
  /// **'Jannat al-Mu\'alla'**
  String get jannatAlMualla;

  /// No description provided for @masjidAlJinn.
  ///
  /// In en, this message translates to:
  /// **'Masjid Al-Jinn'**
  String get masjidAlJinn;

  /// No description provided for @masjidAisha.
  ///
  /// In en, this message translates to:
  /// **'Masjid Aisha (Taneem)'**
  String get masjidAisha;

  /// No description provided for @mountArafat.
  ///
  /// In en, this message translates to:
  /// **'Mount Arafat (Jabal al-Rahmah)'**
  String get mountArafat;

  /// No description provided for @minaMuzdalifah.
  ///
  /// In en, this message translates to:
  /// **'Mina & Muzdalifah'**
  String get minaMuzdalifah;

  /// No description provided for @birthplaceProphet.
  ///
  /// In en, this message translates to:
  /// **'Birthplace of the Prophet (Mawlid)'**
  String get birthplaceProphet;

  /// No description provided for @masjidAlRayyah.
  ///
  /// In en, this message translates to:
  /// **'Masjid Al-Rayyah'**
  String get masjidAlRayyah;

  /// No description provided for @invalidEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailPassword;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get signInWithEmail;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalise your Umrah trips easily with Umrah Trip Planner Buddy.'**
  String get signInSubtitle;

  /// No description provided for @forgotPasswordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Forgot password feature coming soon'**
  String get forgotPasswordComingSoon;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @accountCreatedSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully, but automatic sign-in failed. Please sign in manually.'**
  String get accountCreatedSignInFailed;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists. Please use a different email.'**
  String get emailAlreadyExists;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create account easily with a simple steps and in real-time.'**
  String get createAccountSubtitle;

  /// No description provided for @displayNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your display name'**
  String get displayNameValidation;

  /// No description provided for @displayNameLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Display name must be at least 2 characters'**
  String get displayNameLengthValidation;

  /// No description provided for @passwordLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthValidation;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordValidation;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAccount;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'{count}-star'**
  String stars(int count);

  /// No description provided for @returnFlight.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnFlight;

  /// No description provided for @oneWayFlight.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWayFlight;

  /// No description provided for @transitFlight.
  ///
  /// In en, this message translates to:
  /// **'Transit'**
  String get transitFlight;

  /// No description provided for @directFlight.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get directFlight;

  /// No description provided for @carouselExploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Your Umrah Journey Now!'**
  String get carouselExploreTitle;

  /// No description provided for @carouselPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Journey Without Headache'**
  String get carouselPlanTitle;

  /// No description provided for @carouselNeedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore What You Need Now'**
  String get carouselNeedsTitle;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get weakPassword;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @masjidAlHaramDesc.
  ///
  /// In en, this message translates to:
  /// **'The Grand Mosque, housing the Kaaba.'**
  String get masjidAlHaramDesc;

  /// No description provided for @jabalAlNourDesc.
  ///
  /// In en, this message translates to:
  /// **'The mountain where the first revelation was received.'**
  String get jabalAlNourDesc;

  /// No description provided for @jabalThawrDesc.
  ///
  /// In en, this message translates to:
  /// **'The cave where Prophet Muhammad (PBUH) and Abu Bakr (RA) hid during migration.'**
  String get jabalThawrDesc;

  /// No description provided for @jannatAlMuallaDesc.
  ///
  /// In en, this message translates to:
  /// **'The cemetery where Khadija (RA) and many ancestors of the Prophet are buried.'**
  String get jannatAlMuallaDesc;

  /// No description provided for @masjidAlJinnDesc.
  ///
  /// In en, this message translates to:
  /// **'A mosque marking where a group of Jinn accepted Islam.'**
  String get masjidAlJinnDesc;

  /// No description provided for @masjidAishaDesc.
  ///
  /// In en, this message translates to:
  /// **'The nearest Miqat point for pilgrims in Makkah to renew Ihram.'**
  String get masjidAishaDesc;

  /// No description provided for @mountArafatDesc.
  ///
  /// In en, this message translates to:
  /// **'The Mount of Mercy, essential for Hajj but visited during Ziyarat tours.'**
  String get mountArafatDesc;

  /// No description provided for @minaMuzdalifahDesc.
  ///
  /// In en, this message translates to:
  /// **'Key Hajj sites, often visited during Ziyarat tours.'**
  String get minaMuzdalifahDesc;

  /// No description provided for @birthplaceProphetDesc.
  ///
  /// In en, this message translates to:
  /// **'Located near the Marwah hills (now a library).'**
  String get birthplaceProphetDesc;

  /// No description provided for @masjidAlRayyahDesc.
  ///
  /// In en, this message translates to:
  /// **'Known as the Mosque of the Flag.'**
  String get masjidAlRayyahDesc;

  /// No description provided for @masjidAnNabawi.
  ///
  /// In en, this message translates to:
  /// **'Masjid an-Nabawi'**
  String get masjidAnNabawi;

  /// No description provided for @masjidAnNabawiDesc.
  ///
  /// In en, this message translates to:
  /// **'The Prophet\'s Mosque and his Rawdah (tomb).'**
  String get masjidAnNabawiDesc;

  /// No description provided for @masjidQuba.
  ///
  /// In en, this message translates to:
  /// **'Masjid Quba'**
  String get masjidQuba;

  /// No description provided for @masjidQubaDesc.
  ///
  /// In en, this message translates to:
  /// **'The first mosque built in Islam; offering 2 rakat here equals the reward of an Umrah.'**
  String get masjidQubaDesc;

  /// No description provided for @jannatAlBaqi.
  ///
  /// In en, this message translates to:
  /// **'Jannat al-Baqi'**
  String get jannatAlBaqi;

  /// No description provided for @jannatAlBaqiDesc.
  ///
  /// In en, this message translates to:
  /// **'The main cemetery housing thousands of companions and family of the Prophet.'**
  String get jannatAlBaqiDesc;

  /// No description provided for @mountUhud.
  ///
  /// In en, this message translates to:
  /// **'Mount Uhud & Archers\' Hill'**
  String get mountUhud;

  /// No description provided for @mountUhudDesc.
  ///
  /// In en, this message translates to:
  /// **'Site of the Battle of Uhud and the cemetery of the martyrs (including Hamza RA).'**
  String get mountUhudDesc;

  /// No description provided for @masjidAlQiblatain.
  ///
  /// In en, this message translates to:
  /// **'Masjid Al-Qiblatain'**
  String get masjidAlQiblatain;

  /// No description provided for @masjidAlQiblatainDesc.
  ///
  /// In en, this message translates to:
  /// **'The mosque where the prayer direction changed from Jerusalem to Makkah.'**
  String get masjidAlQiblatainDesc;

  /// No description provided for @sevenMosques.
  ///
  /// In en, this message translates to:
  /// **'The Seven Mosques (Khandaq)'**
  String get sevenMosques;

  /// No description provided for @sevenMosquesDesc.
  ///
  /// In en, this message translates to:
  /// **'Site of the Battle of the Trench.'**
  String get sevenMosquesDesc;

  /// No description provided for @masjidAlGhamamah.
  ///
  /// In en, this message translates to:
  /// **'Masjid Al-Ghamamah'**
  String get masjidAlGhamamah;

  /// No description provided for @masjidAlGhamamahDesc.
  ///
  /// In en, this message translates to:
  /// **'Where the Prophet performed Eid and Rain prayers.'**
  String get masjidAlGhamamahDesc;

  /// No description provided for @masjidAlJummah.
  ///
  /// In en, this message translates to:
  /// **'Masjid Al-Jummah'**
  String get masjidAlJummah;

  /// No description provided for @masjidAlJummahDesc.
  ///
  /// In en, this message translates to:
  /// **'Where the first Friday prayer was offered.'**
  String get masjidAlJummahDesc;

  /// No description provided for @masjidBilal.
  ///
  /// In en, this message translates to:
  /// **'Masjid Bilal'**
  String get masjidBilal;

  /// No description provided for @masjidBilalDesc.
  ///
  /// In en, this message translates to:
  /// **'Near the date market, named after Bilal ibn Rabah (RA).'**
  String get masjidBilalDesc;

  /// No description provided for @ethiqWell.
  ///
  /// In en, this message translates to:
  /// **'Ethiq Well (Garden of Salman Farsi)'**
  String get ethiqWell;

  /// No description provided for @ethiqWellDesc.
  ///
  /// In en, this message translates to:
  /// **'Associated with the story of Salman Farsi\'s freedom.'**
  String get ethiqWellDesc;

  /// No description provided for @validPassport.
  ///
  /// In en, this message translates to:
  /// **'Valid Passport'**
  String get validPassport;

  /// No description provided for @validPassportDesc.
  ///
  /// In en, this message translates to:
  /// **'Must have 6 months validity.'**
  String get validPassportDesc;

  /// No description provided for @umrahVisa.
  ///
  /// In en, this message translates to:
  /// **'Umrah Visa'**
  String get umrahVisa;

  /// No description provided for @umrahVisaDesc.
  ///
  /// In en, this message translates to:
  /// **'Electronic visa or tourist visa (depending on nationality).'**
  String get umrahVisaDesc;

  /// No description provided for @nusukApp.
  ///
  /// In en, this message translates to:
  /// **'Nusuk App'**
  String get nusukApp;

  /// No description provided for @nusukAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Installed and registered (for Rawdah permits).'**
  String get nusukAppDesc;

  /// No description provided for @vaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinations;

  /// No description provided for @vaccinationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Meningitis (mandatory), Influenza (recommended).'**
  String get vaccinationsDesc;

  /// No description provided for @physicalStamina.
  ///
  /// In en, this message translates to:
  /// **'Physical Stamina'**
  String get physicalStamina;

  /// No description provided for @physicalStaminaDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice walking 5-10km daily before the trip.'**
  String get physicalStaminaDesc;

  /// No description provided for @ihramCloths.
  ///
  /// In en, this message translates to:
  /// **'Ihram Cloths (Men)'**
  String get ihramCloths;

  /// No description provided for @ihramClothsDesc.
  ///
  /// In en, this message translates to:
  /// **'2 sets of white, unstitched towels.'**
  String get ihramClothsDesc;

  /// No description provided for @ihramBelt.
  ///
  /// In en, this message translates to:
  /// **'Ihram Belt (Men)'**
  String get ihramBelt;

  /// No description provided for @ihramBeltDesc.
  ///
  /// In en, this message translates to:
  /// **'To hold the lower garment and keep money/phone safe.'**
  String get ihramBeltDesc;

  /// No description provided for @footwearMen.
  ///
  /// In en, this message translates to:
  /// **'Footwear (Men)'**
  String get footwearMen;

  /// No description provided for @footwearMenDesc.
  ///
  /// In en, this message translates to:
  /// **'Slippers/sandals that leave the ankles and metatarsals exposed.'**
  String get footwearMenDesc;

  /// No description provided for @toiletries.
  ///
  /// In en, this message translates to:
  /// **'Unscented Toiletries'**
  String get toiletries;

  /// No description provided for @toiletriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Soap, shampoo, deodorant (for use while in Ihram).'**
  String get toiletriesDesc;

  /// No description provided for @ihramClothingWomen.
  ///
  /// In en, this message translates to:
  /// **'Ihram Clothing (Women)'**
  String get ihramClothingWomen;

  /// No description provided for @ihramClothingWomenDesc.
  ///
  /// In en, this message translates to:
  /// **'Modest, loose-fitting abayas (any color, though white/black are common).'**
  String get ihramClothingWomenDesc;

  /// No description provided for @footwearWomen.
  ///
  /// In en, this message translates to:
  /// **'Comfortable Footwear (Women)'**
  String get footwearWomen;

  /// No description provided for @footwearWomenDesc.
  ///
  /// In en, this message translates to:
  /// **'Sneakers or soft walking shoes.'**
  String get footwearWomenDesc;

  /// No description provided for @hairAccessories.
  ///
  /// In en, this message translates to:
  /// **'Hair Accessories (Women)'**
  String get hairAccessories;

  /// No description provided for @hairAccessoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'To manage hair under the hijab during rituals.'**
  String get hairAccessoriesDesc;

  /// No description provided for @firstAidKit.
  ///
  /// In en, this message translates to:
  /// **'First Aid Kit'**
  String get firstAidKit;

  /// No description provided for @firstAidKitDesc.
  ///
  /// In en, this message translates to:
  /// **'Painkillers, flu meds, oral rehydration salts, blister plasters.'**
  String get firstAidKitDesc;

  /// No description provided for @prayerMat.
  ///
  /// In en, this message translates to:
  /// **'Prayer Mat'**
  String get prayerMat;

  /// No description provided for @prayerMatDesc.
  ///
  /// In en, this message translates to:
  /// **'Lightweight travel version.'**
  String get prayerMatDesc;

  /// No description provided for @drawstringBag.
  ///
  /// In en, this message translates to:
  /// **'Drawstring Bag'**
  String get drawstringBag;

  /// No description provided for @drawstringBagDesc.
  ///
  /// In en, this message translates to:
  /// **'To carry shoes when entering the mosque.'**
  String get drawstringBagDesc;

  /// No description provided for @travelAdapter.
  ///
  /// In en, this message translates to:
  /// **'Universal Travel Adapter'**
  String get travelAdapter;

  /// No description provided for @travelAdapterDesc.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia uses Type G (British style).'**
  String get travelAdapterDesc;

  /// No description provided for @makkahGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Makkah: The Spiritual Core'**
  String get makkahGuideTitle;

  /// No description provided for @catReligious.
  ///
  /// In en, this message translates to:
  /// **'Religious & Historical Landmarks (Ziyarat)'**
  String get catReligious;

  /// No description provided for @masjidAlHaramActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Perform Tawaf (circumambulation) and Sa’i; drink Zamzam water.'**
  String get masjidAlHaramActivity;

  /// No description provided for @jabalAlNourActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Hiking to the cave (approx. 45 min - 1 hour climb). Note: Best done before Fajr to avoid heat.'**
  String get jabalAlNourActivity;

  /// No description provided for @jabalThawrActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Hiking and viewing the cave.'**
  String get jabalThawrActivity;

  /// No description provided for @mountArafatActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Climbing the small hill where the Prophet delivered his Farewell Sermon; making dua.'**
  String get mountArafatActivity;

  /// No description provided for @jannatAlMuallaActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Visiting the graves to pay respects.'**
  String get jannatAlMuallaActivity;

  /// No description provided for @catMuseums.
  ///
  /// In en, this message translates to:
  /// **'Museums & Culture'**
  String get catMuseums;

  /// No description provided for @hiraCulturalDistrict.
  ///
  /// In en, this message translates to:
  /// **'Hira Cultural District'**
  String get hiraCulturalDistrict;

  /// No description provided for @hiraCulturalDistrictDesc.
  ///
  /// In en, this message translates to:
  /// **'Located at the foot of Jabal Al-Nour.'**
  String get hiraCulturalDistrictDesc;

  /// No description provided for @hiraCulturalDistrictWhy.
  ///
  /// In en, this message translates to:
  /// **'Why visit: A modern museum utilizing 3D technology to explain the story of the revelation. It is much easier than climbing the mountain for those who are elderly.'**
  String get hiraCulturalDistrictWhy;

  /// No description provided for @exhibitionHolyMosques.
  ///
  /// In en, this message translates to:
  /// **'The Exhibition of the Two Holy Mosques Architecture'**
  String get exhibitionHolyMosques;

  /// No description provided for @exhibitionHolyMosquesDesc.
  ///
  /// In en, this message translates to:
  /// **'Located in the Umm Al-Joud district.'**
  String get exhibitionHolyMosquesDesc;

  /// No description provided for @exhibitionHolyMosquesWhy.
  ///
  /// In en, this message translates to:
  /// **'Why visit: Contains historical artifacts like the Old Teak Wooden Staircase of the Kaaba (from 1825) and old doors of the Masjid Al-Haram.'**
  String get exhibitionHolyMosquesWhy;

  /// No description provided for @makkahClockTowerMuseum.
  ///
  /// In en, this message translates to:
  /// **'Makkah Clock Tower Museum'**
  String get makkahClockTowerMuseum;

  /// No description provided for @makkahClockTowerMuseumDesc.
  ///
  /// In en, this message translates to:
  /// **'Located in the top floors of the Clock Tower.'**
  String get makkahClockTowerMuseumDesc;

  /// No description provided for @makkahClockTowerMuseumWhy.
  ///
  /// In en, this message translates to:
  /// **'Why visit: Features an astronomy museum and the highest observation deck in Makkah for a panoramic view of the Haram.'**
  String get makkahClockTowerMuseumWhy;

  /// No description provided for @kiswaFactory.
  ///
  /// In en, this message translates to:
  /// **'The Kiswa Factory'**
  String get kiswaFactory;

  /// No description provided for @kiswaFactoryActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Watch artisans hand-embroider the gold threads onto the black silk cloth (Kiswa) that covers the Kaaba. Note: Usually requires a permit or group booking.'**
  String get kiswaFactoryActivity;

  /// No description provided for @catLeisure.
  ///
  /// In en, this message translates to:
  /// **'Leisure & Shopping Activities'**
  String get catLeisure;

  /// No description provided for @makkahMall.
  ///
  /// In en, this message translates to:
  /// **'Makkah Mall'**
  String get makkahMall;

  /// No description provided for @makkahMallDesc.
  ///
  /// In en, this message translates to:
  /// **'One of the largest modern malls in the city.'**
  String get makkahMallDesc;

  /// No description provided for @makkahMallActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Shopping for international brands and dining.'**
  String get makkahMallActivity;

  /// No description provided for @binDawood.
  ///
  /// In en, this message translates to:
  /// **'Bin Dawood Supermarkets'**
  String get binDawood;

  /// No description provided for @binDawoodActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Buying local snacks, dates, and souvenirs (located inside the Clock Tower and near Haram).'**
  String get binDawoodActivity;

  /// No description provided for @eatAlbaik.
  ///
  /// In en, this message translates to:
  /// **'Eat \"Albaik\"'**
  String get eatAlbaik;

  /// No description provided for @eatAlbaikActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Trying the famous Saudi fried chicken (a \"must-do\" ritual for almost every pilgrim).'**
  String get eatAlbaikActivity;

  /// No description provided for @madinahGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Madinah: The City of Peace'**
  String get madinahGuideTitle;

  /// No description provided for @masjidAnNabawiActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Salam to the Prophet (PBUH) and his companions; Praying in the Rawdah (Garden of Paradise) – Requires a permit via the Nusuk App.'**
  String get masjidAnNabawiActivity;

  /// No description provided for @masjidQubaActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Praying 2 Rakaat (Equivalent to the reward of an Umrah).'**
  String get masjidQubaActivity;

  /// No description provided for @mountUhudActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Climbing the small Archers\' Hill; visiting the Shuhada Cemetery (Graves of Hamza RA and other martyrs).'**
  String get mountUhudActivity;

  /// No description provided for @masjidAlQiblatainActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Visiting the site where the prayer direction changed from Jerusalem to Makkah.'**
  String get masjidAlQiblatainActivity;

  /// No description provided for @sevenMosquesActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Visiting the small historical mosques (Masjid Fath, Masjid Salman Farsi, etc.).'**
  String get sevenMosquesActivity;

  /// No description provided for @jannatAlBaqiActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Visiting the graves of thousands of Sahaba and family members of the Prophet. Note: Open briefly after Fajr and Asr prayers.'**
  String get jannatAlBaqiActivity;

  /// No description provided for @prophetBiographyMuseum.
  ///
  /// In en, this message translates to:
  /// **'International Fair and Museum of the Prophet\'s Biography'**
  String get prophetBiographyMuseum;

  /// No description provided for @prophetBiographyMuseumDesc.
  ///
  /// In en, this message translates to:
  /// **'Located just outside the Prophet\'s Mosque (south side).'**
  String get prophetBiographyMuseumDesc;

  /// No description provided for @prophetBiographyMuseumWhy.
  ///
  /// In en, this message translates to:
  /// **'Why visit: Incredible modern displays and cinema screens detailing the life of the Prophet (Seerah) and a model of his house. Highly recommended.'**
  String get prophetBiographyMuseumWhy;

  /// No description provided for @hejazRailwayMuseum.
  ///
  /// In en, this message translates to:
  /// **'Hejaz Railway Museum'**
  String get hejazRailwayMuseum;

  /// No description provided for @hejazRailwayMuseumWhy.
  ///
  /// In en, this message translates to:
  /// **'Why visit: An old Ottoman railway station converted into a museum showing the history of the train line that once connected Damascus to Madinah.'**
  String get hejazRailwayMuseumWhy;

  /// No description provided for @darAlMadinahMuseum.
  ///
  /// In en, this message translates to:
  /// **'Dar Al Madinah Museum'**
  String get darAlMadinahMuseum;

  /// No description provided for @darAlMadinahMuseumWhy.
  ///
  /// In en, this message translates to:
  /// **'Why visit: Focuses specifically on the architectural history and expansion of Madinah city over the centuries.'**
  String get darAlMadinahMuseumWhy;

  /// No description provided for @catLeisureNature.
  ///
  /// In en, this message translates to:
  /// **'Leisure & Nature Activities'**
  String get catLeisureNature;

  /// No description provided for @madinahDatesMarket.
  ///
  /// In en, this message translates to:
  /// **'Madinah Dates Market (Souq Al Tumour)'**
  String get madinahDatesMarket;

  /// No description provided for @madinahDatesMarketActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Tasting and buying Ajwa dates (and many other varieties) to take home.'**
  String get madinahDatesMarketActivity;

  /// No description provided for @ethiqWellActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: Visiting the garden associated with the freeing of Salman Farsi; enjoying tea under the date palms.'**
  String get ethiqWellActivity;

  /// No description provided for @madinahHopOnBus.
  ///
  /// In en, this message translates to:
  /// **'Madinah Hop-On Hop-Off Bus'**
  String get madinahHopOnBus;

  /// No description provided for @madinahHopOnBusActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity: A double-decker bus tour that loops around all the major historical sites (great for DIY travelers).'**
  String get madinahHopOnBusActivity;
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
      <String>['en', 'ms'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ms':
      return AppLocalizationsMs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
