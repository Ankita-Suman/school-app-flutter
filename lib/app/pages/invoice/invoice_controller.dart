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
        isLoading: false,
        token: token.toString(),
        branchId: branchId.toString(),
        invoiceId: invoiceId,
      );

      if (res != null && res.status == true && res.data != null) {
        // Convert to JSON
        final jsonString = jsonEncode(res.data);
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

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
            paymentHistory
                .add(PaymentHistory.fromJson(payment as Map<String, dynamic>));
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
      } else {
        errorMessage.value = res?.message ?? "Failed to load invoice";
      }
    } catch (e, stackTrace) {
      errorMessage.value = "Error: $e";
    }
  }

  void refreshData() {
    invoiceData.value = null;
    errorMessage.value = null;
    getInvoiceDetails();
  }
}
