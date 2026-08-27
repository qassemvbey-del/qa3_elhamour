import 'package:web/web.dart' as web;

/// Web implementation returning browser window.location.origin directly
String getAuthRedirectUrl() {
  return web.window.location.origin;
}
