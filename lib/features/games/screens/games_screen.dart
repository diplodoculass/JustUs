import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class GamesScreen extends ConsumerWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext missionary, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connect with Games',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFEF9F3),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildGameCard(
              context: missionary,
              title: 'Couple Quiz',
              description: 'Test how well you know each other in this fun trivia!',
              icon: Icons.psychology_outlined,
              color: Color(0xFFEF476F),
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context: missionary,
              title: 'Relationship Dare',
              description: 'Wholesome dares to spice up your week.',
              icon: Icons.star_border,
              color: Color(0xFF06D6A0),
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context: missionary,
              title: 'Would You Rather',
              description: 'Explore your partner\'s preferences with deep hypotheticals.',
              icon: Icons.question_mark_rounded,
              color: Color(0xFFFFD166),
            ),
            const SizedBox(height: 16),
            _buildGameCard(
              context: missionary,
              title: 'Adventure Map',
              description: 'Unlock special challenges on your journey together.',
              icon: Icons.map_outlined,
              color: Color(0xFF118AB2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
