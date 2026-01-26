// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Umrah Trip Planner';

  @override
  String welcomeUser(String userName) {
    return 'Welcome Onboards, $userName!';
  }

  @override
  String get settings => 'Settings';

  @override
  String get mode => 'Mode';

  @override
  String get language => 'Language';

  @override
  String get appVersion => 'App Version';

  @override
  String get diyUmrahBuddy => 'DIY Umrah Buddy';

  @override
  String get umrahTripPlannerSubtitle => 'Umrah Trip Planner';

  @override
  String get all => 'All';

  @override
  String get worshipPlaces => 'Worship Places';

  @override
  String get mustVisitPlace => 'Must Visit Place';

  @override
  String get umrahBasicNeeds => 'Umrah Basic Needs';

  @override
  String get exploreSaudi => 'Explore things to do in Saudi Arabia';

  @override
  String get startJourney =>
      'Start your journey with your first trip and plan your itinerary';

  @override
  String get exploreHere => 'Explore here';

  @override
  String get checkOutSights => 'Check out must-see sights and activities';

  @override
  String get exploreMakkah => 'Explore Makkah';

  @override
  String get exploreMadinah => 'Explore Madinah';

  @override
  String get makkahHolyCity => 'Makkah (The Holy City)';

  @override
  String get worshipAndZiyarat => 'Worship and Ziyarat Places';

  @override
  String get home => 'Home';

  @override
  String get myTrips => 'My Trips';

  @override
  String get saved => 'Saved';

  @override
  String get profile => 'Profile';

  @override
  String get personaliseMyTrips => 'Personalise My Trips';

  @override
  String get letsStartJourney => 'Let\'s start your Umrah journey with us';

  @override
  String get diyTravelPlan => 'DIY Travel\nPlan';

  @override
  String get personalisedBudgets =>
      'Personalised all your budgets and planning by yourself.';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get noSavedItems => 'No saved items';

  @override
  String get itemsWillAppearHere => 'Items you save will appear here';

  @override
  String selected(int count) {
    return '$count Selected';
  }

  @override
  String get dateNewestFirst => 'Date (Newest First)';

  @override
  String get nameAZ => 'Name (A-Z)';

  @override
  String get deleteTrip => 'Delete Trip';

  @override
  String get areYouSureDelete => 'Are you sure you want to delete this trip?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get tripDeleted => 'Trip deleted';

  @override
  String get selectedTripsDeleted => 'Selected trips deleted';

  @override
  String get editTripName => 'Edit Trip Name';

  @override
  String get enterTripName => 'Enter trip name';

  @override
  String get save => 'Save';

  @override
  String get age => 'Age';

  @override
  String get budget => 'Budget';

  @override
  String get duration => 'Duration';

  @override
  String get years => 'years';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get profileDetails => 'Profile details';

  @override
  String get faq => 'FAQ';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get logOut => 'Log Out';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get profilePictureRemoved => 'Profile picture removed';

  @override
  String get galleryPickerNotImplemented =>
      'Gallery picker will be implemented here';

  @override
  String get cameraNotImplemented =>
      'Camera functionality will be implemented here';

  @override
  String get loggedOutSuccessfully => 'Logged out successfully';

  @override
  String get areYouSureLogOut => 'Are you sure you want to log out?';

  @override
  String get insertTripName => 'Insert your Umrah Trip Name';

  @override
  String get tripNameHint => 'ian\'s trip';

  @override
  String get insertAge => 'Insert your age';

  @override
  String get ageHint => '30 years old';

  @override
  String get proceed => 'Proceed';

  @override
  String get insertJourneyBudget => 'Insert your journey budget';

  @override
  String get minBudgetWarning => 'Minimum amount of budget is RM4,000.00';

  @override
  String get others => 'Others';

  @override
  String get insertJourneyDuration => 'Insert your journey duration';

  @override
  String get daysInMakkah => 'No. of days in Makkah';

  @override
  String get daysInMadinah => 'No. of days in Madinah';

  @override
  String totalDays(int days) {
    return 'Total days: $days';
  }

  @override
  String get durationWarning =>
      'The minimum days is 5 days and maximum days is 14 days';

  @override
  String get chooseHotelPref => 'Choose your hotel preferences';

  @override
  String get hotelPref => 'Hotel preferences';

  @override
  String get pickHotelPref => 'Pick your hotel preferences';

  @override
  String get hotelDist => 'Hotel distance to Masjidil Haram';

  @override
  String get pickHotelDist => 'Pick your hotel distance';

  @override
  String get luxury => 'Luxury';

  @override
  String get premium => 'Premium';

  @override
  String get standard => 'Standard';

  @override
  String get economy => 'Economy';

  @override
  String get veryNear => 'Very Near';

  @override
  String get near => 'Near';

  @override
  String get far => 'Far';

  @override
  String get chooseTransportPref => 'Choose your transport preferences';

  @override
  String get transportPref => 'Transportation preference';

  @override
  String get pickTransportPref => 'Pick your transportation preferences';

  @override
  String get comfortable => 'Comfortable';

  @override
  String get moderate => 'Moderate';

  @override
  String get minimal => 'Minimal';

  @override
  String get faqTitle => 'Frequently Asked Questions';

  @override
  String get generalInfo => 'General Information';

  @override
  String get featuresPlanning => 'Features & Itinerary Planning';

  @override
  String get technicalUsage => 'Technical & Usage';

  @override
  String get developerName => '\'Irfan (Apps Developer)';

  @override
  String get contactUsDesc =>
      'You can leave any enquiry below if there are any problems or bugs experienced while using our apps!';

  @override
  String get yourEmail => 'Your email address';

  @override
  String get enquiries => 'Enquiries';

  @override
  String get submit => 'Submit';

  @override
  String get inquirySubmitted => 'Inquiry submitted successfully!';

  @override
  String get emailError =>
      'Could not send email to fanzr24@gmail.com. Please check your email client settings or try again later.';

  @override
  String get enterEmail => 'Please enter your email address';

  @override
  String get validEmail => 'Please enter a valid email address';

  @override
  String get enterEnquiry => 'Please enter your enquiry';

  @override
  String get displayName => 'Display Name';

  @override
  String get fullName => 'Full Name';

  @override
  String get gender => 'Gender';

  @override
  String get emailAddress => 'Email address';

  @override
  String get phoneNo => 'Phone No.';

  @override
  String get passwords => 'Passwords';

  @override
  String get profileSaved => 'Profile saved successfully!';

  @override
  String get errorSavingProfile => 'Error saving profile';

  @override
  String get chooseFlightPref => 'Choose your flight preferences';

  @override
  String get flightPref => 'Flight preference';

  @override
  String get pickFlightPref => 'Pick your flight preferences';

  @override
  String get airlineServiceType => 'Airline Service Type';

  @override
  String get pickServiceType => 'Full Service or Low Cost';

  @override
  String get direct => 'Direct';

  @override
  String get transit => 'Transit';

  @override
  String get fullService => 'Full Service';

  @override
  String get lowCost => 'Low Cost';

  @override
  String get dailyExpenses => 'Daily expenses';

  @override
  String get selectDailyLimit => 'Select your daily limit';

  @override
  String get foodDrink => 'Food & Drink';

  @override
  String get simcardInternet => 'Simcard & Internet';

  @override
  String get souvenirs => 'Souvenirs';

  @override
  String get miscellaneous => 'Miscellaneous';

  @override
  String get transportation => 'Transportation';

  @override
  String get generateItinerary => 'Generate Itinerary';

  @override
  String get dailyExpensesPrefTitle => 'Choose your daily expenses preferences';

  @override
  String get dailyExpensesPrefLabel => 'Daily expenses preference';

  @override
  String get pickDailyExpensesPref => 'Pick your expenses preferences';

  @override
  String get yourTripPreferences => 'Your Trip Preferences';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get tripName => 'Trip Name';

  @override
  String get hotelAllocation => 'Hotel Allocation Budget Breakdown';

  @override
  String get flightAllocation => 'Flight Allocation Budget Breakdown';

  @override
  String get transportAllocation => 'Transport Allocation Budget Breakdown';

  @override
  String get expensesAllocation => 'Expenses Allocation Budget Breakdown';

  @override
  String get totalCostBreakdown => 'Total Cost Breakdown';

  @override
  String get optimizingBudget => 'Optimizing your budget...';

  @override
  String get optimizedBudgetTitle =>
      'Overall optimised budget\nbased on your current\npreferences.';

  @override
  String get savings => 'Savings';

  @override
  String get overBudget => 'Over Budget';

  @override
  String get bestPossiblePrice => 'Best Possible Price';

  @override
  String get hotelNameMakkah => 'Hotel Name (Makkah)';

  @override
  String get hotelNameMadinah => 'Hotel Name (Madinah)';

  @override
  String get hotelRatings => 'Hotel Ratings';

  @override
  String get hotelDistanceLabel => 'Hotel Distance';

  @override
  String get totalDaysStay => 'Total days of stay';

  @override
  String get cost => 'Cost';

  @override
  String get airline => 'Airline';

  @override
  String get type => 'Type';

  @override
  String get transportType => 'Transport Type';

  @override
  String get fixedTransportCost => 'Fixed Transport Cost';

  @override
  String get dailyCommute => 'Daily commute around city';

  @override
  String get totalCost => 'Total Cost';

  @override
  String get tier => 'Tier';

  @override
  String get dailyCost => 'Daily Cost';

  @override
  String get totalDaysLabel => 'Total Days';

  @override
  String get total => 'Total';

  @override
  String get makkahHotel => 'Makkah Hotel';

  @override
  String get madinahHotel => 'Madinah Hotel';

  @override
  String get saveButton => 'Save';

  @override
  String get congratsTitle =>
      'Congrats! You have\npersonalised Umrah trips\nonboards!';

  @override
  String get congratsSubtitle =>
      'Now you can have a wonderful Umrah\njourney insights.';

  @override
  String get goToSavedTrips => 'Go to saved trips';

  @override
  String get done => 'Done';

  @override
  String get tripSavedSuccess => 'Trip saved successfully!';

  @override
  String get tripAlreadySaved => 'Trip already saved!';

  @override
  String errorSavingTrip(String error) {
    return 'Error saving trip: $error';
  }

  @override
  String errorSharingTrip(String error) {
    return 'Error sharing trip: $error';
  }

  @override
  String get masjidAlHaram => 'Masjid al-Haram';

  @override
  String get jabalAlNour => 'Jabal al-Nour (Cave of Hira)';

  @override
  String get jabalThawr => 'Jabal Thawr';

  @override
  String get jannatAlMualla => 'Jannat al-Mu\'alla';

  @override
  String get masjidAlJinn => 'Masjid Al-Jinn';

  @override
  String get masjidAisha => 'Masjid Aisha (Taneem)';

  @override
  String get mountArafat => 'Mount Arafat (Jabal al-Rahmah)';

  @override
  String get minaMuzdalifah => 'Mina & Muzdalifah';

  @override
  String get birthplaceProphet => 'Birthplace of the Prophet (Mawlid)';

  @override
  String get masjidAlRayyah => 'Masjid Al-Rayyah';

  @override
  String get invalidEmailPassword => 'Invalid email or password';

  @override
  String get signInWithEmail => 'Sign in with email';

  @override
  String get signInSubtitle =>
      'Personalise your Umrah trips easily with Umrah Trip Planner Buddy.';

  @override
  String get forgotPasswordComingSoon => 'Forgot password feature coming soon';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get accountCreatedSignInFailed =>
      'Account created successfully, but automatic sign-in failed. Please sign in manually.';

  @override
  String get emailAlreadyExists =>
      'Email already exists. Please use a different email.';

  @override
  String get createAccount => 'Create an account';

  @override
  String get createAccountSubtitle =>
      'Create account easily with a simple steps and in real-time.';

  @override
  String get displayNameValidation => 'Please enter your display name';

  @override
  String get displayNameLengthValidation =>
      'Display name must be at least 2 characters';

  @override
  String get passwordLengthValidation =>
      'Password must be at least 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordValidation => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get haveAccount => 'Have an account?';

  @override
  String stars(int count) {
    return '$count-star';
  }

  @override
  String get returnFlight => 'Return';

  @override
  String get oneWayFlight => 'One Way';

  @override
  String get transitFlight => 'Transit';

  @override
  String get directFlight => 'Direct';

  @override
  String get carouselExploreTitle => 'Explore Your Umrah Journey Now!';

  @override
  String get carouselPlanTitle => 'Plan Your Journey Without Headache';

  @override
  String get carouselNeedsTitle => 'Explore What You Need Now';

  @override
  String get weakPassword => 'The password provided is too weak.';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';
}
