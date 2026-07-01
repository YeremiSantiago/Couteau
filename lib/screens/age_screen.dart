import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import '../theme/app_theme.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});
  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _resultController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  int? _age;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _resultController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _resultController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String get _category {
    if (_age == null) return '';
    if (_age! < 18) return 'Joven';
    if (_age! < 60) return 'Adulto';
    return 'Anciano';
  }

  IconData get _categoryIcon {
    if (_age == null) return Icons.person;
    if (_age! < 18) return Icons.child_care;
    if (_age! < 60) return Icons.person;
    return Icons.elderly;
  }

  List<Color> get _gradientColors {
    if (_age == null) return [AppTheme.bgDeep, const Color(0xFF1A1F3C)];
    if (_age! < 18) return [const Color(0xFF1B5E20), const Color(0xFF66BB6A)];
    if (_age! < 60) return [const Color(0xFFE65100), const Color(0xFFFFCA28)];
    return [const Color(0xFF4A148C), const Color(0xFFCE93D8)];
  }

  Future<void> _predict() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _loading = true; _error = null; _age = null; });
    _resultController.reset();
    try {
      final data = await ApiService.predictAge(_controller.text.trim());
      setState(() {
        _age = data['age'] as int?;
        _loading = false;
      });
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
            colors: _gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Predictor de Edad',
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
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                        child: Container(
                          key: ValueKey(_category),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                          ),
                          child: Icon(_categoryIcon, size: 64, color: Colors.white),
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
                            prefixIcon: Icon(Icons.face, color: Colors.white70),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          ),
                          onSubmitted: (_) => _predict(),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      if (_error != null)
                        Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                      if (_age != null)
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
                                  // Contador animado de edad
                                  TweenAnimationBuilder<int>(
                                    tween: IntTween(begin: 0, end: _age!),
                                    duration: const Duration(milliseconds: 1000),
                                    builder: (ctx, val, _) => Text(
                                      '$val años',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _category,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _age! < 18
                                        ? '🌱 Etapa de crecimiento y aprendizaje'
                                        : _age! < 60
                                        ? '💼 En la plenitud de la vida'
                                        : '🌟 Lleno de sabiduría y experiencia',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white70, fontSize: 14),
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