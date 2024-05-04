import 'package:school_app/domain/domain.dart';

/// Use case for getting the data from the API
class SplashUseCases {
  SplashUseCases(this.repository);

  final Repository repository;

  // Future<VersionResponse?> appVersion({required bool isLoading}) async =>
  //     await repository.appVersion(isLoading: isLoading);
  // Future<AccountStatusResponse?> accountStatus({
  //   required bool isLoading,
  // }) async =>
  //     await repository.accountStatus(isLoading: isLoading);
}
