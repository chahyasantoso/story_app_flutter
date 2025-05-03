sealed class ResultState {}

class ResultNone extends ResultState {}

class ResultLoading extends ResultState {}

class ResultSuccess<T> extends ResultState {
  final T data;
  final String? message;
  ResultSuccess({required this.data, this.message});
}

class ResultError extends ResultState {
  final Object error;
  final String? message;
  ResultError({required this.error, this.message});
}
