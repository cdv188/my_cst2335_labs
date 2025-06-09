import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String loginName = '';

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';

  Future<void> saveData(EncryptedSharedPreferences prefs) async {
    await prefs.setString('Username', loginName);
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setString('email', email);
  }

  Future<void> loadData(EncryptedSharedPreferences prefs) async {
    loginName = await prefs.getString('Username');
    firstName = await prefs.getString('firstName');
    lastName = await prefs.getString('lastName');
    phoneNumber = await prefs.getString('phoneNumber');
    email = await prefs.getString('email');
  }
}
