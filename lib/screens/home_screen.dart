import 'package:flutter/material.dart';

import '../services/pokemon_service.dart';
import 'favorites_screen.dart';
import 'pokemon_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService _pokemonService = PokemonService();

  List<dynamic> pokemons = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPokemons();
  }

  Future<void> carregarPokemons() async {
    try {
      pokemons = await _pokemonService.getPokemons();
    } catch (e) {
      debugPrint('Erro ao carregar Pokémons: $e');
    }

    setState(() {
      carregando = false;
    });
  }

  void abrirDetalhes(Map<String, dynamic> pokemon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PokemonDetailPage(
          pokemonName: pokemon['name'],
          pokemonUrl: pokemon['url'],
        ),
      ),
    );
  }

  void abrirFavoritos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: abrirFavoritos,
          ),
        ],
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.red.shade100,
                      child: const Icon(
                        Icons.catching_pokemon,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                      pokemon['name'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text('Toque para ver detalhes'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      abrirDetalhes(pokemon);
                    },
                  ),
                );
              },
            ),
    );
  }
}
