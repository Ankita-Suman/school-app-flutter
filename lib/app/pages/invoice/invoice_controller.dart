// app/pages/invoice/invoice_controller.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:school_app/app/pages/invoice/invoice_presenter.dart';
import '../../../device/device_constants.dart';
import '../../../device/repositories/device_repositories.dart';
import '../../../domain/models/invoice_response.dart';

class InvoiceController extends GetxController {
  final InvoicePresenter invoicePresenter;

  var invoiceData = Rxn<InvoiceResponseModel>();
  var errorMessage = Rxn<String>();
  String invoiceId = '';

  InvoiceController(this.invoicePresenter);

  @override
  void onInit() {
    super.onInit();
    _getInvoiceIdAndFetchData();
  }

  void _getInvoiceIdAndFetchData() {
    try {
      if (Get.arguments != null) {
        if (Get.arguments is Map<String, dynamic>) {
          invoiceId = Get.arguments['invoiceId'] ?? '';
        } else if (Get.arguments is String) {
          invoiceId = Get.arguments as String;
        }
      }
      print("📄 Invoice ID: $invoiceId");

      if (invoiceId.isNotEmpty) {
        getInvoiceDetails();
      } else {
        errorMessage.value = "Invoice ID not found";
      }
    } catch (e) {
      errorMessage.value = "Error loading invoice";
    }
  }

  Future<void> getInvoiceDetails() async {
    if (invoiceId.isEmpty) return;

    try {
      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      var res = await invoicePresenter.getInvoiceDetailsAPI(
        isLoading: true,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3Nzk3ODM5OTMsImV4cCI6MTc3OTk1Njc5MywibmJmIjoxNzc5NzgzOTkzLCJqdGkiOiJZeVFnVWdrMFNwYnhubmxLIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZmYzk3M2RjLTExMGMtNGMxZS04YTQwLTkxNzBhYTAzOTRiYiIsInJvbGVfaWQiOiI3N2M1NjIyNS02NDZlLTRiMzUtODM5Yy0zZDYzN2I1ODEwZDYifQ.JyJrp_uc96k1J32tAse5MeL8J-Mtvt80pqrHQfRqSqg',
        branchId: branchId?.toString() ?? '',
        invoiceId: invoiceId,
      );

      print("📡 API Status: ${res?.status}");

      if (res != null && res.status == true && res.data != null) {

        // Convert to JSON
        final jsonString = jsonEncode(res.data);
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

        print("📡 JSON Keys: ${jsonMap.keys}");

        // ✅ Create invoice object
        final invoice = jsonMap['invoice'] != null
            ? Invoice.fromJson(jsonMap['invoice'] as Map<String, dynamic>)
            : null;

        // ✅ Create student object
        final student = jsonMap['student'] != null
            ? StudentInfo.fromJson(jsonMap['student'] as Map<String, dynamic>)
            : null;

        // ✅ Create feeItems list - FIXED
        final List<FeeItem> feeItems = [];
        if (jsonMap['fee_items'] != null) {
          final feeItemsList = jsonMap['fee_items'] as List;
          for (var item in feeItemsList) {
            feeItems.add(FeeItem.fromJson(item as Map<String, dynamic>));
          }
        }

        // ✅ Create summary object
        final summary = jsonMap['summary'] != null
            ? Summary.fromJson(jsonMap['summary'] as Map<String, dynamic>)
            : null;

        // ✅ Create paymentHistory list - FIXED
        final List<PaymentHistory> paymentHistory = [];
        if (jsonMap['payment_history'] != null) {
          final paymentList = jsonMap['payment_history'] as List;
          for (var payment in paymentList) {
            paymentHistory.add(PaymentHistory.fromJson(payment as Map<String, dynamic>));
          }
        }

        final downloadUrl = jsonMap['download_url'] as String?;
        final warning = jsonMap['warning'] as String?;

        final invoiceDataObj = InvoiceData(
          invoice: invoice,
          student: student,
          feeItems: feeItems,
          summary: summary,
          paymentHistory: paymentHistory,
          downloadUrl: downloadUrl,
          warning: warning,
        );

        invoiceData.value = InvoiceResponseModel(
          status: true,
          message: "Success",
          data: invoiceDataObj,
        );

        print("✅ Success! Invoice Number: ${invoiceData.value?.data?.invoice?.invoiceNumber}");
        print("✅ Student Name: ${invoiceData.value?.data?.student?.name}");
        print("✅ Net Amount: ${invoiceData.value?.data?.summary?.netAmount}");
        print("✅ Fee Items Count: ${invoiceData.value?.data?.feeItems?.length}");
        print("✅ Payment History Count: ${invoiceData.value?.data?.paymentHistory?.length}");

      } else {
        errorMessage.value = res?.message ?? "Failed to load invoice";
      }
    } catch (e, stackTrace) {
      errorMessage.value = "Error: $e";
      print("❌ Error: $e");
      print("StackTrace: $stackTrace");
    }
  }

  void refreshData() {
    invoiceData.value = null;
    errorMessage.value = null;
    getInvoiceDetails();
  }
}