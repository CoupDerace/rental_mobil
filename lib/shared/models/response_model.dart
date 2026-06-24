class ResponseModel<T> {
  final bool success;

  final String message;

  final T? data;

  const ResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ResponseModel.success(T data) {
    return ResponseModel(success: true, message: '', data: data);
  }

  factory ResponseModel.error(String message) {
    return ResponseModel(success: false, message: message);
  }
}
