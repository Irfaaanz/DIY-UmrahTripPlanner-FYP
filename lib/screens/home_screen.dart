import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'my_trips_screen.dart';
import 'makkah_guide_screen.dart';
import 'madinah_guide_screen.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum CategoryType {
  all,
  worshipPlaces,
  mustVisitPlace,
  umrahBasicNeeds,
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  String _userName = 'User';
  CategoryType _selectedCategory = CategoryType.all;
  bool _isSettingsExpanded = false;
  final Set<String> _expandedPlaces = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Carousel data
  List<CarouselItem> _carouselItems = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _startAutoScroll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCarouselItems();
  }

  void _updateCarouselItems() {
    final l10n = AppLocalizations.of(context)!;
    _carouselItems = [
      CarouselItem(
        image: 'assets/images/makkah-img.jpg',
        text: l10n.carouselExploreTitle,
      ),
      CarouselItem(
        image: 'assets/images/makkah-img2.jpg',
        text: l10n.carouselPlanTitle,
      ),
      CarouselItem(
        image: 'assets/images/madinah.jpeg',
        text: l10n.carouselNeedsTitle,
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserName() async {
    final displayName = await AuthService.getDisplayName();
    if (mounted) {
      setState(() {
        _userName = displayName ?? 'User';
      });
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_pageController.hasClients && _carouselItems.isNotEmpty) {
        _currentPage = (_currentPage + 1) % _carouselItems.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToMyTrips() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MyTripsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Carousel Section
              _buildHeaderCarousel(),
              
              // Category Filter Bar
              _buildCategoryFilterBar(),
              
              const SizedBox(height: 16),
              
              // Dynamic Content Based on Selected Category
              _buildCategoryContent(),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, _) {
        final isDark = themeProvider.isDarkMode;
        final l10n = AppLocalizations.of(context)!;
        
        return Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                // Drawer Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE3F2FD),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.diyUmrahBuddy,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.umrahTripPlannerSubtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // App Settings Section (Expandable)
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    l10n.settings,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  trailing: Icon(
                    _isSettingsExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                  ),
                  onTap: () {
                    setState(() {
                      _isSettingsExpanded = !_isSettingsExpanded;
                    });
                  },
                ),
                
                // Expandable Settings Content
                if (_isSettingsExpanded) ...[
                  Container(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[50], // Slightly lighter/darker than bg
                    child: Column(
                      children: [
                        // Mode Toggle
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.mode,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                              _buildModeToggle(themeProvider, isDark),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        // Language Selection
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.language,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                              _buildLanguageSelector(languageProvider, isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const Divider(),
                
                // App Version Section
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.appVersion,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1.0.0',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeToggle(ThemeProvider themeProvider, bool isDark) {
    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme(!isDark);
      },
      child: Container(
        width: 56,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.blue[600] : Colors.grey[300],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: isDark ? 28 : 4,
              top: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  size: 14,
                  color: isDark ? Colors.blue[900] : Colors.amber[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(LanguageProvider languageProvider, bool isDark) {
    final isMalay = languageProvider.currentLanguage == AppLanguage.malay;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Colors.grey[700] : Colors.grey[200],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageButton(
            'EN',
            !isMalay,
            () => languageProvider.setLanguage(AppLanguage.english),
            isDark,
          ),
          _buildLanguageButton(
            'MY',
            isMalay,
            () => languageProvider.setLanguage(AppLanguage.malay),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? (isDark ? Colors.black : Colors.black87)
              : Colors.transparent,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[400] : Colors.grey[700]),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomMenuIcon() {
    return SizedBox(
      width: 24,
      height: 18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24, // Longest line
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Container(
            width: 20, // Second longest line
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Container(
            width: 16, // Third longest (shortest) line
            height: 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCarousel() {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // PageView for carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _carouselItems.length,
            itemBuilder: (context, index) {
              return _buildCarouselItem(_carouselItems[index]);
            },
          ),
          
          // Top overlay with welcome text and menu
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcomeUser(_userName),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: _buildCustomMenuIcon(),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Text overlay at middle-bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _carouselItems[_currentPage].text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Page indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _carouselItems.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(CarouselItem item) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          item.image,
          fit: BoxFit.cover,
        ),
        // Dark overlay for better text visibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilterBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryFilterItem(
            label: l10n.all,
            isSelected: _selectedCategory == CategoryType.all,
            onTap: () => setState(() => _selectedCategory = CategoryType.all),
          ),
          const SizedBox(width: 16),
          _buildCategoryFilterItem(
            label: l10n.worshipPlaces,
            icon: Icons.mosque,
            isSelected: _selectedCategory == CategoryType.worshipPlaces,
            onTap: () => setState(() => _selectedCategory = CategoryType.worshipPlaces),
          ),
          const SizedBox(width: 16),
          _buildCategoryFilterItem(
            label: l10n.mustVisitPlace,
            icon: Icons.location_city,
            isSelected: _selectedCategory == CategoryType.mustVisitPlace,
            onTap: () => setState(() => _selectedCategory = CategoryType.mustVisitPlace),
          ),
          const SizedBox(width: 16),
          _buildCategoryFilterItem(
            label: l10n.umrahBasicNeeds,
            icon: Icons.checklist,
            isSelected: _selectedCategory == CategoryType.umrahBasicNeeds,
            onTap: () => setState(() => _selectedCategory = CategoryType.umrahBasicNeeds),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterItem({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final borderColor = isSelected ? theme.textTheme.bodyLarge?.color ?? Colors.black : Colors.transparent;
    final contentColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: contentColor,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case CategoryType.all:
        return _buildAllContent();
      case CategoryType.worshipPlaces:
        return _buildWorshipPlacesContent();
      case CategoryType.mustVisitPlace:
        return _buildMustVisitPlaceContent();
      case CategoryType.umrahBasicNeeds:
        return _buildUmrahBasicNeedsContent();
    }
  }

  Widget _buildAllContent() {
    final l10n = AppLocalizations.of(context)!;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.exploreSaudi,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            image: 'assets/images/makkah-img.jpg',
            title: l10n.startJourney,
            buttonText: l10n.exploreHere,
            onTap: _navigateToMyTrips,
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            image: 'assets/images/makkah-img2.jpg',
            title: l10n.checkOutSights,
            buttonText: l10n.exploreMakkah,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MakkahGuideScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            image: 'assets/images/madinah.jpeg',
            title: l10n.checkOutSights,
            buttonText: l10n.exploreMadinah,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MadinahGuideScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorshipPlacesContent() {
    final l10n = AppLocalizations.of(context)!;

    final titleColor = Theme.of(context).textTheme.titleLarge?.color ?? Colors.black87;
    final subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    final headerColor = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87;

    final makkahPlaces = [
      {'title': l10n.masjidAlHaram, 'description': l10n.masjidAlHaramDesc},
      {'title': l10n.jabalAlNour, 'description': l10n.jabalAlNourDesc},
      {'title': l10n.jabalThawr, 'description': l10n.jabalThawrDesc},
      {'title': l10n.jannatAlMualla, 'description': l10n.jannatAlMuallaDesc},
      {'title': l10n.masjidAlJinn, 'description': l10n.masjidAlJinnDesc},
      {'title': l10n.masjidAisha, 'description': l10n.masjidAishaDesc},
      {'title': l10n.mountArafat, 'description': l10n.mountArafatDesc},
      {'title': l10n.minaMuzdalifah, 'description': l10n.minaMuzdalifahDesc},
      {'title': l10n.birthplaceProphet, 'description': l10n.birthplaceProphetDesc},
      {'title': l10n.masjidAlRayyah, 'description': l10n.masjidAlRayyahDesc},
    ];

    final madinahPlaces = [
      {'title': l10n.masjidAnNabawi, 'description': l10n.masjidAnNabawiDesc},
      {'title': l10n.masjidQuba, 'description': l10n.masjidQubaDesc},
      {'title': l10n.jannatAlBaqi, 'description': l10n.jannatAlBaqiDesc},
      {'title': l10n.mountUhud, 'description': l10n.mountUhudDesc},
      {'title': l10n.masjidAlQiblatain, 'description': l10n.masjidAlQiblatainDesc},
      {'title': l10n.sevenMosques, 'description': l10n.sevenMosquesDesc},
      {'title': l10n.masjidAlGhamamah, 'description': l10n.masjidAlGhamamahDesc},
      {'title': l10n.masjidAlJummah, 'description': l10n.masjidAlJummahDesc},
      {'title': l10n.masjidBilal, 'description': l10n.masjidBilalDesc},
      {'title': l10n.ethiqWell, 'description': l10n.ethiqWellDesc},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.worshipPlaces,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.worshipAndZiyarat,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(l10n.makkahHolyCity, headerColor),
          ...makkahPlaces.map((place) => _buildPlaceItem(place['title']!, place['description']!)),
          const SizedBox(height: 16),
          _buildSectionHeader('Madinah (The City of the Prophet)', headerColor),
          ...madinahPlaces.map((place) => _buildPlaceItem(place['title']!, place['description']!)),
        ],
      ),
    );
  }

  Widget _buildMustVisitPlaceContent() {
    final l10n = AppLocalizations.of(context)!;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color ?? Colors.black87;
    final subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    final headerColor = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87;

    final makkahPlaces = [
      {'title': l10n.masjidAlHaram, 'description': l10n.masjidAlHaramDesc},
      {'title': l10n.jabalAlNour, 'description': l10n.jabalAlNourDesc},
      {'title': l10n.jabalThawr, 'description': l10n.jabalThawrDesc},
      {'title': l10n.jannatAlMualla, 'description': l10n.jannatAlMuallaDesc},
      {'title': l10n.masjidAlJinn, 'description': l10n.masjidAlJinnDesc},
      {'title': l10n.masjidAisha, 'description': l10n.masjidAishaDesc},
      {'title': l10n.mountArafat, 'description': l10n.mountArafatDesc},
      {'title': l10n.minaMuzdalifah, 'description': l10n.minaMuzdalifahDesc},
      {'title': l10n.birthplaceProphet, 'description': l10n.birthplaceProphetDesc},
      {'title': l10n.masjidAlRayyah, 'description': l10n.masjidAlRayyahDesc},
    ];

    final madinahPlaces = [
      {'title': l10n.masjidAnNabawi, 'description': l10n.masjidAnNabawiDesc},
      {'title': l10n.masjidQuba, 'description': l10n.masjidQubaDesc},
      {'title': l10n.jannatAlBaqi, 'description': l10n.jannatAlBaqiDesc},
      {'title': l10n.mountUhud, 'description': l10n.mountUhudDesc},
      {'title': l10n.masjidAlQiblatain, 'description': l10n.masjidAlQiblatainDesc},
      {'title': l10n.sevenMosques, 'description': l10n.sevenMosquesDesc},
      {'title': l10n.masjidAlGhamamah, 'description': l10n.masjidAlGhamamahDesc},
      {'title': l10n.masjidAlJummah, 'description': l10n.masjidAlJummahDesc},
      {'title': l10n.masjidBilal, 'description': l10n.masjidBilalDesc},
      {'title': l10n.ethiqWell, 'description': l10n.ethiqWellDesc},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mustVisitPlace,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.worshipAndZiyarat,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(l10n.makkahHolyCity, headerColor),
          ...makkahPlaces.map((place) => _buildPlaceItem(place['title']!, place['description']!)),
          const SizedBox(height: 16),
          _buildSectionHeader('Madinah (The City of the Prophet)', headerColor),
          ...madinahPlaces.map((place) => _buildPlaceItem(place['title']!, place['description']!)),
        ],
      ),
    );
  }

  Widget _buildUmrahBasicNeedsContent() {
    final l10n = AppLocalizations.of(context)!;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color ?? Colors.black87;
    final subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    final headerColor = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87;

    final preDeparture = [
      {'title': l10n.validPassport, 'description': l10n.validPassportDesc},
      {'title': l10n.umrahVisa, 'description': l10n.umrahVisaDesc},
      {'title': l10n.nusukApp, 'description': l10n.nusukAppDesc},
      {'title': l10n.vaccinations, 'description': l10n.vaccinationsDesc},
      {'title': l10n.physicalStamina, 'description': l10n.physicalStaminaDesc},
    ];

    final menNeeds = [
      {'title': l10n.ihramCloths, 'description': l10n.ihramClothsDesc},
      {'title': l10n.ihramBelt, 'description': l10n.ihramBeltDesc},
      {'title': l10n.footwearMen, 'description': l10n.footwearMenDesc},
      {'title': l10n.toiletries, 'description': l10n.toiletriesDesc},
    ];

    final womenNeeds = [
      {'title': l10n.ihramClothingWomen, 'description': l10n.ihramClothingWomenDesc},
      {'title': l10n.footwearWomen, 'description': l10n.footwearWomenDesc},
      {'title': l10n.hairAccessories, 'description': l10n.hairAccessoriesDesc},
    ];

    final generalEssentials = [
      {'title': l10n.firstAidKit, 'description': l10n.firstAidKitDesc},
      {'title': l10n.prayerMat, 'description': l10n.prayerMatDesc},
      {'title': l10n.drawstringBag, 'description': l10n.drawstringBagDesc},
      {'title': l10n.travelAdapter, 'description': l10n.travelAdapterDesc},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.umrahBasicNeeds,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.worshipAndZiyarat,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSectionHeader('Pre-Departure Preparation', headerColor),
          ...preDeparture.map((item) => _buildPlaceItem(item['title']!, item['description']!)),
          const SizedBox(height: 16),
          
          _buildSectionHeader('Basic Packing Needs (Men)', headerColor),
          ...menNeeds.map((item) => _buildPlaceItem(item['title']!, item['description']!)),
          const SizedBox(height: 16),

          _buildSectionHeader('Basic Packing Needs (Women)', headerColor),
          ...womenNeeds.map((item) => _buildPlaceItem(item['title']!, item['description']!)),
          const SizedBox(height: 16),

          _buildSectionHeader('General Essentials', headerColor),
          ...generalEssentials.map((item) => _buildPlaceItem(item['title']!, item['description']!)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPlaceItem(String title, String description) {
    final isExpanded = _expandedPlaces.contains(title);
    
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final subTextColor = theme.textTheme.bodyMedium?.color ?? Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: 24,
              color: subTextColor,
            ),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedPlaces.remove(title);
                } else {
                  _expandedPlaces.add(title);
                }
              });
            },
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required String image,
    required String title,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            // Dark overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200]?.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselItem {
  final String image;
  final String text;

  CarouselItem({
    required this.image,
    required this.text,
  });
}