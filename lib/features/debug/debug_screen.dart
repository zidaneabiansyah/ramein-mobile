import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/onboarding_provider.dart';
import '../onboarding/onboarding_screen.dart';

/// Debug Screen untuk testing onboarding flow
class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Onboarding'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Onboarding Status',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Icon(
                          onboardingState.isCompleted 
                              ? Icons.check_circle 
                              : Icons.cancel,
                          color: onboardingState.isCompleted 
                              ? AppColors.success 
                              : AppColors.error,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          onboardingState.isCompleted 
                              ? 'Completed' 
                              : 'Not Completed',
                          style: AppTypography.bodyLarge.copyWith(
                            color: onboardingState.isCompleted 
                                ? AppColors.success 
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (onboardingState.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: AppSpacing.sm),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Action Buttons
            Text(
              'Actions',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Reset Onboarding Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(onboardingProvider.notifier).resetOnboarding();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Onboarding reset successfully!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Onboarding'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Complete Onboarding Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(onboardingProvider.notifier).completeOnboarding();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Onboarding marked as completed!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Mark as Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // View Onboarding Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text('View Onboarding'),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Debug Info
            Card(
              color: AppColors.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Info',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Loading: ${onboardingState.isLoading}',
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      'Completed: ${onboardingState.isCompleted}',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
