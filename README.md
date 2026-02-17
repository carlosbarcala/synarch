# Synarch

**Synarch**: unifica todas tus herramientas de Inteligencia Artificial Generativa en una sola aplicación de escritorio.

![Logo](logo-synarch.svg)

## Características

- **Interfaz de Pestañas**: Cambia rápidamente entre ChatGPT, Claude, Gemini, Grok, DeepSeek, Copilot, Perplexity y Mistral.
- **Persistencia de Sesión**: Cada plataforma mantiene su propia sesión independiente mediante particiones de webview.
- **Barra de Progreso**: Visualización en tiempo real del estado de carga de cada plataforma.
- **Herramientas de Desarrollador**: Acceso rápido mediante atajos de teclado (F12 para webviews, Ctrl+Shift+I para la ventana principal).
- **Multiplataforma**: Soporte para compilación en Linux, Windows y macOS.

## Requisitos

- [Node.js](https://nodejs.org/) (se recomienda la versión LTS)
- npm (incluido con Node.js)

## Desarrollo

Para comenzar a desarrollar o probar la aplicación localmente:

1. Instala las dependencias:
   ```bash
   npm install
   ```

2. Ejecuta la aplicación en modo desarrollo:
   ```bash
   npm start
   ```

## Compilación

Synarch utiliza `nw-builder` para empaquetar la aplicación para diferentes sistemas operativos:

- **Linux**: `npm run build:linux`
- **Windows**: `npm run build:win`
- **macOS**: `npm run build:mac`
- **Generar paquete .deb (Linux)**: `npm run build:deb`
- **Compilar para todas las plataformas**: `npm run build:all`

Los ejecutables resultantes se encontrarán en el directorio `dist/`.

## Arquitectura

La aplicación se basa en **NW.js**, combinando las capacidades de Node.js con el motor de renderizado de Chromium.

- **`index.html`**: Punto de entrada de la UI, gestiona la lógica de pestañas y los elementos `<webview>`.
- **`package.json`**: Configuración de NW.js, gestión de dependencias y scripts de compilación.
- **Webviews**: Se utilizan etiquetas `<webview>` con atributos `partition` para garantizar que las cookies y el almacenamiento local se mantengan aislados por plataforma pero persistentes entre reinicios.

## Atajos de Teclado

- **F12**: Abre las herramientas de desarrollador del webview (Inteligencia Artificial) activo.
- **Ctrl + Shift + I**: Abre las herramientas de desarrollador de la ventana principal de Synarch.

---


