import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/product_card.dart';

class ExploreScreen extends StatefulWidget {
  final VoidCallback onGoToDrops;

  const ExploreScreen({super.key, required this.onGoToDrops});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _productService = ProductService();
  String _selectedCategory = 'todo';

  final List<Map<String, String>> _categories = [
    {'id': 'todo', 'label': 'Todo'},
    {'id': 'ropa', 'label': 'Ropa'},
    {'id': 'joyeria', 'label': 'Joyería'},
    {'id': 'accesorios', 'label': 'Accesorios'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-COMMERCE'),
        actions: [
          IconButton(
            tooltip: 'Carrito',
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('El carrito se habilitará en el Bloque 3'),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: _productService.getProductsStream(),
        builder: (context, snapshot) {
          final allProducts = snapshot.data ?? [];
          final filteredProducts = _selectedCategory == 'todo'
              ? allProducts
              : allProducts
                  .where((p) => p.category == _selectedCategory)
                  .toList();

          return CustomScrollView(
            slivers: [
              // Hero Banner Editorial
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: _buildHeroBanner(),
                ),
              ),

              // Filtros en píldoras
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat['id'];

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat['id']!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            cat['label']!,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Estado de carga o catálogo vacío
              if (snapshot.connectionState == ConnectionState.waiting)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filteredProducts.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Aún no hay productos aquí',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Activa tu Modo Vendedor en Perfil para publicar tu primer artículo.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                // Cuadrícula espaciosa de 2 columnas
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.62,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(product.title)),
                            );
                          },
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF141418), Color(0xFF2B2B36)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Tipografía gigante de fondo estilo editorial
          Positioned(
            right: -10,
            bottom: -18,
            child: Text(
              'DROP 01',
              style: AppTheme.editorialTitle(
                fontSize: 96,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassContainer(
                  borderRadius: 20,
                  blur: 8,
                  color: AppColors.dropAccent.withValues(alpha: 0.9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: const Text(
                    'EDICIÓN LIMITADA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW STREETWEAR & JOYERÍA',
                      style: AppTheme.editorialTitle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: widget.onGoToDrops,
                      child: GlassContainer(
                        borderRadius: 30,
                        blur: 10,
                        color: Colors.white.withValues(alpha: 0.16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Explorar Drops',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
