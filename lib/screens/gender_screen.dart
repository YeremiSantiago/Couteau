import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import '../theme/app_theme.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});
  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _bgController;
  late AnimationController _resultController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  String? _gender;
  double? _probability;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _resultController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _resultController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _loading = true; _error = null; _gender = null; });
    _resultController.reset();
    try {
      final data = await ApiService.predictGender(_controller.text.trim());
      setState(() {
        _gender = data['gender'];
        _probability = (data['probability'] as num).toDouble();
        _loading = false;
      });
      _bgController.forward(from: 0);
      _resultController.forward();
    } catch (e) {
      setState(() { _error = 'Error al conectar'; _loading = false; });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _gender == null
                ? [AppTheme.bgDeep, const Color(0xFF1A1F3C)]
                : _gender == 'male'
                ? [const Color(0xFF0D47A1), const Color(0xFF42A5F5)]
                : [const Color(0xFF880E4F), const Color(0xFFF48FB1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar custom
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Predictor de Género',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icono animado
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 800),
                        builder: (ctx, val, child) => Opacity(
                          opacity: val,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - val)),
                            child: child,
                          ),
                        ),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              _gender == 'male'
                                  ? Icons.male
                                  : _gender == 'female'
                                  ? Icons.female
                                  : Icons.person,
                              key: ValueKey(_gender),
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Escribe un nombre...',
                            hintStyle: TextStyle(color: Colors.white60),
                            prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          ),
                          onSubmitted: (_) => _predict(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botón
                      GestureDetector(
                        onTap: _loading ? null : _predict,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(_loading ? 0.1 : 0.25),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.5)),
                          ),
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                              width: 24, height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : const Text('Predecir',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Resultado
                      if (_error != null)
                        Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                      if (_gender != null)
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: ScaleTransition(
                            scale: _scaleAnim,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.4)),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _gender == 'male' ? '♂ Masculino' : '♀ Femenino',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Probabilidad: ${((_probability ?? 0) * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: _probability ?? 0),
                                      duration: const Duration(milliseconds: 800),
                                      builder: (ctx, val, _) => LinearProgressIndicator(
                                        value: val,
                                        minHeight: 8,
                                        backgroundColor: Colors.white24,
                                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}