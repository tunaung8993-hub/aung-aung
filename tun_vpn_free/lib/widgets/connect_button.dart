import 'package:flutter/material.dart';
import '../providers/vpn_provider.dart';
import '../theme/app_theme.dart';
import 'vpn_shield_logo.dart';

class ConnectButton extends StatefulWidget {
  final VpnStatus status;
  final VoidCallback onPressed;

  const ConnectButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _outerPulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _outerPulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _updateAnimations();
  }

  @override
  void didUpdateWidget(ConnectButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    if (widget.status == VpnStatus.connecting ||
        widget.status == VpnStatus.disconnecting) {
      _rotateController.repeat();
      _pulseController.repeat(reverse: true);
    } else if (widget.status == VpnStatus.connected) {
      _rotateController.stop();
      _pulseController.repeat(reverse: true);
    } else {
      _rotateController.stop();
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Color get _buttonColor {
    switch (widget.status) {
      case VpnStatus.connected:
        return AppColors.error; // Red when connected (to disconnect)
      case VpnStatus.connecting:
      case VpnStatus.disconnecting:
        return AppColors.connecting;
      case VpnStatus.error:
        return AppColors.error;
      default:
        return AppColors.primary; // Green when disconnected (to connect)
    }
  }

  String get _buttonLabel {
    switch (widget.status) {
      case VpnStatus.connected:
        return 'DISCONNECT';
      case VpnStatus.connecting:
        return 'CONNECTING';
      case VpnStatus.disconnecting:
        return 'DISCONNECTING';
      case VpnStatus.error:
        return 'RETRY';
      default:
        return 'CONNECT';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _buttonColor;
    final isActive = widget.status == VpnStatus.connecting ||
        widget.status == VpnStatus.disconnecting;

    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _outerPulseAnimation]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              if (widget.status == VpnStatus.connected || isActive)
                Transform.scale(
                  scale: _outerPulseAnimation.value,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.06),
                    ),
                  ),
                ),
              // Middle ring
              if (widget.status == VpnStatus.connected || isActive)
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 155,
                    height: 155,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.1),
                    ),
                  ),
                ),
              // Rotating ring for connecting state
              if (isActive)
                RotationTransition(
                  turns: _rotateController,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: CustomPaint(
                      painter: _ArcPainter(color: color),
                    ),
                  ),
                ),
              // Main button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.7),
                      color.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VpnShieldLogo(
                      size: 44,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _buttonLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;

  _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      2.0,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => oldDelegate.color != color;
}
