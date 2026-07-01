import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_gradient_bg.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir $url');
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copiado ✓'),
        backgroundColor: AppTheme.accentCyan.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        colors: AppTheme.gradientAbout,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text('Acerca de', style: Theme.of(context).textTheme.titleLarge),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [

                      // ── Foto + Nombre ─────────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: AppTheme.gradientAbout),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentCyan.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3),
                        child: const CircleAvatar(
                          radius: 72,
                          backgroundColor: Colors.black,
                          backgroundImage: AssetImage('assets/images/foto_perfil.jpg'),
                        ),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

                      const SizedBox(height: 20),

                      Text('Jeremy Santiago',
                        style: Theme.of(context).textTheme.displayMedium,
                      ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      Text('Desarrollador Mobile & Web',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.accentCyan,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 250.ms),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPurple.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.accentPurple.withOpacity(0.4)),
                        ),
                        child: Text('Matrícula: 2024-1504',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 28),

                      // ── Skills chips ──────────────────────────────────────
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: ['Flutter', 'Dart', 'Firebase', 'REST APIs', 'UI/UX', 'Git']
                            .map((s) => _SkillChip(label: s))
                            .toList(),
                      ).animate().fadeIn(delay: 350.ms),

                      const SizedBox(height: 28),

                      // ── Contacto directo ──────────────────────────────────
                      GlassCard(
                        borderGradient: AppTheme.gradientAbout,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.contact_page_rounded, color: AppTheme.accentCyan, size: 20),
                              const SizedBox(width: 10),
                              Text('Contacto', style: Theme.of(context).textTheme.titleLarge),
                            ]),
                            const SizedBox(height: 16),

                            _ContactRow(
                              icon: Icons.email_rounded,
                              label: 'Email',
                              value: 'yeremishr151@gmail.com',
                              color: const Color(0xFFEA4335),
                              onTap: () => _launchUrl('mailto:yeremishr151@gmail.com'),
                              onLongPress: () => _copyToClipboard(context, 'yeremishr151@gmail.com', 'Email'),
                            ),
                            const _Divider(),


                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.08, end: 0),

                      const SizedBox(height: 16),

                      // ── Redes sociales ────────────────────────────────────
                      GlassCard(
                        borderGradient: AppTheme.gradientAbout,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.share_rounded, color: AppTheme.accentCyan, size: 20),
                              const SizedBox(width: 10),
                              Text('Redes', style: Theme.of(context).textTheme.titleLarge),
                            ]),
                            const SizedBox(height: 16),

                            _ContactRow(
                              icon: Icons.code_rounded,
                              label: 'GitHub',
                              value: 'github.com/YeremiSantiago',
                              color: Colors.white,
                              onTap: () => _launchUrl('https://github.com/YeremiSantiago'),
                              onLongPress: () => _copyToClipboard(context, 'https://github.com/YeremiSantiago', 'GitHub'),
                            ),
                            const _Divider(),

                            _ContactRow(
                              icon: Icons.work_rounded,
                              label: 'LinkedIn',
                              value: 'Jeremy Santiago Hernandez',
                              color: const Color(0xFF0077B5),
                              onTap: () => _launchUrl('https://www.linkedin.com/in/jeremy-santiago-hernandez/'),
                              onLongPress: () => _copyToClipboard(context, 'https://www.linkedin.com/in/jeremy-santiago-hernandez/', 'LinkedIn'),
                            ),

                          ],
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.08, end: 0),

                      const SizedBox(height: 16),

                      // ── Disponibilidad ────────────────────────────────────
                      GlassCard(
                        borderGradient: [const Color(0xFF00C853), const Color(0xFF00E5FF)],
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 12, height: 12,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00C853),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Color(0xFF00C853), blurRadius: 8, spreadRadius: 2)],
                              ),
                            ).animate(onPlay: (c) => c.repeat())
                                .fadeOut(duration: 900.ms, curve: Curves.easeInOut)
                                .then()
                                .fadeIn(duration: 900.ms),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Disponible para proyectos',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Freelance · Prácticas · Tiempo completo',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95)),

                      const SizedBox(height: 32),

                      // ── Footer ────────────────────────────────────────────
                      Text('Toca para abrir · Mantén para copiar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ).animate().fadeIn(delay: 700.ms),

                      const SizedBox(height: 24),
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

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                  ),
                  Text(value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      const Divider(color: Colors.white10, height: 1);
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.glassWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Text(label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
