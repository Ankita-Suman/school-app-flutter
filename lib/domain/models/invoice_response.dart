// domain/models/invoice_response.dart
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

class InvoiceResponseModel {
  final bool status;
  final String message;
  final InvoiceData? data;

  InvoiceResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    return InvoiceResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? InvoiceData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class InvoiceData {
  final Invoice? invoice;
  final StudentInfo? student;
  final List<FeeItem>? feeItems;
  final Summary? summary;
  final List<PaymentHistory>? paymentHistory;
  final String? downloadUrl; // ✅ Added download_url field
  final String? warning;

  InvoiceData({
    this.invoice,
    this.student,
    this.feeItems,
    this.summary,
    this.paymentHistory,
    this.downloadUrl, // ✅ Added
    this.warning,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      invoice: json['invoice'] != null ? Invoice.fromJson(json['invoice'] as Map<String, dynamic>) : null,
      student: json['student'] != null ? StudentInfo.fromJson(json['student'] as Map<String, dynamic>) : null,
      feeItems: json['fee_items'] != null
          ? (json['fee_items'] as List).map((e) => FeeItem.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      summary: json['summary'] != null ? Summary.fromJson(json['summary'] as Map<String, dynamic>) : null,
      paymentHistory: json['payment_history'] != null
          ? (json['payment_history'] as List).map((e) => PaymentHistory.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      downloadUrl: json['download_url'] as String?, // ✅ Added
      warning: json['warning'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice': invoice?.toJson(),
      'student': student?.toJson(),
      'fee_items': feeItems?.map((e) => e.toJson()).toList(),
      'summary': summary?.toJson(),
      'payment_history': paymentHistory?.map((e) => e.toJson()).toList(),
      'download_url': downloadUrl, // ✅ Added
      'warning': warning,
    };
  }

  // ✅ Helper getter to check if download URL exists
  bool get hasDownloadUrl => downloadUrl != null && downloadUrl!.isNotEmpty;
}

class Invoice {
  final String? id;
  final String? invoiceNumber;
  final String? invoicePeriod;
  final String? invoiceType;
  final String? invoiceDate;
  final String? dueDate;
  final String? status;
  final bool? isOverdue;
  final bool? isPayable;

  Invoice({
    this.id,
    this.invoiceNumber,
    this.invoicePeriod,
    this.invoiceType,
    this.invoiceDate,
    this.dueDate,
    this.status,
    this.isOverdue,
    this.isPayable,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String?,
      invoiceNumber: json['invoice_number'] as String?,
      invoicePeriod: json['invoice_period'] as String?,
      invoiceType: json['invoice_type'] as String?,
      invoiceDate: json['invoice_date'] as String?,
      dueDate: json['due_date'] as String?,
      status: json['status'] as String?,
      isOverdue: json['is_overdue'] as bool? ?? false,
      isPayable: json['is_payable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'invoice_period': invoicePeriod,
      'invoice_type': invoiceType,
      'invoice_date': invoiceDate,
      'due_date': dueDate,
      'status': status,
      'is_overdue': isOverdue,
      'is_payable': isPayable,
    };
  }

  // Helper getters
  bool get isPartial => status?.toUpperCase() == 'PARTIAL';
  bool get isPaid => status?.toUpperCase() == 'PAID';
  bool get isUpcoming => status?.toUpperCase() == 'UPCOMING';
  bool get isOverdueStatus => isOverdue ?? false;

  Color get statusColor {
    switch (status?.toUpperCase()) {
      case 'PAID':
        return Colors.green;
      case 'PARTIAL':
        return Colors.orange;
      case 'UPCOMING':
        return Colors.blue;
      case 'OVERDUE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class StudentInfo {
  final String? id;
  final String? name;
  final String? className;
  final String? section;
  final String? rollNumber;
  final String? admissionNumber;
  final String? session;

  StudentInfo({
    this.id,
    this.name,
    this.className,
    this.section,
    this.rollNumber,
    this.admissionNumber,
    this.session,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'] as String?,
      name: json['name'] as String?,
      className: json['class'] as String?,
      section: json['section'] as String?,
      rollNumber: json['roll_number'] as String?,
      admissionNumber: json['admission_number'] as String?,
      session: json['session'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'class': className,
      'section': section,
      'roll_number': rollNumber,
      'admission_number': admissionNumber,
      'session': session,
    };
  }

  String get fullName => name ?? '';
  String get classWithSection => '${className ?? ''} ${section ?? ''}'.trim();
  String get fullAddress => 'Roll No: ${rollNumber ?? 'N/A'} | Admission: ${admissionNumber ?? 'N/A'}';

  // ✅ Helper to get initials
  String get initials {
    if (name == null || name!.isEmpty) return 'S';
    final names = name!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }
}

class FeeItem {
  final String? id;
  final String? feeTitle;
  final String? feeType;
  final int? baseAmount;
  final int? waiverAmount;
  final int? finalAmount;
  final int? paidAmount;
  final int? pendingAmount;

  FeeItem({
    this.id,
    this.feeTitle,
    this.feeType,
    this.baseAmount,
    this.waiverAmount,
    this.finalAmount,
    this.paidAmount,
    this.pendingAmount,
  });

  factory FeeItem.fromJson(Map<String, dynamic> json) {
    return FeeItem(
      id: json['id'] as String?,
      feeTitle: json['fee_title'] as String?,
      feeType: json['fee_type'] as String?,
      baseAmount: json['base_amount'] as int? ?? 0,
      waiverAmount: json['waiver_amount'] as int? ?? 0,
      finalAmount: json['final_amount'] as int? ?? 0,
      paidAmount: json['paid_amount'] as int? ?? 0,
      pendingAmount: json['pending_amount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fee_title': feeTitle,
      'fee_type': feeType,
      'base_amount': baseAmount,
      'waiver_amount': waiverAmount,
      'final_amount': finalAmount,
      'paid_amount': paidAmount,
      'pending_amount': pendingAmount,
    };
  }

  // Helper getters
  bool get isLateFine => feeType?.toUpperCase() == 'LATE_FINE';
  bool get isGeneral => feeType?.toUpperCase() == 'GENERAL';
  bool get isFullyPaid => (pendingAmount ?? 0) == 0;
  bool get isUnpaid => (paidAmount ?? 0) == 0;
  bool get hasWaiver => (waiverAmount ?? 0) > 0;
  bool get hasPending => (pendingAmount ?? 0) > 0;

  String get formattedBaseAmount => '₹${baseAmount ?? 0}';
  String get formattedFinalAmount => '₹${finalAmount ?? 0}';
  String get formattedPaidAmount => '₹${paidAmount ?? 0}';
  String get formattedPendingAmount => '₹${pendingAmount ?? 0}';
}

class Summary {
  final int? grossAmount;
  final int? discountAmount;
  final int? netAmount;
  final int? paidAmount;
  final int? pendingAmount;

  Summary({
    this.grossAmount,
    this.discountAmount,
    this.netAmount,
    this.paidAmount,
    this.pendingAmount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      grossAmount: json['gross_amount'] as int? ?? 0,
      discountAmount: json['discount_amount'] as int? ?? 0,
      netAmount: json['net_amount'] as int? ?? 0,
      paidAmount: json['paid_amount'] as int? ?? 0,
      pendingAmount: json['pending_amount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gross_amount': grossAmount,
      'discount_amount': discountAmount,
      'net_amount': netAmount,
      'paid_amount': paidAmount,
      'pending_amount': pendingAmount,
    };
  }

  // Helper getters
  String get formattedGrossAmount => '₹${grossAmount ?? 0}';
  String get formattedDiscountAmount => '₹${discountAmount ?? 0}';
  String get formattedNetAmount => '₹${netAmount ?? 0}';
  String get formattedPaidAmount => '₹${paidAmount ?? 0}';
  String get formattedPendingAmount => '₹${pendingAmount ?? 0}';

  bool get hasDiscount => (discountAmount ?? 0) > 0;
  bool get isFullyPaid => (pendingAmount ?? 0) == 0;
  double get paymentPercentage => (paidAmount ?? 0) / (netAmount ?? 1);

  int get totalAmount => grossAmount ?? 0;
  int get totalPaid => paidAmount ?? 0;
  int get totalPending => pendingAmount ?? 0;
}

class PaymentHistory {
  final String? id;
  final String? receiptNumber;
  final String? collectionDate;
  final int? amountCollected;
  final String? collectionMode;
  final String? receiptDownloadUrl;

  PaymentHistory({
    this.id,
    this.receiptNumber,
    this.collectionDate,
    this.amountCollected,
    this.collectionMode,
    this.receiptDownloadUrl,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'] as String?,
      receiptNumber: json['receipt_number'] as String?,
      collectionDate: json['collection_date'] as String?,
      amountCollected: json['amount_collected'] as int? ?? 0,
      collectionMode: json['collection_mode'] as String?,
      receiptDownloadUrl: json['receipt_download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receipt_number': receiptNumber,
      'collection_date': collectionDate,
      'amount_collected': amountCollected,
      'collection_mode': collectionMode,
      'receipt_download_url': receiptDownloadUrl,
    };
  }

  // Helper getters
  String get formattedAmount => '₹${amountCollected ?? 0}';
  String get formattedDate => collectionDate ?? '';

  bool get isCash => collectionMode?.toUpperCase() == 'CASH';
  bool get isOnline => collectionMode?.toUpperCase() == 'ONLINE';
  bool get isCheque => collectionMode?.toUpperCase() == 'CHEQUE';

  bool get hasReceiptUrl => receiptDownloadUrl != null && receiptDownloadUrl!.isNotEmpty;

  Color get modeColor {
    if (isCash) return Colors.green;
    if (isOnline) return Colors.blue;
    if (isCheque) return Colors.orange;
    return Colors.grey;
  }

  IconData get modeIcon {
    if (isCash) return Icons.money;
    if (isOnline) return Icons.wifi;
    if (isCheque) return Icons.receipt;
    return Icons.payment;
  }
}

// Extension for number formatting
extension NumberFormattingExt on int {
  String get toPriceString {
    return toString();
  }

  String get toFormattedPrice {
    if (this >= 100000) {
      return '${(this / 100000).toStringAsFixed(1)}L';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  String get toCurrency {
    return '₹${toString()}';
  }
}

// Helper function to parse JSON string
InvoiceResponseModel invoiceResponseFromJson(String str) =>
    InvoiceResponseModel.fromJson(json.decode(str) as Map<String, dynamic>);

String invoiceResponseToJson(InvoiceResponseModel data) => json.encode(data.toJson());