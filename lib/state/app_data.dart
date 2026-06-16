import 'dart:async';

import 'package:claymore/models/control.dart';
import 'package:claymore/models/trg_event.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  List<User> users = [];
  List<Control> controls = [];
  List<TrgEvent> trgEvents = [];
  User currentUser = User.empty();
  User? _selectedJtac;

  User? get selectedJtac => _selectedJtac;

  set selectedJtac(User? user) {
    _selectedJtac = user;
    notifyListeners();
  }

  StreamSubscription? _usersSub;
  StreamSubscription? _controlsSub;
  StreamSubscription? _trgSub;

  void startListening() {
    _usersSub = FirestoreService.watchCollection(collectionPath: 'users')
        .listen((data) {
          users = data.map((map) {
            return User.fromFirestore(map['id'], map);
          }).toList();

          notifyListeners();
        });

    _controlsSub = FirestoreService.watchCollection(collectionPath: 'controls')
        .listen((data) {
          controls = data.map((map) {
            return Control.fromFirestore(map['id'], map);
          }).toList()..sort((a, b) => a.controlDate.compareTo(b.controlDate));
          ;

          notifyListeners();
        });
    _trgSub = FirestoreService.watchCollection(collectionPath: 'training')
        .listen((data) {
          trgEvents = data.map((map) {
            return TrgEvent.fromFirestore(map['id'], map);
          }).toList()..sort((a, b) => a.trgDate.compareTo(b.trgDate));

          notifyListeners();
        });
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    _controlsSub?.cancel();
    _trgSub?.cancel();
    super.dispose();
  }
}
