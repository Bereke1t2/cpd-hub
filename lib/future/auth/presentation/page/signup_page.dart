import 'package:flutter/material.dart';
import 'package:cpd_hub/core/exceptions.dart';
import 'package:cpd_hub/core/injection.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/widgets/app_logo.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authService = Injection().authService;
      await authService.signup(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account created successfully',
              style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: UiConstants.primaryButtonColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pushReplacementNamed(context, '/');
      });
    } on ServerException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message, style: const TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Connection failed. Check your network.',
              style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 28 * sc),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32 * sc),
                    _buildHeader(sc),
                    SizedBox(height: 36 * sc),
                    _buildForm(sc),
                    SizedBox(height: 28 * sc),
                    _buildLoginLink(sc),
                    SizedBox(height: 40 * sc),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double sc) {
    return Column(
      children: [
        AppLogo(size: 230 * sc, variant: AppLogoVariant.full),
        SizedBox(height: 12 * sc),
        Text(
          "Join the competitive programming community",
          style: TextStyle(
            fontSize: 13 * sc,
            color: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(double sc) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Full Name", sc),
          SizedBox(height: 8 * sc),
          _buildField(
            controller: _nameController,
            hint: "Enter your full name",
            icon: Icons.person_outline_rounded,
            sc: sc,
            validator: (val) => val!.isEmpty ? "Required" : null,
          ),
          SizedBox(height: 18 * sc),
          _buildLabel("Email", sc),
          SizedBox(height: 8 * sc),
          _buildField(
            controller: _emailController,
            hint: "Enter your email",
            icon: Icons.mail_outline_rounded,
            sc: sc,
            keyboardType: TextInputType.emailAddress,
            validator: (val) => !val!.contains('@') ? "Invalid email" : null,
          ),
          SizedBox(height: 18 * sc),
          _buildLabel("Password", sc),
          SizedBox(height: 8 * sc),
          _buildField(
            controller: _passwordController,
            hint: "Create a password",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            showToggle: true,
            isVisible: _isPasswordVisible,
            onToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            sc: sc,
            validator: (val) => val!.length < 6 ? "Min 6 characters" : null,
          ),
          SizedBox(height: 18 * sc),
          _buildLabel("Confirm Password", sc),
          SizedBox(height: 8 * sc),
          _buildField(
            controller: _confirmPasswordController,
            hint: "Confirm your password",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            showToggle: true,
            isVisible: _isConfirmVisible,
            onToggle: () => setState(() => _isConfirmVisible = !_isConfirmVisible),
            sc: sc,
            validator: (val) => val != _passwordController.text ? "Passwords don't match" : null,
          ),
          SizedBox(height: 28 * sc),
          _buildSignUpButton(sc),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, double sc) {
    return Text(
      text,
      style: TextStyle(
        color: UiConstants.subtitleTextColor.withValues(alpha: 0.7),
        fontSize: 12 * sc,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double sc,
    bool isPassword = false,
    bool showToggle = false,
    bool isVisible = false,
    VoidCallback? onToggle,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isVisible,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white, fontSize: 14 * sc, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: UiConstants.subtitleTextColor.withValues(alpha: 0.3),
          fontSize: 13 * sc,
        ),
        prefixIcon: Icon(icon, color: UiConstants.subtitleTextColor.withValues(alpha: 0.4), size: 20 * sc),
        suffixIcon: showToggle
            ? GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: UiConstants.subtitleTextColor.withValues(alpha: 0.3),
                  size: 20 * sc,
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: EdgeInsets.symmetric(horizontal: 16 * sc, vertical: 16 * sc),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: UiConstants.primaryButtonColor.withValues(alpha: 0.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(double sc) {
    return SizedBox(
      width: double.infinity,
      height: 50 * sc,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignup,
        style: ElevatedButton.styleFrom(
          backgroundColor: UiConstants.primaryButtonColor,
          foregroundColor: Colors.black,
          disabledBackgroundColor: UiConstants.primaryButtonColor.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isLoading
            ? SizedBox(
                width: 20 * sc,
                height: 20 * sc,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            : Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 15 * sc,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink(double sc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            color: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
            fontSize: 13 * sc,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text(
            "Sign In",
            style: TextStyle(
              color: UiConstants.primaryButtonColor,
              fontSize: 13 * sc,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
