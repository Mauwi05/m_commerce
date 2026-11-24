import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  bool _isEnglish = false;

  bool get isEnglish => _isEnglish;
  String get languageCode => _isEnglish ? 'EN' : 'ES';

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }

  String t(String key) {
    return _isEnglish ? (_en[key] ?? key) : (_es[key] ?? key);
  }

  static const Map<String, String> _es = {
    'nav_explore': 'Explorar',
    'nav_drops': 'Exclusivos',
    'nav_lab': 'Diseñar',
    'nav_profile': 'Perfil',
    'login_subtitle':
        'Compra, vende y descubre de todo: moda, joyeria, tecnología y más',
    'hero_badge': 'EDICIÓN LIMITADA',
    'hero_title': 'COMPRA, VENDE Y DESCUBRE DE TODO',
    'hero_cta': 'Ver lanzamientos',
    'hero_watermark': 'NUEVO',
    'cat_all': 'Todo',
    'cat_clothing': 'Ropa',
    'cat_jewelry': 'Joyería',
    'cat_accessories': 'Accesorios',
    'badge_drop': 'EXCLUSIVO',
    'empty_title': 'Aún no hay productos aquí',
    'empty_subtitle':
        'Activa tu Modo Vendedor en Perfil para publicar tu primer artículo.',
    'cart_soon': 'El carrito se habilitará en el siguiente bloque',
    'drops_title': 'LANZAMIENTOS EXCLUSIVOS',
    'drops_subtitle': 'Aquí verás los productos de edición limitada con cuenta regresiva en vivo.',
    'lab_title': 'ESTUDIO DE DISEÑO IA',
    'lab_subtitle':
        'Crea y previsualiza tus propios estampados en tiempo real.',
    'profile_title': 'Mi Perfil',
    'logout': 'Cerrar sesión',
    'buyer': 'Comprador',
    'store_prefix': 'Tienda',
    'seller_prompt_title': '¿Tienes algo que vender?',
    'seller_prompt_subtitle': 'Activa tu perfil de vendedor gratis y publica artículos de cualquier categoría en tiempo real.',
    'activate_seller': 'Activar Modo Vendedor',
    'publish_product': 'Publicar Nuevo Producto',
    'my_listings': 'Mis Publicaciones',
    'no_listings': 'Todavía no has publicado ningún artículo.',
    'edit_profile': 'Editar perfil',
    'change_photo': 'Cambiar foto de perfil',
    'full_name': 'Nombre en la app',
    'store_name': 'Nombre de tu tienda',
    'phone': 'Teléfono (opcional)',
    'address': 'Dirección de envío (opcional)',
    'bio': 'Descripción corta (opcional)',
    'save_changes': 'Guardar cambios',
    'profile_updated': 'Perfil actualizado correctamente',
    'name_required': 'Ingresa tu nombre',
    'logout_title': '¿Cerrar sesión?',
    'logout_message': 'Se cerrará tu sesión actual en este dispositivo.',
    'cancel': 'Cancelar',
  };

  static const Map<String, String> _en = {
    'nav_explore': 'Explore',
    'nav_drops': 'Exclusive',
    'nav_lab': 'Custom Lab',
    'nav_profile': 'Profile',
    'login_subtitle':
        'Buy, sell, and discover everything: fashion, jewelry, tech, and more',
    'hero_badge': 'LIMITED EDITION',
    'hero_title': 'BUY, SELL & DISCOVER EVERYTHING',
    'hero_cta': 'View releases',
    'hero_watermark': 'NEW',
    'cat_all': 'All',
    'cat_clothing': 'Apparel',
    'cat_jewelry': 'Jewelry',
    'cat_accessories': 'Accessories',
    'badge_drop': 'LIMITED',
    'empty_title': 'No products here yet',
    'empty_subtitle':
        'Activate Seller Mode in your Profile to publish your first item.',
    'cart_soon': 'Shopping cart will be available in the next step',
    'drops_title': 'EXCLUSIVE RELEASES',
    'drops_subtitle':
        'Limited-edition items with a live countdown will appear here.',
    'lab_title': 'AI CUSTOM STUDIO',
    'lab_subtitle': 'Create and preview your own custom prints in real time.',
    'profile_title': 'My Profile',
    'logout': 'Sign out',
    'buyer': 'Buyer',
    'store_prefix': 'Store',
    'seller_prompt_title': 'Have something to sell?',
    'seller_prompt_subtitle': 'Activate your seller profile for free and list items from any category in real time.',
    'activate_seller': 'Activate Seller Mode',
    'publish_product': 'Publish New Product',
    'my_listings': 'My Listings',
    'no_listings': 'You have not published any items yet.',
    'edit_profile': 'Edit profile',
    'change_photo': 'Change profile photo',
    'full_name': 'Display name',
    'store_name': 'Store name',
    'phone': 'Phone number (optional)',
    'address': 'Shipping address (optional)',
    'bio': 'Short bio (optional)',
    'save_changes': 'Save changes',
    'profile_updated': 'Profile updated successfully',
    'name_required': 'Enter your name',
    'logout_title': 'Sign out?',
    'logout_message': 'Your current session on this device will be closed.',
    'cancel': 'Cancel',
  };
}
