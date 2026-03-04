import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/app_theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(const AppTheme(size: AppThemeSize.normal));

  void setThemeSize(AppThemeSize size) {
    emit(AppTheme(size: size));
  }
}
