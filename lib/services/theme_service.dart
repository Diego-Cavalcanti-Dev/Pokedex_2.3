import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _temaEscuroKey = 'temaEscuro';
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  bool obterTemaEscuro() {
    return _preferences.getBool(_temaEscuroKey) ?? false;
  }

  Future<void> definirTemaEscuro(bool valor) async {
    await _preferences.setBool(_temaEscuroKey, valor);
  }
}
