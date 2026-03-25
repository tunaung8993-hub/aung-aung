import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/vpn_shield_logo.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasScrolledToBottom = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        if (!_hasScrolledToBottom) {
          setState(() => _hasScrolledToBottom = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: Column(
                    children: [
                      const VpnShieldLogo(size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome to Tun VPN Free',
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textLight,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please read and accept before continuing',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection(
                              icon: Icons.security,
                              title: 'Free VPN Service',
                              content:
                                  'Tun VPN Free provides a free VPN service powered by V2Ray/Xray protocol. This service is provided as-is without any warranty of uptime or performance.',
                              isDark: isDark,
                            ),
                            _buildSection(
                              icon: Icons.privacy_tip,
                              title: 'No Data Collection',
                              content:
                                  'We do NOT collect, store, or sell your personal data, browsing history, or connection logs. Your privacy is our priority.',
                              isDark: isDark,
                            ),
                            _buildSection(
                              icon: Icons.ad_units,
                              title: 'Ad-Supported',
                              content:
                                  'This free app is supported by advertisements. Ads are shown after connecting or disconnecting. You may see full-screen ads and banner ads.',
                              isDark: isDark,
                            ),
                            _buildSection(
                              icon: Icons.warning_amber,
                              title: 'Acceptable Use Policy',
                              content:
                                  'This VPN must NOT be used for:\n• Illegal activities of any kind\n• Torrenting or piracy\n• Hacking or unauthorized access\n• Spam or malicious activities\n\nViolators may be permanently banned.',
                              isDark: isDark,
                              isWarning: true,
                            ),
                            _buildSection(
                              icon: Icons.speed,
                              title: 'Service Limitations',
                              content:
                                  'As a free service, connection speeds may be limited. Server availability is not guaranteed. For best performance, upgrade to a premium VPN service.',
                              isDark: isDark,
                            ),
                            _buildSection(
                              icon: Icons.gavel,
                              title: 'Disclaimer',
                              content:
                                  'By using this app, you agree to use it responsibly and in compliance with all applicable laws in your country. The developers are not responsible for any misuse.',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 8),
                            // Burmese translation
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'ဤ VPN အပလီကေးရှင်းသည် အခမဲ့ဝန်ဆောင်မှုဖြစ်သည်။ ကျွန်ုပ်တို့သည် သင်၏ ကိုယ်ရေးကိုယ်တာ အချက်အလက်များကို မသိမ်းဆည်းပါ။ တရားမဝင်သောလုပ်ဆောင်မှုများအတွက် အသုံးမပြုပါနှင့်။',
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                  fontSize: 12,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Accept button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    children: [
                      if (!_hasScrolledToBottom)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Scroll down to read all terms',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            await context.read<SettingsProvider>().acceptPrivacy();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacementNamed('/home');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'I Agree & Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required bool isDark,
    bool isWarning = false,
  }) {
    final color = isWarning ? AppColors.error : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textLight,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
