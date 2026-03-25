import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../theme/app_theme.dart';

class ServerTile extends StatelessWidget {
  final VpnServer server;
  final bool isSelected;
  final VoidCallback onTap;

  const ServerTile({
    super.key,
    required this.server,
    required this.isSelected,
    required this.onTap,
  });

  Color _pingColor(int ping) {
    if (ping == -1) return AppColors.textSecondary;
    if (ping >= 9999) return AppColors.error;
    if (ping < 100) return AppColors.connected;
    if (ping < 200) return AppColors.connecting;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.12)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.5)
                : (isDark ? AppColors.darkBorder : Colors.grey.shade200),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag
            Text(server.flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            // Server info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.city,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textLight,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        server.country,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          server.protocol,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Ping
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (server.ping == -1)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textSecondary,
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _pingColor(server.ping),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        server.pingLabel,
                        style: TextStyle(
                          color: _pingColor(server.ping),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 18,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
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
}
