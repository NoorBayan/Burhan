import 'package:flutter/material.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: SettingsService(),
        builder: (context, child) {
          final settings = SettingsService();
          
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              _buildSectionHeader(localizations.language, theme),
              _buildSettingsCard(
                theme,
                isDark,
                child: Column(
                  children: [
                    _buildRadioTile<Locale>(
                      title: localizations.arabic,
                      value: const Locale('ar'),
                      groupValue: settings.locale,
                      onChanged: (val) => settings.updateLocale(val!),
                      theme: theme,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildRadioTile<Locale>(
                      title: localizations.english,
                      value: const Locale('en'),
                      groupValue: settings.locale,
                      onChanged: (val) => settings.updateLocale(val!),
                      theme: theme,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _buildSectionHeader(localizations.theme, theme),
              _buildSettingsCard(
                theme,
                isDark,
                child: Column(
                  children: [
                    _buildRadioTile<ThemeMode>(
                      title: localizations.system,
                      value: ThemeMode.system,
                      groupValue: settings.themeMode,
                      onChanged: (val) => settings.updateThemeMode(val!),
                      theme: theme,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildRadioTile<ThemeMode>(
                      title: localizations.light,
                      value: ThemeMode.light,
                      groupValue: settings.themeMode,
                      onChanged: (val) => settings.updateThemeMode(val!),
                      theme: theme,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildRadioTile<ThemeMode>(
                      title: localizations.dark,
                      value: ThemeMode.dark,
                      groupValue: settings.themeMode,
                      onChanged: (val) => settings.updateThemeMode(val!),
                      theme: theme,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _buildSectionHeader(localizations.reading_settings, theme),
              _buildSettingsCard(
                theme,
                isDark,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(localizations.font_size, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${settings.fontSize.toInt()}',
                              style: TextStyle(
                                fontSize: 14, 
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Slider(
                        value: settings.fontSize,
                        min: 18.0,
                        max: 40.0,
                        divisions: 11,
                        activeColor: theme.colorScheme.primary,
                        inactiveColor: theme.colorScheme.primary.withOpacity(0.2),
                        onChanged: (double value) => settings.updateFontSize(value),
                      ),
                      const SizedBox(height: 20),
                      Center(child: Text(localizations.preview_text, style: TextStyle(color: theme.hintColor, fontSize: 12))),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.grey[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                        ),
                        child: Text(
                          localizations.basmala,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'UthmanicHafs',
                            fontSize: settings.fontSize,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary.withOpacity(0.8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(ThemeData theme, bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: child,
    );
  }

  Widget _buildRadioTile<T>({
    required String title,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
    required ThemeData theme,
  }) {
    return RadioListTile<T>(
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: theme.colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      visualDensity: VisualDensity.compact,
    );
  }
}
