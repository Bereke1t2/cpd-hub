import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/app_router.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/branded_loader.dart';
import 'package:lab_portal/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:lab_portal/features/auth/presentation/page/welcome_page.dart';
import 'package:lab_portal/future/main/presentation/page/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionBloc>(
      // Singleton from get_it; fires SessionStarted to resolve auth state.
      create: (_) => getIt<SessionBloc>()..add(const SessionStarted()),
      child: MaterialApp(
        title: 'CPD Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: UiConstants.primaryButtonColor,
          useMaterial3: true,
          // Dark defaults so route transitions never flash a white canvas
          // behind the (dark) pages.
          brightness: Brightness.dark,
          scaffoldBackgroundColor: UiConstants.backgroundColor,
          canvasColor: UiConstants.backgroundColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: UiConstants.primaryButtonColor,
            brightness: Brightness.dark,
          ).copyWith(surface: UiConstants.backgroundColor),
        ),
        home: const _AuthGate(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}

/// Decides which root screen to show based on [SessionBloc] state.
///
/// Flow:
///   SessionUnknown (resolving token) → branded splash loader
///   SessionUnauthenticated            → WelcomePage (sign in / create account)
///   SessionAuthenticated              → HomePage
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final Widget child;
        if (state is SessionAuthenticated) {
          child = const HomePage();
        } else if (state is SessionUnauthenticated) {
          child = const WelcomePage();
        } else {
          // SessionUnknown — still resolving the stored token.
          child = const Scaffold(
            key: ValueKey('splash'),
            backgroundColor: UiConstants.backgroundColor,
            body: Center(child: BrandedLoader()),
          );
        }

        // Fade between splash → welcome → home so there's never a hard cut.
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: KeyedSubtree(
            key: ValueKey(state.runtimeType),
            child: child,
          ),
        );
      },
    );
  }
}
