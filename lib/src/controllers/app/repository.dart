import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/models/scan_ticket.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class AppRepo {
  Future<ResponseRepository> scanTicket(String code) async {
    final response = await Api.service.post(EndPoints.scanTicket, {'qr': code});

    return response.toResponseRepository(
        fromJson: (data) => ScanTicket.fromJson(data));
  }
}
