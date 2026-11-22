import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// White rounded card with a hairline border, used for list rows and info
/// boxes on Home, Profile and Admin. Styled from [AppTheme] tokens.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.child,
    this.onTap,
    this.highlighted = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool highlighted;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: highlighted ? AppTheme.highlight : AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: highlighted ? AppTheme.accent : AppTheme.divider,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Settings-style row: bold label on the left, value / chevron on the right.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.label,
    this.value,
    this.chevron = true,
    this.onTap,
    this.highlighted = false,
  });

  final String label;
  final String? value;
  final bool chevron;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      onTap: onTap,
      highlighted: highlighted,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          if (chevron)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Full-width button. Soft blush by default; pass [color] for a filled one.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppTheme.highlight,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dark = color.computeLuminance() < 0.5;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: dark ? Colors.white : AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
