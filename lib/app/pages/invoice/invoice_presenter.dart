import 'package:school_app/domain/domain.dart';

import '../../../domain/models/invoice_response.dart';

class InvoicePresenter {
  InvoicePresenter(this.invoiceUseCases);

  final InvoiceUseCases invoiceUseCases;

  Future<InvoiceResponseModel?> getInvoiceDetailsAPI({
    required bool isLoading,
    required String token,
     required String invoiceId, required String branchId,
  }) async {
    return await invoiceUseCases.getInvoiceDetailsAPI(
      isLoading: isLoading,
      token: token,
      invoiceId: invoiceId,
      branchId: branchId,
    );
  }
}
