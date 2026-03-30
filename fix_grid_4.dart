import 'dart:io';

void main() {
  final file = File('lib/future/learning/presentation/pages/learning_hub_page.dart');
  String content = file.readAsStringSync();

  content = content.replaceAll(
    '''
  Widget _buildGridCard({
    required double sc,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentUrl,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: UiConstants.primaryButtonColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.1)),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.dstATop),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16 * sc),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12 * sc),
                  decoration: BoxDecoration(
                    color: accentUrl.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentUrl, size: 28 * sc),
                ),''',
    '''
  Widget _buildGridCard({
    required double sc,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentUrl,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: UiConstants.primaryButtonColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
            gradient: LinearGradient(
              colors: [
                UiConstants.primaryButtonColor.withValues(alpha: 0.8),
                UiConstants.primaryButtonColor.withValues(alpha: 0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.2), BlendMode.dstATop),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16 * sc),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12 * sc),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28 * sc),
                ),'''
  );
  
  file.writeAsStringSync(content);
  print('updated grid structure');
}
