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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
