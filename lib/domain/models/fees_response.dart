// fees_response.dart
import 'dart:convert';

class FeeResponseModel {
  final bool status;
  final String message;
  final FeeData? data;

  FeeResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory FeeResponseModel.fromJson(Map<String, dynamic> json) {
    return FeeResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? FeeData.fromJson(json['data']) : null,
    );
  }

  // ADD toJson method
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class FeeData {
  final Student? student;
  final String? sessionId;
  final Cards? cards;
  final GrandTotal? grandTotal;
  final List<Invoice>? invoices;

  FeeData({
    this.student,
    this.sessionId,
    this.cards,
    this.grandTotal,
    this.invoices,
  });

  factory FeeData.fromJson(Map<String, dynamic> json) {
    return FeeData(
      student: json['student'] != null ? Student.fromJson(json['student']) : null,
      sessionId: json['session_id']?.toString() ?? '',
      cards: json['cards'] != null ? Cards.fromJson(json['cards']) : null,
      grandTotal: json['grand_total'] != null ? GrandTotal.fromJson(json['grand_total']) : null,
      invoices: json['invoices'] != null
          ? (json['invoices'] as List).map((e) => Invoice.fromJson(e)).toList()
          : [],
    );
  }

  // ADD toJson method
  Map<String, dynamic> toJson() {
    return {
      'student': student?.toJson(),
      'session_id': sessionId,
      'cards': cards?.toJson(),
      'grand_total': grandTotal?.toJson(),
      'invoices': invoices?.map((e) => e.toJson()).toList(),
    };
  }
}

class Student {
  final String? id;
  final String? registrationNumber;
  final String? admissionNumber;
  final String? firstName;
  final String? lastName;
  final String? rollNumber;

  Student({
    this.id,
    this.registrationNumber,
    this.admissionNumber,
    this.firstName,
    this.lastName,
    this.rollNumber,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString(),
      registrationNumber: json['registration_number']?.toString() ?? '',
      admissionNumber: json['admission_number']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      rollNumber: json['roll_number']?.toString() ?? '',
    );
  }

  // ADD toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registration_number': registrationNumber,
      'admission_number': admissionNumber,
      'first_name': firstName,
      'last_name': lastName,
      'roll_number': rollNumber,
    };
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}

class Cards {
  final int? totalDue;
  final int? paid;
  final int? pending;

  Cards({
    this.totalDue,
    this.paid,
    this.pending,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      totalDue: json['total_due'] as int? ?? 0,
      paid: json['paid'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
    );
  }

  // ADD toJson method
  Map<String, dynamic> toJson() {
    return {
      'total_due': totalDue,
      'paid': paid,
      'pending': pending,
    };
  }
}

class GrandTotal {
  final int? amount;
  final int? discount;
  final int? fine;
  final int? paid;
  final int? balance;

  GrandTotal({
    this.amount,
    this.discount,
    this.fine,
    this.paid,
    this.balance,
  });

  factory GrandTotal.fromJson(Map<String, dynamic> json) {
    return GrandTotal(
      amount: json['amount'] as int? ?? 0,
      discount: json['discount'] as int? ?? 0,
      fine: json['fine'] as int? ?? 0,
      paid: json['paid'] as int? ?? 0,
      balance: json['balance'] as int? ?? 0,
    );
  }

  // ADD toJson method
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'discount': discount,
      'fine': fine,
      'paid': paid,
      'balance': balance,
    };
  }
}

class Invoice {
  final String? id;
  final String? invoiceNumber;
  final String? invoicePeriod;
  final String? invoiceType;
  final String? dueDate;
  final String? invoiceDate;
  final String? status;
  final bool? isPayable;
  final int? grossAmount;
  final int? discountAmount;
  final int? netAmount;
  final int? paidAmount;
  final int? pendingAmount;
  final List<InvoiceItem>? items;

  Invoice({
    this.id,
    this.invoiceNumber,
    this.invoicePeriod,
    this.invoiceType,
    this.dueDate,
    this.invoiceDate,
    this.status,
    this.isPayable,
    this.grossAmount,
    this.discountAmount,
    this.netAmount,
    this.paidAmount,
    this.pendingAmount,
    this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id']?.toString(),
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      invoicePeriod: json['invoice_period']?.toString() ?? '',
      invoiceType: json['invoice_type']?.toString() ?? '',
      dueDate: json['due_date']?.toString() ?? '',
      invoiceDate: json['invoice_date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      isPayable: json['is_payable'] as bool? ?? false,
      grossAmount: json['gross_amount'] as int? ?? 0,
      discountAmount: json['discount_amount'] as int? ?? 0,
      netAmount: json['net_amount'] as int? ?? 0,
      paidAmount: json['paid_amount'] as int? ?? 0,
      pendingAmount: json['pending_amount'] as int? ?? 0,
      items: json['items'] != null
          ? (json['items'] as List).map((e) => InvoiceItem.fromJson(e)).toList()
          : [],
    );
  }

  // ADD toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'invoice_period': invoicePeriod,
      'invoice_type': invoiceType,
      'due_date': dueDate,
      'invoice_date': invoiceDate,
      'status': status,
      'is_payable': isPayable,
      'gross_amount': grossAmount,
      'discount_amount': discountAmount,
      'net_amount': netAmount,
      'paid_amount': paidAmount,
      'pending_amount': pendingAmount,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}

class InvoiceItem {
  final String? id;
  final String? feeTitle;
  final String? feeType;
  final int? finalAmount;
  final int? paidAmount;
  final int? pendingAmount;

  InvoiceItem({
    this.id,
    this.feeTitle,
    this.feeType,
    this.finalAmount,
    this.paidAmount,
    this.pendingAmount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id']?.toString(),
      feeTitle: json['fee_title']?.toString() ?? '',
      feeType: json['fee_type']?.toString() ?? '',
      finalAmount: json['final_amount'] as int? ?? 0,
      paidAmount: json['paid_amount'] as int? ?? 0,
      pendingAmount: json['pending_amount'] as int? ?? 0,
    );
  }

  // ADD toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fee_title': feeTitle,
      'fee_type': feeType,
      'final_amount': finalAmount,
      'paid_amount': paidAmount,
      'pending_amount': pendingAmount,
    };
  }
}

FeeResponseModel feeResponseFromJson(String str) =>
    FeeResponseModel.fromJson(json.decode(str) as Map<String, dynamic>);

String feeResponseToJson(FeeResponseModel data) => json.encode(data.toJson());