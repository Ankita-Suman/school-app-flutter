// staff_notice_response.dart

class StaffNoticeResponse {
  bool? status;
  String? message;
  StaffNoticeData? data;

  StaffNoticeResponse({this.status, this.message, this.data});

  StaffNoticeResponse.fromJson(Map<String, dynamic> json) {
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
  List<StaffMyNotice>? notices;
  Links? links;
  Meta? meta;
  String? tab;
  Tabs? tabs;

  StaffNoticeData({this.notices, this.links, this.meta, this.tab, this.tabs});

  StaffNoticeData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      notices = <StaffMyNotice>[];
      json['data'].forEach((v) {
        notices!.add(StaffMyNotice.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    tab = json['tab'];
    tabs = json['tabs'] != null ? Tabs.fromJson(json['tabs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notices != null) {
      data['data'] = notices!.map((v) => v.toJson()).toList();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    data['tab'] = tab;
    if (tabs != null) {
      data['tabs'] = tabs!.toJson();
    }
    return data;
  }
}

class StaffMyNotice {
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

  StaffMyNotice(
      {this.id,
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
        this.attachments});

  StaffMyNotice.fromJson(Map<String, dynamic> json) {
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

  Targets(
      {this.id,
        this.targetType,
        this.userId,
        this.userName,
        this.roleId,
        this.roleName,
        this.classId,
        this.className,
        this.sectionId,
        this.sectionName});

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

  Attachments({this.id, this.fileName, this.fileUrl, this.fileType, this.fileSize});

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

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first'] = first;
    data['last'] = last;
    data['prev'] = prev;
    data['next'] = next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<MetaLinks>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <MetaLinks>[];
      json['links'].forEach((v) {
        links!.add(MetaLinks.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['from'] = from;
    data['last_page'] = lastPage;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['path'] = path;
    data['per_page'] = perPage;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class MetaLinks {
  String? url;
  String? label;
  int? page;
  bool? active;

  MetaLinks({this.url, this.label, this.page, this.active});

  MetaLinks.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    page = json['page'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['page'] = page;
    data['active'] = active;
    return data;
  }
}

class Tabs {
  My? my;
  Other? other;

  Tabs({this.my, this.other});

  Tabs.fromJson(Map<String, dynamic> json) {
    my = json['my'] != null ? My.fromJson(json['my']) : null;
    other = json['other'] != null ? Other.fromJson(json['other']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (my != null) {
      data['my'] = my!.toJson();
    }
    if (other != null) {
      data['other'] = other!.toJson();
    }
    return data;
  }
}

class My {
  int? total;
  int? unread;

  My({this.total, this.unread});

  My.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    unread = json['unread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['unread'] = unread;
    return data;
  }
}

class Other {
  int? total;
  int? unread;

  Other({this.total, this.unread});

  Other.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    unread = json['unread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['unread'] = unread;
    return data;
  }
}