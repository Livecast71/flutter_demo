import 'package:flutter/material.dart';
import 'dart:math';
import '../models/confetti_particle.dart';

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter(this.particles, this.progress);

  Path _createStarPath(double size) {
    final path = Path();
    final center = Offset.zero;
    final outerRadius = size / 2;
    final innerRadius = outerRadius * 0.4;
    final numPoints = 5;

    for (int i = 0; i < numPoints * 2; i++) {
      final angle = (i * pi / numPoints) - (pi / 2);
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _createHeartPath(double size) {
    final path = Path();
    final scale = size / 20.0;
    final center = Offset.zero;
    
    // Draw heart shape using Bezier curves
    path.moveTo(center.dx, center.dy + 5 * scale);
    
    // Left curve
    path.cubicTo(
      center.dx - 5 * scale, center.dy + 5 * scale,
      center.dx - 10 * scale, center.dy,
      center.dx - 10 * scale, center.dy - 5 * scale,
    );
    path.cubicTo(
      center.dx - 10 * scale, center.dy - 8 * scale,
      center.dx - 5 * scale, center.dy - 10 * scale,
      center.dx, center.dy - 10 * scale,
    );
    
    // Right curve
    path.cubicTo(
      center.dx + 5 * scale, center.dy - 10 * scale,
      center.dx + 10 * scale, center.dy - 8 * scale,
      center.dx + 10 * scale, center.dy - 5 * scale,
    );
    path.cubicTo(
      center.dx + 10 * scale, center.dy,
      center.dx + 5 * scale, center.dy + 5 * scale,
      center.dx, center.dy + 5 * scale,
    );
    
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = particle.startX * size.width + particle.velocityX * size.width * progress * 50;
      final y = particle.startY * size.height + particle.velocityY * size.height * progress * 100;
      final rotation = particle.rotationSpeed * progress * 10;

      // Apply gravity effect
      final gravityY = y + (progress * progress * 200);

      if (gravityY < size.height && x > 0 && x < size.width) {
        final paint = Paint()
          ..color = particle.color.withOpacity(1.0 - progress)
          ..style = PaintingStyle.fill;

        canvas.save();
        canvas.translate(x, gravityY);
        canvas.rotate(rotation);

        // Draw shape based on particle type
        final shapePath = particle.shape == ConfettiShape.star
            ? _createStarPath(particle.size)
            : _createHeartPath(particle.size);
        canvas.drawPath(shapePath, paint);

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

