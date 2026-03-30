import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_shell_page.dart');
  String content = file.readAsStringSync();

  content = content.replaceAll(
    '''
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0D4D2E),
                  UiConstants.primaryButtonColor.withValues(alpha: 0.85),
                  UiConstants.infoBackgroundColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),''',
    '''
            decoration: BoxDecoration(
              image: _tab == 0 
                ? null 
                : const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1550684848-fac1c5b4e853?q=80&w=2070&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  ),
              gradient: _tab == 0 
                ? LinearGradient(
                    colors: [
                      const Color(0xFF0D4D2E),
                      UiConstants.primaryButtonColor.withValues(alpha: 0.85),
                      UiConstants.infoBackgroundColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      UiConstants.infoBackgroundColor.withValues(alpha: 0.9),
                      UiConstants.infoBackgroundColor.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),'''
  );

  file.writeAsStringSync(content);
  print('done shell update online image');
}
