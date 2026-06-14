import 'dart:async';

import 'package:claymore/models/control.dart';
import 'package:claymore/models/user.dart';
import 'package:claymore/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  List<User> users = [];
  List<Control> controls = [];
  User currentUser = User.empty();

  StreamSubscription? _usersSub;
  StreamSubscription? _controlsSub;

  void startListening() {
    _usersSub = FirestoreService.watchCollection(
      collectionPath: 'users',
    ).listen((data) {
      users = data.map((map) {
        return User.fromFirestore(map['id'], map);
      }).toList();

      notifyListeners();
    });

    _controlsSub = FirestoreService.watchCollection(
      collectionPath: 'controls',
    ).listen((data) {
      controls = data.map((map) {
        return Control.fromFirestore(map['id'], map);
      }).toList();

      notifyListeners();
    });
  }

  User? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _usersSub?.cancel();
    _controlsSub?.cancel();
    super.dispose();
  }
}