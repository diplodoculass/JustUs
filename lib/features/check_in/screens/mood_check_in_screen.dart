import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../features/auth/controllers/user_repository.dart';
import '../../../features/home/controllers/couple_repository.dart';
import '../../../features/check_in/controllers/mood_repository.dart';
import '../../../shared/models/mood_model.dart';

class MoodCheckInScreen extends ConsumerStatefulWidget {
  const MoodCheckInScreen({super.key});

  @override
  ConsumerState<MoodCheckInScreen> createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends ConsumerState<MoodCheckInScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedMood;
  int _energyLevel = 3;
  final _noteController = TextEditingController();
  bool _isSubmitting = false;
  late AnimationController _bounceController;

  static const _moods = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '🥰', 'label': 'Loved'},
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😐', 'label': 'Okay'},
    {'emoji': '😔', 'label': 'Down'},
    {'emoji': '😤', 'label': 'Frustrated'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '🤗', 'label': 'Grateful'},
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todaysMoods = ref.watch(todaysMoodsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Mood Check-In', style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),

            Text(
              "How are you feeling\nright now?",
              style: AppTypography.headlineLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your partner will see this too.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ─── Mood Selector ────────────────────────────────────
            Wrap(
              spacing: AppSpacing.smd,
              runSpacing: AppSpacing.smd,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['label'];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedMood = mood['label'] as String);
                    _bounceController.forward(from: 0);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.smd,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentPrimary.withValues(alpha: 0.15)
                          : AppColors.backgroundSurface,
                      borderRadius: AppRadius.borderRadiusMd,
                      border: isSelected
                          ? Border.all(
                              color: AppColors.accentPrimary,
                              width: 2,
                            )
                          : Border.all(
                              color: Colors.transparent,
                              width: 2,
                            ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          mood['emoji'] as String,
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood['label'] as String,
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected
                                ? AppColors.accentPrimary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ─── Energy Level ─────────────────────────────────────
            Text('Energy level', style: AppTypography.titleSmall),
            const SizedBox(height: AppSpacing.smd),
            Row(
              children: [
                const Text('🔋', style: TextStyle(fontSize: 20)),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.accentPrimary,
                      inactiveTrackColor: AppColors.backgroundElevated,
                      thumbColor: AppColors.accentPrimary,
                      overlayColor: AppColors.accentPrimary.withValues(alpha: 0.2),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _energyLevel.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      onChanged: (v) => setState(() => _energyLevel = v.round()),
                    ),
                  ),
                ),
                const Text('⚡', style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Low', style: AppTypography.labelSmall),
                Text(
                  _energyLevel.toString(),
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.accentPrimary,
                  ),
                ),
                Text('High', style: AppTypography.labelSmall),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // ─── Optional Note ────────────────────────────────────
            Text('Add a note (optional)', style: AppTypography.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              maxLength: 200,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Anything on your mind?',
                hintStyle: AppTypography.bodyMedium.copyWith(
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

            const SizedBox(height: AppSpacing.xl),

            // ─── Submit ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: _selectedMood != null
                      ? AppColors.ctaGradient
                      : null,
                  color: _selectedMood == null
                      ? AppColors.backgroundElevated
                      : null,
                  borderRadius: AppRadius.borderRadiusPill,
                ),
                child: ElevatedButton(
                  onPressed:
                      _selectedMood != null && !_isSubmitting
                          ? _submitMood
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
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
                      : Text(
                          'Check In',
                          style: TextStyle(
                            color: _selectedMood != null
                                ? Colors.white
                                : AppColors.textMuted,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ─── Today's Status ───────────────────────────────────
            todaysMoods.when(
              loading: () => const SizedBox.shrink(),
              error: (e, st) => const SizedBox.shrink(),
              data: (moods) {
                if (moods.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's check-ins", style: AppTypography.titleSmall),
                    const SizedBox(height: AppSpacing.smd),
                    ...moods.map((m) => _buildMoodRow(m)),
                  ],
                );
              },
            ),

            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodRow(MoodEntryModel mood) {
    final emoji = _moods
        .firstWhere(
          (m) => m['label'] == mood.mood,
          orElse: () => {'emoji': '😊', 'label': mood.mood},
        )['emoji'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${mood.userName} is feeling ${mood.mood.toLowerCase()}',
                  style: AppTypography.bodyMedium,
                ),
                if (mood.note != null && mood.note!.isNotEmpty)
                  Text(
                    mood.note!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '🔋' * mood.energyLevel,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Future<void> _submitMood() async {
    final couple = ref.read(currentCoupleProvider).valueOrNull;
    final user = ref.read(currentUserProfileProvider).valueOrNull;
    if (couple == null || user == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(moodRepositoryProvider).submitMood(
            coupleId: couple.id,
            userName: user.displayName,
            mood: _selectedMood!,
            note: _noteController.text.trim().isNotEmpty
                ? _noteController.text.trim()
                : null,
            energyLevel: _energyLevel,
          );
      if (mounted) {
        context.showAppToast('Mood shared! 🌟');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        context.showAppToast('Failed to check in', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
