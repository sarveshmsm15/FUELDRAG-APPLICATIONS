import '../errors/failures.dart';


sealed class Result<T> {
  const Result();

  /// Whether this result is a success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result is a failure.
  bool get isFailure => this is FailureResult<T>;

  /// Get the success value or throw.
  T getOrThrow() {
    return switch (this) {
      Success<T>() => (this as Success<T>).data,
      FailureResult<T>() => throw (this as FailureResult<T>).failure,
    };
  }

  /// Get the success value or return a default.
  T getOrDefault(T defaultValue) {
    return switch (this) {
      Success<T>() => (this as Success<T>).data,
      FailureResult<T>() => defaultValue,
    };
  }

  /// Map the success value.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>() => Success(transform((this as Success<T>).data)),
      FailureResult<T>() => FailureResult((this as FailureResult<T>).failure),
    };
  }

  /// Execute side effects based on result.
  void when({
    required void Function(T data) onSuccess,
    required void Function(Failure failure) onFailure,
  }) {
    switch (this) {
      case Success<T>():
        onSuccess((this as Success<T>).data);
      case FailureResult<T>():
        onFailure((this as FailureResult<T>).failure);
    }
  }

  /// Fold into a single value.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>() => onSuccess((this as Success<T>).data),
      FailureResult<T>() => onFailure((this as FailureResult<T>).failure),
    };
  }
}

/// Successful result containing data.
class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;

  @override
  String toString() => 'Success($data)';
}

/// Failed result containing a Failure.
class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;

  @override
  String toString() => 'Failure(${failure.code}: ${failure.message})';
}

/// Convenience constructors.
Result<T> success<T>(T data) => Success(data);
Result<T> failure<T>(Failure fail) => FailureResult(fail);