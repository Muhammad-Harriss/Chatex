// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TabButtonWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const TabButtonWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.primaryBlue.withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isActive 
              ? Border.all(color: AppColors.primaryBlue.withOpacity(0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.primaryBlue : AppColors.mediumGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isActive ? AppColors.primaryBlue : AppColors.mediumGrey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}