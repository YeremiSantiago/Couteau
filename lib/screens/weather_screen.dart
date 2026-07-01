import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'dart:math' as math;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  late AnimationController _sunController;
  late AnimationController _cloudController;
  late AnimationController _cardController;
  late Animation<double> _cardFade;

  Map<String, dynamic>? _weather;
  bool _loading = true;
  String? _error;

  // Coordenadas Santo Domingo, RD
  static const double _lat = 18.4861;
  static const double _lon = -69.9312;

  @override
  void initState() {
    super.initState();
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardFade = CurvedAnimation(parent: _cardController, curve: Curves.easeOut);
    _fetchWeather();
  }

  @override
  void dispose() {
    _sunController.dispose();
    _cloudController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await ApiService.getWeather(_lat, _lon);
      setState(() { _weather = data; _loading = false; });
      _cardController.forward();
    } catch (e) {
      setState(() { _error = 'Error al obtener el clima'; _loading = false; });
    }
  }

  String _weatherDesc(int code) {
    if (code == 0) return 'Despejado';
    if (code <= 3) return 'Parcialmente nublado';
    if (code <= 48) return 'Nublado / Niebla';
    if (code <= 67) return 'Lluvia';
    if (code <= 77) return 'Nieve';
    if (code <= 82) return 'Chubascos';
    return 'Tormenta';
  }

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code <= 48) return Icons.foggy;
    if (code <= 67) return Icons.grain;
    if (code <= 82) return Icons.umbrella;
    return Icons.thunderstorm;
  }

  String _dayName(String dateStr, int i) {
    if (i == 0) return 'Hoy';
    if (i == 1) return 'Mañana';
    final days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    final date = DateTime.parse(dateStr);
    return days[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final current = _weather?['current'];
    final daily = _weather?['daily'];
    final code = current != null ? (current['weathercode'] as num).toInt() : 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0277BD), Color(0xFF01579B), Color(0xFF002F6C)],
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _error != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_error!, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          )
              : Stack(
            children: [
              // Sol animado
              Positioned(
                top: 40,
                right: 30,
                child: AnimatedBuilder(
                  animation: _sunController,
                  builder: (_, child) => Transform.rotate(
                    angle: _sunController.value * 2 * math.pi,
                    child: child,
                  ),
                  child: Icon(
                    Icons.wb_sunny,
                    size: 80,
                    color: Colors.yellow.withOpacity(0.3),
                  ),
                ),
              ),
              // Nube flotante
              AnimatedBuilder(
                animation: _cloudController,
                builder: (_, child) => Positioned(
                  top: 80 + (_cloudController.value * 10),
                  left: 20,
                  child: child!,
                ),
                child: Icon(
                  Icons.cloud,
                  size: 60,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              // Contenido
              Column(
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
                          child: Text('Clima en RD',
                              style: TextStyle(color: Colors.white, fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _fetchWeather,
                        ),
                      ],
                    ),
                  ),
                  // Ciudad
                  const Text(
                    'Santo Domingo',
                    style: TextStyle(color: Colors.white, fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'República Dominicana',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  // Temp principal
                  FadeTransition(
                    opacity: _cardFade,
                    child: Column(
                      children: [
                        Icon(_weatherIcon(code), size: 80, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          '${current?['temperature_2m']?.toStringAsFixed(0) ?? '--'}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text(
                          _weatherDesc(code),
                          style: const TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stats row
                  FadeTransition(
                    opacity: _cardFade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statChip(Icons.water_drop, '${current?['relative_humidity_2m'] ?? '--'}%', 'Humedad'),
                          _statChip(Icons.air, '${current?['wind_speed_10m']?.toStringAsFixed(0) ?? '--'} km/h', 'Viento'),
                          _statChip(Icons.thermostat,
                              '${daily?['temperature_2m_max']?[0]?.toStringAsFixed(0) ?? '--'}°/'
                                  '${daily?['temperature_2m_min']?[0]?.toStringAsFixed(0) ?? '--'}°',
                              'Max/Min'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Pronóstico 5 días
                  if (daily != null)
                    Expanded(
                      child: FadeTransition(
                        opacity: _cardFade,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PRONÓSTICO 5 DÍAS',
                                  style: TextStyle(color: Colors.white60, fontSize: 12,
                                      letterSpacing: 1.5)),
                              const SizedBox(height: 12),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (ctx, i) {
                                    final dayCode = (daily['weathercode'][i] as num).toInt();
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 400 + i * 100),
                                      builder: (ctx, val, child) => Opacity(
                                        opacity: val,
                                        child: Transform.translate(
                                          offset: Offset(20 * (1 - val), 0),
                                          child: child,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              child: Text(
                                                _dayName(daily['time'][i], i),
                                                style: const TextStyle(color: Colors.white,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            Icon(_weatherIcon(dayCode),
                                                color: Colors.white70, size: 22),
                                            const Spacer(),
                                            Text(
                                              '${daily['temperature_2m_min'][i]?.toStringAsFixed(0)}°',
                                              style: const TextStyle(color: Colors.white60),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${daily['temperature_2m_max'][i]?.toStringAsFixed(0)}°',
                                              style: const TextStyle(color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold, fontSize: 13)),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        ],
      ),
    );
  }
}