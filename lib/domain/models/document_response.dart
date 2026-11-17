// documents_model.dart

class DocumentsResponse {
  bool? status;
  String? message;
  List<DocumentItem>? data;

  DocumentsResponse({this.status, this.message, this.data});

  DocumentsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DocumentItem>[];
      json['data'].forEach((v) {
        data!.add(DocumentItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocumentItem {
  String? id;
  String? studentId;
  String? title;
  String? filePath;
  String? createdAt;
  String? updatedAt;

  DocumentItem({
    this.id,
    this.studentId,
    this.title,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });

  DocumentItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    title = json['title'];
    filePath = json['file_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_id'] = studentId;
    data['title'] = title;
    data['file_path'] = filePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}