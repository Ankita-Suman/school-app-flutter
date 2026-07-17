class ResponseModel {
  ResponseModel({
    required this.data,
    required this.hasError,
    this.errorCode,
  });

  final dynamic data;  // ✅ dynamic - String/Map/List sab handle karega
  final bool hasError;
  final int? errorCode;
}