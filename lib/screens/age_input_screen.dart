import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'budget_input_screen.dart';
import '../l10n/generated/app_localizations.dart';

class AgeInputScreen extends StatefulWidget {
  const AgeInputScreen({super.key});

  @override
  State<AgeInputScreen> createState() => _AgeInputScreenState();
}

class _AgeInputScreenState extends State<AgeInputScreen> {
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _tripName = '';
  int? _age;

  @override
  void dispose() {
    _tripNameController.dispose();
    _ageController.dispose();
    super.dispose();
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
              _buildProgressBar(1, 8),
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
              const SizedBox(height: 40),
              // Trip name prompt
              Text(
                l10n.insertTripName,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),
              // Trip name input field
              TextField(
                controller: _tripNameController,
                decoration: InputDecoration(
                  hintText: l10n.tripNameHint,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: theme.hintColor,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                      width: 1,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                onChanged: (value) {
                  setState(() {
                    _tripName = value.trim();
                  });
                },
              ),
              const SizedBox(height: 32),
              // Age prompt
              Text(
                l10n.insertAge,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 24),
              // Age input field
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Image.asset(
                      'assets/icons/calendar.png',
                      width: 24,
                      height: 24,
                      color: theme.iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: l10n.ageHint,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: theme.hintColor,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.dividerColor,
                            width: 1,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.dividerColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final parsedAge = int.tryParse(value);
                          setState(() {
                            _age = parsedAge;
                          });
                        } else {
                          setState(() {
                            _age = null;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Proceed button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _tripName.isNotEmpty && _age != null && _age! > 0
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BudgetInputScreen(
                                  tripName: _tripName,
                                  age: _age!,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _age != null && _age! > 0
                          ? const Color(0xFFE3F2FD) // Keep light blue for active state
                          : theme.disabledColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.proceed,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _age != null && _age! > 0
                            ? Colors.black87
                            : theme.disabledColor.withOpacity(0.5),
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

