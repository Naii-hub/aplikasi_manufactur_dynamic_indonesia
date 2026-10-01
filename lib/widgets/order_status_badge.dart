import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/order_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, borderColor) = _getColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  (Color, Color, Color) _getColors(OrderStatus status) {
    switch (status) {
      case OrderStatus.menungguPembayaran:
        return (
          AppColors.badgePendingBg,
          AppColors.badgePendingText,
          AppColors.terracotta.withValues(alpha: 0.3),
        );
      case OrderStatus.diproses:
        return (
          AppColors.badgeProcessingBg,
          AppColors.badgeProcessingText,
          AppColors.darkBrown.withValues(alpha: 0.25),
        );
      case OrderStatus.dikirim:
        return (
          AppColors.badgeShippedBg,
          AppColors.badgeShippedText,
          const Color(0xFF2A5C7A).withValues(alpha: 0.3),
        );
      case OrderStatus.selesai:
        return (
          AppColors.badgeCompletedBg,
          AppColors.badgeCompletedText,
          const Color(0xFF2E7D32).withValues(alpha: 0.3),
        );
      case OrderStatus.dibatalkan:
        return (
          AppColors.badgeCancelledBg,
          AppColors.badgeCancelledText,
          const Color(0xFF8A3030).withValues(alpha: 0.25),
        );
    }
  }
}
