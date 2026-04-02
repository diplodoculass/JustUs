import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../features/auth/controllers/user_repository.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../features/home/controllers/couple_repository.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../router/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final coupleAsync = ref.watch(currentCoupleProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              // ─── Header ──────────────────────────────────────────────
              _buildHeader(context, ref, userAsync),

              const SizedBox(height: AppSpacing.xxl),

              // ─── Streak / Relationship Card ──────────────────────────
              _buildRelationshipCard(coupleAsync),

              const SizedBox(height: AppSpacing.xl),

              // ─── Quick Actions ────────────────────────────────────────
              Text('Today', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.smd),

              _buildQuickActionCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Daily Question',
                subtitle: 'A new question waiting for you both',
                color: AppColors.accentPrimary,
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.smd),

              _buildQuickActionCard(
                icon: Icons.mail_outline_rounded,
                title: 'Love Letter',
                subtitle: 'Write something sweet',
                color: const Color(0xFFE8A0BF),
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.smd),

              _buildQuickActionCard(
                icon: Icons.emoji_emotions_outlined,
                title: 'Mood Check-In',
                subtitle: "How are you feeling today?",
                color: const Color(0xFF81C784),
                onTap: () {},
              ),

              const SizedBox(height: AppSpacing.xl),

              // ─── Features Grid ────────────────────────────────────────
              Text('Explore', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.smd),

              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.smd,
                crossAxisSpacing: AppSpacing.smd,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                children: [
                  _buildFeatureTile(
                    icon: Icons.auto_stories_outlined,
                    label: 'Journal',
                    color: const Color(0xFFBB86FC),
                    onTap: () {},
                  ),
                  _buildFeatureTile(
                    icon: Icons.sports_esports_outlined,
                    label: 'Games',
                    color: const Color(0xFFFFAB40),
                    onTap: () {},
                  ),
                  _buildFeatureTile(
                    icon: Icons.timeline_outlined,
                    label: 'Timeline',
                    color: const Color(0xFF4FC3F7),
                    onTap: () {},
                  ),
                  _buildFeatureTile(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    color: const Color(0xFFAED581),
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AsyncValue userAsync,
  ) {
    final user = userAsync.valueOrNull;

    return Row(
      children: [
        AppAvatar(
          name: user?.displayName ?? 'U',
          imageUrl: user?.avatarUrl,
          size: 48,
        ),
        const SizedBox(width: AppSpacing.smd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, ${user?.displayName?.split(' ').first ?? 'there'} 💛',
                style: AppTypography.titleLarge,
              ),
              Text(
                _getGreeting(),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            _showSettingsSheet(context, ref);
          },
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipCard(AsyncValue coupleAsync) {
    final couple = coupleAsync.valueOrNull;

    if (couple == null) {
      return AppCard(
        gradient: AppColors.ctaGradient,
        padding: AppSpacing.cardPaddingLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Connect with your partner',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Pair up to unlock all features and start your wellness journey together.',
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      );
    }

    final daysTogether = AppDateUtils.daysBetween(
      couple.relationshipStartDate,
      DateTime.now(),
    );

    return AppCard(
      color: AppColors.backgroundSurface,
      padding: AppSpacing.cardPaddingLarge,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔥 ${couple.streakCount} day streak',
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$daysTogether days together',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
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
                  AppDateUtils.nextMilestone(couple.relationshipStartDate),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accentPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      color: AppColors.backgroundSurface,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      color: AppColors.backgroundSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTypography.labelLarge),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: AppRadius.borderRadiusPill,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 32),
                ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: AppColors.destructive,
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: AppColors.destructive),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(authControllerProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
