import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});
  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _pokeballController;
  late AnimationController _cardController;
  late AnimationController _shakeController;
  late Animation<double> _cardFade;
  late Animation<double> _cardScale;
  late Animation<double> _shakeAnim;

  Map<String, dynamic>? _pokemon;
  bool _loading = false;
  String? _error;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, Color> _typeColors = {
    'fire': const Color(0xFFFF6B35),
    'water': const Color(0xFF4A90D9),
    'grass': const Color(0xFF56C02B),
    'electric': const Color(0xFFF7C948),
    'psychic': const Color(0xFFFF5F8D),
    'ice': const Color(0xFF74CEC0),
    'dragon': const Color(0xFF7038F8),
    'dark': const Color(0xFF5A5465),
    'fairy': const Color(0xFFEE99AC),
    'fighting': const Color(0xFFC03028),
    'poison': const Color(0xFFA040A0),
    'ground': const Color(0xFFE0C068),
    'flying': const Color(0xFF89AAE3),
    'bug': const Color(0xFFA8B820),
    'rock': const Color(0xFFB8A038),
    'ghost': const Color(0xFF705898),
    'steel': const Color(0xFFB8B8D0),
    'normal': const Color(0xFFA8A878),
  };

  @override
  void initState() {
    super.initState();
    _pokeballController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeOut);
    _cardScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    _shakeAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _pokeballController.dispose();
    _cardController.dispose();
    _shakeController.dispose();
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _playCry() {
    if (_pokemon != null && _pokemon!['cries'] != null) {
      final cryUrl = _pokemon!['cries']['latest'];
      if (cryUrl != null) {
        _audioPlayer.play(UrlSource(cryUrl));
      }
    }
  }

  Future<void> _search() async {
    final name = _controller.text.trim().toLowerCase();
    if (name.isEmpty) return;
    setState(() { _loading = true; _error = null; _pokemon = null; });
    _cardController.reset();
    try {
      final data = await ApiService.getPokemon(name);
      if (data == null) {
        setState(() { _error = 'Pokémon no encontrado'; _loading = false; });
        _shakeController.forward(from: 0);
        return;
      }
      setState(() { _pokemon = data; _loading = false; });
      _cardController.forward();
    } catch (e) {
      setState(() { _error = 'Error al conectar'; _loading = false; });
    }
  }

  Color get _primaryColor {
    if (_pokemon == null) return const Color(0xFF1A1F3C);
    final types = _pokemon!['types'] as List;
    final typeName = types.first['type']['name'] as String;
    return _typeColors[typeName] ?? const Color(0xFF1A1F3C);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _pokemon != null ? _primaryColor.withOpacity(0.8) : const Color(0xFF1A0A0A),
              const Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text('Pokédex',
                          style: TextStyle(color: Colors.white, fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    // Pokeball giratoria
                    AnimatedBuilder(
                      animation: _pokeballController,
                      builder: (_, child) => Transform.rotate(
                        angle: _loading
                            ? _pokeballController.value * 2 * math.pi
                            : 0,
                        child: child,
                      ),
                      child: const Text('⚪', style: TextStyle(fontSize: 28)),
                    ),
                  ],
                ),
              ),
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedBuilder(
                  animation: _shakeAnim,
                  builder: (ctx, child) => Transform.translate(
                    offset: Offset(_shakeController.isAnimating ? _shakeAnim.value : 0, 0),
                    child: child,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.25)),
                          ),
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'pikachu, charizard, mewtwo...',
                              hintStyle: TextStyle(color: Colors.white38),
                              prefixIcon: Icon(Icons.catching_pokemon, color: Colors.white54),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            onSubmitted: (_) => _search(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _loading ? null : _search,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _loading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pokeballController,
                        builder: (_, __) => Transform.rotate(
                          angle: _pokeballController.value * 2 * math.pi,
                          child: const Text('⚪', style: TextStyle(fontSize: 60)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Buscando...', style: TextStyle(color: Colors.white60)),
                    ],
                  ),
                )
                    : _error != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('❌', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(_error!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
                    ],
                  ),
                )
                    : _pokemon == null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pokeballController,
                        builder: (_, child) => Transform.rotate(
                          angle: _pokeballController.value * 2 * math.pi,
                          child: child,
                        ),
                        child: const Text('⚪', style: TextStyle(fontSize: 80)),
                      ),
                      const SizedBox(height: 16),
                      const Text('Escribe el nombre de un Pokémon',
                          style: TextStyle(color: Colors.white60)),
                    ],
                  ),
                )
                    : _buildPokemonCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonCard() {
    final name = _pokemon!['name'] as String;
    final id = _pokemon!['id'] as int;
    final types = (_pokemon!['types'] as List)
        .map((t) => t['type']['name'] as String)
        .toList();
    final stats = _pokemon!['stats'] as List;
    final abilities = (_pokemon!['abilities'] as List)
        .map((a) => a['ability']['name'] as String)
        .toList();
    final spriteUrl = _pokemon!['sprites']['other']['official-artwork']['front_default']
        ?? _pokemon!['sprites']['front_default'];
    final baseExp = _pokemon!['base_experience'];
    final height = (_pokemon!['height'] as int) / 10;
    final weight = (_pokemon!['weight'] as int) / 10;

    return FadeTransition(
      opacity: _cardFade,
      child: ScaleTransition(
        scale: _cardScale,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Header card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _primaryColor.withOpacity(0.5), width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('#${id.toString().padLeft(3, '0')}',
                            style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                        Row(
                          children: types.map((t) => Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: (_typeColors[t] ?? Colors.grey).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(t.toUpperCase(),
                                style: const TextStyle(color: Colors.white,
                                    fontSize: 11, fontWeight: FontWeight.bold)),
                          )).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Sprite con animación flotante
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: -8, end: 8),
                      duration: const Duration(seconds: 2),
                      builder: (ctx, val, child) => Transform.translate(
                        offset: Offset(0, val),
                        child: child,
                      ),
                      onEnd: () => setState(() {}),
                      child: spriteUrl != null
                          ? Image.network(spriteUrl, height: 150, fit: BoxFit.contain)
                          : const Icon(Icons.catching_pokemon, size: 100, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name[0].toUpperCase() + name.substring(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_pokemon!['cries'] != null && _pokemon!['cries']['latest'] != null)
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: Colors.white70),
                            onPressed: _playCry,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Info row
              Row(
                children: [
                  Expanded(child: _infoChip('⚡ Exp Base', '$baseExp')),
                  const SizedBox(width: 8),
                  Expanded(child: _infoChip('📏 Altura', '${height}m')),
                  const SizedBox(width: 8),
                  Expanded(child: _infoChip('⚖️ Peso', '${weight}kg')),
                ],
              ),
              const SizedBox(height: 12),
              // Habilidades
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HABILIDADES',
                        style: TextStyle(color: Colors.white60, fontSize: 11, letterSpacing: 1.5)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: abilities.map((a) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _primaryColor.withOpacity(0.5)),
                        ),
                        child: Text(a, style: const TextStyle(color: Colors.white, fontSize: 13)),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ESTADÍSTICAS',
                        style: TextStyle(color: Colors.white60, fontSize: 11, letterSpacing: 1.5)),
                    const SizedBox(height: 12),
                    ...stats.map((s) {
                      final statName = s['stat']['name'] as String;
                      final value = s['base_stat'] as int;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 90,
                              child: Text(
                                statName.replaceAll('-', ' ').toUpperCase(),
                                style: const TextStyle(color: Colors.white60, fontSize: 10),
                              ),
                            ),
                            SizedBox(
                              width: 36,
                              child: Text('$value',
                                  style: const TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: (value / 255).clamp(0, 1)),
                                  duration: const Duration(milliseconds: 900),
                                  builder: (ctx, val, _) => LinearProgressIndicator(
                                    value: val,
                                    minHeight: 6,
                                    backgroundColor: Colors.white12,
                                    valueColor: AlwaysStoppedAnimation(
                                      value > 80 ? Colors.greenAccent :
                                      value > 50 ? Colors.yellowAccent : Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}