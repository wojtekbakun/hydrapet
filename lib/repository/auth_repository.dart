import 'package:hydrapet/model/schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthRepository {
  // Zapis tokenu JWT
  Future<void> saveJwtToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
  }

  // Pobranie tokenu JWT
  Future<String?> loadJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  // Usunięcie tokenu JWT
  Future<void> removeJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
  }
}
