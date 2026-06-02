import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum TrackingStepState { completed, active, pending }

class TrackingStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final TrackingStepState state;

  const TrackingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.state,
  });
}

class TrackingTimeline extends StatelessWidget {
  final List<TrackingStep> steps;

  const TrackingTimeline({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return _TimelineRow(
          step: step,
          showLine: !isLast,
          lineActive: step.state == TrackingStepState.completed,
        );
      }),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TrackingStep step;
  final bool showLine;
  final bool lineActive;

  const _TimelineRow({
    required this.step,
    required this.showLine,
    required this.lineActive,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = step.state == TrackingStepState.completed;
    final isActive = step.state == TrackingStepState.active;

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _StepIcon(step: step),
              if (showLine)
                Container(
                  width: 2,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: lineActive
                      ? AppColors.trackingDarkGreen.withValues(alpha: 0.35)
                      : const Color(0xFFE5E7EB),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLine ? 20 : 0, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isCompleted || isActive
                          ? AppColors.trackingDarkGreen
                          : AppColors.chipInactiveText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? AppColors.trackingAccentGreen
                          : AppColors.chipInactiveText,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

class _StepIcon extends StatelessWidget {
  final TrackingStep step;

  const _StepIcon({required this.step});

  @override
  Widget build(BuildContext context) {
    switch (step.state) {
      case TrackingStepState.completed:
        return Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.trackingDarkGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
      case TrackingStepState.active:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.trackingAccentGreen.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.trackingAccentGreen, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.trackingAccentGreen.withValues(alpha: 0.35),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(step.icon, size: 14, color: AppColors.trackingDarkGreen),
        );
      case TrackingStepState.pending:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Icon(step.icon, size: 14, color: AppColors.chipInactiveText),
        );
    }
  }
}
