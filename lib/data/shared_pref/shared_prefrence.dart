import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrenceHelper {
  static String userIdKey = "USERIDKEY";
  static String nameKey = "NAMEKEY";
  static String emailKey = "EMAILKEY";
  static String walletKey = "WALLETKEY";
  static String userProfile = "USERPROFILE";
  static String onBoardscreen = "ONBOARDSCREEN";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, getUserId);
  }

  Future<bool> saveOnboard(bool getonboard) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(onBoardscreen, getonboard);
  }

  Future<bool?> getOnboard() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(onBoardscreen);
  }

  Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(nameKey, getUserName);
  }

  Future<bool> saveUserProfile(String getUserProfile) async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    return ref.setString(userProfile, getUserProfile);
  }

  Future<String?> getUserProfile() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    return ref.getString(userProfile);
  }

  Future<String?> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(emailKey, getUserEmail);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(emailKey);
  }

  Future<bool> saveUserWallet(String getUserWallet) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(walletKey, getUserWallet);
  }

  Future<String?> getUserWallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(walletKey);
  }
}
