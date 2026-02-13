import 'package:flutter/material.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _accountFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _leetcodeController = TextEditingController();
  final _codeforcesController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _telegramController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  int _currentStep = 0; // 0=Account, 1=Profiles, 2=Done
  final _pageController = PageController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _leetcodeController.dispose();
    _codeforcesController.dispose();
    _linkedinController.dispose();
    _telegramController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_accountFormKey.currentState!.validate()) return;
    }
    if (_currentStep == 1) {
      // Submit signup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account Created Successfully',
              style: TextStyle(fontWeight: FontWeight.w900)),
          backgroundColor: UiConstants.primaryButtonColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _prevStep() {
    if (_currentStep > 0 && _currentStep < 2) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.infoBackgroundColor.withOpacity(0.75),
      body: Column(
        children: [
          _buildGradientHeader(),
          const SizedBox(height: 24),
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildProgressBar(),
          ),
          const SizedBox(height: 8),
          // Step Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepLabel("Account", 0),
                _buildStepLabel("Profiles", 1),
                _buildStepLabel("Done", 2),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildAccountStep(),
                _buildProfilesStep(),
                _buildDoneStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress Bar ──
  Widget _buildProgressBar() {
    return Row(
      children: [
        _buildProgressSegment(0),
        const SizedBox(width: 6),
        _buildProgressSegment(1),
        const SizedBox(width: 6),
        _buildProgressSegment(2),
      ],
    );
  }

  Widget _buildProgressSegment(int step) {
    final isCompleted = _currentStep > step;
    final isActive = _currentStep == step;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: isCompleted
              ? UiConstants.primaryButtonColor
              : isActive
                  ? UiConstants.primaryButtonColor.withOpacity(0.5)
                  : UiConstants.borderColor.withOpacity(0.15),
        ),
      ),
    );
  }

  Widget _buildStepLabel(String label, int step) {
    final isActive = _currentStep >= step;
    return Text(
      label,
      style: TextStyle(
        color: isActive
            ? UiConstants.primaryButtonColor
            : UiConstants.subtitleTextColor.withOpacity(0.4),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  // ── Step 1: Account Information ──
  Widget _buildAccountStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardLabel(Icons.account_circle_rounded, "Account Information"),
          const SizedBox(height: 6),
          Text(
            "Set up your login credentials.",
            style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Form(
              key: _accountFormKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    hint: "Full Name",
                    icon: Icons.badge_rounded,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _emailController,
                    hint: "Email Address",
                    icon: Icons.email_rounded,
                    validator: (val) => !val!.contains('@') ? "Invalid Email" : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _passwordController,
                    hint: "Password",
                    icon: Icons.lock_rounded,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    validator: (val) => val!.length < 6 ? "Min 6 chars" : null,
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hint: "Confirm Password",
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    isPasswordVisible: _isConfirmVisible,
                    onToggleVisibility: () => setState(() => _isConfirmVisible = !_isConfirmVisible),
                    validator: (val) => val != _passwordController.text ? "Passwords don't match" : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          _buildPrimaryButton(text: "CONTINUE", onTap: _nextStep),
          const SizedBox(height: 20),
          _buildLoginLink(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Step 2: Coding Profiles ──
  Widget _buildProfilesStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardLabel(Icons.code_rounded, "Coding Profiles"),
          const SizedBox(height: 6),
          Text(
            "Optional — link your competitive accounts.",
            style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                _buildHandleField(
                  controller: _codeforcesController,
                  hint: "Codeforces Handle",
                  icon: Icons.terminal_rounded,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 14),
                _buildHandleField(
                  controller: _leetcodeController,
                  hint: "LeetCode Handle",
                  icon: Icons.code_rounded,
                  color: Colors.orange,
                ),
                const SizedBox(height: 14),
                _buildHandleField(
                  controller: _linkedinController,
                  hint: "LinkedIn Username",
                  icon: Icons.link_rounded,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 14),
                _buildHandleField(
                  controller: _telegramController,
                  hint: "Telegram Handle",
                  icon: Icons.send_rounded,
                  color: Colors.lightBlue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _buildPrimaryButton(text: "FINISH", onTap: _nextStep),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _nextStep,
              child: Text(
                "SKIP FOR NOW",
                style: TextStyle(
                  color: UiConstants.subtitleTextColor.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Back button
          Center(
            child: TextButton.icon(
              onPressed: _prevStep,
              icon: Icon(Icons.arrow_back_ios_rounded, size: 12, color: UiConstants.subtitleTextColor.withOpacity(0.5)),
              label: Text(
                "BACK",
                style: TextStyle(
                  color: UiConstants.subtitleTextColor.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Step 3: Done ──
  Widget _buildDoneStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: UiConstants.primaryButtonColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: UiConstants.primaryButtonColor,
                size: 56,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              "You're All Set!",
              style: TextStyle(
                color: UiConstants.mainTextColor,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your account has been created.\nWelcome to CPD Hub!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UiConstants.subtitleTextColor.withOpacity(0.6),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            _buildPrimaryButton(
              text: "GO TO LOGIN",
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Gradient Header ──
  Widget _buildGradientHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [UiConstants.primaryButtonColor, UiConstants.infoBackgroundColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Row(
            children: [
              if (_currentStep < 2)
                InkWell(
                  onTap: _currentStep == 0
                      ? () => Navigator.pushReplacementNamed(context, '/login')
                      : _prevStep,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset('assets/images/logo.png', width: 22, height: 22),
                ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("CPD HUB",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                  Text(
                    _currentStep == 0
                        ? "Step 1 of 3 — Account"
                        : _currentStep == 1
                            ? "Step 2 of 3 — Profiles"
                            : "Registration Complete",
                    style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Shared Widgets ──

  Widget _buildCardLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: UiConstants.primaryButtonColor, size: 16),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: UiConstants.mainTextColor, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: UiConstants.infoBackgroundColor.withOpacity(0.6),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: UiConstants.borderColor.withOpacity(0.1)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.backgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UiConstants.borderColor.withOpacity(0.15)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.4), fontSize: 14),
          prefixIcon: Icon(icon, color: UiConstants.primaryButtonColor, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: UiConstants.subtitleTextColor.withOpacity(0.4),
                    size: 18,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildHandleField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.backgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.4), fontSize: 14),
          prefixIcon: Icon(icon, color: color, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [UiConstants.primaryButtonColor, Color(0xFF32D74B)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: UiConstants.primaryButtonColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6)),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2.0),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: UiConstants.primaryButtonColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ALREADY REGISTERED? ",
                style: TextStyle(
                  color: UiConstants.subtitleTextColor.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const Text(
                "SIGN IN",
                style: TextStyle(
                  color: UiConstants.primaryButtonColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: UiConstants.primaryButtonColor),
            ],
          ),
        ),
      ),
    );
  }
}
