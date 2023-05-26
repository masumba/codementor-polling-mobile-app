class ApiPayload<T> {
  T? payload;
  String? message;
  bool success;

  ApiPayload({this.payload, this.message, this.success = true});

  factory ApiPayload.fromJson(Map<String, dynamic> data) => ApiPayload(
        payload: data["payload"],
        message: data["message"] ??
            'Something went wrong. Please try again at a later time.',
        success: data["success"] ?? false,
      );

  Map<String, dynamic> toJson() {
    return {
      'payload': payload,
      'message': message,
      'success': success,
    };
  }

  @override
  String toString() {
    return 'ApiPayload{payload: $payload, message: $message, success: $success}';
  }
}
