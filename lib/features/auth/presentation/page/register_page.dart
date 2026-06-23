import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/branded_loader.dart';
import 'package:lab_portal/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:lab_portal/features/auth/presentation/bloc/session/session_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: const _RegisterView(),
    );
  }
}

// ── Step definitions ──────────────────────────────────────────────────────────

const _kStepTitles = ['Account', 'Security', 'CP Profile'];
const _kStepSubtitles = [
  'Tell us who you are',
  'Secure your account',
  'Connect your CP identity',
];

// ── Main view (manages current step) ─────────────────────────────────────────

class _RegisterView extends StatefulWidget {
  const _RegisterView();
  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _pageCtrl = PageController();
  int _step = 0;

  // Step 1
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _step1Key = GlobalKey<FormState>();

  // Step 2
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  final _step2Key = GlobalKey<FormState>();

  // Step 3
  final _cfHandleCtrl = TextEditingController();
  final _step3Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _cfHandleCtrl.dispose();
    super.dispose();
  }

  GlobalKey<FormState> get _currentKey =>
      [_step1Key, _step2Key, _step3Key][_step];

  void _next() {
    FocusScope.of(context).unfocus();
    if (!_currentKey.currentState!.validate()) return;
    if (_step < 2) {
      setState(() => _step++);
      _pageCtrl.animateToPage(
        _step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _back() {
    FocusScope.of(context).unfocus();
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.animateToPage(
        _step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _submit() {
    context.read<RegisterBloc>().add(RegisterSubmitted(
          username: _usernameCtrl.text.trim(),
          fullName: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          confirmPassword: _confirmCtrl.text,
          codeforcesHandle: _cfHandleCtrl.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.read<SessionBloc>().add(SessionLoggedIn(state.user));
          Navigator.of(context).popUntil((r) => r.isFirst);
        }
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red.shade700,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: UiConstants.backgroundColor,
        body: Stack(
          children: [
            // Ambient glow
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    UiConstants.primaryButtonColor.withValues(alpha: 0.18),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // ── Top bar ──────────────────────────────────────────
                  _TopBar(step: _step, onBack: _back),

                  // ── Step header ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                    child: Column(
                      children: [
                        // Progress bar
                        _StepProgress(step: _step, total: 3),
                        const SizedBox(height: 20),
                        // Brand glyph (small)
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    UiConstants.primaryButtonColor,
                                    UiConstants.primaryDark,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: UiConstants.primaryButtonColor
                                        .withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '</>',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _kStepTitles[_step],
                                    style: const TextStyle(
                                      color: UiConstants.mainTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    _kStepSubtitles[_step],
                                    style: const TextStyle(
                                      color: UiConstants.subtitleTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Step content ──────────────────────────────────────
                  Expanded(
                    child: PageView(
                      controller: _pageCtrl,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _Step1(
                          formKey: _step1Key,
                          nameCtrl: _nameCtrl,
                          emailCtrl: _emailCtrl,
                        ),
                        _Step2(
                          formKey: _step2Key,
                          usernameCtrl: _usernameCtrl,
                          passwordCtrl: _passwordCtrl,
                          confirmCtrl: _confirmCtrl,
                          obscurePass: _obscurePass,
                          obscureConfirm: _obscureConfirm,
                          onTogglePass: () =>
                              setState(() => _obscurePass = !_obscurePass),
                          onToggleConfirm: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        _Step3(
                          formKey: _step3Key,
                          cfHandleCtrl: _cfHandleCtrl,
                        ),
                      ],
                    ),
                  ),

                  // ── Bottom action ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        final loading = state is RegisterLoading;
                        return _PrimaryButton(
                          label: _step == 2 ? 'Create Account' : 'Continue',
                          loading: loading,
                          onPressed: _next,
                        );
                      },
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
}

// ── Top bar with back arrow and step counter ───────────────────────────────────

class _TopBar extends StatelessWidget {
  final int step;
  final VoidCallback onBack;
  const _TopBar({required this.step, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: UiConstants.mainTextColor, size: 20),
          ),
          const Spacer(),
          Text(
            'Step ${step + 1} of 3',
            style: const TextStyle(
              color: UiConstants.subtitleTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step progress bar ─────────────────────────────────────────────────────────

class _StepProgress extends StatelessWidget {
  final int step;
  final int total;
  const _StepProgress({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final done = i <= step;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height: 4,
              decoration: BoxDecoration(
                color: done
                    ? UiConstants.primaryButtonColor
                    : UiConstants.primaryButtonColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Step 1: Name + Email ──────────────────────────────────────────────────────

class _Step1 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;

  const _Step1({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _AuthField(
              controller: nameCtrl,
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter your full name'
                  : null,
            ),
            const SizedBox(height: AppDimens.md),
            _AuthField(
              controller: emailCtrl,
              label: 'Email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Enter a valid email'
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: Username + Password ───────────────────────────────────────────────

class _Step2 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final bool obscurePass;
  final bool obscureConfirm;
  final VoidCallback onTogglePass;
  final VoidCallback onToggleConfirm;

  const _Step2({
    required this.formKey,
    required this.usernameCtrl,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.obscurePass,
    required this.obscureConfirm,
    required this.onTogglePass,
    required this.onToggleConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _AuthField(
              controller: usernameCtrl,
              label: 'Username',
              icon: Icons.alternate_email_rounded,
              validator: (v) => (v == null || v.trim().length < 3)
                  ? 'At least 3 characters'
                  : null,
            ),
            const SizedBox(height: AppDimens.md),
            _AuthField(
              controller: passwordCtrl,
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              obscure: obscurePass,
              suffix: _EyeToggle(
                  visible: !obscurePass, onToggle: onTogglePass),
              validator: (v) => (v == null || v.length < 6)
                  ? 'At least 6 characters'
                  : null,
            ),
            const SizedBox(height: AppDimens.md),
            _AuthField(
              controller: confirmCtrl,
              label: 'Confirm Password',
              icon: Icons.lock_person_outlined,
              obscure: obscureConfirm,
              suffix: _EyeToggle(
                  visible: !obscureConfirm, onToggle: onToggleConfirm),
              validator: (v) => v != passwordCtrl.text
                  ? 'Passwords do not match'
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 3: Codeforces handle ─────────────────────────────────────────────────

class _Step3 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cfHandleCtrl;

  const _Step3({
    required this.formKey,
    required this.cfHandleCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(AppDimens.md),
              decoration: BoxDecoration(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: UiConstants.primaryButtonColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your Codeforces handle lets CPD Hub track your rating, '
                      'contest history, and recommend problems tailored to your level.',
                      style: const TextStyle(
                        color: UiConstants.subtitleTextColor,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.lg),

            _AuthField(
              controller: cfHandleCtrl,
              label: 'Codeforces handle',
              icon: Icons.code_rounded,
              validator: (_) => null, // optional
            ),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {
                // Skip step — just leave handle empty
              },
              child: const Text(
                'Skip for now — you can add it later in Settings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: UiConstants.subtitleTextColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reused auth widgets (same as login_page.dart) ─────────────────────────────

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      style: const TextStyle(
          color: UiConstants.mainTextColor, fontSize: AppDimens.fBody),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: UiConstants.subtitleTextColor, fontSize: 13),
        prefixIcon: Icon(icon,
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.8),
            size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: UiConstants.infoBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.18),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: UiConstants.primaryButtonColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}

class _EyeToggle extends StatelessWidget {
  final bool visible;
  final VoidCallback onToggle;
  const _EyeToggle({required this.visible, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: UiConstants.subtitleTextColor,
        size: 20,
      ),
      onPressed: onToggle,
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: UiConstants.primaryButtonColor,
          disabledBackgroundColor:
              UiConstants.primaryButtonColor.withValues(alpha: 0.50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: loading
            ? const BrandedLoader.small()
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}
