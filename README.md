<div align="center">
  <h1>🛠️ Couteau </h1>
  <p>Una aplicación móvil multifuncional (multi-herramienta) con un diseño moderno en Glassmorphism.</p>
  
  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License MIT" />
  </p>
</div>

---

## ✨ Características Principales

- 🔮 **Interfaz Glassmorphism Oscura**: Un diseño moderno y elegante enfocado en el modo oscuro.
- 🎬 **Animaciones Fluidas**: Interacciones y transiciones pulidas utilizando `flutter_animate` y `flutter_staggered_animations`.
- 🌈 **Fondos Degradados Animados**: Cada pantalla cuenta con un fondo degradado que se anima de forma única.
- ⏳ **Estados de Carga Shimmer**: Experiencia de usuario mejorada durante la carga de datos de red mediante esqueletos animados (shimmer).
- 🔗 **Soporte para Enlaces Externos**: Capacidad integrada para abrir enlaces de noticias, universidades y más directamente en el navegador del dispositivo.

---

## 📱 Pantallas y APIs

| Pantalla | Descripción | API Utilizada |
| :--- | :--- | :--- |
| 🏠 **Inicio (Home)** | Menú principal de navegación tipo caja de herramientas (toolbox nav). | - |
| 🔮 **Predicción de Género** | Adivina el género de una persona ingresando su nombre. | [genderize.io](https://genderize.io) |
| 🎂 **Estimación de Edad** | Determina la edad aproximada de una persona a partir de su nombre. | [agify.io](https://agify.io) |
| 🎓 **Universidades por País** | Encuentra instituciones educativas de cualquier país. | [adamix.net/proxy.php](http://adamix.net/proxy.php) |
| 🌤️ **Clima en República Dominicana** | Consulta las condiciones meteorológicas actuales del país. | [open-meteo.com](https://open-meteo.com) |
| ⚡ **Información Pokémon** | Busca cualquier Pokémon, mostrando detalles y reproduciendo su sonido oficial. | [pokeapi.co](https://pokeapi.co) |
| 📰 **Blog WordPress (CSS-Tricks)** | Lector de las 3 publicaciones más recientes de CSS-Tricks. | [css-tricks.com/wp-json/wp/v2/posts](https://css-tricks.com/wp-json/wp/v2/posts) |
| 🧑‍💻 **Acerca de Mí** | Información de contacto y detalles del desarrollador. | - |

---

## 🛠️ Tecnologías Utilizadas (Tech Stack)

La aplicación está construida utilizando herramientas y paquetes modernos de la comunidad de Flutter:

- **Framework:** Flutter 3.x, Dart
- **Red (Network):** `http`
- **Animaciones:** `flutter_animate`, `flutter_staggered_animations`
- **Tipografía:** `google_fonts` (Space Grotesk e Inter)
- **Carga de Imágenes:** `cached_network_image`, `shimmer`
- **Multimedia:** `audioplayers` (para sonidos de Pokémon)
- **Navegación Externa:** `url_launcher`

---

## 🚀 Empezando (Getting Started)

### Prerrequisitos

- Tener [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
- Un dispositivo físico conectado o un emulador (Android/iOS) configurado.

### Instalación

Sigue estos pasos para ejecutar el proyecto de manera local:

1. Clona este repositorio:
   ```bash
   git clone https://github.com/YeremiSantiago/Couteau.git
   ```

2. Navega a la carpeta del proyecto e instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

---

## 📂 Estructura del Proyecto

El código fuente está organizado de la siguiente manera para mantener la escalabilidad y limpieza:

```text
lib/
├── screens/    # Pantallas de cada herramienta (Home, Pokémon, Weather, etc.)
├── services/   # Lógica de conexión con las APIs externas
├── theme/      # Definición de colores, estilos y el Glassmorphism UI
└── widgets/    # Componentes visuales reutilizables a lo largo de la app
```

---

## 🧑‍💻 Autor

**Jeremy Santiago**  
Estudiante del Instituto Tecnológico de Las Américas (ITLA)  
**Matrícula:** 2024-1504  

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/YeremiSantiago)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jeremy-santiago-hernandez)

---

<div align="center">
  <p><i>Desarrollado como parte del curso impartido por el <b>Prof. Couteau</b>.</i></p>
</div>
