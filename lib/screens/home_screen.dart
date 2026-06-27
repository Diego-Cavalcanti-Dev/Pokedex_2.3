import 'package:flutter/material.dart';

import '../services/pokemon_service.dart';
import 'pokemon_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService _pokemonService = PokemonService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> pokemons = [];
  List<dynamic> pokemonosFiltrados = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPokemons();
    _searchController.addListener(_filtrarPokemons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> carregarPokemons() async {
    try {
      pokemons = await _pokemonService.getPokemons();
      pokemonosFiltrados = pokemons;
    } catch (e) {
      debugPrint('Erro ao carregar Pokémons: $e');
    }

    setState(() {
      carregando = false;
    });
  }

  void _filtrarPokemons() {
    final termo = _searchController.text.toLowerCase();

    setState(() {
      if (termo.isEmpty) {
        pokemonosFiltrados = pokemons;
      } else {
        pokemonosFiltrados = pokemons
            .where(
              (pokemon) =>
                  pokemon['name'].toString().toLowerCase().contains(termo),
            )
            .toList();
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar Pokémon...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: pokemonosFiltrados.isEmpty
                      ? const Center(child: Text('Nenhum Pokémon encontrado'))
                      : ListView.builder(
                          itemCount: pokemonosFiltrados.length,
                          itemBuilder: (context, index) {
                            final pokemon = pokemonosFiltrados[index];

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
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.catching_pokemon,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            );
                                          },
                                    ),
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
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                ),
                                onTap: () {
                                  abrirDetalhes(pokemon);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
