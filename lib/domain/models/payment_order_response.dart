// domain/models/payment_order_response.dart
import 'dart:convert';

// ============================================================
// ✅ ROOT RESPONSE
// ============================================================
class PaymentOrderResponse {
  final bool status;
  final String message;
  final PaymentOrderData? data;

  PaymentOrderResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaymentOrderResponse.fromJson(Map<String, dynamic> json) {
    return PaymentOrderResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? PaymentOrderData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

// ============================================================
// ✅ DATA (order + gateway + student)
// ============================================================
class PaymentOrderData {
  final String gateway;
  final String orderId;

  /// API देता है int (paise में), पर हम double रखते हैं flexibility के लिए
  final double amount;
  final String currency;
  final String paymentUrl;
  final PaymentOrderStudent? student;

  PaymentOrderData({
    required this.gateway,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentUrl,
    this.student,
  });

  factory PaymentOrderData.fromJson(Map<String, dynamic> json) {
    return PaymentOrderData(
      gateway: json['gateway']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      currency: json['currency']?.toString() ?? 'INR',
      paymentUrl: json['payment_url']?.toString() ?? '',
      student: json['student'] != null
          ? PaymentOrderStudent.fromJson(
          json['student'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'gateway': gateway,
    'order_id': orderId,
    'amount': amount,
    'currency': currency,
    'payment_url': paymentUrl,
    'student': student?.toJson(),
  };

  /// ✅ Convenience — amount रुपयों में (paise ÷ 100)
  ///    उदाहरण: 155500 → 1555.00
  double get amountInRupees => amount / 100;

  /// ✅ Convenience — formatted string "₹1,555.00"
  String get amountFormatted {
    final rupees = amountInRupees;
    final parts = rupees.toStringAsFixed(2).split('.');
    // हजार separator
    final intPart = parts[0];
    final buffer = StringBuffer();
    final len = intPart.length;
    for (int i = 0; i < len; i++) {
      if (i != 0 && (len - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return '₹$buffer.${parts[1]}';
  }
}

// ============================================================
// ✅ STUDENT (id + name)
// ============================================================
class PaymentOrderStudent {
  final String id;
  final String name;

  PaymentOrderStudent({
    required this.id,
    required this.name,
  });

  factory PaymentOrderStudent.fromJson(Map<String, dynamic> json) {
    return PaymentOrderStudent(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

// ============================================================
// ✅ Safe number parser (String / int / double — सब handle)
// ============================================================
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// ============================================================
// ✅ Helper — full response को JSON string में (save/load के लिए)
// ============================================================
String paymentOrderResponseToJson(PaymentOrderResponse response) {
  return jsonEncode(response.toJson());
}

// ============================================================
// ✅ Helper — JSON string से direct parse
// ============================================================
PaymentOrderResponse paymentOrderResponseFromJson(String jsonString) {
  return PaymentOrderResponse.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>);
}