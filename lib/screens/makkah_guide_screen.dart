import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/generated/app_localizations.dart';

class MakkahGuideScreen extends StatefulWidget {
  const MakkahGuideScreen({super.key});

  @override
  State<MakkahGuideScreen> createState() => _MakkahGuideScreenState();
}

class _MakkahGuideScreenState extends State<MakkahGuideScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    // Data Structure
    final religiousPlaces = [
      GuideItem(
        title: l10n.masjidAlHaram,
        description: l10n.masjidAlHaramDesc,
        activity: l10n.masjidAlHaramActivity,
      ),
      GuideItem(
        title: l10n.jabalAlNour,
        description: l10n.jabalAlNourDesc,
        activity: l10n.jabalAlNourActivity,
      ),
      GuideItem(
        title: l10n.jabalThawr,
        description: l10n.jabalThawrDesc,
        activity: l10n.jabalThawrActivity,
      ),
      GuideItem(
        title: l10n.mountArafat,
        description: l10n.mountArafatDesc,
        activity: l10n.mountArafatActivity,
      ),
      GuideItem(
        title: l10n.jannatAlMualla,
        description: l10n.jannatAlMuallaDesc,
        activity: l10n.jannatAlMuallaActivity,
      ),
    ];

    final museums = [
      GuideItem(
        title: l10n.hiraCulturalDistrict,
        description: l10n.hiraCulturalDistrictDesc,
        activity: l10n.hiraCulturalDistrictWhy, 
      ),
      GuideItem(
        title: l10n.exhibitionHolyMosques,
        description: l10n.exhibitionHolyMosquesDesc,
        activity: l10n.exhibitionHolyMosquesWhy,
      ),
      GuideItem(
        title: l10n.makkahClockTowerMuseum,
        description: l10n.makkahClockTowerMuseumDesc,
        activity: l10n.makkahClockTowerMuseumWhy,
      ),
      GuideItem(
        title: l10n.kiswaFactory,
        description: '', // Description embedded in activity for this one
        activity: l10n.kiswaFactoryActivity,
      ),
    ];

    final leisure = [
      GuideItem(
        title: l10n.makkahMall,
        description: l10n.makkahMallDesc,
        activity: l10n.makkahMallActivity,
      ),
      GuideItem(
        title: l10n.binDawood,
        description: '',
        activity: l10n.binDawoodActivity,
      ),
      GuideItem(
        title: l10n.eatAlbaik,
        description: '',
        activity: l10n.eatAlbaikActivity,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.makkahGuideTitle,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/makkah-img2.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(l10n.catReligious, religiousPlaces),
                  const SizedBox(height: 24),
                  _buildSection(l10n.catMuseums, museums),
                  const SizedBox(height: 24),
                  _buildSection(l10n.catLeisure, leisure),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<GuideItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildGuideCard(item)),
      ],
    );
  }

  Widget _buildGuideCard(GuideItem item) {
    final theme = Theme.of(context);
    
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
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                item.description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
              ),
            ],
            const Divider(height: 24),
            Text(
              item.activity,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: theme.textTheme.bodyMedium?.color,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuideItem {
  final String title;
  final String description;
  final String activity;

  GuideItem({
    required this.title,
    required this.description,
    required this.activity,
  });
}
