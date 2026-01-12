import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'duration_input_screen.dart';

class BudgetInputScreen extends StatefulWidget {
  final int age;

  const BudgetInputScreen({super.key, required this.age});

  @override
  State<BudgetInputScreen> createState() => _BudgetInputScreenState();
}

class _BudgetInputScreenState extends State<BudgetInputScreen> {
  final TextEditingController _budgetController = TextEditingController();
  final FocusNode _budgetFocusNode = FocusNode();
  double? _budget;
  String? _selectedBudget;
  final List<double> _recommendedBudgets = [3000, 6000, 9000, 12000];

  @override
  void dispose() {
    _budgetController.dispose();
    _budgetFocusNode.dispose();
    super.dispose();
  }

  void _selectBudget(double amount) {
    setState(() {
      _budget = amount;
      _selectedBudget = amount.toString();
      _budgetController.text = amount.toStringAsFixed(2);
    });
  }

  void _handleOthersInput(String value) {
    if (value.isNotEmpty) {
      final parsedBudget = double.tryParse(value);
      if (parsedBudget != null && parsedBudget > 0) {
        // Check if the value matches any recommended budget
        final matchingBudget = _recommendedBudgets.firstWhere(
          (budget) => (budget - parsedBudget).abs() < 0.01,
          orElse: () => -1,
        );
        
        setState(() {
          _budget = parsedBudget;
          if (matchingBudget > 0) {
            _selectedBudget = matchingBudget.toString();
          } else {
            _selectedBudget = 'others';
          }
        });
      } else {
        setState(() {
          _budget = null;
          _selectedBudget = null;
        });
      }
    } else {
      setState(() {
        _budget = null;
        _selectedBudget = null;
      });
    }
  }

  String _formatCurrency(double amount) {
    final intAmount = amount.toInt();
    return 'RM ${intAmount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isBudgetValid = _budget != null && _budget! >= 4000;
    final bool isBudgetBelowMinimum = _budget != null && _budget! > 0 && _budget! < 4000;

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
            fontSize: 16,
            fontWeight: FontWeight.w500,
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
              _buildProgressBar(2, 7),
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
              // Budget title with wallet icon aligned to the right
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
                          "budget",
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
                    'assets/icons/wallet.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Budget input field
              Row(
                children: [
                  Text(
                    'RM',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _budgetController,
                      focusNode: _budgetFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: '0.00',
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
                      onChanged: _handleOthersInput,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Minimum budget message
              Text(
                'Minimum amount of budget is RM4,000.00',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isBudgetBelowMinimum ? Colors.red : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              // Recommended budget buttons (3 on top row, 2 on bottom)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (final budget in _recommendedBudgets.take(3))
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildBudgetButton(
                            _formatCurrency(budget),
                            _selectedBudget == budget.toString(),
                            () => _selectBudget(budget),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final budget in _recommendedBudgets.skip(3))
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildBudgetButton(
                            _formatCurrency(budget),
                            _selectedBudget == budget.toString(),
                            () => _selectBudget(budget),
                          ),
                        ),
                      _buildBudgetButton(
                        'Others',
                        _selectedBudget == 'others' && _budget != null,
                        () {
                          setState(() {
                            _selectedBudget = 'others';
                            _budgetController.clear();
                            _budget = null;
                          });
                          _budgetFocusNode.requestFocus();
                        },
                      ),
                    ],
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
                    onPressed: isBudgetValid
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DurationInputScreen(
                                  age: widget.age,
                                  budget: _budget!,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBudgetValid
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
                          color: isBudgetValid ? Colors.black87 : Colors.grey[600],
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

  Widget _buildBudgetButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
          border: isSelected
              ? Border.all(color: const Color(0xFF90CAF9), width: 2)
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
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

