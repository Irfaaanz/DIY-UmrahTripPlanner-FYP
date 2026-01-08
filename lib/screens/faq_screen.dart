import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final Map<String, List<FAQItem>> _faqCategories = {
    'General Information': [
      FAQItem(
        question: 'What is the DIY Umrah Trip Planner?',
        answer: 'The DIY Umrah Trip Planner is a mobile application designed to help you plan and optimize your Umrah journey. It uses Particle Swarm Optimization (PSO) to create personalized itineraries based on your budget and preferences, making your Umrah trip planning easier and more efficient.',
      ),
      FAQItem(
        question: 'Who is this app for?',
        answer: 'This app is designed for anyone planning to perform Umrah. Whether you are a first-time pilgrim or have experience, the app helps you plan your trip, manage your budget, and optimize your itinerary to make the most of your journey.',
      ),
      FAQItem(
        question: 'Is this the official Saudi Nusuk app?',
        answer: 'No, this is not the official Saudi Nusuk app. This is an independent DIY (Do-It-Yourself) Umrah Trip Planner application created to assist pilgrims in planning their Umrah journey. For official Saudi government services and visa applications, please use the official Nusuk app or visit the official Saudi tourism websites.',
      ),
    ],
    'Features & Itinerary Planning': [
      FAQItem(
        question: 'How does the "Smart Itinerary" feature work?',
        answer: 'The Smart Itinerary feature uses Particle Swarm Optimization (PSO) algorithm to analyze your budget, travel duration, age, and preferences. It then generates an optimized itinerary that maximizes your experience while staying within your budget constraints. The algorithm considers various factors including accommodation costs, transportation, and activities.',
      ),
      FAQItem(
        question: 'Can I manage my travel budget in the app?',
        answer: 'Yes! The app allows you to set your travel budget during the planning process. The system will then optimize your itinerary to work within your specified budget, helping you make informed decisions about accommodations, transportation, and activities.',
      ),
      FAQItem(
        question: 'Does the app provide guidance on Umrah rituals?',
        answer: 'The app focuses primarily on trip planning and itinerary optimization. While it may provide basic information about Umrah rituals, we recommend consulting with knowledgeable scholars or using official religious resources for detailed guidance on performing Umrah correctly.',
      ),
      FAQItem(
        question: 'Can I book flights and hotels directly through the app?',
        answer: 'Currently, the app provides itinerary planning and optimization services. Direct booking of flights and hotels may not be available within the app. We recommend using the optimized itinerary as a guide and booking through your preferred travel agencies or booking platforms.',
      ),
      FAQItem(
        question: 'Does the itinerary change if prices go up?',
        answer: 'The itinerary generated is based on the prices and information available at the time of planning. Prices may fluctuate, so we recommend verifying current prices with service providers before making final bookings. The app provides a framework that you can adjust based on current market conditions.',
      ),
    ],
    'Technical & Usage': [
      FAQItem(
        question: 'Is my data safe?',
        answer: 'Yes, we take data privacy seriously. Your personal information and trip data are stored locally on your device using secure storage methods. We do not share your personal information with third parties. However, we recommend keeping your device secure and not sharing your account credentials with others.',
      ),
      FAQItem(
        question: 'How do I report a bug or request a feature?',
        answer: 'You can report bugs or request new features through the "Contact Us" section in the app. We appreciate your feedback and will work to improve the app based on user suggestions. Please provide as much detail as possible when reporting issues.',
      ),
    ],
  };

  final Map<String, bool> _expandedItems = {};

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
          'Frequently Asked Questions',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.help_outline,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              onPressed: () {
                // Help icon action (optional)
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _faqCategories.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Title
                Text(
                  entry.key,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                // FAQ Items
                ...entry.value.map((faqItem) {
                  final key = '${entry.key}_${faqItem.question}';
                  final isExpanded = _expandedItems[key] ?? false;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Question Header
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedItems[key] = !isExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    faqItem.question,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Answer (Expanded)
                        if (isExpanded)
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              faqItem.answer,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 32),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}

