import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_gradient_bg.dart';
import 'gender_screen.dart';
import 'age_screen.dart';
import 'universities_screen.dart';
import 'weather_screen.dart';
import 'pokemon_screen.dart';
import 'wordpress_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _toolboxCtrl;
  late Animation<double> _toolboxBounce;

  final List<_ToolItem> tools = [
    _ToolItem(icon: Icons.wc_rounded,             label: 'Género',         subtitle: 'Predice tu género',        gradient: AppTheme.gradientGender,  index: 0),
    _ToolItem(icon: Icons.cake_rounded,           label: 'Edad',           subtitle: 'Joven, adulto o anciano',  gradient: AppTheme.gradientAge,     index: 1),
    _ToolItem(icon: Icons.school_rounded,         label: 'Universidades',  subtitle: 'Por país',                 gradient: AppTheme.gradientUni,     index: 2),
    _ToolItem(icon: Icons.wb_sunny_rounded,       label: 'Clima RD',       subtitle: 'Tiempo en RD hoy',         gradient: AppTheme.gradientWeather, index: 3),
    _ToolItem(icon: Icons.catching_pokemon,       label: 'Pokémon',        subtitle: 'Info + sonido',            gradient: AppTheme.gradientPokemon, index: 4),
    _ToolItem(icon: Icons.article_rounded,        label: 'CSS-Tricks',     subtitle: 'Últimas noticias',         gradient: AppTheme.gradientWP,      index: 5),
    _ToolItem(icon: Icons.person_rounded,         label: 'Acerca de',      subtitle: 'Mi información',           gradient: AppTheme.gradientAbout,   index: 6),
  ];

  @override
  void initState() {
    super.initState();
    _toolboxCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _toolboxBounce = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _toolboxCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _toolboxCtrl.dispose();
    super.dispose();
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0: Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, a, __) => const GenderScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ));
      break;
      case 1: Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, a, __) => const AgeScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ));
      break;
      case 2: Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, a, __) => const UniversitiesScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ));
      break;
      case 3: Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, a, __) => const WeatherScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
      break;
      case 4: Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, a, __) => const PokemonScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ));
      break;
      case 5: Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, a, __) => const WordpressScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
      break;
      case 6:
        Navigator.push(context, _buildRoute(const AboutScreen()));
        break;
    }
  }

  PageRoute _buildRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => screen,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        colors: AppTheme.gradientHome,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ──────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toolbox animada
                      Center(
                        child: AnimatedBuilder(
                          animation: _toolboxBounce,
                          builder: (_, __) => Transform.translate(
                            offset: Offset(0, _toolboxBounce.value),
                            child: _ToolboxHero(),
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),

                      const SizedBox(height: 28),

                      Text('Caja de\nHerramientas',
                        style: Theme.of(context).textTheme.displayLarge,
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms)
                          .slideX(begin: -0.2, end: 0),

                      const SizedBox(height: 8),

                      Text('Selecciona una herramienta para comenzar',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ).animate().fadeIn(delay: 350.ms, duration: 500.ms),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Grid de tools ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, i) => _ToolCard(
                      item: tools[i],
                      onTap: () => _navigate(context, tools[i].index),
                    ).animate(delay: (100 * i).ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.15, end: 0),
                    childCount: tools.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Toolbox SVG / Icon animado ──────────────────────────────────────────────
class _ToolboxHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: AppTheme.gradientHome,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentCyan.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/toolbox.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ── Tool Card ───────────────────────────────────────────────────────────────
class _ToolCard extends StatefulWidget {
  final _ToolItem item;
  final VoidCallback onTap;
  const _ToolCard({required this.item, required this.onTap});

  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1, end: 0.93).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: GlassCard(
          borderGradient: widget.item.gradient,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono con fondo degradado
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: widget.item.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.item.gradient[0].withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(widget.item.icon, color: Colors.white, size: 26),
              ),

              const Spacer(),

              Text(widget.item.label,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(widget.item.subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Arrow chip
              Row(
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: widget.item.gradient[0].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.arrow_forward_rounded,
                      size: 14,
                      color: widget.item.gradient[0],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Model ────────────────────────────────────────────────────────────────────
class _ToolItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> gradient;
  final int index;

  const _ToolItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.index,
  });
}
