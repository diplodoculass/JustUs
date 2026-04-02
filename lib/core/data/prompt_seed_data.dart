/// Pre-seeded daily relationship prompts (first 60 of 365).
/// Organized by category for varied daily experiences.
class PromptSeedData {
  PromptSeedData._();

  static const List<Map<String, dynamic>> prompts = [
    // ─── Getting to Know ────────────────────────────────────────────────
    {'dayNumber': 1, 'question': 'What is one thing you love about our relationship that you have never told me?', 'category': 'Connection'},
    {'dayNumber': 2, 'question': 'What is a childhood memory that shaped who you are today?', 'category': 'Memories'},
    {'dayNumber': 3, 'question': 'If we could travel anywhere tomorrow, where would you want to go and why?', 'category': 'Dreams'},
    {'dayNumber': 4, 'question': 'What is the most thoughtful thing I have ever done for you?', 'category': 'Gratitude'},
    {'dayNumber': 5, 'question': 'What is a fear you have never shared with anyone?', 'category': 'Vulnerability'},
    {'dayNumber': 6, 'question': 'What does your perfect lazy Sunday with me look like?', 'category': 'Dreams'},
    {'dayNumber': 7, 'question': 'What song reminds you of us?', 'category': 'Memories'},

    // ─── Deeper Conversations ───────────────────────────────────────────
    {'dayNumber': 8, 'question': 'What is something you wish more people understood about you?', 'category': 'Vulnerability'},
    {'dayNumber': 9, 'question': 'What is the best compliment you have ever received?', 'category': 'Gratitude'},
    {'dayNumber': 10, 'question': 'How do you feel most loved by me?', 'category': 'Connection'},
    {'dayNumber': 11, 'question': 'What is a goal you are quietly working toward?', 'category': 'Growth'},
    {'dayNumber': 12, 'question': 'What moment in our relationship would you relive?', 'category': 'Memories'},
    {'dayNumber': 13, 'question': 'What small daily habit of mine makes you smile?', 'category': 'Gratitude'},
    {'dayNumber': 14, 'question': 'If you could learn any new skill together with me, what would it be?', 'category': 'Dreams'},

    // ─── Playful ────────────────────────────────────────────────────────
    {'dayNumber': 15, 'question': 'What is the funniest thing that has happened to us?', 'category': 'Fun'},
    {'dayNumber': 16, 'question': 'If you had to describe me using only three emojis, which would you pick?', 'category': 'Fun'},
    {'dayNumber': 17, 'question': 'What is your guilty pleasure that I should know about?', 'category': 'Fun'},
    {'dayNumber': 18, 'question': 'If we starred in a movie together, what genre would it be?', 'category': 'Fun'},
    {'dayNumber': 19, 'question': 'What fictional couple reminds you of us?', 'category': 'Fun'},
    {'dayNumber': 20, 'question': 'What is the most random fact you know that would impress me?', 'category': 'Fun'},
    {'dayNumber': 21, 'question': 'If you could swap lives with me for one day, what would you do first?', 'category': 'Fun'},

    // ─── Future ─────────────────────────────────────────────────────────
    {'dayNumber': 22, 'question': 'Where do you see us in five years?', 'category': 'Dreams'},
    {'dayNumber': 23, 'question': 'What kind of home do you dream of us having?', 'category': 'Dreams'},
    {'dayNumber': 24, 'question': 'What tradition would you love us to start?', 'category': 'Dreams'},
    {'dayNumber': 25, 'question': 'What adventure is on your bucket list for us?', 'category': 'Dreams'},
    {'dayNumber': 26, 'question': 'How do you want us to celebrate our next anniversary?', 'category': 'Dreams'},
    {'dayNumber': 27, 'question': 'If money was no object, what would a perfect date with me look like?', 'category': 'Dreams'},
    {'dayNumber': 28, 'question': 'What is a value you want to build our relationship around?', 'category': 'Growth'},

    // ─── Emotional Depth ────────────────────────────────────────────────
    {'dayNumber': 29, 'question': 'What is something I do that makes you feel safe?', 'category': 'Connection'},
    {'dayNumber': 30, 'question': 'What is the hardest thing about being vulnerable with someone?', 'category': 'Vulnerability'},
    {'dayNumber': 31, 'question': 'When was the last time you felt truly at peace?', 'category': 'Vulnerability'},
    {'dayNumber': 32, 'question': 'What is something you are proud of but do not talk about?', 'category': 'Growth'},
    {'dayNumber': 33, 'question': 'How has our relationship changed you for the better?', 'category': 'Growth'},
    {'dayNumber': 34, 'question': 'What does forgiveness mean to you?', 'category': 'Vulnerability'},
    {'dayNumber': 35, 'question': 'What is the best piece of advice you have ever received about love?', 'category': 'Connection'},

    // ─── Appreciation ───────────────────────────────────────────────────
    {'dayNumber': 36, 'question': 'What is one thing I do that makes your day better?', 'category': 'Gratitude'},
    {'dayNumber': 37, 'question': 'What quality of mine do you admire the most?', 'category': 'Gratitude'},
    {'dayNumber': 38, 'question': 'What is a small moment with me that you treasure?', 'category': 'Memories'},
    {'dayNumber': 39, 'question': 'When did you first realize you wanted to be with me?', 'category': 'Memories'},
    {'dayNumber': 40, 'question': 'What is something I taught you without realizing it?', 'category': 'Gratitude'},
    {'dayNumber': 41, 'question': 'What makes our relationship different from others?', 'category': 'Connection'},
    {'dayNumber': 42, 'question': 'What is the kindest thing a stranger has ever done for you?', 'category': 'Gratitude'},

    // ─── Self Discovery ─────────────────────────────────────────────────
    {'dayNumber': 43, 'question': 'What did your younger self dream about that came true?', 'category': 'Growth'},
    {'dayNumber': 44, 'question': 'What do you wish you could tell your teenage self?', 'category': 'Growth'},
    {'dayNumber': 45, 'question': 'What is a belief you held strongly but then changed your mind about?', 'category': 'Growth'},
    {'dayNumber': 46, 'question': 'What makes you feel most alive?', 'category': 'Vulnerability'},
    {'dayNumber': 47, 'question': 'What is a challenge that made you stronger?', 'category': 'Growth'},
    {'dayNumber': 48, 'question': 'What is one thing on your mind today that you want to share?', 'category': 'Connection'},
    {'dayNumber': 49, 'question': 'What is the bravest thing you have ever done?', 'category': 'Vulnerability'},

    // ─── Relationship Building ──────────────────────────────────────────
    {'dayNumber': 50, 'question': 'How can I support you better this week?', 'category': 'Connection'},
    {'dayNumber': 51, 'question': 'What is one thing we should do more of together?', 'category': 'Connection'},
    {'dayNumber': 52, 'question': 'What is your love language moment from this past week?', 'category': 'Connection'},
    {'dayNumber': 53, 'question': 'What is something new you would like to try with me?', 'category': 'Dreams'},
    {'dayNumber': 54, 'question': 'What is the most meaningful gift you have ever received?', 'category': 'Memories'},
    {'dayNumber': 55, 'question': 'What does home mean to you?', 'category': 'Vulnerability'},
    {'dayNumber': 56, 'question': 'What is one thing you never get tired of?', 'category': 'Fun'},
    {'dayNumber': 57, 'question': 'What smell or taste instantly brings back a happy memory?', 'category': 'Memories'},
    {'dayNumber': 58, 'question': 'What is the last thing that made you laugh until you cried?', 'category': 'Fun'},
    {'dayNumber': 59, 'question': 'What would your perfect morning routine with me look like?', 'category': 'Dreams'},
    {'dayNumber': 60, 'question': 'What do you hope people say about us as a couple?', 'category': 'Connection'},
  ];

  /// Get the prompt for a given day (cycles after exhausting all prompts).
  static Map<String, dynamic> getPromptForDay(int dayNumber) {
    final index = (dayNumber - 1) % prompts.length;
    return prompts[index];
  }

  /// All unique categories.
  static final categories = prompts
      .map((p) => p['category'] as String)
      .toSet()
      .toList()
    ..sort();
}
