// ============================================================
// DART — CONCEPTOS BÁSICOS PARA ALGUIEN QUE VIENE DE PYTHON/JAVA
// ============================================================
// Dart es orientado a objetos (como Java), pero con sintaxis más limpia.
// Todo en Flutter es un "Widget" — como componentes en React o elementos HTML.
// Los widgets son INMUTABLES: para cambiar la UI usas setState().
//
// TIPOS BÁSICOS en Dart:
//   int, double, String, bool  → igual que Java
//   var  → infiere el tipo automáticamente (como en Kotlin)
//   final → constante en tiempo de ejecución (como final en Java)
//   const → constante en tiempo de COMPILACIÓN (más eficiente)
//   List<T>, Map<K,V>  → equivalente a ArrayList y HashMap de Java
//
// CLASES:
//   class Foo extends Bar {}   → herencia, igual que Java
//   @override                  → igual que Java
//   _variablePrivada           → el guion bajo hace la variable privada
//
// FUNCIONES:
//   void miFuncion() {}        → igual que Java/Python
//   Widget _buildAlgo() {}     → convención: métodos privados de build con _
//
// NULL SAFETY (característica clave de Dart moderno):
//   String nombre;    → ERROR, debe ser inicializado
//   String? nombre;   → puede ser null (el ? lo indica)
//   String nombre = 'hola'; → correcto, no puede ser null
// ============================================================

import 'package:flutter/material.dart';

// ============================================================
// PUNTO DE ENTRADA DE LA APP
// main() es igual que en Java/Python — es donde todo comienza
// runApp() toma un widget y lo convierte en la app
// ============================================================
void main() {
  runApp(const MyApp());
}

