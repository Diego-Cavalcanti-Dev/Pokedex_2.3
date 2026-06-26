import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/favorite_service.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonName;
  final String pokemonUrl;

  const PokemonDetailPage({
    super.key,
    required this.pokemonName,
    required this.pokemonUrl,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  final FavoriteService favoriteService = FavoriteService();

  bool isLoading = true;
  bool isFavorite = false;
  Map<String, dynamic>? pokemon;

  @override
  void initState() {
    super.initState();
    loadPokemonDetail();
    loadFavorite();
  }

  Future<void> loadPokemonDetail() async {
    try {
      final response = await http.get(Uri.parse(widget.pokemonUrl));

      if (response.statusCode == 200) {
        setState(() {
          pokemon = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadFavorite() async {
    final result = await favoriteService.isFavorite(widget.pokemonName);

    setState(() {
      isFavorite = result;
    });
  }

  Future<void> toggleFavorite() async {
    await favoriteService.toggleFavorite(widget.pokemonName);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonName.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pokemon == null
          ? const Center(child: Text('Erro ao carregar Pokémon'))
          : buildContent(),
    );
  }

  Widget buildContent() {
    final imageUrl =
        pokemon?['sprites']?['other']?['official-artwork']?['front_default'] ??
        pokemon?['sprites']?['front_default'];
    final abilities = pokemon?['abilities'] ?? [];
    final types = pokemon?['types'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (imageUrl != null)
            Image.network(imageUrl, height: 220, fit: BoxFit.contain),

          const SizedBox(height: 16),

          Text(
            widget.pokemonName.toUpperCase(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Card(
            child: ListTile(
              title: const Text('Altura'),
              trailing: Text('${pokemon?['height']}'),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Peso'),
              trailing: Text('${pokemon?['weight']}'),
            ),
          ),

          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tipos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Wrap(
            spacing: 8,
            children: types.map<Widget>((item) {
              return Chip(label: Text(item['type']['name']));
            }).toList(),
          ),

          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Habilidades',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Column(
            children: abilities.map<Widget>((item) {
              return Card(
                child: ListTile(title: Text(item['ability']['name'])),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
