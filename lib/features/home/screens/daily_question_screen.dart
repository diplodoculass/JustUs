import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/extensions/context_extensions.dart';

import '../../../features/home/controllers/couple_repository.dart';
import '../../../features/home/controllers/daily_prompt_repository.dart';


class DailyQuestionScreen extends ConsumerStatefulWidget {
  const DailyQuestionScreen({super.key});

  @override
  ConsumerState<DailyQuestionScreen> createState() =>
      _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends ConsumerState<DailyQuestionScreen>
    with SingleTickerProviderStateMixin {
  final _answerController = TextEditingController();
  bool _isSubmitting = false;
  bool _showPartnerAnswer = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final promptAsync = ref.watch(todaysPromptProvider);
    final responsesAsync = ref.watch(todaysResponsesProvider);
    final uid = ref.watch(authServiceProvider).uid;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Daily Question', style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: promptAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accentPrimary),
          ),
          error: (e, _) => Center(
            child: Text('Could not load prompt', style: AppTypography.bodyLarge),
          ),
          data: (promptData) {
            if (promptData == null) {
              return _buildNoCoupleState();
            }

            final question = promptData['question'] as String;
            final category = promptData['category'] as String;
            final dayNumber = promptData['dayNumber'] as int;

            final responses = responsesAsync.valueOrNull ?? [];
            final myResponse =
                responses.where((r) => r.userId == uid).firstOrNull;
            final partnerResponse =
                responses.where((r) => r.userId != uid).firstOrNull;

            return SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // Category chip + day counter
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.smd,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentPrimary.withValues(alpha: 0.12),
                          borderRadius: AppRadius.borderRadiusPill,
                        ),
                        child: Text(
                          category,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.accentPrimary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Day $dayNumber',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Question
                  Text(
                    question,
                    style: AppTypography.headlineLarge.copyWith(
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // ─── My Answer ───────────────────────────────────────
                  if (myResponse == null) ...[
                    Text('Your answer', style: AppTypography.labelMedium),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _answerController,
                      maxLines: 5,
                      maxLength: 500,
                      style: AppTypography.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Take your time...',
                        hintStyle: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textMuted,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundElevated,
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.borderRadiusMd,
                          borderSide: BorderSide.none,
                        ),
                        counterStyle: AppTypography.labelSmall,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors.ctaGradient,
                          borderRadius: AppRadius.borderRadiusPill,
                        ),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text('Share Answer'),
                        ),
                      ),
                    ),
                  ] else ...[
                    // My submitted answer
                    _buildAnswerCard(
                      label: 'Your answer',
                      answer: myResponse.answer,
                      isMe: true,
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xl),

                  // ─── Partner's Answer ───────────────────────────────────
                  if (myResponse != null && partnerResponse != null) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() => _showPartnerAnswer = !_showPartnerAnswer);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: AppSpacing.cardPaddingLarge,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                          borderRadius: AppRadius.borderRadiusLg,
                          border: Border.all(
                            color: AppColors.accentSecondary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _showPartnerAnswer
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.accentSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  "Partner's answer",
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.accentSecondary,
                                  ),
                                ),
                              ],
                            ),
                            if (_showPartnerAnswer) ...[
                              const SizedBox(height: AppSpacing.smd),
                              Text(
                                partnerResponse.answer,
                                style: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Tap to reveal',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ] else if (myResponse != null && partnerResponse == null) ...[
                    Container(
                      padding: AppSpacing.cardPaddingLarge,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSurface,
                        borderRadius: AppRadius.borderRadiusLg,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.hourglass_top_rounded,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.smd),
                          Text(
                            'Waiting for your partner to answer...',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.huge),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnswerCard({
    required String label,
    required String answer,
    required bool isMe,
  }) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPaddingLarge,
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.accentPrimary.withValues(alpha: 0.08)
            : AppColors.backgroundSurface,
        borderRadius: AppRadius.borderRadiusLg,
        border: isMe
            ? Border.all(
                color: AppColors.accentPrimary.withValues(alpha: 0.2),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isMe ? AppColors.accentPrimary : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(answer, style: AppTypography.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildNoCoupleState() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.textMuted,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Pair with your partner to start answering daily questions together.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      context.showAppToast('Write something before submitting', isError: true);
      return;
    }

    final couple = ref.read(currentCoupleProvider).valueOrNull;
    final prompt = ref.read(todaysPromptProvider).valueOrNull;
    if (couple == null || prompt == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(dailyPromptRepositoryProvider).submitResponse(
            coupleId: couple.id,
            dayNumber: prompt['dayNumber'] as int,
            answer: answer,
          );
      if (mounted) {
        context.showAppToast('Answer shared! 💛');
      }
    } catch (e) {
      if (mounted) {
        context.showAppToast('Failed to submit', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
