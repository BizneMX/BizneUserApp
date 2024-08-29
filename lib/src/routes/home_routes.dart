import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/binding.dart';
import 'package:bizne_flutter_app/src/controllers/layout/view.dart';
import 'package:get/get.dart';

class HomePages {
  static List<GetPage> pages = [
    GetPage(name: home, page: () => LayoutBizne(), binding: LayoutBinding()),
  ];
}
