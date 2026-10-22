@deprecated
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

final class NoAppInstalled extends AppException {
  const NoAppInstalled() : super('No app installed');
}

final class NoAppFound extends AppException {
  const NoAppFound() : super('App not found');
}

final class FailedToLaunch extends AppException {
  const FailedToLaunch() : super('Failed to launch app');
}

final class FailedToOpen extends AppException {
  const FailedToOpen() : super('Failed to open app');
}

final class FailedToUninstall extends AppException {
  const FailedToUninstall() : super('Failed to uninstall app');
}

final class LockPermissionFailed extends AppException {
  const LockPermissionFailed() : super('please grant the permission');
}
