import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SecureAccountPage extends StatelessWidget {
  const SecureAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.surfaceLow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Secure Account',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phonelink_lock_rounded,
              size: 80,
              color: AppColors.electricAmber,
            ),
            const SizedBox(height: 32),
            Text(
              'Link Your Phone',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.electricAmber,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your phone number to secure your venue and receive gig notifications.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            // Placeholder for Phone Number Input
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceMid,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                'Phone Number Input Coming Soon',
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
