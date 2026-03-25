import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/settings_provider.dart';
import '../providers/vpn_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/vpn_shield_logo.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _appVersion = '${info.version}+${info.buildNumber}');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<SettingsProvider, VpnProvider>(
      builder: (context, settings, vpn, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Connection settings
              _SectionHeader(title: 'Connection', isDark: isDark),
              _SettingCard(
                isDark: isDark,
                children: [
                  _SwitchTile(
                    icon: Icons.power_settings_new,
                    title: 'Auto-Connect on Launch',
                    subtitle: 'Connect VPN when app opens',
                    value: settings.autoConnect,
                    onChanged: settings.setAutoConnect,
                    isDark: isDark,
                  ),
                  _Divider(isDark: isDark),
                  _SwitchTile(
                    icon: Icons.security,
                    title: 'Kill Switch',
                    subtitle: 'Block internet if VPN disconnects',
                    value: settings.killSwitch,
                    onChanged: settings.setKillSwitch,
                    isDark: isDark,
                    badge: 'Beta',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Appearance
              _SectionHeader(title: 'Appearance', isDark: isDark),
              _SettingCard(
                isDark: isDark,
                children: [
                  _SwitchTile(
                    icon: isDark ? Icons.dark_mode : Icons.light_mode,
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    value: settings.themeMode == ThemeMode.dark,
                    onChanged: (val) => settings.setThemeMode(
                      val ? ThemeMode.dark : ThemeMode.light,
                    ),
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Language
              _SectionHeader(title: 'Language', isDark: isDark),
              _SettingCard(
                isDark: isDark,
                children: [
                  _LanguageTile(
                    currentLanguage: settings.language,
                    onChanged: settings.setLanguage,
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // About
              _SectionHeader(title: 'About', isDark: isDark),
              _SettingCard(
                isDark: isDark,
                children: [
                  _InfoTile(
                    icon: Icons.info_outline,
                    title: 'App Version',
                    value: _appVersion,
                    isDark: isDark,
                  ),
                  _Divider(isDark: isDark),
                  _InfoTile(
                    icon: Icons.shield,
                    title: 'Protocol',
                    value: 'V2Ray / Xray Core',
                    isDark: isDark,
                  ),
                  _Divider(isDark: isDark),
                  _InfoTile(
                    icon: Icons.business,
                    title: 'Package',
                    value: 'com.tun.freevpn',
                    isDark: isDark,
                  ),
                  _Divider(isDark: isDark),
                  _ActionTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _showPrivacyDialog(context, isDark),
                    isDark: isDark,
                  ),
                  _Divider(isDark: isDark),
                  _ActionTile(
                    icon: Icons.star_outline,
                    title: 'Rate Us on Play Store',
                    onTap: () {},
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // App branding
              Center(
                child: Column(
                  children: [
                    const VpnShieldLogo(size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Tun VPN Free',
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'v$_appVersion • Free & Open Source',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textLight,
          ),
        ),
        content: Text(
          'Tun VPN Free does not collect, store, or share any personal data. '
          'We do not log your VPN traffic or browsing history. '
          'Ads are served by Google AdMob which may collect device identifiers. '
          'By using this app, you agree to Google\'s privacy policy.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;
  final bool isDark;
  final String? badge;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDark,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.connecting.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: AppColors.connecting,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onChanged;
  final bool isDark;

  const _LanguageTile({
    required this.currentLanguage,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'my', 'name': 'မြန်မာဘာသာ (Burmese)', 'flag': '🇲🇲'},
      {'code': 'th', 'name': 'ภาษาไทย (Thai)', 'flag': '🇹🇭'},
    ];

    final current = languages.firstWhere(
      (l) => l['code'] == currentLanguage,
      orElse: () => languages.first,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.language, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${current['flag']} ${current['name']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: onChanged,
            color: isDark ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (ctx) => languages
                .map(
                  (lang) => PopupMenuItem<String>(
                    value: lang['code'],
                    child: Row(
                      children: [
                        Text(lang['flag']!, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          lang['name']!,
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.textLight,
                          ),
                        ),
                        if (lang['code'] == currentLanguage) ...[
                          const Spacer(),
                          const Icon(Icons.check, color: AppColors.primary, size: 16),
                        ],
                      ],
                    ),
                  ),
                )
                .toList(),
            child: const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textLight,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;

  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 52,
      color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
    );
  }
}
