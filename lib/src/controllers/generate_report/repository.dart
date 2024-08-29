import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/report_category.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class GenerateReportRepo {
  Future<ResponseRepository> getReportCategories() async {
    final response = await Api.service.get(EndPoints.userReportCategories, {});

    return response.toResponseRepository(
        fromJson: (data) => data
            .map<ReportCategory>((e) => ReportCategory.fromJson(e))
            .toList());
  }

  Future<ResponseRepository> generateReport(
      int id, String comments, int type) async {
    final response = await Api.service.post(EndPoints.userGenerateReport,
        {'visit': id, 'comments': comments, 'type': type});

    return response.toResponseRepository();
  }
}
