// staff_other_announcement_response.dart

class StaffOtherNoticeResponse {
  bool? status;
  String? message;
  StaffNoticeData? data;

  StaffOtherNoticeResponse({this.status, this.message, this.data});

  StaffOtherNoticeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? StaffNoticeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StaffNoticeData {
  String? tab;
  int? total;
  int? unread;
  List<StaffNotice>? notices;

  StaffNoticeData({this.tab, this.total, this.unread, this.notices});

  StaffNoticeData.fromJson(Map<String, dynamic> json) {
    tab = json['tab'];
    total = json['total'];
    unread = json['unread'];

    // ✅ FIX: पहले 'notices' चेक करें (जैसा Postman में है), अगर नहीं मिले तो 'data' चेक करें
    if (json['notices'] != null) {
      notices = <StaffNotice>[];
      json['notices'].forEach((v) {
        notices!.add(StaffNotice.fromJson(v));
      });
    } else if (json['data'] != null) {
      notices = <StaffNotice>[];
      json['data'].forEach((v) {
        notices!.add(StaffNotice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tab'] = tab;
    data['total'] = total;
    data['unread'] = unread;
    if (notices != null) {
      // toJson में हम इसे 'notices' के रूप में भेजेंगे
      data['notices'] = notices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffNotice {
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
  List<Targets>? targets;
  List<Attachments>? attachments;

  StaffNotice({
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
    this.targets,
    this.attachments,
  });

  StaffNotice.fromJson(Map<String, dynamic> json) {
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

    if (json['targets'] != null) {
      targets = <Targets>[];
      json['targets'].forEach((v) {
        targets!.add(Targets.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
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
    if (targets != null) {
      data['targets'] = targets!.map((v) => v.toJson()).toList();
    }
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Targets {
  String? id;
  String? targetType;
  String? userId;
  String? userName;
  String? roleId;
  String? roleName;
  String? classId;
  String? className;
  String? sectionId;
  String? sectionName;

  Targets({
    this.id,
    this.targetType,
    this.userId,
    this.userName,
    this.roleId,
    this.roleName,
    this.classId,
    this.className,
    this.sectionId,
    this.sectionName,
  });

  Targets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    targetType = json['target_type'];
    userId = json['user_id'];
    userName = json['user_name'];
    roleId = json['role_id'];
    roleName = json['role_name'];
    classId = json['class_id'];
    className = json['class_name'];
    sectionId = json['section_id'];
    sectionName = json['section_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['target_type'] = targetType;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['role_id'] = roleId;
    data['role_name'] = roleName;
    data['class_id'] = classId;
    data['class_name'] = className;
    data['section_id'] = sectionId;
    data['section_name'] = sectionName;
    return data;
  }
}

class Attachments {
  String? id;
  String? fileName;
  String? fileUrl;
  String? fileType;
  int? fileSize;

  Attachments({
    this.id,
    this.fileName,
    this.fileUrl,
    this.fileType,
    this.fileSize,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
    fileType = json['file_type'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file_name'] = fileName;
    data['file_url'] = fileUrl;
    data['file_type'] = fileType;
    data['file_size'] = fileSize;
    return data;
  }
}