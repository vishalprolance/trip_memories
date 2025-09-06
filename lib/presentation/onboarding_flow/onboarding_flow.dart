import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/app_export.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Private Group Sharing",
      "description":
          "Create invite-only groups for your trips and events. Share memories with only the people who matter most to you.",
      "illustration":
          "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z3JvdXAlMjBwaG90b3xlbnwwfHwwfHx8MA%3D%3D",
      "iconName": "group",
    },
    {
      "title": "Original Quality Photos",
      "description":
          "Upload and preserve your photos and videos in their original resolution without any compression or quality loss.",
      "illustration":
          "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGhvdG9ncmFwaHl8ZW58MHx8MHx8fDA%3D",
      "iconName": "high_quality",
    },
    {
      "title": "Secure & Encrypted",
      "description":
          "Your memories are protected with end-to-end encryption. Only group members can access your shared content.",
      "illustration":
          "https://images.pexels.com/photos/60504/security-protection-anti-virus-software-60504.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "iconName": "security",
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToRegistration();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _navigateToRegistration();
  }

  void _navigateToRegistration() {
    Navigator.pushReplacementNamed(context, '/groups-dashboard');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    ),
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page view content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return _buildOnboardingPage(
                    title: data["title"] as String,
                    description: data["description"] as String,
                    illustration: data["illustration"] as String,
                    iconName: data["iconName"] as String,
                  );
                },
              ),
            ),

            // Bottom navigation area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingData.length,
                    effect: WormEffect(
                      dotHeight: 1.2.h,
                      dotWidth: 1.2.h,
                      spacing: 2.w,
                      activeDotColor: AppTheme.lightTheme.colorScheme.primary,
                      dotColor: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Navigation button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
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

  Widget _buildOnboardingPage({
    required String title,
    required String description,
    required String illustration,
    required String iconName,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: 70.w,
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: Stack(
                children: [
                  // Background image
                  CustomImageWidget(
                    imageUrl: illustration,
                    width: 70.w,
                    height: 35.h,
                    fit: BoxFit.cover,
                  ),

                  // Overlay with icon
                  Container(
                    width: 70.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: iconName,
                          size: 8.w,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
