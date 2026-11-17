class StudentNoticeResponse {
  bool? status;
  String? message;
  List<StudentNotice>? data;

  StudentNoticeResponse({this.status, this.message, this.data});

  StudentNoticeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StudentNotice>[];
      json['data'].forEach((v) {
        data!.add(StudentNotice.fromJson(v));
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

class StudentNotice {
  String? id;
  String? title;
  String? message;
  String? noticeDate;
  String? publishOn;
  String? expiryDate;
  String? attachment;
  String? noticeType;
  bool? isActive;
  String? status;
  bool? isRead;
  int? readCount;
  String? createdBy;
  String? createdByName;
  String? createdAt;
  List<dynamic>? attachments;

  StudentNotice({
    this.id,
    this.title,
    this.message,
    this.noticeDate,
    this.publishOn,
    this.expiryDate,
    this.attachment,
    this.noticeType,
    this.isActive,
    this.status,
    this.isRead,
    this.readCount,
    this.createdBy,
    this.createdByName,
    this.createdAt,
    this.attachments,
  });

  StudentNotice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    noticeDate = json['notice_date'];
    publishOn = json['publish_on'];
    expiryDate = json['expiry_date'];
    attachment = json['attachment'];
    noticeType = json['notice_type'];
    isActive = json['is_active'];
    status = json['status'];
    isRead = json['is_read'];
    readCount = json['read_count'];
    createdBy = json['created_by'];
    createdByName = json['created_by_name'];
    createdAt = json['created_at'];
    attachments = json['attachments'] != null ? json['attachments'] : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['message'] = message;
    data['notice_date'] = noticeDate;
    data['publish_on'] = publishOn;
    data['expiry_date'] = expiryDate;
    data['attachment'] = attachment;
    data['notice_type'] = noticeType;
    data['is_active'] = isActive;
    data['status'] = status;
    data['is_read'] = isRead;
    data['read_count'] = readCount;
    data['created_by'] = createdBy;
    data['created_by_name'] = createdByName;
    data['created_at'] = createdAt;
    data['attachments'] = attachments;
    return data;
  }
}