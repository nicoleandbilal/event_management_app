/// Utility class for sanitizing and validating event IDs.
class EventIdSanitizer {
  /// Sanitizes the given [eventId] by removing invalid characters.
  /// Only alphanumeric characters, underscores (_), and hyphens (-) are allowed.
  static String sanitize(String eventId) {
    final sanitized = eventId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
    return sanitized;
  }

  /// Validates the given [eventId] to ensure it conforms to the expected format.
  /// Returns `true` if valid, `false` otherwise.
  static bool isValid(String eventId) {
    final regex = RegExp(r'^[a-zA-Z0-9_-]+$');
    return regex.hasMatch(eventId) && eventId.isNotEmpty;
  }

  /// Provides a formatted error message for an invalid event ID.
  static String invalidEventIdMessage(String eventId) {
    return 'The provided event ID "$eventId" contains invalid characters or is empty.';
  }
}
