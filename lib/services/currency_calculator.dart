import 'package:claymore/models/control.dart';
import 'package:claymore/models/user.dart';

class Currency {
  final bool t1;
  final bool t2;
  final bool t3;
  final bool bot;
  final bool boc;
  final bool fw;
  final bool rw;
  final bool laser;
  final bool ir;
  final bool ro;
  final bool vdl;
  final bool live;
  final bool np;
  final bool day;
  final bool night;
  final bool ll;
  final bool supervised;

  const Currency({
    required this.t1,
    required this.t2,
    required this.t3,
    required this.bot,
    required this.boc,
    required this.fw,
    required this.rw,
    required this.laser,
    required this.ir,
    required this.ro,
    required this.vdl,
    required this.live,
    required this.np,
    required this.day,
    required this.night,
    required this.ll,
    required this.supervised,
  });

  Map<String, bool> toMap() {
    return {
      'T1': t1,
      'T2': t2,
      'T3': t3,
      'BoT': bot,
      'BoC': boc,
      'FW': fw,
      'RW': rw,
      'Laser': laser,
      'IR': ir,
      'RO': ro,
      'VDL': vdl,
      'Live': live,
      'NP': np,
      'Day': day,
      'Night': night,
      'LL': ll,
      'Supervised': supervised,
    };
  }

  bool get allTrue => [
    t1,
    t2,
    t3,
    bot,
    boc,
    fw,
    rw,
    laser,
    ir,
    ro,
    vdl,
    live,
    np,
    day,
    night,
    ll,
    supervised,
  ].every((b) => b);
}

class CurrencyCalculator {
  static Currency calculate6Month({
    required User user,
    required List<Control> controls,
  }) {
    final cutoff = DateTime.now().subtract(const Duration(days: 183));

    final userControls = controls.where((control) {
      return control.controllingJTACId == user.id &&
          control.controlDate.isAfter(cutoff) &&
          control.approved == true &&
          control.grading == true;
    }).toList();

    return Currency(
      t1: userControls.any((c) => c.typeofControl == 1),
      t2: userControls.any((c) => c.typeofControl == 2),
      t3: userControls.any((c) => c.typeofControl == 3),

      bot: userControls.any((c) => c.methodOfAttack == 'BoT'),
      boc: userControls.any((c) => c.methodOfAttack == 'BoC'),

      fw: userControls.where((c) => c.fwAircraft).length >= 2,

      rw: userControls.any((c) => c.rwAircraft),

      laser: userControls.any((c) => c.laserMark),
      ir: userControls.any((c) => c.irMark),
      ro: userControls.any((c) => c.remoteObserver),
      vdl: userControls.any((c) => c.fmv),

      live: userControls.any((c) => c.live),

      np: userControls.any((c) => c.nonPermissive),

      day: userControls.any((c) => c.day),
      night: userControls.any((c) => c.night),

      ll: userControls.any((c) => c.lowLevel),

      supervised: userControls.any((c) => c.supervisedById.isNotEmpty),
    );
  }

  static Currency calculate12Month({
    required User user,
    required List<Control> controls,
  }) {
    final cutoff = DateTime.now().subtract(const Duration(days: 365));

    final userControls = controls.where((control) {
      return control.controllingJTACId == user.id &&
          control.controlDate.isAfter(cutoff) &&
          control.approved == true &&
          control.grading == true;
    }).toList();

    return Currency(
      t1: userControls.where((c) => c.typeofControl == 1).length >= 2,
      t2: userControls.where((c) => c.typeofControl == 2).length >= 2,
      t3: userControls.where((c) => c.typeofControl == 3).isNotEmpty,

      bot: userControls.where((c) => c.methodOfAttack == 'BoT').length >= 2,
      boc: userControls.where((c) => c.methodOfAttack == 'BoC').length >= 2,

      fw: userControls.where((c) => c.fwAircraft).length >= 4,

      rw: userControls.any((c) => c.rwAircraft),

      laser: userControls.where((c) => c.laserMark).length >= 2,
      ir: userControls.where((c) => c.irMark).length >= 2,
      ro: userControls.where((c) => c.remoteObserver).length >= 2,
      vdl: userControls.any((c) => c.fmv),
      live: userControls.any((c) => c.live),

      np: userControls.where((c) => c.nonPermissive).length >= 2,

      day: userControls.where((c) => c.day).length >= 2,
      night: userControls.where((c) => c.night).length >= 2,

      ll: userControls.where((c) => c.lowLevel).length >= 2,

      supervised: userControls
          .where((c) => c.supervisedById.isNotEmpty)
          .isNotEmpty,
    );
  }
}
