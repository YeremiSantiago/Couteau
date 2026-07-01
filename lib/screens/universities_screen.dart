import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_gradient_bg.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _universities = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller.text = 'Dominican Republic';
    WidgetsBinding.instance.addPostFrameCallback((_) => _search());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final country = _controller.text.trim();
    if (country.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _universities = [];
    });
    try {
      final data = await ApiService.getUniversities(country);
      setState(() {
        _universities = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al buscar universidades';
        _loading = false;
      });
    }
  }

  Future<void> _openUrl(BuildContext context, String urlString) async {

    String fixed = urlString.trim();
    if (!fixed.startsWith('http://') && !fixed.startsWith('https://')) {
      fixed = 'https://$fixed';
    }
    final uri = Uri.tryParse(fixed);
    if (uri == null) return;

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir: $fixed'),
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir el enlace: $fixed'),
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        colors: AppTheme.gradientUni,
        child: SafeArea(
          child: Column(
            children: [
              // ── AppBar ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text('Universidades',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    if (_universities.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.glassWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.glassBorder),
                        ),
                        child: Text('${_universities.length}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white)),
                      ),
                  ],
                ),
              ),

              // ── Search bar ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          hintText: 'País en inglés (ej: Mexico)',
                          prefixIcon: Icon(Icons.search_rounded,
                              color: AppTheme.textSecondary),
                        ),
                        onSubmitted: (_) => _search(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _loading ? null : _search,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppTheme.gradientUni,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.gradientUni[0].withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.travel_explore_rounded,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Lista ────────────────────────────────────────────────────
              Expanded(
                child: _loading
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.accentCyan))
                    : _error != null
                    ? Center(
                  child: Text(_error!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.redAccent)),
                )
                    : _universities.isEmpty
                    ? Center(
                  child: Text('Busca universidades por país',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium),
                )
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _universities.length,
                  itemBuilder: (ctx, i) {
                    final u = _universities[i];
                    final name = u['name'] ?? 'Sin nombre';
                    final domain =
                    (u['domains'] is List &&
                        (u['domains'] as List).isNotEmpty)
                        ? (u['domains'] as List).first.toString()
                        : null;
                    final webPage =
                    (u['web_pages'] is List &&
                        (u['web_pages'] as List).isNotEmpty)
                        ? (u['web_pages'] as List).first.toString()
                        : null;

                    return _UniversityCard(
                      index: i,
                      name: name,
                      domain: domain,
                      webPage: webPage,
                      onOpen: webPage == null
                          ? null
                          : () => _openUrl(context, webPage),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── University Card ────────────────────────────────────────────────────────────
class _UniversityCard extends StatelessWidget {
  final int index;
  final String name;
  final String? domain;
  final String? webPage;
  final VoidCallback? onOpen;

  const _UniversityCard({
    required this.index,
    required this.name,
    required this.domain,
    required this.webPage,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: GlassCard(
          borderGradient: AppTheme.gradientUni,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.gradientUni,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.school_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    if (domain != null)
                      Text(domain!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12)),
                    if (webPage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.link_rounded,
                                color: AppTheme.accentCyan, size: 13),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(webPage!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontSize: 11),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (onOpen != null)
                const Icon(Icons.open_in_new_rounded,
                    color: AppTheme.textSecondary, size: 16),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: (60 * index).clamp(0, 800)))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }
}