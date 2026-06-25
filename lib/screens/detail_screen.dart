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
  final FavoriteService _favoriteService = FavoriteService();

  bool _isLoading = true;
  bool _isFavorite = false;
  Map<String, dynamic>? _pokemon;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetail();
    _loadFavorite();
  }

  Future<void> _loadPokemonDetail() async {
    try {
      final response = await http.get(Uri.parse(widget.pokemonUrl));

      if (response.statusCode == 200) {
        setState(() {
          _pokemon = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar detalhes do Pokémon');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavorite() async {
    final result = await _favoriteService.isFavorite(widget.pokemonName);

    setState(() {
      _isFavorite = result;
    });
  }

  Future<void> _toggleFavorite() async {
    await _favoriteService.toggleFavorite(widget.pokemonName);

    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '${widget.pokemonName} adicionado aos favoritos'
              : '${widget.pokemonName} removido dos favoritos',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.pokemonName.toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pokemon == null
          ? const Center(child: Text('Não foi possível carregar o Pokémon.'))
          : _buildPokemonContent(),
    );
  }

  Widget _buildPokemonContent() {
    final String imageUrl =
        _pokemon?['sprites']?['front_default'] ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png';

    final int height = _pokemon?['height'] ?? 0;
    final int weight = _pokemon?['weight'] ?? 0;

    final List abilities = _pokemon?['abilities'] ?? [];
    final List types = _pokemon?['types'] ?? [];
    final List stats = _pokemon?['stats'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.network(imageUrl, height: 160, fit: BoxFit.contain),
          const SizedBox(height: 16),

          Text(
            widget.pokemonName.toUpperCase(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Card(
            child: ListTile(
              title: const Text('Altura'),
              trailing: Text('$height'),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Peso'),
              trailing: Text('$weight'),
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
            children: types.map<Widget>((type) {
              return Chip(label: Text(type['type']['name']));
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
            children: abilities.map<Widget>((ability) {
              return Card(
                child: ListTile(title: Text(ability['ability']['name'])),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Column(
            children: stats.map<Widget>((stat) {
              return Card(
                child: ListTile(
                  title: Text(stat['stat']['name']),
                  trailing: Text('${stat['base_stat']}'),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
