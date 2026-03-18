import 'package:flutter/material.dart';
import 'package:cpd_hub/core/exceptions.dart';
import 'package:cpd_hub/core/injection.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/widgets/app_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authService = Injection().authService;
      await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
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
                    SizedBox(height: 40 * sc),
                    _buildLogo(sc),
                    SizedBox(height: 40 * sc),
                    _buildForm(sc),
                    SizedBox(height: 32 * sc),
                    _buildSignupLink(sc),
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

  Widget _buildLogo(double sc) {
    return Column(
      children: [
        AppLogo(size: 230 * sc, variant: AppLogoVariant.full),
        SizedBox(height: 12 * sc),
        Text(
          "Sign in to your account",
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
          _buildLabel("Email or Username", sc),
          SizedBox(height: 8 * sc),
          _buildField(
            controller: _emailController,
            hint: "Enter your email",
            icon: Icons.mail_outline_rounded,
            sc: sc,
            validator: (val) => val!.isEmpty ? "Required" : null,
          ),
          SizedBox(height: 20 * sc),
          _buildLabel("Password", sc),
          SizedBox(height: 8 * sc),
          _buildField(
            controller: _passwordController,
            hint: "Enter your password",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            sc: sc,
            validator: (val) => val!.length < 6 ? "Min 6 characters" : null,
          ),
          SizedBox(height: 10 * sc),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.8),
                  fontSize: 12 * sc,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 28 * sc),
          _buildSignInButton(sc),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      validator: validator,
      style: TextStyle(color: Colors.white, fontSize: 14 * sc, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: UiConstants.subtitleTextColor.withValues(alpha: 0.3),
          fontSize: 13 * sc,
        ),
        prefixIcon: Icon(icon, color: UiConstants.subtitleTextColor.withValues(alpha: 0.4), size: 20 * sc),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                child: Icon(
                  _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
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

  Widget _buildSignInButton(double sc) {
    return SizedBox(
      width: double.infinity,
      height: 50 * sc,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
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
                "Sign In",
                style: TextStyle(
                  fontSize: 15 * sc,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  Widget _buildSignupLink(double sc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
            fontSize: 13 * sc,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
          child: Text(
            "Sign Up",
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
