import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/journal_model.dart';
import '../controllers/journal_repository.dart';
import '../../home/controllers/couple_repository.dart';
import '../../../core/services/auth_service.dart';

class LoveLetterScreen extends ConsumerStatefulWidget {
  const LoveLetterScreen({super.key});

  @override
  ConsumerState<LoveLetterScreen> createState() => _LoveLetterScreenState();
}

class _LoveLetterScreenState extends ConsumerState<LoveLetterScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journalEntries = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Parchment-like background
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: journalEntries.when(
              data: (entries) => entries.isEmpty
                  ? SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildLetterCard(entries[index], index),
                        childCount: entries.length,
                      ),
                    ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: _buildPremiumFab(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Our Love Letters',
        style: AppTypography.titleLarge.copyWith(
          fontFamily: 'Playfair Display', // Premium serif feel
          color: AppColors.accentSecondary,
          letterSpacing: 1.2,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.accentSecondary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 2,
            color: AppColors.accentPrimary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'The digital archive of your hearts.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 60,
            height: 2,
            color: AppColors.accentPrimary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterCard(JournalEntryModel entry, int index) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentSecondary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Show letter details
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(entry.createdAt),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                          entry.mood != null
                              ? Text(entry.mood!, style: const TextStyle(fontSize: 20))
                              : const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        entry.content,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyLarge.copyWith(
                          fontFamily: 'Inter',
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          _buildSealIndicator(entry),
                          const Spacer(),
                          Text(
                            'READ LETTER',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.accentPrimary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_right, color: AppColors.accentPrimary, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSealIndicator(JournalEntryModel entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 12, color: AppColors.accentPrimary),
          const SizedBox(width: 4),
          Text(
            entry.isPrivate ? 'PRIVATE SEAL' : 'OPEN LETTER',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.accentPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail_outline_rounded, size: 80, color: AppColors.accentPrimary.withValues(alpha: 0.2)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'The ink hasn\'t found the paper yet.',
            style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Write your first love letter to forever.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFab() {
    return FloatingActionButton.extended(
      onPressed: () => _showWriteLetterSheet(),
      backgroundColor: AppColors.accentSecondary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      label: Row(
        children: [
          const Icon(Icons.create_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'WRITE A LETTER',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showWriteLetterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WriteLetterSheet(),
    );
  }

  String _formatDate(DateTime date) {
    // Simple format for now
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _WriteLetterSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_WriteLetterSheet> createState() => _WriteLetterSheetState();
}

class _WriteLetterSheetState extends ConsumerState<_WriteLetterSheet> {
  final _contentController = TextEditingController();
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          _buildSheetHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dearest,',
                    style: AppTypography.titleLarge.copyWith(
                      fontFamily: 'Playfair Display',
                      color: AppColors.accentSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Let your heart flow onto the page...',
                      hintStyle: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                    ),
                    style: AppTypography.bodyLarge.copyWith(
                      height: 1.8,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildSheetFooter(),
        ],
      ),
    );
  }

  Widget _buildSheetHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTypography.bodyMedium.copyWith(color: AppColors.destructive)),
          ),
          Text(
            'Writing Letter',
            style: AppTypography.titleMedium.copyWith(color: AppColors.accentSecondary),
          ),
          const SizedBox(width: 60), // Balance
        ],
      ),
    );
  }

  Widget _buildSheetFooter() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg + (MediaQuery.of(context).viewInsets.bottom > 0? 0 : MediaQuery.of(context).padding.bottom),
        top: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Row(
            children: [
              Switch.adaptive(
                value: _isPrivate,
                onChanged: (val) => setState(() => _isPrivate = val),
                activeThumbColor: AppColors.accentPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                'Private Seal',
                style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final content = _contentController.text.trim();
              if (content.isEmpty) return;

              final couple = ref.read(currentCoupleProvider).valueOrNull;
              final user = ref.read(authServiceProvider);
              if (couple == null || user.uid == null) return;

              await ref.read(journalRepositoryProvider).createEntry(
                coupleId: couple.id,
                authorName: user.currentUser?.displayName ?? 'Partner',
                content: content,
                isPrivate: _isPrivate,
              );

              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Seal & Send'),
          ),
        ],
      ),
    );
  }
}
