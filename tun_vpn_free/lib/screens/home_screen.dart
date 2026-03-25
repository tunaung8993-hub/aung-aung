import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/connect_button.dart';
import '../widgets/status_card.dart';
import '../services/ads_service.dart';
import 'server_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  VpnStatus? _lastStatus;

  @override
  void initState() {
    super.initState();
  }

  void _onConnectPressed(VpnProvider vpn) async {
    final wasConnected = vpn.isConnected;
    await vpn.toggleConnection();
    // Show interstitial ad after connect/disconnect
    if (wasConnected || vpn.isConnected) {
      await Future.delayed(const Duration(milliseconds: 500));
      await AdsService.instance.showInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<VpnProvider, SettingsProvider>(
      builder: (context, vpn, settings, _) {
        // Detect status changes for ad display
        if (_lastStatus != vpn.status) {
          if (_lastStatus == VpnStatus.connecting &&
              vpn.status == VpnStatus.connected) {
            // Just connected - show ad
            Future.microtask(() => AdsService.instance.showInterstitialAd());
          } else if (_lastStatus == VpnStatus.connected &&
              vpn.status == VpnStatus.disconnected) {
            // Just disconnected - show ad
            Future.microtask(() => AdsService.instance.showInterstitialAd());
          }
          _lastStatus = vpn.status;
        }

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tun VPN Free',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onPressed: () => settings.toggleTheme(),
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _MainTab(onConnectPressed: _onConnectPressed),
              const ServerListScreen(),
              const SettingsScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.shield_outlined),
                  activeIcon: Icon(Icons.shield),
                  label: 'VPN',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dns_outlined),
                  activeIcon: Icon(Icons.dns),
                  label: 'Servers',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
          // Banner ad at bottom (optional)
          // bottomSheet: AdsService.instance.isBannerReady
          //     ? BannerAdWidget()
          //     : null,
        );
      },
    );
  }
}

class _MainTab extends StatelessWidget {
  final Function(VpnProvider) onConnectPressed;

  const _MainTab({required this.onConnectPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<VpnProvider>(
      builder: (context, vpn, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Status badge
              _StatusBadge(status: vpn.status),
              const SizedBox(height: 32),

              // Big connect button
              ConnectButton(
                status: vpn.status,
                onPressed: () => onConnectPressed(vpn),
              ),
              const SizedBox(height: 32),

              // Connection info cards
              if (vpn.status == VpnStatus.connected) ...[
                StatusCard(vpn: vpn),
                const SizedBox(height: 16),
              ],

              // Error message
              if (vpn.errorMessage.isNotEmpty && vpn.status == VpnStatus.error)
                _ErrorCard(message: vpn.errorMessage),

              // Selected server
              _SelectedServerCard(vpn: vpn, isDark: isDark),
              const SizedBox(height: 24),

              // Quick stats row
              if (vpn.status == VpnStatus.connected)
                _StatsRow(vpn: vpn, isDark: isDark),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final VpnStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case VpnStatus.connected:
        color = AppColors.connected;
        text = 'CONNECTED';
        icon = Icons.lock;
        break;
      case VpnStatus.connecting:
        color = AppColors.connecting;
        text = 'CONNECTING...';
        icon = Icons.sync;
        break;
      case VpnStatus.disconnecting:
        color = AppColors.connecting;
        text = 'DISCONNECTING...';
        icon = Icons.sync;
        break;
      case VpnStatus.error:
        color = AppColors.error;
        text = 'CONNECTION FAILED';
        icon = Icons.error_outline;
        break;
      default:
        color = AppColors.disconnected;
        text = 'NOT PROTECTED';
        icon = Icons.lock_open;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == VpnStatus.connecting || status == VpnStatus.disconnecting)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
          else
            Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedServerCard extends StatelessWidget {
  final VpnProvider vpn;
  final bool isDark;

  const _SelectedServerCard({required this.vpn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final server = vpn.selectedServer;
    if (server == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        // Navigate to server list
        DefaultTabController.of(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Text(server.flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.city,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${server.country} • ${server.protocol}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _pingColor(server.ping).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    server.pingLabel,
                    style: TextStyle(
                      color: _pingColor(server.ping),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _pingColor(int ping) {
    if (ping == -1) return AppColors.textSecondary;
    if (ping < 100) return AppColors.connected;
    if (ping < 200) return AppColors.connecting;
    return AppColors.error;
  }
}

class _StatsRow extends StatelessWidget {
  final VpnProvider vpn;
  final bool isDark;

  const _StatsRow({required this.vpn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.timer_outlined,
            label: 'Duration',
            value: vpn.connectionDurationFormatted,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.data_usage,
            label: 'Data Used',
            value: vpn.dataUsageFormatted,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textLight,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
