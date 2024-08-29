import 'package:bizne_flutter_app/src/models/payment_method.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

import '../themes.dart';
import 'my_text.dart';

class CountrySelector extends StatelessWidget {
  final Function(String) onSelected;
  const CountrySelector({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.5.h,
      child: CountryCodePicker(
        padding: EdgeInsets.zero,
        onChanged: (value) {
          onSelected(value.toString());
        },
        initialSelection: 'MX',
        favorite: const ['+52', 'MX'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
      ),
    );
  }
}

class CountryDropdownMenuItem extends StatelessWidget {
  final Map<String, String> country;

  const CountryDropdownMenuItem({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(country['name']!), Text(country['lada']!)]);
  }
}

class CreditCardSelector extends StatefulWidget {
  const CreditCardSelector({super.key});

  @override
  State<CreditCardSelector> createState() => CreditCardSelectorState();
}

class CreditCardSelectorState extends State<CreditCardSelector> {
  PaymentMethod? selectedCard;
  List<PaymentMethod> cards = [];

  void setCards(List<PaymentMethod> newCards) {
    setState(() {
      cards = newCards;

      for (var element in cards) {
        if (element.active) {
          selectedCard = element;
        }
      }

      if (selectedCard == null && cards.isNotEmpty) {
        selectedCard = cards[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
        underline: const SizedBox(),
        buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
                color: AppThemes().whiteInputs,
                borderRadius: AppThemes().borderRadius)),
        customButton: Stack(children: [
          Center(
              child: selectedCard == null
                  ? Text(AppLocalizations.of(context)!.noSavedCards)
                  : CreditCardDropdownMenuItem(card: selectedCard!)),
          Positioned(
            top: 5,
            right: 2,
            child: selectedCard == null
                ? const SizedBox()
                : const Icon(Icons.arrow_drop_down_sharp),
          )
        ]),
        items: cards
            .map((e) => DropdownMenuItem<PaymentMethod>(
                  value: e,
                  child: CreditCardDropdownMenuItem(card: e),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCard = value!;
          });
        });
  }
}

class CreditCardDropdownMenuItem extends StatelessWidget {
  final PaymentMethod card;

  const CreditCardDropdownMenuItem({super.key, required this.card});

  String showCard() {
    return "**** **** **** ${card.last4}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(showCard())]);
  }
}

class TipSelector extends StatefulWidget {
  final List<String> tips;
  final Function(String) onChange;
  const TipSelector({super.key, required this.tips, required this.onChange});

  @override
  State<TipSelector> createState() => _TipSelectorState();
}

class _TipSelectorState extends State<TipSelector> {
  String? selectedTip;

  @override
  Widget build(BuildContext context) {
    if (selectedTip == null && widget.tips.isNotEmpty) {
      selectedTip = widget.tips[0];
    }

    return DropdownButton2(
        underline: const SizedBox(),
        buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
                color: AppThemes().whiteInputs,
                borderRadius: AppThemes().borderRadius)),
        customButton: Stack(children: [
          Center(
              child: selectedTip == null
                  ? Text(AppLocalizations.of(context)!.noSavedCards)
                  : CreditTipDropdownMenuItem(tip: selectedTip!)),
          Positioned(
            top: 5,
            right: 2,
            child: selectedTip == null
                ? const SizedBox()
                : const Icon(Icons.arrow_drop_down_sharp),
          )
        ]),
        items: widget.tips
            .map((e) => DropdownMenuItem<String>(
                  value: e.toString(),
                  child: CreditTipDropdownMenuItem(tip: e),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            widget.onChange(value!);
            selectedTip = value;
          });
        });
  }
}

class CreditTipDropdownMenuItem extends StatelessWidget {
  final String tip;

  const CreditTipDropdownMenuItem({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Text(AppLocalizations.of(context)!.tip(tip))]);
  }
}

class Dateable {
  final int index;

  const Dateable({required this.index});

  String toDate() {
    return '';
  }
}

class Year extends Dateable {
  Year({required super.index});

  @override
  String toDate() => index.toString();
}

class Month extends Dateable {
  Month({required super.index});

  String intToMonth(int month) {
    String result = '';
    switch (month) {
      case 0:
        result = 'Enero';
      case 1:
        result = 'Febrero';
      case 2:
        result = 'Marzo';
      case 3:
        result = 'Abril';
      case 4:
        result = 'Mayo';
      case 5:
        result = 'Junio';
      case 6:
        result = 'Julio';
      case 7:
        result = 'Agosto';
      case 8:
        result = 'Septiembre';
      case 9:
        result = 'Octubre';
      case 10:
        result = 'Noviembre';
      case 11:
        result = 'Diciembre';
      default:
    }

    return result;
  }

  @override
  String toDate() => intToMonth(index);
}

class DateSelector extends StatefulWidget {
  final int quantity;
  final int initial;
  final Dateable Function(int index) constructor;
  final void Function(String) onChange;

  const DateSelector(
      {super.key,
      required this.quantity,
      required this.constructor,
      required this.initial,
      required this.onChange});

  @override
  State<DateSelector> createState() => _CreditDateSelectorState();
}

class _CreditDateSelectorState extends State<DateSelector> {
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    selectedDate ??= widget.constructor(widget.initial).toDate();

    return DropdownButton2<String>(
        underline: const SizedBox(),
        buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
                color: AppThemes().whiteInputs,
                borderRadius: AppThemes().borderRadius)),
        customButton: _buildDateButton(selectedDate!),
        items: _constructIndexList().map((e) {
          final date = widget.constructor(e);
          return DropdownMenuItem<String>(
              value: date.toDate(), child: DateDropdownMenuItem(date: date));
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDate = value;
            widget.onChange(value!);
          });
        });
  }

  List<int> _constructIndexList() {
    List<int> indexList = [];
    if (widget.initial > 1000) {
      // int mid = widget.quantity ~/ 2;
      for (int i = 0; i < widget.quantity; i++) {
        indexList.add(widget.initial + i - widget.quantity + 1);
      }
    } else {
      for (int i = 0; i < widget.quantity; i++) {
        indexList.add(i);
      }
    }
    indexList.sort();
    return indexList;
  }

  Widget _buildDateButton(String value) {
    return Container(
        width: 40.w,
        padding: EdgeInsets.only(left: 3.w, top: 0.5.h, bottom: 0.5.h),
        decoration: BoxDecoration(
            color: AppThemes().whiteInputs,
            borderRadius: AppThemes().borderRadius),
        child: Row(children: [
          MyText(
            text: value,
            fontSize: 14.sp,
            type: FontType.regular,
            color: AppThemes().black,
          ),
          const Expanded(child: SizedBox()),
          const Icon(Icons.arrow_drop_down)
        ]));
  }
}

class DateDropdownMenuItem extends StatelessWidget {
  final Dateable date;

  const DateDropdownMenuItem({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(child: MyText(text: date.toDate()));
  }
}
