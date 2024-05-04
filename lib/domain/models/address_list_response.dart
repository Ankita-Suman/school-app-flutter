import 'dart:convert';

AddressListResponse addressResponseFromJson(String str) =>
    AddressListResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String addressResponseToJson(AddressListResponse data) =>
    json.encode(data.toJson());

class AddressListResponse {
  AddressListResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory AddressListResponse.fromJson(Map<String, dynamic> json) =>
      AddressListResponse(
        statusCode: json['statusCode'] as int? ?? 0,
        message: json['message'] as String? ?? '',
        data: json['data']['rows'] != null
            ? List<AddressListData>.from(
            (json['data']['rows'] as List<dynamic>? ?? <dynamic>[]).map<dynamic>(
                    (dynamic x) =>
                        AddressListData.fromJson(x as Map<String, dynamic>)))
            : [],

      );

  int? statusCode;
  String? message;
  List<AddressListData>? data;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'statusCode': statusCode,
    'message': message,
    'data': data,
  };
}

class AddressListData {
  factory AddressListData.fromJson(Map<String, dynamic> json) => AddressListData(
    title: json['title'] as String? ?? '',
    id: json['id'] as String? ?? '',
    location: json['location'] as String? ?? '',
    countryCode: json['countryCode'] as String? ?? '',
    landmark: json['landmark'] as String? ?? '',
    floor: json['floor'] as String? ?? '',
    latitude: json['latitude'] as String? ?? '',
    longitude: json['longitude'] as String? ?? '',
    isSelected: json['isSelected'] as bool? ?? false,
  );

  AddressListData({
    this.title,
    this.id,
    this.location,
    this.countryCode,
    this.landmark,
    this.floor,
    this.latitude,
    this.longitude,
    this.isSelected,
  });
  String? title;
  String? id;
  bool? isSelected;
  String? location;
  String? countryCode;
  String? landmark;
  String? floor;
  String? latitude;
  String? longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'title': title,
    'id': id,
    'location': location,
    'countryCode': countryCode,
    'landmark': landmark,
    'floor': floor,
    'latitude': latitude,
    'longitude': longitude,
    'isSelected': isSelected,
  };
}
