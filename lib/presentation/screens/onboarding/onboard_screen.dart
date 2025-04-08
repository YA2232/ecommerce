import 'package:ecommerce/data/shared_pref/shared_prefrence.dart';
import 'package:ecommerce/presentation/screens/auth/signup.dart';
import 'package:ecommerce/presentation/screens/onboarding/widgets/onboarding_page.dart';
import 'package:ecommerce/presentation/screens/onboarding/widgets/page_indicator.dart';
import 'package:ecommerce/presentation/widgets/onboarding_content_model.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  late final PageController _pageController;
  late final SharedPrefrenceHelper _sharedPrefrenceHelper;
  int _currentIndex = 0;
  bool _hasSeenOnboard = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _sharedPrefrenceHelper = SharedPrefrenceHelper();
    _checkOnboardStatus();
  }

  Future<void> _checkOnboardStatus() async {
    final seen = await _sharedPrefrenceHelper.getOnboard();
    setState(() => _hasSeenOnboard = seen ?? false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleOnboardComplete() {
    setState(() {
      _hasSeenOnboard = true;
      _sharedPrefrenceHelper.saveOnboard(_hasSeenOnboard);
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  }

  void _handleNextAction() {
    if (_currentIndex == OnboardingContentModel.contents.length - 1) {
      _handleOnboardComplete();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildPageView(),
            _buildIndicatorSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return Expanded(
      flex: 3,
      child: PageView.builder(
        controller: _pageController,
        itemCount: OnboardingContentModel.contents.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (_, index) => OnboardingPage(
          content: OnboardingContentModel.contents[index],
        ),
      ),
    );
  }

  Widget _buildIndicatorSection() {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          _buildPageIndicators(),
          const Spacer(),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        OnboardingContentModel.contents.length,
        (index) => PageIndicator(
          isActive: index == _currentIndex,
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    final isLastPage =
        _currentIndex == OnboardingContentModel.contents.length - 1;

    return Container(
      margin: const EdgeInsets.all(40),
      child: ElevatedButton(
        onPressed: _handleNextAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          isLastPage ? "Get Started" : "Next",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
