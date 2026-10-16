import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica02/main.dart';
import 'package:practica02/models/pokemon.dart';
import 'package:practica02/services/pokemon_service.dart';

class FakePokemonService extends PokemonService {
  @override
  Future<Pokemon> getPokemon(String nameOrId) async {
    return Pokemon(
      id: 25,
      name: 'pikachu',
      height: 4,
      weight: 60,
      imageUrl: 'https://example.com/pikachu.png',
      animatedGifUrl: 'https://example.com/pikachu.gif',
      cryAudioUrl: 'https://example.com/pikachu.ogg',
      types: const ['electric'],
      abilities: const ['static', 'lightning-rod'],
      stats: const {
        'hp': 35,
        'attack': 55,
        'defense': 40,
        'special-attack': 50,
        'special-defense': 50,
        'speed': 90,
      },
    );
  }
}

void main() {
  testWidgets('La app muestra la cabecera de la Pokédex', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PokemonHomeScreen(pokemonService: FakePokemonService()),
      ),
    );

    expect(find.text('POKÉDEX'), findsOneWidget);
    expect(find.text('Buscar'), findsOneWidget);
  });
}
