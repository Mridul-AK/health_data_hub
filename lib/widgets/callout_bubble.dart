import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/health_data.dart';
import '../theme/app_theme.dart';

/// Rounded neon annotation attached to the organ / body art.
class CalloutBubble extends StatelessWidget {
  final Callout callout;
  final double maxWidth;
  const CalloutBubble(this.callout, {super.key, this.maxWidth = 180});

  @override
  Widget build(BuildContext context) {
    final Color c = callout.positive ? AppColors.green : AppColors.red;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0x990A0D0C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.withValues(alpha: 0.9), width: 1.3),
              boxShadow: [
                BoxShadow(
                    color: c.withValues(alpha: 0.28),
                    blurRadius: 14,
                    spreadRadius: -3),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(callout.text,
                    style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.25,
                        color: AppColors.textPrimary)),
                if (callout.link) ...[
                  const SizedBox(height: 4),
                  Text('View in Details →',
                      style: AppText.mono10.copyWith(color: c)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
