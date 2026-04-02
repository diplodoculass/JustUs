/// App-wide constants for the JustUs relationship wellness app.
class AppConstants {
  AppConstants._();

  // ─── App Identity ───────────────────────────────────────────────────
  static const appName = 'JustUs';
  static const appTagline = 'Your relationship, reimagined.';

  // ─── Firestore Collection Names ─────────────────────────────────────
  static const usersCollection = 'users';
  static const couplesCollection = 'couples';
  static const promptsCollection = 'prompts';
  static const promptResponsesCollection = 'promptResponses';
  static const journalEntriesCollection = 'journalEntries';
  static const journalRepliesCollection = 'journalReplies';
  static const memoriesCollection = 'memories';
  static const milestonesCollection = 'milestones';
  static const dateIdeasCollection = 'dateIdeas';
  static const checkInsCollection = 'checkIns';
  static const challengesCollection = 'challenges';
  static const coupleChallengesCollection = 'coupleChallenges';
  static const thisOrThatQuestionsCollection = 'thisOrThatQuestions';
  static const thisOrThatResponsesCollection = 'thisOrThatResponses';
  static const thumbKissesCollection = 'thumbKisses';
  static const notesCollection = 'notes';
  static const inviteCodesCollection = 'inviteCodes';
  static const notificationsCollection = 'notifications';

  // ─── Limits ─────────────────────────────────────────────────────────
  static const maxNoteLength = 200;
  static const maxNotesPerHour = 10;
  static const maxImageSizeMb = 5;
  static const maxImageSizeBytes = maxImageSizeMb * 1024 * 1024;
  static const inviteCodeLength = 6;
  static const inviteCodeExpiryHours = 48;

  // ─── Streak ─────────────────────────────────────────────────────────
  static const streakFreezePerWeek = 1;
  static const streakMilestones = [7, 14, 30, 60, 100, 200, 365];

  // ─── Love Language ──────────────────────────────────────────────────
  static const loveLanguageQuizQuestions = 30;
  static const loveLanguageQuestionsPerType = 5;
  static const loveLanguages = [
    'Words of Affirmation',
    'Acts of Service',
    'Receiving Gifts',
    'Quality Time',
    'Physical Touch',
  ];

  // ─── Check-In ───────────────────────────────────────────────────────
  static const checkInCategories = [
    'Connection',
    'Communication',
    'Fun',
    'Intimacy',
  ];
  static const checkInMinScore = 1;
  static const checkInMaxScore = 10;

  // ─── Journal Moods ──────────────────────────────────────────────────
  static const journalMoods = [
    'Happy',
    'Grateful',
    'Reflective',
    'Tender',
    'Playful',
    'Vulnerable',
  ];

  // ─── Date Idea Categories ───────────────────────────────────────────
  static const dateIdeaCategories = [
    'At Home',
    'Going Out',
    'Adventure',
    'Virtual',
    'Surprise Me',
  ];

  // ─── Notification Types ─────────────────────────────────────────────
  static const notifStreakReminder = 'streak_reminder';
  static const notifThumbKiss = 'thumb_kiss';
  static const notifPartnerPrompt = 'partner_prompt';
  static const notifPartnerJournal = 'partner_journal';
  static const notifMilestone = 'milestone';
  static const notifCheckInReminder = 'check_in_reminder';
  static const notifNoteReceived = 'note_received';
  static const notifChallengeTask = 'challenge_task';

  // ─── Timing ─────────────────────────────────────────────────────────
  static const dailyReminderHour = 20; // 8 PM
  static const weeklyCheckInDay = DateTime.sunday;
  static const weeklyCheckInHour = 10; // 10 AM
  static const milestoneReminderDaysBefore = 3;

  // ─── Animation Durations ────────────────────────────────────────────
  static const animFast = Duration(milliseconds: 200);
  static const animMedium = Duration(milliseconds: 400);
  static const animSlow = Duration(milliseconds: 600);
  static const animPageTransition = Duration(milliseconds: 300);
  static const animStaggerDelay = Duration(milliseconds: 80);

  // ─── Storage Paths ──────────────────────────────────────────────────
  static const avatarStoragePath = 'avatars';
  static const journalPhotosStoragePath = 'journal_photos';
  static const memoryPhotosStoragePath = 'memory_photos';
}
