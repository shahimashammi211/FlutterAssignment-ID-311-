import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Mobile-first auth frame. The decorative shapes use only the existing
/// AQILEXA theme colors; reference images guide layout, not color selection.
class WaveAuthShell extends StatelessWidget {
  final Widget child;
  const WaveAuthShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 650;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: wide ? 480 : 520),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(wide ? 28 : 0),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(color: AppColors.background),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        width: 190,
                        height: 190,
                        child: CustomPaint(painter: _TopShapePainter()),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 175,
                        child: CustomPaint(painter: _BottomWavePainter()),
                      ),
                      SafeArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(28, 22, 28, 32),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - 55,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class _TopShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary.withValues(alpha: .20);
    final path = Path()
      ..moveTo(size.width * .32, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * .78)
      ..cubicTo(size.width * .70, size.height * .95,
          size.width * .43, size.height * .72, size.width * .32, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary.withValues(alpha: .20);
    final path = Path()
      ..moveTo(0, size.height * .42)
      ..cubicTo(size.width * .28, size.height * .05,
          size.width * .55, size.height * .78, size.width, size.height * .28)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
