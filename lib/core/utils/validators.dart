/// Validators for all form inputs across the app.
/// Every field is validated inline before submission — never silent.
class Validators {
  Validators._();

  /// Email validation with regex
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Password must be at least 8 characters with 1 letter and 1 number
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Confirm password matches
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != password) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  /// Name — required, 2-50 chars
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  /// Required field
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Invite code — exactly 6 alphanumeric characters
  static String? inviteCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invite code is required';
    }
    if (value.trim().length != 6) {
      return 'Invite code must be exactly 6 characters';
    }
    if (!RegExp(r'^[A-Za-z0-9]{6}$').hasMatch(value.trim())) {
      return 'Invite code must be alphanumeric';
    }
    return null;
  }

  /// Note body — max 200 characters
  static String? noteBody(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Note cannot be empty';
    }
    if (value.trim().length > 200) {
      return 'Note must be less than 200 characters';
    }
    return null;
  }

  /// Journal title — optional but max 100 chars if provided
  static String? journalTitle(String? value) {
    if (value != null && value.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  /// Journal body — required
  static String? journalBody(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Journal entry cannot be empty';
    }
    return null;
  }

  /// Delete confirmation — must type "DELETE"
  static String? deleteConfirmation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Type DELETE to confirm';
    }
    if (value.trim() != 'DELETE') {
      return 'Type DELETE exactly to confirm';
    }
    return null;
  }

  /// Sanitize text input — strip potential injection
  static String sanitize(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Strip HTML tags
        .replaceAll(RegExp(r'''[<>"']'''), '') // Strip dangerous chars
        .trim();
  }
}
