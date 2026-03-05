import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/generated/app_localizations.dart';

class MadinahGuideScreen extends StatefulWidget {
  const MadinahGuideScreen({super.key});

  @override
  State<MadinahGuideScreen> createState() => _MadinahGuideScreenState();
}

class _MadinahGuideScreenState extends State<MadinahGuideScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    // Data Structure
    final religiousPlaces = [
      GuideItem(
        title: l10n.masjidAnNabawi,
        description: l10n.masjidAnNabawiDesc,
        activity: l10n.masjidAnNabawiActivity,
      ),
      GuideItem(
        title: l10n.masjidQuba,
        description: l10n.masjidQubaDesc,
        activity: l10n.masjidQubaActivity,
      ),
      GuideItem(
        title: l10n.mountUhud,
        description: l10n.mountUhudDesc,
        activity: l10n.mountUhudActivity,
      ),
      GuideItem(
        title: l10n.masjidAlQiblatain,
        description: l10n.masjidAlQiblatainDesc,
        activity: l10n.masjidAlQiblatainActivity,
      ),
      GuideItem(
        title: l10n.sevenMosques,
        description: l10n.sevenMosquesDesc,
        activity: l10n.sevenMosquesActivity,
      ),
      GuideItem(
        title: l10n.jannatAlBaqi,
        description: l10n.jannatAlBaqiDesc,
        activity: l10n.jannatAlBaqiActivity,
      ),
    ];

    final museums = [
      GuideItem(
        title: l10n.prophetBiographyMuseum,
        description: l10n.prophetBiographyMuseumDesc,
        activity: l10n.prophetBiographyMuseumWhy, 
      ),
      GuideItem(
        title: l10n.hejazRailwayMuseum,
        description: '',
        activity: l10n.hejazRailwayMuseumWhy,
      ),
      GuideItem(
        title: l10n.darAlMadinahMuseum,
        description: '',
        activity: l10n.darAlMadinahMuseumWhy,
      ),
    ];

    final leisure = [
      GuideItem(
        title: l10n.madinahDatesMarket,
        description: '',
        activity: l10n.madinahDatesMarketActivity,
      ),
      GuideItem(
        title: l10n.ethiqWell,
        description: l10n.ethiqWellDesc,
        activity: l10n.ethiqWellActivity,
      ),
      GuideItem(
        title: l10n.madinahHopOnBus,
        description: '',
        activity: l10n.madinahHopOnBusActivity,
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
                l10n.madinahGuideTitle,
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
                    'assets/images/madinah.jpeg',
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
                  _buildSection(l10n.catLeisureNature, leisure),
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
