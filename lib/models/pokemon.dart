class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final String imageUrl;
  final String animatedGifUrl;
  final String cryAudioUrl;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.animatedGifUrl,
    required this.cryAudioUrl,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> typesList = (json['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    List<String> abilitiesList = (json['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();

    Map<String, int> statsMap = {};
    for (var stat in (json['stats'] as List)) {
      statsMap[stat['stat']['name'].toString()] = stat['base_stat'] as int;
    }

    String idStr = json['id'].toString();
    
    // GIF ANIMADO SHOWDOWN
    String gif = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/$idStr.gif";
    
    // ARTWORK OFICIAL
    String officialArt = json['sprites']['other']['official-artwork']['front_default'] ?? '';

    // RUGBIDO / AUDIO OFICIAL POKÉAPI
    String cry = "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/$idStr.ogg";

    return Pokemon(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      imageUrl: officialArt,
      animatedGifUrl: gif,
      cryAudioUrl: cry,
      types: typesList,
      abilities: abilitiesList,
      stats: statsMap,
    );
  }
}