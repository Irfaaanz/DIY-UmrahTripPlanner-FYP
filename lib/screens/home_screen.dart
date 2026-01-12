import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'my_trips_screen.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';

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
  final List<CarouselItem> _carouselItems = [
    CarouselItem(
      image: 'assets/images/makkah-img.jpg',
      text: 'Explore Your Umrah Journey Now!',
    ),
    CarouselItem(
      image: 'assets/images/makkah-img2.jpg',
      text: 'Plan Your Journey Without Headache',
    ),
    CarouselItem(
      image: 'assets/images/madinah.jpeg',
      text: 'Explore What You Need Now',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _startAutoScroll();
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
      if (_pageController.hasClients) {
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
      backgroundColor: Colors.white,
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
        final isMalay = languageProvider.currentLanguage == AppLanguage.malay;
        
        return Drawer(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                // Drawer Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : const Color(0xFFE3F2FD),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIY Umrah Buddy',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isMalay ? 'Pelan Perjalanan Umrah' : 'Umrah Trip Planner',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDark ? Colors.grey[300] : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // App Settings Section (Expandable)
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  title: Text(
                    isMalay ? 'Tetapan' : 'Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  trailing: Icon(
                    _isSettingsExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isDark ? Colors.grey[400] : Colors.black54,
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
                    color: isDark ? Colors.grey[850] : Colors.grey[50],
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
                                isMalay ? 'Mod' : 'Mode',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black87,
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
                                isMalay ? 'Bahasa' : 'Language',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black87,
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
                            isMalay ? 'Versi Aplikasi' : 'App Version',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey[400] : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1.0.0',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
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
                    'Welcome Onboards, $_userName!',
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryFilterItem(
            label: 'All',
            isSelected: _selectedCategory == CategoryType.all,
            onTap: () => setState(() => _selectedCategory = CategoryType.all),
          ),
          const SizedBox(width: 16),
          _buildCategoryFilterItem(
            label: 'Worship Places',
            icon: Icons.mosque,
            isSelected: _selectedCategory == CategoryType.worshipPlaces,
            onTap: () => setState(() => _selectedCategory = CategoryType.worshipPlaces),
          ),
          const SizedBox(width: 16),
          _buildCategoryFilterItem(
            label: 'Must Visit Place',
            icon: Icons.location_city,
            isSelected: _selectedCategory == CategoryType.mustVisitPlace,
            onTap: () => setState(() => _selectedCategory = CategoryType.mustVisitPlace),
          ),
          const SizedBox(width: 16),
          _buildCategoryFilterItem(
            label: 'Umrah Basic Needs',
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
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
                color: Colors.black87,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: Colors.black87,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore things to do in Saudi Arabia',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            image: 'assets/images/makkah-img.jpg',
            title: 'Start your journey with your first trip and plan your itinerary',
            buttonText: 'Explore here',
            onTap: _navigateToMyTrips,
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            image: 'assets/images/makkah-img2.jpg',
            title: 'Check out must-see sights and activities',
            buttonText: 'Explore Makkah',
            onTap: _navigateToMyTrips,
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            image: 'assets/images/madinah.jpeg',
            title: 'Check out must-see sights and activities',
            buttonText: 'Explore Madinah',
            onTap: _navigateToMyTrips,
          ),
        ],
      ),
    );
  }

  Widget _buildWorshipPlacesContent() {
    final places = [
      'Masjid al-Haram',
      'Jabal al-Nour (Cave of Hira)',
      'Jabal Thawr',
      'Jannat al-Mu\'alla',
      'Masjid Al-Jinn',
      'Masjid Aisha (Taneem)',
      'Mount Arafat (Jabal al-Rahmah)',
      'Mina & Muzdalifah',
      'Birthplace of the Prophet (Mawlid)',
      'Masjid Al-Rayyah',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Makkah (The Holy City)',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Worship and Ziyarat Places',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...places.map((place) => _buildPlaceItem(place)),
        ],
      ),
    );
  }

  Widget _buildMustVisitPlaceContent() {
    final places = [
      'Masjid al-Haram',
      'Jabal al-Nour (Cave of Hira)',
      'Jabal Thawr',
      'Jannat al-Mu\'alla',
      'Masjid Al-Jinn',
      'Masjid Aisha (Taneem)',
      'Mount Arafat (Jabal al-Rahmah)',
      'Mina & Muzdalifah',
      'Birthplace of the Prophet (Mawlid)',
      'Masjid Al-Rayyah',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Must Visit Place',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Worship and Ziyarat Places',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...places.map((place) => _buildPlaceItem(place)),
        ],
      ),
    );
  }

  Widget _buildUmrahBasicNeedsContent() {
    final places = [
      'Masjid al-Haram',
      'Jabal al-Nour (Cave of Hira)',
      'Jabal Thawr',
      'Jannat al-Mu\'alla',
      'Masjid Al-Jinn',
      'Masjid Aisha (Taneem)',
      'Mount Arafat (Jabal al-Rahmah)',
      'Mina & Muzdalifah',
      'Birthplace of the Prophet (Mawlid)',
      'Masjid Al-Rayyah',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Umrah Basic Needs',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Worship and Ziyarat Places',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...places.map((place) => _buildPlaceItem(place)),
        ],
      ),
    );
  }

  Widget _buildPlaceItem(String placeName) {
    final isExpanded = _expandedPlaces.contains(placeName);
    const loremIpsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              placeName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: 24,
              color: Colors.black54,
            ),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedPlaces.remove(placeName);
                } else {
                  _expandedPlaces.add(placeName);
                }
              });
            },
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                loremIpsum,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
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