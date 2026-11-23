import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../services/cloudinary_service.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '10');

  final _cloudinaryService = CloudinaryService();
  final _productService = ProductService();
  final _picker = ImagePicker();

  XFile? _pickedImage;
  Uint8List? _imageBytes;
  String _selectedCategory = 'ropa';
  final List<String> _availableSizes = ['S', 'M', 'L', 'XL', 'Oversize'];
  final Set<String> _selectedSizes = {'M', 'L'};
  bool _isDrop = false;
  bool _isCustomizable = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      _pickedImage = file;
      _imageBytes = bytes;
    });
  }

  Future<void> _publishProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una foto para el producto')),
      );
      return;
    }

    if (_selectedCategory == 'ropa' && _selectedSizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos una talla')),
      );
      return;
    }

    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      // 1. Subir imagen a Cloudinary en la carpeta de su categoría
      final imageUrl = await _cloudinaryService.uploadXFile(
        _pickedImage!,
        category: _selectedCategory,
      );

      // 2. Guardar producto en Firestore
      final product = ProductModel(
        id: '',
        sellerId: user.uid,
        storeName: user.storeName ?? user.name,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _selectedCategory,
        imageUrl: imageUrl,
        stock: int.parse(_stockController.text.trim()),
        sizes: _selectedCategory == 'ropa' ? _selectedSizes.toList() : [],
        isDrop: _isDrop,
        dropEndTime:
            _isDrop ? DateTime.now().add(const Duration(days: 3)) : null,
        isCustomizable: _isCustomizable,
        createdAt: DateTime.now(),
      );

      await _productService.createProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto publicado correctamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al publicar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Producto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selector de fotografía
              GestureDetector(
                onTap: _isSubmitting ? null : _pickImage,
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _imageBytes != null
                      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Toca para subir foto del producto',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto (ej. Hoodie Oversize)',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Descripción, materiales, detalles...',
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Ingresa una descripción'
                    : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Precio (MXN)',
                      ),
                      validator: (v) {
                        if (v == null || double.tryParse(v) == null) {
                          return 'Precio inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Stock',
                      ),
                      validator: (v) {
                        if (v == null || int.tryParse(v) == null) {
                          return 'Stock inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Categoría',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ['ropa', 'joyeria', 'accesorios'].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat[0].toUpperCase() + cat.substring(1)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                }).toList(),
              ),
              if (_selectedCategory == 'ropa') ...[
                const SizedBox(height: 20),
                Text(
                  'Tallas disponibles',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: _availableSizes.map((size) {
                    final isSelected = _selectedSizes.contains(size);
                    return FilterChip(
                      label: Text(size),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (val) {
                        setState(() {
                          val
                              ? _selectedSizes.add(size)
                              : _selectedSizes.remove(size);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Publicar como Drop (Edición Limitada)'),
                subtitle: const Text('Activo durante 72 horas con insignia Drop'),
                activeThumbColor: AppColors.dropAccent,
                value: _isDrop,
                onChanged: (val) => setState(() => _isDrop = val),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Habilitar para Custom Lab'),
                subtitle: const Text('Permite estampar diseños IA sobre esta prenda'),
                activeThumbColor: AppColors.aiAccent,
                value: _isCustomizable,
                onChanged: (val) => setState(() => _isCustomizable = val),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSubmitting ? null : _publishProduct,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Publicar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
