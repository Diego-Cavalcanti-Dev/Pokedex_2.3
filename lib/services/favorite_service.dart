import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorite_pokemons';

  /// Retorna todos os IDs dos Pokémon favoritos.
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Salva a lista de favoritos.
  Future<void> _saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, favorites);
  }

  /// Adiciona um Pokémon aos favoritos.
  Future<void> addFavorite(String pokemonId) async {
    final favorites = await getFavorites();

    if (!favorites.contains(pokemonId)) {
      favorites.add(pokemonId);
      await _saveFavorites(favorites);
    }
  }

  /// Remove um Pokémon dos favoritos.
  Future<void> removeFavorite(String pokemonId) async {
    final favorites = await getFavorites();

    favorites.remove(pokemonId);
    await _saveFavorites(favorites);
  }

  /// Verifica se um Pokémon é favorito.
  Future<bool> isFavorite(String pokemonId) async {
    final favorites = await getFavorites();
    return favorites.contains(pokemonId);
  }

  /// Alterna o estado de favorito.
  /// Se já estiver favoritado, remove.
  /// Caso contrário, adiciona.
  Future<void> toggleFavorite(String pokemonId) async {
    final favorites = await getFavorites();

    if (favorites.contains(pokemonId)) {
      favorites.remove(pokemonId);
    } else {
      favorites.add(pokemonId);
    }

    await _saveFavorites(favorites);
  }

  /// Limpa todos os favoritos.
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
