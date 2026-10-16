import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'models/pokemon.dart';
import 'services/pokemon_service.dart';

void main() => runApp(const ProPokedexApp());

class ProPokedexApp extends StatelessWidget {
  const ProPokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéDex Ultra Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030712),
        colorSchemeSeed: const Color(0xFFEF4444),
      ),
      home: const PokemonHomeScreen(),
    );
  }
}

class PokemonHomeScreen extends StatefulWidget {
  final PokemonService? pokemonService;

  const PokemonHomeScreen({super.key, this.pokemonService});

  @override
  State<PokemonHomeScreen> createState() => _PokemonHomeScreenState();
}

class _PokemonHomeScreenState extends State<PokemonHomeScreen> {
  late final PokemonService _pokemonService;
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  late Future<Pokemon> _pokemonFuture;
  int _currentId = 1;

  @override
  void initState() {
    super.initState();
    _pokemonService = widget.pokemonService ?? PokemonService();
    _loadPokemon('1');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playCry(String cryUrl) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(cryUrl));
    } catch (_) {}
  }

  void _loadPokemon(String query) {
    setState(() {
      _pokemonFuture = _pokemonService.getPokemon(query).then((pokemon) {
        _currentId = pokemon.id;
        _playCry(pokemon.cryAudioUrl);
        return pokemon;
      });
    });
  }

  void _search() {
    if (_searchController.text.isNotEmpty) {
      _loadPokemon(_searchController.text.trim());
    }
  }

  void _previousPokemon() {
    if (_currentId > 1) {
      _loadPokemon((_currentId - 1).toString());
    }
  }

  void _nextPokemon() {
    _loadPokemon((_currentId + 1).toString());
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return const Color(0xFF10B981);
      case 'poison': return const Color(0xFFA855F7);
      case 'fire': return const Color(0xFFEF4444);
      case 'water': return const Color(0xFF3B82F6);
      case 'electric': return const Color(0xFFF59E0B);
      case 'bug': return const Color(0xFF84CC16);
      case 'normal': return const Color(0xFF9CA3AF);
      case 'flying': return const Color(0xFF06B6D4);
      default: return const Color(0xFF6366F1);
    }
  }

  Color _getAbilityColor(String ability) {
    final name = ability.toLowerCase();

    if (name.contains('chlorophyll') || name.contains('solar') || name.contains('rain') || name.contains('drizzle') || name.contains('drought') || name.contains('sand') || name.contains('leaf') || name.contains('overgrow')) {
      return const Color(0xFF10B981);
    }

    if (name.contains('blaze') || name.contains('guts') || name.contains('huge-power') || name.contains('pure-power') || name.contains('sheer-force') || name.contains('flash-fire') || name.contains('flame')) {
      return const Color(0xFFEF4444);
    }

    if (name.contains('torrent') || name.contains('water') || name.contains('swift-swim') || name.contains('damp') || name.contains('hydration')) {
      return const Color(0xFF3B82F6);
    }

    if (name.contains('shield') || name.contains('sturdy') || name.contains('regenerator') || name.contains('natural-cure') || name.contains('magic') || name.contains('thick-fat')) {
      return const Color(0xFFEC4899);
    }

    if (name.contains('static') || name.contains('speed') || name.contains('lightning') || name.contains('volt') || name.contains('motor') || name.contains('levitate')) {
      return const Color(0xFFF59E0B);
    }

    return const Color(0xFF8B5CF6);
  }

  String _formatStatName(String rawName) {
    switch (rawName.toLowerCase()) {
      case 'hp': return 'HP';
      case 'attack': return 'ATAQUE';
      case 'defense': return 'DEFENSA';
      case 'special-attack': return 'SP. ATAQUE';
      case 'special-defense': return 'SP. DEFENSA';
      case 'speed': return 'VELOCIDAD';
      default: return rawName.toUpperCase();
    }
  }

  String _getStatEmoji(String rawName) {
    switch (rawName.toLowerCase()) {
      case 'hp': return '❤️';
      case 'attack': return '⚔️';
      case 'defense': return '🛡️';
      case 'special-attack': return '💥';
      case 'special-defense': return '🔰';
      case 'speed': return '⚡';
      default: return '📊';
    }
  }

  Color _getStatColor(int stat) {
    if (stat >= 90) return const Color(0xFF10B981);
    if (stat >= 65) return const Color(0xFF0EA5E9);
    if (stat >= 45) return const Color(0xFF8B5CF6);
    return const Color(0xFFF43F5E);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.9),
            border: Border(
              bottom: BorderSide(
                color: Colors.redAccent.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 1.5),
                    ),
                    child: const Icon(Icons.catching_pokemon, color: Colors.redAccent, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'POKÉDEX',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: 2.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'DATABASE SYSTEM v2.4',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF10B981), width: 1),
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                        SizedBox(width: 6),
                        Text(
                          'ONLINE',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // BARRA DE BÚSQUEDA CYBER-TECH
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Icon(Icons.radar, color: Colors.redAccent, size: 22),
                      ),
                      hintText: '⚡ RASTREAR POKÉMON (EJ: PIKACHU O 25)...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.6),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.center_focus_strong, color: Colors.white, size: 22),
                          onPressed: _search,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(height: 24),

                FutureBuilder<Pokemon>(
                  future: _pokemonFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const PokeballOpeningAnimation();
                    }

                    if (snapshot.hasError) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red.shade900.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        child: Text(
                          'Error en base de datos: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      final pokemon = snapshot.data!;
                      final mainTypeColor = pokemon.types.isNotEmpty
                          ? _getTypeColor(pokemon.types.first)
                          : Colors.redAccent;

                      return SequentialCenterPokemonView(
                        key: ValueKey<int>(pokemon.id),
                        pokemon: pokemon,
                        mainTypeColor: mainTypeColor,
                        getTypeColor: _getTypeColor,
                        getAbilityColor: _getAbilityColor,
                        formatStatName: _formatStatName,
                        getStatEmoji: _getStatEmoji,
                        getStatColor: _getStatColor,
                        onPlayCry: () => _playCry(pokemon.cryAudioUrl),
                        onPrevious: _previousPokemon,
                        onNext: _nextPokemon,
                        currentId: _currentId,
                      );
                    }

                    return const Text('Ingresa un Pokémon para buscar.');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SequentialCenterPokemonView extends StatefulWidget {
  final Pokemon pokemon;
  final Color mainTypeColor;
  final Color Function(String) getTypeColor;
  final Color Function(String) getAbilityColor;
  final String Function(String) formatStatName;
  final String Function(String) getStatEmoji;
  final Color Function(int) getStatColor;
  final VoidCallback onPlayCry;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final int currentId;

  const SequentialCenterPokemonView({
    super.key,
    required this.pokemon,
    required this.mainTypeColor,
    required this.getTypeColor,
    required this.getAbilityColor,
    required this.formatStatName,
    required this.getStatEmoji,
    required this.getStatColor,
    required this.onPlayCry,
    required this.onPrevious,
    required this.onNext,
    required this.currentId,
  });

  @override
  State<SequentialCenterPokemonView> createState() => _SequentialCenterPokemonViewState();
}

