import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';

class ErrorController extends LayoutRouteController {}

class ErrorParams {
  final String error;
  final String description;
  final List<(String, Function())> actions;

  const ErrorParams(
      {required this.description, required this.error, required this.actions});
}