// ============================================================
// STATELESS WIDGET — Widget sin estado (no cambia)
// Equivalente a un componente React puro / función sin useState
// Se usa cuando la UI no necesita actualizarse dinámicamente
// ============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // super.key es para optimización interna de Flutter

  @override
  Widget build(BuildContext context) {
    // MaterialApp es el widget raíz que configura la app
    return MaterialApp(
      title: 'FridgeEye',
      debugShowCheckedModeBanner: false, // Quita el banner rojo de "DEBUG"
      theme: ThemeData(
        // ColorScheme.fromSeed genera una paleta completa desde un color base
        colorScheme: ColorScheme.fromSeed(  // ✅ CORRECCIÓN: faltaba "ColorScheme"
          seedColor: const Color(0xFF2ECC71),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Widget que se muestra al iniciar
    );
  }
}

// ============================================================
// STATEFUL WIDGET — Widget CON estado (puede cambiar con el tiempo)
// Equivalente a un componente React con useState
// Requiere DOS clases: el Widget + su State
//
// ¿POR QUÉ DOS CLASES?
// Flutter separa la "configuración" (HomeScreen) del "estado mutable"
// (_HomeScreenState). Esto permite que Flutter reutilice el estado
// sin recrear el widget completo.
// ============================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // createState() conecta el widget con su clase de estado
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // ESTADO DEL WIDGET — variables que cuando cambian, actualizan la UI
  // En Python sería self.total_alimentos = 6
  // El _ al inicio las hace privadas (solo visibles en este archivo)
  // ============================================================
  int _totalAlimentos = 6;
  int _porVencer = 2;
  int _frescos = 4;

  // ============================================================
  // BUILD — método que construye la UI
  // Se ejecuta cada vez que llamas setState()
  // Retorna un Widget que describe cómo se ve la pantalla
  // ============================================================
  @override
  Widget build(BuildContext context) {
    // Scaffold es el "esqueleto" de una pantalla Material Design
    // Provee estructura base: appBar, body, bottomNavigationBar, etc.
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),

      // -------------------------------------------------------
      // APP BAR — barra superior
      // -------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        // leading: widget a la IZQUIERDA del título
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.remove_red_eye_rounded,
                color: const Color(0xFF2ECC71),
                size: 28,
              ),
            ],
          ),
        ),
        leadingWidth: 50,

        title: const Text(
          'FridgeEye',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,

        // actions: lista de widgets a la DERECHA del AppBar
        actions: [
          // Stack apila widgets uno encima del otro (como position: relative en CSS)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  // TODO: navegar a pantalla de notificaciones
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF1A1A2E),
                  size: 28,
                ),
              ),
              // Positioned dentro de Stack = position: absolute en CSS
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE74C3C),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '6',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      // -------------------------------------------------------
      // BODY — contenido principal
      // SingleChildScrollView = overflow-y: auto en CSS
      // -------------------------------------------------------
      body: SingleChildScrollView(
        // Column organiza widgets en vertical
        // crossAxisAlignment controla el eje HORIZONTAL (perpendicular al flujo)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===================================================
            // 1. BANNER HERO — imagen de nevera con texto superpuesto
            // ===================================================
            _buildHeroBanner(),

            const SizedBox(height: 20), // Espaciado — como margin-top en CSS

            // ===================================================
            // 2. TARJETAS DE ESTADÍSTICAS
            // ===================================================
            Padding(
              // EdgeInsets.symmetric = padding igual en ambos lados del eje
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildStatsRow(),
            ),

            const SizedBox(height: 24),

            // ===================================================
            // 3. SECCIÓN DE ALIMENTOS RECIENTES
            // ===================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildRecentSection(),
            ),

            const SizedBox(height: 24),

            // ===================================================
            // 4. BOTÓN AGREGAR ALIMENTO
            // ===================================================
            Padding(
              // EdgeInsets.fromLTRB = Left, Top, Right, Bottom
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _buildAddButton(context),
            ),
          ],
        ),
      ),

      // -------------------------------------------------------
      // BOTTOM NAVIGATION BAR — barra inferior
      // -------------------------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Muestra etiquetas en todos
        selectedItemColor: const Color(0xFF2ECC71),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: 0, // Tab activo (0 = Inicio)
        onTap: (index) {
          // TODO: implementar navegación entre tabs
          // index 0 = Inicio, 1 = Cámara, 2 = Inventario, 3 = Galería
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt_rounded),
            label: 'Cámara',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library_rounded),
            label: 'Galería',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MÉTODOS PRIVADOS DE CONSTRUCCIÓN DE UI
  // Convención en Flutter: _build* para métodos que retornan Widgets
  // Son como componentes auxiliares — equivale a funciones en Python
  // que retornan HTML, o métodos privados que retornan Views en Java
  //
  // "Widget" es el tipo de retorno — todo en Flutter es un Widget
  // ============================================================

  /// Construye el banner hero con imagen de nevera y texto superpuesto
  /// Las /// (triple slash) son comentarios de documentación en Dart
  Widget _buildHeroBanner() {
    // Container = el <div> de Flutter
    // Puede tener: color, padding, margin, decoration, child, etc.
    return Container(
      height: 220,
      margin: const EdgeInsets.all(16),
      // ClipRRect recorta su hijo con bordes redondeados
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        // Stack apila widgets — el primero es el fondo, los demás van encima
        child: Stack(
          fit: StackFit.expand, // Todos los hijos ocupan el tamaño del Stack
          children: [
            // ── FONDO: Gradiente que simula nevera ──────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D3B2E), // Verde muy oscuro
                    Color(0xFF1A6B4A), // Verde medio
                    Color(0xFF0F3460), // Azul oscuro — da sensación de frío
                  ],
                ),
              ),
            ),

            // ── CÍRCULOS DECORATIVOS (profundidad visual) ────────────
            // Los colores con 0x30 al inicio = 30 de opacidad (hex)
            // 0xFF = 100% opaco, 0x80 = 50%, 0x30 = ~19%
            Positioned(
              top: -30, right: -30,
              child: _decorativeCircle(140, const Color(0x25FF6B35)),
            ),
            Positioned(
              bottom: -40, left: 10,
              child: _decorativeCircle(120, const Color(0x252ECC71)),
            ),
            Positioned(
              top: 20, right: 60,
              child: _decorativeCircle(50, const Color(0x35FFD700)),
            ),
            Positioned(
              top: 60, left: -20,
              child: _decorativeCircle(80, const Color(0x2000BCD4)),
            ),

            // ── ÍCONOS DECORATIVOS (simulan comida) ─────────────────
            // withOpacity() es un método de Color que ajusta la transparencia
            Positioned(
              right: 16,
              top: 16,
              child: Column(
                children: [
                  Icon(Icons.kitchen_outlined, size: 60,
                      color: Colors.white.withOpacity(0.12)),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Row(
                children: [
                  Icon(Icons.eco_outlined, size: 30,
                      color: const Color(0xFF2ECC71).withOpacity(0.5)),
                  const SizedBox(width: 8),
                  Icon(Icons.local_drink_outlined, size: 26,
                      color: Colors.lightBlue.withOpacity(0.4)),
                  const SizedBox(width: 8),
                  Icon(Icons.lunch_dining_outlined, size: 28,
                      color: Colors.orange.withOpacity(0.4)),
                ],
              ),
            ),

            // ── TEXTO SUPERPUESTO ────────────────────────────────────
            // Positioned sin valores = fill (ocupa todo el espacio)
            Positioned(
              left: 20,
              bottom: 28,
              child: Column(
                // crossAxisAlignment.start = alinear a la izquierda
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RichText permite mezclar estilos en un mismo párrafo
                  const Text(
                    '¡Hola, Usuario! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      shadows: [
                        // Sombra al texto para legibilidad sobre el fondo
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tu nevera te espera 🧊',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Chip pequeño con estado de la nevera
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF2ECC71).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Ancho mínimo necesario
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2ECC71),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Nevera activa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Círculo decorativo reutilizable — ejemplo de método helper
  /// Recibe tamaño y color como parámetros (tipado, como en Java)
  Widget _decorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Fila con las 3 tarjetas de estadísticas
  Widget _buildStatsRow() {
    // Row organiza widgets en HORIZONTAL (opuesto a Column)
    return Row(
      // children: lista de widgets hijos
      children: [
        // Expanded hace que el widget ocupe el espacio disponible
        // Equivale a flex: 1 en CSS
        Expanded(
          child: _buildStatCard(
            value: _totalAlimentos.toString(), // int → String (como str() en Python)
            label: 'Alimentos',
            valueColor: const Color(0xFF1A1A2E),
            backgroundColor: Colors.white,
            borderColor: const Color(0xFFE8E8E8),
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF6C757D),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            value: _porVencer.toString(),
            label: 'Por vencer',
            valueColor: const Color(0xFFE74C3C),
            backgroundColor: const Color(0xFFFFF0EE),
            borderColor: const Color(0xFFFFD5D0),
            icon: Icons.warning_amber_outlined,
            iconColor: const Color(0xFFE74C3C),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            value: _frescos.toString(),
            label: 'Frescos',
            valueColor: const Color(0xFF27AE60),
            backgroundColor: const Color(0xFFEEFAF3),
            borderColor: const Color(0xFFB8EDD0),
            icon: Icons.eco_outlined,
            iconColor: const Color(0xFF27AE60),
          ),
        ),
      ],
    );
  }

  /// Tarjeta de estadística individual — reutilizable con parámetros
  /// Los {} en los parámetros los hacen NOMBRADOS (como kwargs en Python)
  /// El 'required' indica que son obligatorios
  Widget _buildStatCard({
    required String value,
    required String label,
    required Color valueColor,
    required Color backgroundColor,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        // boxShadow es una lista porque puedes tener múltiples sombras
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6C757D),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Sección de alimentos recientes
  Widget _buildRecentSection() {
    // Lista de datos de ejemplo — en producción vendrán de una BD o API
    // En Dart, List<Map<String, dynamic>> es como List[dict] en Python

    final List<Map<String, dynamic>> alimentos = [
      {
        'nombre': 'Manzanas',
        'estado': 'Fresco',
        'diasRestantes': 5,
        'emoji': '🍎',
        'color': const Color(0xFF27AE60),
      },
      {
        'nombre': 'Banano',
        'estado': 'Por vencer',
        'diasRestantes': 1,
        'emoji': '🍌',
        'color': const Color(0xFFE74C3C),
      },
      {
        'nombre': 'Zanahoria',
        'estado': 'Por vencer',
        'diasRestantes': 2,
        'emoji': '🥕',
        'color': const Color(0xFFE67E22),
      },
    ];

    return Column(
      // crossAxisAlignment.start = alinear contenido a la izquierda
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ENCABEZADO DE SECCIÓN
        Row(
          // MainAxisAlignment.spaceBetween = justify-content: space-between
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Alimentos recientes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: navegar a inventario completo
              },
              child: const Text(
                'Ver todos',
                style: TextStyle(
                  color: Color(0xFF2ECC71),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // LISTA DE ALIMENTOS
        // map() en Dart = map() en Python — transforma cada elemento
        // .toList() convierte el Iterable resultante a List
        // La expresión con => es una función flecha (arrow function)
        // equivalente a lambda en Python
        ...alimentos.map((alimento) => _buildAlimentoTile(alimento)),
      ],
    );
  }

  /// Tile (fila) individual de alimento
  Widget _buildAlimentoTile(Map<String, dynamic> alimento) {
    // Determinar color del estado
    final bool esFresco = alimento['estado'] == 'Fresco';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Row con ícono, info y badge de estado
      child: Row(
        children: [
          // Ícono con fondo de color
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              // El color del alimento con poca opacidad como fondo
              color: (alimento['color'] as Color).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              alimento['emoji'] as String,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 14),

          // Nombre y días restantes
          Expanded( // Expanded toma el espacio disponible horizontalmente
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alimento['nombre'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  // Interpolación de strings en Dart con ${}
                  // Equivale a f-strings en Python: f"Vence en {dias} días"
                  'Vence en ${alimento['diasRestantes']} día${alimento['diasRestantes'] == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),

          // Badge de estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: esFresco
                  ? const Color(0xFFEEFAF3) // Operador ternario: condición ? siTrue : siFalse
                  : const Color(0xFFFFF0EE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              alimento['estado'] as String,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: esFresco
                    ? const Color(0xFF27AE60)
                    : const Color(0xFFE74C3C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Botón principal de agregar alimento
  Widget _buildAddButton(BuildContext context) {
    // ElevatedButton = botón con elevación (sombra)
    // SizedBox.expand o width: double.infinity = ancho completo
    return SizedBox(
      width: double.infinity, // double.infinity = 100% del ancho disponible
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: navegar a la pantalla de cámara
          // Navigator.push(context, MaterialPageRoute(builder: ...))
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📸 Abriendo cámara...'),
              backgroundColor: Color(0xFF2ECC71),
              duration: Duration(seconds: 2),
            ),
          );
        },
        // icon: ícono que aparece a la izquierda del texto
        icon: const Icon(Icons.camera_alt_rounded, size: 22),
        label: const Text(
          'Agregar alimento',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        // style: personalización visual del botón
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2ECC71),
          foregroundColor: Colors.white, // Color del texto e ícono
          elevation: 3,
          shadowColor: const Color(0xFF2ECC71).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// NOTA SOBRE EL CÓDIGO ORIGINAL:
// Se eliminó la clase MyHomePage y _MyHomePageState porque era
// el código de ejemplo de Flutter que ya no se necesita.
//
// ERRORES CORREGIDOS:
// 1. ColorScheme.fromSeed → faltaba "ColorScheme."
// 2. MainAxisAlignment.center → faltaba "MainAxisAlignment."
// 3. _buildHeroBanner() → faltaba el ";" al final del return
// 4. Se completaron los métodos _buildStatsRow(), _buildRecentSection()
//    y _buildAddButton() que estaban ausentes
// 5. Icons.notification_add_outlined → cambiado a notifications_outlined
//    (el nombre correcto en Flutter)
// ============================================================