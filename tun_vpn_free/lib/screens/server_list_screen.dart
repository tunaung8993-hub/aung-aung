import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/server_tile.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-test pings on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vpn = context.read<VpnProvider>();
      if (vpn.servers.every((s) => s.ping == -1)) {
        vpn.testAllPings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<VpnProvider>(
      builder: (context, vpn, _) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Server List',
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.textLight,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${vpn.servers.length} servers available',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Ping test button
                  ElevatedButton.icon(
                    onPressed: vpn.isTestingPing ? null : vpn.testAllPings,
                    icon: vpn.isTestingPing
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.network_ping, size: 16),
                    label: Text(
                      vpn.isTestingPing ? 'Testing...' : 'Test Ping',
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            // Auto-select button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: vpn.autoSelectBestServer,
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Auto-Select Best Server'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Server list
            Expanded(
              child: ListView.builder(
                itemCount: vpn.servers.length,
                itemBuilder: (context, index) {
                  final server = vpn.servers[index];
                  return ServerTile(
                    server: server,
                    isSelected: vpn.selectedServer?.id == server.id,
                    onTap: () {
                      vpn.selectServer(server);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${server.flag} ${server.city} selected',
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
