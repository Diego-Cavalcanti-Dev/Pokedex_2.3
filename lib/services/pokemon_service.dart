import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  // URL base da PokéAPI
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  // Busca os primeiros 20 Pokémons
  Future<List<dynamic>> getPokemons() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?limit=20'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return data['results'];
      } else {
        throw Exception(
          'Erro ao buscar Pokémons. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Busca um Pokémon pelo nome
  Future<Map<String, dynamic>> getPokemonByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/${name.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Pokémon não encontrado.');
      }
    } catch (e) {
      throw Exception('Erro ao buscar Pokémon: $e');
    }
  }
}
