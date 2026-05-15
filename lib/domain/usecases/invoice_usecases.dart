import 'package:school_app/domain/domain.dart';

import '../models/invoice_response.dart';
import '../models/profile_response.dart';

/// Use case for getting the data from the API
class InvoiceUseCases {
  InvoiceUseCases(this.repository);

  final Repository repository;

  Future<InvoiceResponseModel?> getInvoiceDetailsAPI(
          {required bool isLoading,
            required String token,
            required String invoiceId, required String branchId,
          }) async =>
      await repository.getInvoiceDetailsAPI(
          isLoading: isLoading,
          token: token,
        invoiceId: invoiceId,
        branchId: branchId,
      );

}
