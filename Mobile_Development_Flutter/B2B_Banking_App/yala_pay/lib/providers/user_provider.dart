import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yala_pay/models/user.dart';

class UserProvider extends Notifier<List<User>> {
  @override
  List<User> build() {
    initializeState();
    return [];
  }

  void initializeState() async {
    List<User> temp = [];
    var data = await rootBundle.loadString('assets/YalaPay-data/users.json');

    var productsMap = jsonDecode(data);
    for (var product in productsMap) {
      temp.add(User.fromJson(product));
    }
    state = temp;
  }

  //checks if the user exists and returns the user else returns null
  User? logInCheck(String email, String password) {
    // ignore: avoid_init_to_null
    User? user = null;
    try {
      user = state.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      e.toString();
    }
    user != null ? user.isLogged = true : null;
    return user;
  }
}

final userNotifierProvider =
    NotifierProvider<UserProvider, List<User>>(() => UserProvider());
