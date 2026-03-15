import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/app_theme.dart';
import 'theme_cubit.dart';

extension ThemeSpacingExt on num {
  double scaled(BuildContext context) {
    return this * context.read<ThemeCubit>().state.scale;
  }
}

extension AppThemeContext on BuildContext {
  double get sc => watch<ThemeCubit>().state.scale;
  AppTheme get appTheme => watch<ThemeCubit>().state;
}
