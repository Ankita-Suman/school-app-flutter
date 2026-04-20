
import '../../app/utils/app_constants.dart';
import '../repositories/repository.dart';

/// Use case for getting the data from the API
class AuthUseCases {
  AuthUseCases(this.repository);

  final Repository repository;

  /// Check if the user is logged in or not.
  bool isUserLoggedIn() => repository.getBoolValue(AppConstants.isUserLoggedIn);

}
