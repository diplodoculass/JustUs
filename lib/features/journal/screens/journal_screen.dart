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
import '../../../features/journal/controllers/journal_repository.dart';
import '../../../shared/models/journal_model.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Love Letters', style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showComposeSheet(context),
        backgroundColor: AppColors.accentPrimary,
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
      body: entriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accentPrimary),
        ),
        error: (e, _) => Center(
          child: Text('Could not load journal', style: AppTypography.bodyLarge),
        ),
        data: (entries) {
          if (entries.isEmpty) return _buildEmptyState();

          return ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: entries.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _JournalCard(
                entry: entry,
                onReply: () => _showReplySheet(context, entry),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              color: AppColors.textMuted,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Your shared journal is empty',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Write your first love letter or journal entry.\nYour partner will see it too.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComposeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ComposeEntrySheet(),
    );
  }

  void _showReplySheet(BuildContext context, JournalEntryModel entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReplySheet(entry: entry),
    );
  }
}

/// Individual journal entry card.
class _JournalCard extends StatelessWidget {
  final JournalEntryModel entry;
  final VoidCallback onReply;

  const _JournalCard({required this.entry, required this.onReply});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.cardPaddingLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.accentPrimary.withValues(alpha: 0.15),
                      child: Text(
                        entry.authorName.isNotEmpty
                            ? entry.authorName[0].toUpperCase()
                            : '?',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.accentPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.authorName,
                            style: AppTypography.titleSmall,
                          ),
                          Text(
                            _formatDate(entry.createdAt),
                            style: AppTypography.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    if (entry.mood != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentSecondary.withValues(alpha: 0.12),
                          borderRadius: AppRadius.borderRadiusPill,
                        ),
                        child: Text(
                          entry.mood!,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.accentSecondary,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.smd),

                // Content
                Text(
                  entry.content,
                  style: AppTypography.bodyLarge.copyWith(height: 1.6),
                ),

                if (entry.isPrivate) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(
                        'Private entry',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Actions
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.divider.withValues(alpha: 0.15),
                ),
              ),
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: onReply,
                  icon: const Icon(
                    Icons.reply_rounded,
                    size: 18,
                  ),
                  label: const Text('Reply'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    textStyle: AppTypography.labelMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Bottom sheet for composing a new journal entry.
class _ComposeEntrySheet extends ConsumerStatefulWidget {
  const _ComposeEntrySheet();

  @override
  ConsumerState<_ComposeEntrySheet> createState() => _ComposeEntrySheetState();
}

class _ComposeEntrySheetState extends ConsumerState<_ComposeEntrySheet> {
  final _contentController = TextEditingController();
  String? _selectedMood;
  bool _isPrivate = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),
            Text('New entry', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.md),

            // Content Input
            TextFormField(
              controller: _contentController,
              maxLines: 8,
              maxLength: 2000,
              autofocus: true,
              style: AppTypography.bodyLarge,
              decoration: InputDecoration(
                hintText: "What's on your heart? Share your thoughts with your partner...",
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

            // Options Row
            Row(
              children: [
                // Mood selector placeholder / simplified version
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedMood,
                    decoration: InputDecoration(
                      hintText: 'Select mood',
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      filled: true,
                      fillColor: AppColors.backgroundElevated,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.borderRadiusMd,
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: ['Happy', 'Grateful', 'Loved', 'Sad', 'Excited', 'Tired'].map((String mood) {
                      return DropdownMenuItem<String>(
                        value: mood,
                        child: Text(mood, style: AppTypography.bodySmall),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedMood = val),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Privacy Toggle
                TextButton.icon(
                  onPressed: () => setState(() => _isPrivate = !_isPrivate),
                  icon: Icon(
                    _isPrivate ? Icons.lock_rounded : Icons.lock_open_rounded,
                    size: 20,
                    color: _isPrivate ? AppColors.accentPrimary : AppColors.textMuted,
                  ),
                  label: Text(
                    _isPrivate ? 'Private' : 'Public',
                    style: AppTypography.labelMedium.copyWith(
                      color: _isPrivate ? AppColors.accentPrimary : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.ctaGradient,
                  borderRadius: AppRadius.borderRadiusPill,
                ),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Share Entry'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      context.showAppToast('Write something first', isError: true);
      return;
    }

    final couple = ref.read(currentCoupleProvider).valueOrNull;
    final user = ref.read(currentUserProfileProvider).valueOrNull;
    if (couple == null || user == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(journalRepositoryProvider).createEntry(
            coupleId: couple.id,
            authorName: user.displayName,
            content: content,
            mood: _selectedMood,
            isPrivate: _isPrivate,
          );
      if (mounted) {
        context.showAppToast('Entry shared! ✨');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        context.showAppToast('Failed to save entry', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

/// Bottom sheet for replying to a journal entry.
class _ReplySheet extends ConsumerStatefulWidget {
  final JournalEntryModel entry;

  const _ReplySheet({required this.entry});

  @override
  ConsumerState<_ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends ConsumerState<_ReplySheet> {
  final _replyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 120),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Reply', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.sm),

            // Preview of the entry being replied to
            Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: AppRadius.borderRadiusSm,
              ),
              child: Text(
                widget.entry.content.length > 100
                    ? '${widget.entry.content.substring(0, 100)}...'
                    : widget.entry.content,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _replyController,
              maxLines: 4,
              maxLength: 500,
              autofocus: true,
              style: AppTypography.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Write your reply...',
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
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.ctaGradient,
                  borderRadius: AppRadius.borderRadiusPill,
                ),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Send Reply'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReply() async {
    final content = _replyController.text.trim();
    if (content.isEmpty) {
      context.showAppToast('Write a reply first', isError: true);
      return;
    }

    final user = ref.read(currentUserProfileProvider).valueOrNull;
    if (user == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(journalRepositoryProvider).addReply(
            journalEntryId: widget.entry.id,
            authorName: user.displayName,
            content: content,
          );
      if (mounted) {
        context.showAppToast('Reply sent! 💌');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        context.showAppToast('Failed to send reply', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
