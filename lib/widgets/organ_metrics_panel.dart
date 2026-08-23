import 'package:flutter/material.dart';
import '../models/health_data.dart';
import '../theme/app_theme.dart';

/// Slide-in "Organ Metrics" accordion panel (right side overlay).
Future<void> showOrganMetrics(
  BuildContext context, {
  required String selectedId,
  required ValueChanged<Organ> onSelect,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Organ Metrics',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, secondaryAnim, _) {
      final curved =
          CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return Align(
        alignment: Alignment.centerRight,
        child: SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(curved),
          child: _OrganMetricsPanel(
            selectedId: selectedId,
            onSelect: (o) {
              Navigator.of(ctx).pop();
              onSelect(o);
            },
          ),
        ),
      );
    },
  );
}

class _OrganMetricsPanel extends StatefulWidget {
  final String selectedId;
  final ValueChanged<Organ> onSelect;
  const _OrganMetricsPanel(
      {required this.selectedId, required this.onSelect});

  @override
  State<_OrganMetricsPanel> createState() => _OrganMetricsPanelState();
}

class _OrganMetricsPanelState extends State<_OrganMetricsPanel> {
  int _open = 0; // 0 organs, 1 blood, 2 hormone

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: size.width * 0.66,
        height: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 60),
        padding: const EdgeInsets.fromLTRB(18, 22, 14, 22),
        decoration: BoxDecoration(
          color: const Color(0xFF15191A),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(26),
            bottomLeft: Radius.circular(26),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.6), blurRadius: 30),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('Organ Metrics', 0, chevron: true),
              if (_open == 0)
                ...HealthData.organs.map((o) => _organTile(o)),
              const SizedBox(height: 10),
              _sectionHeader('Blood Metrics', 1, filled: true),
              if (_open == 1) _placeholderList(),
              const SizedBox(height: 10),
              _sectionHeader('Hormone', 2, filled: true),
              if (_open == 2) _placeholderList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, int index,
      {bool chevron = false, bool filled = false}) {
    final open = _open == index;
    return GestureDetector(
      onTap: () => setState(() => _open = open ? -1 : index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF20262A) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppText.sectionTitle.copyWith(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chevron) ...[
              const SizedBox(width: 8),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.green),
                ),
                child: Icon(open ? Icons.expand_less : Icons.expand_more,
                    size: 18, color: AppColors.green),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _organTile(Organ o) {
    final selected = o.id == widget.selectedId;
    return GestureDetector(
      onTap: () => widget.onSelect(o),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: selected
              ? LinearGradient(colors: [
                  AppColors.green.withValues(alpha: 0.16),
                  Colors.transparent,
                ])
              : null,
        ),
        child: Row(
          children: [
            SizedBox(
                width: 44,
                height: 44,
                child: Image.asset(o.asset, fit: BoxFit.contain)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                o.name,
                style: TextStyle(
                    fontFamily: AppText.display,
                    fontSize: selected ? 17 : 14,
                    color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderList() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text('No data available',
            style: AppText.bodyFaint.copyWith(fontSize: 12)),
      );
}
