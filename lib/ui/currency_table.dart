import 'package:claymore/models/user.dart';
import 'package:claymore/services/currency_calculator.dart';
import 'package:claymore/state/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LargeCurrencyTable extends StatelessWidget {
  final User user;

  const LargeCurrencyTable({super.key, required this.user});

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
      color: Colors.black,
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 2),
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
              _splitLabelCell(),
              _splitCurrencyCell(currency6.t1, currency12.t1),
              _splitCurrencyCell(currency6.t2, currency12.t2),
              _splitCurrencyCell(currency6.t3, currency12.t3),
              _splitCurrencyCell(currency6.bot, currency12.bot),
              _splitCurrencyCell(currency6.boc, currency12.boc),
              _splitCurrencyCell(currency6.fw, currency12.fw),
              _splitCurrencyCell(currency6.rw, currency12.rw),
              _splitCurrencyCell(currency6.laser, currency12.laser),
              _splitCurrencyCell(currency6.ir, currency12.ir),
              _splitCurrencyCell(currency6.ro, currency12.ro),
              _splitCurrencyCell(currency6.vdl, currency12.vdl),
              _splitCurrencyCell(currency6.live, currency12.live),
              _splitCurrencyCell(currency6.np, currency12.np),
              _splitCurrencyCell(currency6.day, currency12.day),
              _splitCurrencyCell(currency6.night, currency12.night),
              _splitCurrencyCell(currency6.ll, currency12.ll),
              _splitCurrencyCell(currency6.supervised, currency12.supervised),
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


  Widget _splitLabelCell() {
    return SizedBox(
      height: 40,
      child: CustomPaint(
        painter: _DiagonalCurrencyPainter(
          topLeftColor: Colors.grey.shade700,
          bottomRightColor: Colors.grey.shade900,
          lineColor: Colors.white24,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4,
              left: 6,
              child: Text(
                '6M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 6,
              child: Text(
                '12M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _splitCurrencyCell(bool sixMonthValue, bool twelveMonthValue) {
    return SizedBox(
      height: 40,
      child: CustomPaint(
        painter: _DiagonalCurrencyPainter(
          topLeftColor: sixMonthValue
              ? Colors.green.shade700
              : Colors.red.shade500,
          bottomRightColor: twelveMonthValue
              ? Colors.green.shade700
              : Colors.red.shade500,
          lineColor: Colors.white24,
        ),
      ),
    );
  }
}

class SmallCurrencyTable extends StatelessWidget {
  final User user;

  const SmallCurrencyTable({super.key, required this.user});

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
      color: Colors.black,
      child: Table(
        border: TableBorder.all(color: Colors.black, width: 2),
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
            ],
          ),
          TableRow(
            children: [
              _splitLabelCell(),
              _splitCurrencyCell(currency6.t1, currency12.t1),
              _splitCurrencyCell(currency6.t2, currency12.t2),
              _splitCurrencyCell(currency6.t3, currency12.t3),
              _splitCurrencyCell(currency6.bot, currency12.bot),
              _splitCurrencyCell(currency6.boc, currency12.boc),
              _splitCurrencyCell(currency6.fw, currency12.fw),
              _splitCurrencyCell(currency6.rw, currency12.rw),
              _splitCurrencyCell(currency6.laser, currency12.laser),
            ],
          ),
          TableRow(
            children: [
              _splitCurrencyCell(currency6.ir, currency12.ir),
              _splitCurrencyCell(currency6.ro, currency12.ro),
              _splitCurrencyCell(currency6.vdl, currency12.vdl),
              _splitCurrencyCell(currency6.live, currency12.live),
              _splitCurrencyCell(currency6.np, currency12.np),
              _splitCurrencyCell(currency6.day, currency12.day),
              _splitCurrencyCell(currency6.night, currency12.night),
              _splitCurrencyCell(currency6.ll, currency12.ll),
              _splitCurrencyCell(currency6.supervised, currency12.supervised),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade900),
            children: [
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
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _splitLabelCell() {
    return SizedBox(
      height: 40,
      child: CustomPaint(
        painter: _DiagonalCurrencyPainter(
          topLeftColor: Colors.grey.shade700,
          bottomRightColor: Colors.grey.shade900,
          lineColor: Colors.white24,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4,
              left: 6,
              child: Text(
                '6M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 6,
              child: Text(
                '12M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _splitCurrencyCell(bool sixMonthValue, bool twelveMonthValue) {
    return SizedBox(
      height: 40,
      child: CustomPaint(
        painter: _DiagonalCurrencyPainter(
          topLeftColor: sixMonthValue
              ? Colors.green.shade700
              : Colors.red.shade500,
          bottomRightColor: twelveMonthValue
              ? Colors.green.shade700
              : Colors.red.shade500,
          lineColor: Colors.white24,
        ),
      ),
    );
  }
}

class _DiagonalCurrencyPainter extends CustomPainter {
  final Color topLeftColor;
  final Color bottomRightColor;
  final Color lineColor;

  _DiagonalCurrencyPainter({
    required this.topLeftColor,
    required this.bottomRightColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final topLeftPaint = Paint()..color = topLeftColor;
    final bottomRightPaint = Paint()..color = bottomRightColor;

    final topLeftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();

    final bottomRightPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(topLeftPath, topLeftPaint);
    canvas.drawPath(bottomRightPath, bottomRightPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), linePaint);
  }

  @override
  bool shouldRepaint(covariant _DiagonalCurrencyPainter oldDelegate) {
    return topLeftColor != oldDelegate.topLeftColor ||
        bottomRightColor != oldDelegate.bottomRightColor ||
        lineColor != oldDelegate.lineColor;
  }
}
