import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../features/home/controllers/couple_repository.dart';
import '../../../router/app_router.dart';

class RelationshipSetupScreen extends ConsumerStatefulWidget {
  const RelationshipSetupScreen({super.key});

  @override
  ConsumerState<RelationshipSetupScreen> createState() =>
      _RelationshipSetupScreenState();
}

class _RelationshipSetupScreenState
    extends ConsumerState<RelationshipSetupScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1: What's your name
  final _nameController = TextEditingController();

  // Step 2: When did you start dating
  DateTime? _startDate;

  // Step 3: Invite or enter code
  final _codeController = TextEditingController();
  String? _generatedCode;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _currentStep++);
    }
  }

  Future<void> _generateCode() async {
    setState(() => _isLoading = true);
    try {
      final code = await ref.read(coupleRepositoryProvider).createInviteCode();
      setState(() {
        _generatedCode = code;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        context.showAppToast('Failed to generate code', isError: true);
      }
    }
  }

  Future<void> _acceptCode() async {
    if (_codeController.text.trim().length != 6) {
      context.showAppToast('Please enter a valid 6-character code', isError: true);
      return;
    }
    if (_startDate == null) {
      context.showAppToast('Please select your start date', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(coupleRepositoryProvider).acceptInviteCode(
            code: _codeController.text.trim(),
            relationshipStartDate: _startDate!,
          );
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        context.showAppToast(e.toString(), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Set Up Your Relationship',
          style: AppTypography.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 3,
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? AppColors.accentPrimary
                          : AppColors.backgroundElevated,
                      borderRadius: AppRadius.borderRadiusPill,
                    ),
                  ),
                );
              }),
            ),
          ),

          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNameStep(),
                _buildDateStep(),
                _buildPairingStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text("What should we call you?", style: AppTypography.headlineLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "This is how your partner will see you in the app.",
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: AppTypography.bodyLarge,
            decoration: const InputDecoration(
              hintText: 'Your name or nickname',
              prefixIcon: Icon(Icons.person_outline, color: AppColors.textMuted),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nameController.text.trim().length >= 2
                  ? _nextStep
                  : null,
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildDateStep() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text("When did you start dating?", style: AppTypography.headlineLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "We'll use this to calculate milestones and anniversaries.",
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _startDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: AppColors.accentPrimary,
                          ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _startDate = picked);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.smd),
                  Text(
                    _startDate != null
                        ? '${_startDate!.month}/${_startDate!.day}/${_startDate!.year}'
                        : 'Select a date',
                    style: AppTypography.bodyLarge.copyWith(
                      color: _startDate != null
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _startDate != null ? _nextStep : null,
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildPairingStep() {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            Text("Pair with your partner", style: AppTypography.headlineLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Share your invite code or enter your partner's code.",
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // Generate code section
            Container(
              width: double.infinity,
              padding: AppSpacing.cardPaddingLarge,
              decoration: BoxDecoration(
                color: AppColors.backgroundSurface,
                borderRadius: AppRadius.borderRadiusLg,
              ),
              child: Column(
                children: [
                  Text('Your Invite Code', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  if (_generatedCode != null)
                    Text(
                      _generatedCode!,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.accentPrimary,
                        letterSpacing: 6,
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _generateCode,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Generate Code'),
                      ),
                    ),
                  if (_generatedCode != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Share this code with your partner',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Divider
            Row(
              children: [
                Expanded(
                  child: Container(height: 0.5, color: AppColors.outlineVariant),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text('or', style: AppTypography.labelMedium),
                ),
                Expanded(
                  child: Container(height: 0.5, color: AppColors.outlineVariant),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Enter partner's code
            Text(
              "Enter your partner's code",
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.smd),
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              style: AppTypography.headlineMedium.copyWith(
                letterSpacing: 4,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '------',
                counterText: '',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _acceptCode,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Join Partner'),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Skip for now
            Center(
              child: TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(
                  'Skip for now',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
