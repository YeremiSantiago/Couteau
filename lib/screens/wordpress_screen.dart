import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_gradient_bg.dart';

class WordpressScreen extends StatefulWidget {
  const WordpressScreen({super.key});

  @override
  State<WordpressScreen> createState() => _WordpressScreenState();
}

class _WordpressScreenState extends State<WordpressScreen> {
  List<dynamic> _posts = [];
  bool _loading = true;
  String? _error;

  static const String _apiUrl =
      'https://css-tricks.com/wp-json/wp/v2/posts?per_page=3&_embed';
  static const String _siteUrl = 'https://css-tricks.com';
  static const String _logoUrl =
      'https://i0.wp.com/css-tricks.com/wp-content/uploads/2019/06/akqRGyta_400x400.jpg';

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ApiService.getWordpressPosts(_apiUrl);
      setState(() {
        _posts = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudo conectar con CSS-Tricks';
        _loading = false;
      });
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('No se pudo abrir $url');
    }
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .replaceAll('&#8217;', "'")
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  String? _extractImage(dynamic post) {
    final direct = post['jetpack_featured_media_url'];
    if (direct != null && direct.toString().isNotEmpty) return direct as String;
    try {
      return post['_embedded']['wp:featuredmedia'][0]['media_details']
      ['sizes']['medium']['source_url'] as String?;
    } catch (_) {
      try {
        return post['_embedded']['wp:featuredmedia'][0]['source_url'] as String?;
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        colors: AppTheme.gradientWP,
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
                      child: Text('WordPress Blog',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded,
                          color: AppTheme.accentCyan),
                      onPressed: _fetchPosts,
                    ),
                  ],
                ),
              ),

              // ── Header CSS-Tricks ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: GlassCard(
                  borderGradient: AppTheme.gradientWP,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          _logoUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.glassWhite,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.web_rounded,
                                color: Colors.white, size: 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CSS-Tricks',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 20)),
                            const SizedBox(height: 4),
                            Text(
                              'Tips, Tricks & Techniques on CSS',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _openLink(_siteUrl),
                              child: Row(
                                children: [
                                  const Icon(Icons.open_in_new_rounded,
                                      color: AppTheme.accentCyan, size: 14),
                                  const SizedBox(width: 4),
                                  Text('css-tricks.com',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.newspaper_rounded,
                        color: AppTheme.accentCyan, size: 16),
                    const SizedBox(width: 8),
                    Text('ÚLTIMAS 3 PUBLICACIONES',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 11,
                          letterSpacing: 1.5,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Posts ────────────────────────────────────────────────────
              Expanded(
                child: _loading
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.accentCyan))
                    : _error != null
                    ? _ErrorView(message: _error!, onRetry: _fetchPosts)
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _posts.length,
                  itemBuilder: (ctx, i) {
                    final post = _posts[i];
                    final title = _stripHtml(
                        post['title']['rendered'] ?? '');
                    final excerpt = _stripHtml(
                        post['excerpt']['rendered'] ?? '');
                    final date = _formatDate(post['date'] ?? '');
                    final link = post['link'] ?? _siteUrl;
                    final imageUrl = _extractImage(post);

                    return _PostCard(
                      index: i,
                      title: title,
                      excerpt: excerpt,
                      date: date,
                      link: link,
                      imageUrl: imageUrl,
                      onVisit: () => _openLink(link),
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

// ── Post Card ─────────────────────────────────────────────────────────────────
class _PostCard extends StatelessWidget {
  final int index;
  final String title;
  final String excerpt;
  final String date;
  final String link;
  final String? imageUrl;
  final VoidCallback onVisit;

  const _PostCard({
    required this.index,
    required this.title,
    required this.excerpt,
    required this.date,
    required this.link,
    required this.imageUrl,
    required this.onVisit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderGradient: AppTheme.gradientWP,
        padding: EdgeInsets.zero,
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            if (imageUrl != null)
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(height: 8),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fecha
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: AppTheme.textSecondary, size: 12),
                      const SizedBox(width: 5),
                      Text(date,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Título
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Excerpt
                  Text(
                    excerpt,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.5, fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Botón visitar — abre el link real
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onVisit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0073AA),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 16),
                      label: const Text('Visitar noticia',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate(delay: (150 * index).ms).fadeIn(duration: 500.ms).slideY(begin: 0.12, end: 0),
    );
  }
}

// ── Error View ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded,
              color: AppTheme.textSecondary, size: 56),
          const SizedBox(height: 16),
          Text(message,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppTheme.textSecondary)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}