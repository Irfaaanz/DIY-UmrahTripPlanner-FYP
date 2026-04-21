import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hotel_preferences_screen.dart';
import '../l10n/generated/app_localizations.dart';

class DurationInputScreen extends StatefulWidget {
  final String tripName;
  final int age;
  final double budget;

  const DurationInputScreen({
    super.key,
    required this.tripName,
    required this.age,
    required this.budget,
  });

  @override
  State<DurationInputScreen> createState() => _DurationInputScreenState();
}

class _DurationInputScreenState extends State<DurationInputScreen> {
  final TextEditingController _makkahDaysController = TextEditingController();
  final TextEditingController _madinahDaysController = TextEditingController();
  
  int? _makkahDays;
  int? _madinahDays;
  int? _totalDuration;
  bool _showMaxDaysWarning = false;

  @override
  void dispose() {
    _makkahDaysController.dispose();
    _madinahDaysController.dispose();
    super.dispose();
  }
  
  void _calculateTotal() {
    setState(() {
      _makkahDays = int.tryParse(_makkahDaysController.text);
      _madinahDays = int.tryParse(_madinahDaysController.text);
      
      if (_makkahDays != null && _madinahDays != null) {
        _totalDuration = _makkahDays! + _madinahDays!;
        _showMaxDaysWarning = _totalDuration! < 5 || _totalDuration! > 14;
      } else {
        _totalDuration = (int.tryParse(_makkahDaysController.text) ?? 0) + 
                         (int.tryParse(_madinahDaysController.text) ?? 0);
        if (_totalDuration == 0) _totalDuration = null;
        _showMaxDaysWarning = false; 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          l10n.personaliseMyTrips,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Progress bar
              _buildProgressBar(3, 8),
              const SizedBox(height: 32),
              // Main heading
              Text(
                l10n.letsStartJourney,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),
              
              // Duration title with clock icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.insertJourneyDuration,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.titleLarge?.color,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/icons/history.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Makkah Days Input
              _buildDayInputRow(
                controller: _makkahDaysController,
                iconPath: 'assets/icons/calendar.png',
                hintText: l10n.daysInMakkah,
                onChanged: (_) => _calculateTotal(),
              ),
              
              const SizedBox(height: 20),
              
              // Madinah Days Input
              _buildDayInputRow(
                controller: _madinahDaysController,
                iconPath: 'assets/icons/calendar.png', 
                hintText: l10n.daysInMadinah,
                 onChanged: (_) => _calculateTotal(),
              ),
              
               const SizedBox(height: 16),
               Divider(color: theme.dividerColor),
               const SizedBox(height: 8),

              // Total days display
              Text(
                l10n.totalDays(_totalDuration ?? 0),
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              // Maximum days warning
              if (_showMaxDaysWarning)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.durationWarning,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                  ),
                ),
              const Spacer(),
              // Proceed button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_totalDuration != null && _totalDuration! >= 5 && _totalDuration! <= 14)
                        ? () {
                            // Navigate to hotel preferences screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HotelPreferencesScreen(
                                  tripName: widget.tripName,
                                  age: widget.age,
                                  budget: widget.budget,
                                  duration: _totalDuration!,
                                  daysMakkah: _makkahDays!,
                                  daysMadinah: _madinahDays!,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64D2FF), // Cyan
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.proceed,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87, // Keep black for contrast on Cyan
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayInputRow({
    required TextEditingController controller, 
    required String iconPath, 
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
             color: theme.iconTheme.color,
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                color: theme.hintColor,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: theme.textTheme.bodyLarge?.color,
            ),
             onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int currentStep, int totalSteps) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: isActive ? Colors.grey[600] : Colors.green[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

