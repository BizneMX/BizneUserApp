import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/models/scan_ticket.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class HowYouWantPayRepo {
  Future<ResponseRepository> payTicket(int tip, bool card, int cardId,
      String imei, int option, ScanTicket scanTicket) async {
    final response = await Api.service.post(EndPoints.payTicket, {
      'option': option,
      'tip': tip,
      'card': card,
      'card_id': card ? cardId : null,
      'imei': imei,
      'total': scanTicket.total,
      'total_with_discount': scanTicket.totalWithDiscount,
      'pay_with_points': scanTicket.payWithPoints,
      'ticket': scanTicket.ticket,
      'establishment': scanTicket.establishment,
      'matrix': scanTicket.matrix,
      'diners': scanTicket.diners
    });

    return response.toResponseRepository();
  }
}
