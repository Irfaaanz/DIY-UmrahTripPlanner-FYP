import '../providers/language_provider.dart';

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  // Settings Screen
  String get settings => language == AppLanguage.malay ? 'Tetapan' : 'Settings';
  String get mode => language == AppLanguage.malay ? 'Mod' : 'Mode';
  String get languageText => language == AppLanguage.malay ? 'Bahasa' : 'Language';
  String get appVersion => language == AppLanguage.malay ? 'Versi aplikasi' : 'Apps version';

  // Home Screen
  String get welcomeOnboards => language == AppLanguage.malay ? 'Selamat Datang, ' : 'Welcome Onboards, ';
  String get exploreUmrahJourney => language == AppLanguage.malay ? 'Terokai perjalanan umrah anda sekarang!' : 'Explore your umrah journey now!';
  String get planJourneyWithoutHeadache => language == AppLanguage.malay ? 'Rancang perjalanan anda tanpa sakit kepala' : 'Plan your journey without headache';
  String get exploreWhatYouNeed => language == AppLanguage.malay ? 'terokai apa yang anda perlukan' : 'explore what you need';
  String get search => language == AppLanguage.malay ? 'Cari' : 'Search';
  String get exploreThingsToDo => language == AppLanguage.malay ? 'Terokai perkara yang perlu dilakukan di Arab Saudi' : 'Explore things to do in Saudi Arabia';
  String get startJourneyText => language == AppLanguage.malay 
      ? 'Mulakan perjalanan anda dengan perjalanan pertama dan rancang itinerary anda'
      : 'Start your journey with your first trip and plan your itinerary';
  String get exploreHere => language == AppLanguage.malay ? 'Terokai di sini' : 'Explore here';
  String get checkOutSights => language == AppLanguage.malay 
      ? 'Lihat tempat menarik dan aktiviti yang mesti dilihat'
      : 'Check out must-see sights and activities';
  String get exploreMakkah => language == AppLanguage.malay ? 'Terokai Makkah' : 'Explore Makkah';
  String get exploreMadinah => language == AppLanguage.malay ? 'Terokai Madinah' : 'Explore Madinah';

  // Drawer
  String get appName => language == AppLanguage.malay ? 'DIY Umrah Buddy' : 'DIY Umrah Buddy';
  String get appSubtitle => language == AppLanguage.malay ? 'Pelan Perjalanan Umrah' : 'Umrah Trip Planner';
  String get appSettings => language == AppLanguage.malay ? 'Tetapan Aplikasi' : 'App Settings';
  String get version => language == AppLanguage.malay ? 'Versi Aplikasi' : 'App Version';

  // My Trips Screen
  String get personalizeMyTrips => language == AppLanguage.malay ? 'Peribadikan Perjalanan Saya' : 'Personalise My Trips';
  String get letsStartJourney => language == AppLanguage.malay 
      ? 'Mari mulakan perjalanan Umrah anda bersama kami'
      : "Let's start your Umrah journey with us";
  String get travellingByOwn => language == AppLanguage.malay 
      ? 'Adakah anda melakukan perjalanan sendiri?'
      : "Are you travelling by own?";
  String get travellingByOwnDesc => language == AppLanguage.malay 
      ? 'Peribadikan semua bajet dan perancangan anda sendiri.'
      : "Personalised all your budgets and planning by yourself.";
  String get travellingByGroup => language == AppLanguage.malay 
      ? 'Adakah anda melakukan perjalanan secara berkumpulan?'
      : "Are you travelling by group?";
  String get travellingByGroupDesc => language == AppLanguage.malay 
      ? 'Peribadikan semua bajet dan perancangan oleh sekumpulan orang.'
      : "Personalised all the budgets and planning by a group of people.";
  String get skipForNow => language == AppLanguage.malay ? 'Langkau buat masa ini' : 'Skip for now';

  static AppLocalizations of(AppLanguage language) {
    return AppLocalizations(language);
  }
}
