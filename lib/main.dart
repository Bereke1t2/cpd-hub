import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/app_router.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/branded_loader.dart';
import 'package:lab_portal/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:lab_portal/features/auth/presentation/page/login_page.dart';
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
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is SessionAuthenticated) return const HomePage();
        if (state is SessionUnauthenticated) return const LoginPage();
        // SessionUnknown — still resolving the stored token.
        return const Scaffold(
          backgroundColor: UiConstants.backgroundColor,
          body: Center(child: BrandedLoader()),
        );
      },
    );
  }
}
