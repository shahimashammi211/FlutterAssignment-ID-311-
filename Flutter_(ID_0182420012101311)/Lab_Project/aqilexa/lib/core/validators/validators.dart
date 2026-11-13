
class Validators {
  static String? required(
    String? value, [
    String label = 'This field',
  ]) =>
      value == null || value.trim().isEmpty
          ? '$label is required.'
          : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }

    return RegExp(r'^[^@\s]+@[^@\s]+\\.[^@\s]+$')
            .hasMatch(value.trim())
        ? null
        : 'Enter a valid email.';
  }

  static String? password(String? value) =>
      value == null || value.length < 6
          ? 'Password must be at least 6 characters.'
          : null;
}
