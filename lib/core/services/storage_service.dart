import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Keys
  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _idKey = 'userId';
  static const String _freshchatRestoreIdKey = 'freshchatRestoreId';

  // SharedPreferences instance
  static SharedPreferences? _preferences;

  // Must be initialized in main() before runApp()
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // =======================
  // TOKEN METHODS
  // =======================

  static bool hasToken() {
    return _preferences?.getString(_tokenKey) != null;
  }

  static Future<void> saveToken(String token) async {
    await _preferences?.setString(_tokenKey, token);
  }

  static String? get token => _preferences?.getString(_tokenKey);

  // =======================
  // REFRESH TOKEN
  // =======================

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _preferences?.setString(_refreshTokenKey, refreshToken);
  }

  static String? get refreshToken => _preferences?.getString(_refreshTokenKey);

  // =======================
  // USER ID (INT)
  // =======================

  static Future<void> saveUserId(int userId) async {
    await _preferences?.setInt(_idKey, userId);
  }

  static int? get userId => _preferences?.getInt(_idKey);

  // =======================
  // FRESHCHAT RESTORE ID
  // =======================

  static Future<void> saveFreshchatRestoreId(String restoreId) async {
    await _preferences?.setString(_freshchatRestoreIdKey, restoreId);
  }

  static String? get freshchatRestoreId =>
      _preferences?.getString(_freshchatRestoreIdKey);

  // =======================
  // LOGOUT
  // =======================

  static Future<void> logoutUser() async {
    await _preferences?.remove(_tokenKey);
    await _preferences?.remove(_refreshTokenKey);
    await _preferences?.remove(_idKey);
    await _preferences?.remove(_freshchatRestoreIdKey);
  }
}
