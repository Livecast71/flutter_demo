import 'package:flutter/material.dart';
import 'dart:math';

enum ConfettiShape { star, heart }

class ConfettiParticle {
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final Color color;
  final double size;
  final double rotationSpeed;
  final ConfettiShape shape;

  ConfettiParticle(Random random)
      : startX = random.nextDouble() * 0.8 + 0.1, // 10% to 90% of screen width
        startY = random.nextDouble() * 0.3, // Top 30% of screen
        velocityX = (random.nextDouble() - 0.5) * 0.02,
        velocityY = random.nextDouble() * 0.01 + 0.005,
        color = Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          1.0,
        ),
        size = random.nextDouble() * 12 + 8, // Size range: 8-20 (was 4-12)
        rotationSpeed = (random.nextDouble() - 0.5) * 0.1,
        shape = random.nextBool() ? ConfettiShape.star : ConfettiShape.heart;
}

