import 'package:bizne_flutter_app/src/environment.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Utils {
  static bool validDate(String date) {
    final dateParts = date.split('/');
    if (dateParts.length != 3) {
      return false;
    }
    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);
    if (day == null || month == null || year == null) {
      return false;
    }
    if (year < 1900) return false;
    DateTime date_;
    try {
      date_ = DateTime(year, month, day);
    } catch (e) {
      return false;
    }
    return date_.day == day && date_.month == month && date_.year == year;
  }

  static DateTime strToDateTime(String date) {
    final dateParts = date.split('-');

    return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  static bool validMonthYear(String date) {
    final dateParts = date.split('/');
    if (dateParts.length != 2) {
      return false;
    }

    if (dateParts[0].length != 2 || dateParts[1].length != 2) {
      return false;
    }

    final month = int.tryParse(dateParts[0]);
    final year = int.tryParse(dateParts[1]);
    if (month == null || year == null) {
      return false;
    }
    if (month < 0 || month > 12) {
      return false;
    }

    return true;
  }

  static String extractWords(String text, int startIndex, int endIndex) {
    List<String> words = text.split(' ');
    startIndex = (startIndex + words.length) % words.length;
    endIndex = (endIndex + words.length) % words.length;

    List<String> selectedWords = words.sublist(startIndex, endIndex + 1);

    String result = selectedWords.join(' ');

    return result;
  }

  static bool validCreditCard(String text) {
    final n = text.split(' ');

    if (n.length != 4) return false;

    bool valid = true;

    for (var i = 0; i < n.length; i++) {
      if (i == n.length - 1) {
        if (n[i].length != 4 && n[i].length != 3) valid = false;
      } else {
        if (n[i].length != 4) valid = false;
      }
      final x = int.tryParse(n[i]);
      if (x == null) {
        valid = false;
      }
    }

    return valid;
  }

  static double decodeDouble(String number) {
    final q = number.split(',');

    return double.parse(q.join(""));
  }

  static int decodeInt(String number) {
    return decodeDouble(number).toInt();
  }

  static Future<void> contactWhatsApp(String phone) async {
    final url = 'whatsapp://send?phone=$phone';
    await launchUrl(Uri.parse(url));
  }

  static Future<void> contactSupport() async {
    String url =
        'whatsapp://send?phone=${Environment.whatsappContact}&text=Hola+necesito+ayuda+en&lang=es';
    await launchUrl(Uri.parse(url));
  }

  static String formattedDistance(double distance) {
    double d = distance;
    if (d > 1000) {
      d /= 100;
      return '${(d.toInt() / 10.0).toString()} km';
    } else {
      return '${d.toInt().toString()} m';
    }
  }

  static String truncateText(String text) {
    if (text.length > 25) return '${text.substring(0, 25)}...';

    return text;
  }
}

class LocalizationFormatters {
  static String numberFormat(double value, {decimalDigits = 2}) {
    final formatNumber = NumberFormat.decimalPattern('es');
    formatNumber.minimumFractionDigits = decimalDigits;
    formatNumber.maximumFractionDigits = decimalDigits;
    return formatNumber.format(value);
  }

  static String formatNumberBizne(double value) {
    final format = numberFormat(value);
    return format
        .replaceAll(',', 'temp')
        .replaceAll('.', ',')
        .replaceAll('temp', '.');
  }

  static String currencyFormat(double value, {decimalDigits = 2}) {
    final formatCurrency =
        NumberFormat.simpleCurrency(locale: 'en', decimalDigits: decimalDigits);
    return formatCurrency.format(value);
  }

  static String dateFormat(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    DateFormat dateFormat = DateFormat('d MMM y', 'es');
    return dateFormat.format(date).replaceAll('.', '');
  }

  static String dateFormat1(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    DateFormat dateFormat = DateFormat('d MMMM y', 'es');
    return dateFormat.format(date).replaceAll('.', '');
  }

  static String dateFormat2(DateTime date) {
    DateFormat dateFormat = DateFormat('d MMMM y hh:mm', 'es');
    return dateFormat.format(date).replaceAll('.', '');
  }

  static String dateFormat3(DateTime date) {
    DateFormat dateFormat = DateFormat('d MMM y', 'es');
    return dateFormat.format(date).replaceAll('.', '');
  }
}

class FileConverter {
  static Future<String> getBase64FormateFile(String path) async {
    File file = File(path);
    final ext = path.split('.')[1];
    List<int> fileInByte = await file.readAsBytes();
    String fileInBase64 = base64Encode(fileInByte);
    return 'data:image/$ext;base64,$fileInBase64';
  }
}
