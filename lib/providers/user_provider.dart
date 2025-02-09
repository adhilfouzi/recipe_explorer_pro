import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  static const String _boxName = "userBox";

  UserModel _user = UserModel.empty();
  UserModel get user => _user;

  /// Initialize Hive and Load User Data
  Future<void> initUser() async {
    var box = await Hive.openBox<UserModel>(_boxName);
    _user = box.get('user', defaultValue: UserModel.empty())!;
    notifyListeners();
  }

  /// Update User Profile
  Future<void> updateUser(UserModel updatedUser) async {
    var box = await Hive.openBox<UserModel>(_boxName);
    await box.put('user', updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  /// Clear User Data
  Future<void> logoutUser() async {
    var box = await Hive.openBox<UserModel>(_boxName);
    await box.delete('user');
    _user = UserModel.empty();
    notifyListeners();
  }

  /// Add User Data on Sign Up or Sign In
  Future<void> addUser(UserModel newUser) async {
    var box = await Hive.openBox<UserModel>(_boxName);
    await box.put('user', newUser);
    _user = newUser;
    notifyListeners();
  }
}
