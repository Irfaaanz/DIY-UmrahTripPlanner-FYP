import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DurationInputScreen extends StatefulWidget {
  final int age;
  final double budget;

  const DurationInputScreen({
    super.key,
    required this.age,
    required this.budget,
  });

  @override
  State<DurationInputScreen> createState() => _DurationInputScreenState();
}

class _DurationInputScreenState extends State<DurationInputScreen> {
  final TextEditingController _durationController = TextEditingController();
  int? _duration;
  bool _showMaxDaysWarning = false;

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          'Personalise My Trips',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
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
              _buildProgressBar(3, 3),
              const SizedBox(height: 32),
              // Main heading - full width
              Text(
                "Let's start your Umrah journey with us",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              // Duration title with history icon aligned to the right
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Insert your journey",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "duration",
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/icons/history.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Duration input field
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Image.asset(
                      'assets/icons/calendar.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'No. of days',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final parsedDuration = int.tryParse(value);
                          setState(() {
                            _duration = parsedDuration;
                            _showMaxDaysWarning = parsedDuration != null && parsedDuration > 14;
                          });
                        } else {
                          setState(() {
                            _duration = null;
                            _showMaxDaysWarning = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Total days display
              Text(
                'Total days: ${_duration ?? 0} ${_duration == 1 ? 'day' : 'days'}',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              // Maximum days warning
              if (_showMaxDaysWarning)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'The maximum days is 14 days',
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
                    onPressed: _duration != null && _duration! > 0 && _duration! <= 14
                        ? () {
                            // Here you can navigate to the next screen or save the data
                            // For now, we'll just show a success message and go back
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Trip personalized! Age: ${widget.age}, Budget: RM ${widget.budget.toStringAsFixed(2)}, Duration: $_duration days',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Navigate back to home or next screen
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _duration != null && _duration! > 0
                          ? const Color(0xFFE3F2FD)
                          : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _duration != null && _duration! > 0
                            ? Colors.black87
                            : Colors.grey[600],
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
                  color: isActive ? Colors.grey[600] : Colors.grey[300],
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