class _SequentialCenterPokemonViewState extends State<SequentialCenterPokemonView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pokemonScale;
  late Animation<double> _detailsFade;
  late Animation<Offset> _detailsSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _pokemonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _detailsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn),
      ),
    );

    _detailsSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: widget.mainTypeColor.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 550;

              final pokemonCard = ScaleTransition(
                scale: _pokemonScale,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B132B),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: widget.mainTypeColor.withOpacity(0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.redAccent, width: 1.5),
                        ),
                        child: Text(
                          '#${widget.pokemon.id}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      UniqueAnimatedPokemonImage(
                        gifUrl: widget.pokemon.animatedGifUrl,
                        imageUrl: widget.pokemon.imageUrl,
                        pokemonId: widget.pokemon.id,
                        onTapSound: widget.onPlayCry,
                      ),
                    ],
                  ),
                ),
              );

              final detailsContent = FadeTransition(
                opacity: _detailsFade,
                child: SlideTransition(
                  position: _detailsSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.pokemon.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: Colors.cyanAccent),
                            tooltip: 'Escuchar rugido',
                            onPressed: widget.onPlayCry,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8.0,
                        runSpacing: 6.0,
                        children: widget.pokemon.types.map((t) {
                          final color = widget.getTypeColor(t);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: Text(
                              t.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 0.8,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildMiniCard(
                              icon: Icons.straighten_rounded,
                              label: 'ALTURA',
                              value: '${widget.pokemon.height / 10} m',
                              color: Colors.cyanAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildMiniCard(
                              icon: Icons.scale_rounded,
                              label: 'PESO',
                              value: '${widget.pokemon.weight / 10} kg',
                              color: Colors.amberAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'HABILIDADES TÁCTICAS',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: widget.pokemon.abilities.map((a) {
                                final abilityColor = widget.getAbilityColor(a);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: abilityColor.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: abilityColor, width: 1.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: abilityColor.withOpacity(0.2),
                                        blurRadius: 6,
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    a.toUpperCase(),
                                    style: TextStyle(
                                      color: abilityColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pokemonCard,
                    const SizedBox(width: 22),
                    Expanded(child: detailsContent),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Center(child: pokemonCard),
                    const SizedBox(height: 20),
                    detailsContent,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          FadeTransition(
            opacity: _detailsFade,
            child: SlideTransition(
              position: _detailsSlide,
              child: Column(
                children: [
                  Divider(color: Colors.white.withOpacity(0.1)),
                  const SizedBox(height: 14),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ESTADÍSTICAS BASE DE COMBATE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.22,
                    ),
                    itemCount: widget.pokemon.stats.length,
                    itemBuilder: (context, index) {
                      final entry = widget.pokemon.stats.entries.elementAt(index);
                      final statName = widget.formatStatName(entry.key);
                      final emoji = widget.getStatEmoji(entry.key);
                      final statColor = widget.getStatColor(entry.value);
                      final progressFactor = (entry.value / 100.0).clamp(0.02, 1.0);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B132B),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: statColor.withOpacity(0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: statColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: statColor.withOpacity(0.25),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: statColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: AnimatedEmoji(emoji: emoji),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    statName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${entry.value}',
                                style: TextStyle(
                                  color: statColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 28,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),

                            Container(
                              height: 22,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: statColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Stack(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 600),
                                        curve: Curves.easeOutCubic,
                                        width: constraints.maxWidth * progressFactor,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(0.9),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: CyberButton(
                          label: 'ANTERIOR',
                          icon: Icons.arrow_back_ios_new_rounded,
                          isNext: false,
                          isEnabled: widget.currentId > 1,
                          onPressed: widget.currentId > 1 ? widget.onPrevious : null,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: CyberButton(
                          label: 'SIGUIENTE',
                          icon: Icons.arrow_forward_ios_rounded,
                          isNext: true,
                          isEnabled: true,
                          onPressed: widget.onNext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CyberButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isNext;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const CyberButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isNext,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  State<CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<CyberButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isNext
        ? const Color(0xFFEF4444)
        : const Color(0xFF06B6D4);

    final darkBg = widget.isNext
        ? const Color(0xFF991B1B)
        : const Color(0xFF0891B2);

    return Opacity(
      opacity: widget.isEnabled ? 1.0 : 0.4,
      child: InkWell(
        onTap: widget.isEnabled ? widget.onPressed : null,
        onHighlightChanged: (isPressed) {
          setState(() {
            _isHovered = isPressed;
          });
        },
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isEnabled
                  ? [
                      primaryColor.withOpacity(_isHovered ? 0.9 : 0.75),
                      darkBg.withOpacity(0.9),
                    ]
                  : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.isEnabled ? primaryColor : Colors.white10,
              width: 1.8,
            ),
            boxShadow: widget.isEnabled
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(_isHovered ? 0.8 : 0.45),
                      blurRadius: _isHovered ? 20 : 12,
                      spreadRadius: _isHovered ? 2 : 1,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.isNext
                ? [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 14),
                    ),
                  ]
                : [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ],
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}

class PokeballOpeningAnimation extends StatefulWidget {
  const PokeballOpeningAnimation({super.key});

  @override
  State<PokeballOpeningAnimation> createState() => _PokeballOpeningAnimationState();
}

class _PokeballOpeningAnimationState extends State<PokeballOpeningAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _openAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _openAnimation = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _openAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.6),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, _openAnimation.value),
                    child: Container(
                      width: 90,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -_openAnimation.value),
                    child: Container(
                      width: 90,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(45)),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 4),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'ABRIENDO POKÉBOLA...',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}

class UniqueAnimatedPokemonImage extends StatelessWidget {
  final String gifUrl;
  final String imageUrl;
  final int pokemonId;
  final VoidCallback onTapSound;

  const UniqueAnimatedPokemonImage({
    super.key,
    required this.gifUrl,
    required this.imageUrl,
    required this.pokemonId,
    required this.onTapSound,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapSound,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              height: 18,
              width: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 14,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Image.network(
            gifUrl,
            height: 190,
            width: 190,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(imageUrl, height: 190, width: 190);
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedEmoji extends StatefulWidget {
  final String emoji;

  const AnimatedEmoji({super.key, required this.emoji});

  @override
  State<AnimatedEmoji> createState() => _AnimatedEmojiState();
}

class _AnimatedEmojiState extends State<AnimatedEmoji> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        widget.emoji,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}