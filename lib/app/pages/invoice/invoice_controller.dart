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
  var isLoading = false.obs;
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
      isLoading.value = true;
      errorMessage.value = null;

      var deviceRepo = Get.find<DeviceRepository>();
      var token = await deviceRepo.getSecuredValue(DeviceConstants.token);
      var branchId = await deviceRepo.getSecuredValue(DeviceConstants.branchId);

      var res = await invoicePresenter.getInvoiceDetailsAPI(
        isLoading: true,
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RlbW8uYWl0c29sdXRpb25zLmluL2FwaS9icmFuY2gvbG9naW4iLCJpYXQiOjE3Nzg4Mzk3NjIsImV4cCI6MTc3OTAxMjU2MiwibmJmIjoxNzc4ODM5NzYyLCJqdGkiOiIwQkJpY2laWU9POHNEQ3RmIiwic3ViIjoiMDE5ZDAwNDAtMjNkNy03MzVlLWE0NDQtNTE3ZjYyMmQ5NjFmIiwicHJ2IjoiOGIwYjQ2ZmU0M2U1YWNjMmU1NzFkYmRlNWIwODFiYzFiMjA1MGNmMiIsInVzZXJfdHlwZSI6InRlbmFudCIsImJyYW5jaF9pZCI6IjZmYzk3M2RjLTExMGMtNGMxZS04YTQwLTkxNzBhYTAzOTRiYiIsInJvbGVfaWQiOiI3N2M1NjIyNS02NDZlLTRiMzUtODM5Yy0zZDYzN2I1ODEwZDYifQ.qKCZMo6B_m1q370wDk8nwsA3SOfTWjfN2B9brurAcU4',
        branchId: branchId?.toString() ?? '',
        invoiceId: invoiceId,
      );

      if (res != null && res.status == true && res.data != null) {
        if (res.data is InvoiceResponseModel) {
          invoiceData.value = res.data as InvoiceResponseModel;
        } else if (res.data is Map<String, dynamic>) {
          invoiceData.value = InvoiceResponseModel.fromJson(res.data as Map<String, dynamic>);
        }
      } else {
        errorMessage.value = res?.message ?? "Failed to load invoice";
      }
    } catch (e) {
      errorMessage.value = "Error loading invoice";
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    getInvoiceDetails();
  }
}