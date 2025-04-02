sealed class Result {
  const Result();
}

class NoneState extends Result {}

class LoadingState extends Result {}

class SuccessState<S> extends Result {
  final S data;
  const SuccessState(this.data);
}

class ErrorState<S> extends Result {
  final String error;
  const ErrorState(this.error);
}
