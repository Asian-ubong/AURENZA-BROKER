import 'app_exception.dart';

abstract final class ErrorMapper {
  static AppException map(Object error) {
    if (error is AppException) return error;

    return AppException(
      'We could not complete that request. Please try again.',
      cause: error,
    );
  }
}
