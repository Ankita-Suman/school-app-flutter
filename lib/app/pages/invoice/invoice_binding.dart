import 'package:get/get.dart';
import 'package:school_app/domain/domain.dart';

import '../../../domain/usecases/home_usecases.dart';
import '../dashboard/dashboard_presenter.dart';
import 'invoice.dart';

/// A list of bindings which will be used in the route of [InvoiceScreen].
class InvoiceBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<InvoiceController>(
      InvoiceController(
        Get.put(
          InvoicePresenter(
            InvoiceUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
