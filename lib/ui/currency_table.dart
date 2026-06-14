import 'package:claymore/models/user.dart';
import 'package:claymore/services/currency_calculator.dart';
import 'package:claymore/state/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyTable extends StatelessWidget {
  final User user;

  const CurrencyTable({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();

    final currency6 = CurrencyCalculator.calculate6Month(
      user: user,
      controls: appData.controls,
    );

    final currency12 = CurrencyCalculator.calculate12Month(
      user: user,
      controls: appData.controls,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Table(
        border: TableBorder.all(color: Colors.white24, width: 2),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade900),
            children: [
              _headerCell(''),
              _headerCell('T1'),
              _headerCell('T2'),
              _headerCell('T3'),
              _headerCell('BoT'),
              _headerCell('BoC'),
              _headerCell('FW'),
              _headerCell('RW'),
              _headerCell('Laser'),
              _headerCell('IR'),
              _headerCell('RO'),
              _headerCell('VDL'),
              _headerCell('Live'),
              _headerCell('NP'),
              _headerCell('Day'),
              _headerCell('Night'),
              _headerCell('LL'),
              _headerCell('Sup'),
            ],
          ),

          TableRow(
            children: [
              _rowLabel('12M'),
              _currencyCell(currency12.t1),
              _currencyCell(currency12.t2),
              _currencyCell(currency12.t3),
              _currencyCell(currency12.bot),
              _currencyCell(currency12.boc),
              _currencyCell(currency12.fw),
              _currencyCell(currency12.rw),
              _currencyCell(currency12.laser),
              _currencyCell(currency12.ir),
              _currencyCell(currency12.ro),
              _currencyCell(currency12.vdl),
              _currencyCell(currency12.live),
              _currencyCell(currency12.np),
              _currencyCell(currency12.day),
              _currencyCell(currency12.night),
              _currencyCell(currency12.ll),
              _currencyCell(currency12.supervised),
            ],
          ),
          TableRow(
            children: [
              _rowLabel('6M'),
              _currencyCell(currency6.t1),
              _currencyCell(currency6.t2),
              _currencyCell(currency6.t3),
              _currencyCell(currency6.bot),
              _currencyCell(currency6.boc),
              _currencyCell(currency6.fw),
              _currencyCell(currency6.rw),
              _currencyCell(currency6.laser),
              _currencyCell(currency6.ir),
              _currencyCell(currency6.ro),
              _currencyCell(currency6.vdl),
              _currencyCell(currency6.live),
              _currencyCell(currency6.np),
              _currencyCell(currency6.day),
              _currencyCell(currency6.night),
              _currencyCell(currency6.ll),
              _currencyCell(currency6.supervised),
            ],
          ),

        ],
      ),
    );
  }

  Widget _headerCell(String text) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _rowLabel(String text) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      color: Colors.grey.shade900,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _currencyCell(bool value) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: value ? Colors.green.shade700 : Colors.red.shade700,
      ),
    );
  }
}
