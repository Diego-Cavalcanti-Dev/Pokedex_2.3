import 'package:flutter/material.dart';

import '../services/favorite_service.dart';
import 'pokemon_detail_page.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _favoriteService = FavoriteService();

  bool _isLoading = true;
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoriteService.getFavorites();

    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(String pokemonName) async {
    await _favoriteService.removeFavorite(pokemonName);
    await _loadFavorites();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$pokemonName removido dos favoritos')),
    );
  }

  String _getPokemonUrl(String pokemonName) {
    return 'https://pokeapi.co/api/v2/pokemon/$pokemonName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Meus Favoritos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? const Center(
              child: Text(
                'Nenhum Pokémon favoritado ainda.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: ListView.builder(
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final pokemonName = _favorites[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: Text(
                        pokemonName.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Toque para ver detalhes'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeFavorite(pokemonName);
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PokemonDetailPage(
                              pokemonName: pokemonName,
                              pokemonUrl: _getPokemonUrl(pokemonName),
                            ),
                          ),
                        );

                        await _loadFavorites();
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
