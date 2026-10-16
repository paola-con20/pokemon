import 'package:practica02/models/pokemon.dart';
import 'package:dio/dio.dart';

class PokemonService {
  PokemonService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Pokemon> getPokemon(String nameOrId) async {
    try {
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon/${nameOrId.toLowerCase()}');
      
      if (response.statusCode == 200) {
        return Pokemon.fromJson(response.data);
      } else {
        throw Exception('Error al obtener datos');
      }
    } catch (e) {
      throw Exception('No se encontró el Pokémon: $e');
    }
  }
}