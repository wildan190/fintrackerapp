import 'package:fintrackerapp/db/db_helper.dart';

class AuthService {
  final DBHelper _dbHelper = DBHelper();

  // ========================== Register ==========================
  Future<bool> register(String username, String password) async {
    try {
      // Cek apakah username sudah digunakan
      var existingUser = await _dbHelper.loginUser(username, password);
      if (existingUser != null) {
        return false; // Username sudah ada
      }

      // Simpan user baru
      await _dbHelper.registerUser(username, password);
      return true; // Registrasi berhasil
    } catch (e) {
      print("Error Register: $e");
      return false;
    }
  }

  // ========================== Login ==========================
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      var user = await _dbHelper.loginUser(username, password);
      if (user != null) {
        return user; // Login berhasil, kembalikan data user
      }
      return null; // Login gagal
    } catch (e) {
      print("Error Login: $e");
      return null;
    }
  }

  // ========================== Logout ==========================
  Future<void> logout() async {
    // Logout bisa diimplementasikan dengan menghapus sesi user
    print("User logged out.");
  }
}
