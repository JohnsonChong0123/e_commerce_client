class ValidationUtils {
  /// Matches standard email addresses like example@domain.com
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Matches Malaysian phone numbers:
  /// - 01X-XXXXXXX or 01X-XXXXXXXX (mobile)
  /// - Optional country code +6
  ///
  /// Valid examples:
  /// - 012-3456789
  /// - +6012-3456789
  /// - 0123456789
  /// - 011-12345678
  static final RegExp _phoneRegExp = RegExp(
    r'^(\+?6?01)[02-46-9]-*[0-9]{7}$|^(\+?6?01)[1]-*[0-9]{8}$',
  );

  static bool isValidEmail(String email) => _emailRegExp.hasMatch(email);

  static bool isValidPhone(String phone) => _phoneRegExp.hasMatch(phone);
}
