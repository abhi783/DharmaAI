import 'future_provider_interface.dart';

/// AIProvider is the abstract contract used by the UI layer. It wraps the lower
/// level FutureProviderInterface and exposes lightweight helpers and metadata.
abstract class AIProvider implements FutureProviderInterface {
  /// Optional description for debugging
  String get description;

  /// Friendly name for the assistant when speaking from this provider (eg. Dharma)
  String get assistantName;
}
