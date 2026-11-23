import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocaleProvider>();

    final screens = [
      ExploreScreen(
        onGoToDrops: () => setState(() => _currentIndex = 1),
      ),
      _PlaceholderTab(
        icon: Icons.bolt_rounded,
        title: loc.t('drops_title'),
        subtitle: loc.t('drops_subtitle'),
      ),
      _PlaceholderTab(
        icon: Icons.auto_awesome_rounded,
        title: loc.t('lab_title'),
        subtitle: loc.t('lab_subtitle'),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),

          // Barra de navegación flotante estilo cristal (Floating Glass Pill)
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: SafeArea(
              child: GlassContainer(
                borderRadius: 32,
                blur: 18,
                color: AppColors.primary.withValues(alpha: 0.82),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(Icons.grid_view_rounded, loc.t('nav_explore'), 0),
                    _navItem(Icons.bolt_rounded, loc.t('nav_drops'), 1),
                    _navItem(Icons.auto_awesome_rounded, loc.t('nav_lab'), 2),
                    _navItem(Icons.person_outline_rounded, loc.t('nav_profile'), 3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 52, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(title, style: AppTheme.editorialTitle(fontSize: 34)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
