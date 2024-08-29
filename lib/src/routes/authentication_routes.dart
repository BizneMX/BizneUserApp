import 'package:bizne_flutter_app/src/controllers/recover_password/binding.dart';
import 'package:bizne_flutter_app/src/controllers/register/binding.dart';
import 'package:bizne_flutter_app/src/controllers/register/view.dart';
import 'package:bizne_flutter_app/src/controllers/verification_code/binding.dart';
import 'package:bizne_flutter_app/src/controllers/verification_code/view.dart';
import 'package:get/get.dart';

import '../constants/routes.dart';
import '../controllers/login/binding.dart';
import '../controllers/login/view.dart';
import '../controllers/recover_password/view.dart';

class AuthenticationPages {
  static List<GetPage> pages = [
    GetPage(
        name: login, page: () => const LoginPage(), binding: LoginBinding()),
    GetPage(
        name: register,
        page: () => const RegisterPage(),
        binding: RegisterBinding()),
    GetPage(
        name: recoverPassword,
        page: () => const RecoverPasswordPage(),
        binding: RecoverPasswordBinding()),
    GetPage(
        name: verificationCode,
        page: () => const VerificationCodePage(),
        binding: VerificationCodeBinding())
  ];
}
