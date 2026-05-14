# Tesla Model 3 Infotainment System

Symulacja systemu infotainment Tesli Model 3 zbudowana w Qt 6 Quick/QML. Projekt prezentuje interfejs użytkownika inspirowany systemem multimedialnym Tesli z mapą nawigacyjną, kontrolami pojazdu, odtwarzaczem muzyki i modelem 3D.

## Funkcje

- **Lewy ekran (LeftScreen)** - Prędkościomierz, wskaźnik baterii i zasięgu, selektor biegów (PRND), wskaźnik regeneracji/mocy, podgląd drzwi i bagażnika, model 3D Tesli z możliwością obrotu i zoomu
- **Prawy ekran (RightScreen)** - Mapa OpenStreetMap z przesuwaniem, zoomem i obracaniem, oraz panel odtwarzacza muzyki z playlistą i kontrolami (play/pause, prev/next, szukaj, udostępnij)
- **Dolny pasek (BottomBar)** - Panel kontrolny z tempomatem (MAN/AUTO), ikonami sterowania szybą przednią/tylną, podgrzewaniem siedzeń, muzyką, telefonem i regulacją głośności

## Wymagania

- **Qt** 6.2 lub nowszy (zalecane 6.6+)
- **Qt Quick** 2.15
- **Qt Quick 3D** - dla renderowania modelu 3D
- **Qt Quick 3D Asset Utils** - dla wczytywania modeli GLB
- **Qt Location** - dla funkcji mapy
- **Qt Positioning** - dla współrzędnych geograficznych
- **Kompilator C++** zgodny z Qt (MinGW/MSVC/GCC/Clang)

## Instalacja

### Windows

1. Zainstaluj Qt z [qt.io](https://www.qt.io/download) lub użyj Qt Maintenance Tool
2. Upewnij się, że masz zainstalowane moduły:
   - Qt Quick
   - Qt Quick 3D
   - Qt Quick 3D Asset Utils
   - Qt Location
   - Qt Positioning

### Linux

```bash
# Ubuntu/Debian
sudo apt-get install qt6-base-dev qt6-declarative-dev qt6-quick3d-dev qt6-location-dev qt6-positioning-dev
```

### macOS

```bash
brew install qt@6
```

## Uruchomienie

### Z Qt Creator

1. Otwórz projekt `Tesla3Screen.pro` w Qt Creator
2. Wybierz odpowiedni kit (kompilator + Qt 6)
3. Kliknij "Run" (Ctrl+R) lub "Build and Run"

### Z linii poleceń

```bash
# Windows (MinGW)
qmake6 Tesla3Screen.pro
mingw32-make

# Linux/macOS
qmake6 Tesla3Screen.pro
make

# Uruchomienie
./Tesla3Screen  # Linux/macOS
Tesla3Screen.exe  # Windows
```

## Struktura projektu

```
Tesla3Screen/
│
├── main.cpp                 # Punkt wejścia aplikacji
├── main.qml                 # Główny plik QML z layoutem
├── Tesla3Screen.pro         # Plik projektu Qt
├── qml.qrc                  # Zasoby QML (pliki, obrazy, modele)
│
└── ui/
    ├── BottomBar/
    │   ├── BottomBar.qml    # Dolny pasek z ikonami kontroli
    │   └── TempIndicator.qml # Wskaźnik temperatury (góra/dół)
    │
    ├── LeftScreen/
    │   ├── LeftScreen.qml   # Lewy ekran z prędkościomierzem i baterią
    │   └── CarViewer.qml    # Podgląd 3D modelu Tesli
    │
    ├── RightScreen/
    │   └── RightScreen.qml  # Prawy ekran z mapą OSM i odtwarzaczem
    │
    ├── test/                # Katalog testów
    │
    └── assets/
        ├── balsam/          # Model 3D Tesli w formacie Qt Quick 3D
        │   ├── maps/        # Tekstury modelu
        │   ├── meshes/      # Siatki modelu
        │   └── Tesla_model_3.qml  # Definicja modelu 3D
        ├── car_icon.png
        ├── defrostBack.png
        ├── defrostFront.png
        ├── demo_tesla_cut.gif
        ├── electric-car.png
        ├── mobile_2.png
        ├── music_note.png
        ├── next.png
        ├── open_locker.png
        ├── pause.png
        ├── play.png
        ├── prev.png
        ├── publish.png
        ├── search.png
        ├── seat_heat_left.png
        ├── seat_heat_right.png
        ├── steering_wheel_heat.png
        ├── tesla_model_3.glb
        ├── tesla_model_3.gltf
        ├── volume_down_24dp.png
        ├── volume_mute_24dp.png
        ├── volume_off_24dp.png
        ├── volume_up_24dp.png
        ├── windshield_defrost.png
        └── windshield_defrost_rear.png
```

## Użycie

### Mapa (RightScreen)

- **Przesuwanie**: Kliknij i przeciągnij mapę
- **Zoom**: Użyj gestu pinch (dotyk) lub scroll (mysz)
- **Obracanie**: Obracaj dwoma palcami podczas gestu pinch
- **Skróty klawiszowe**:
  - `Ctrl +` - Powiększ
  - `Ctrl -` - Pomniejsz

### Odtwarzacz muzyki (RightScreen)

- Play/pause, prev/next, pasek postępu utworu, panel wyszukiwania i udostępniania

### Model 3D (LeftScreen)

- **Obrót**: Kliknij i przeciągnij model
- **Zoom**: Scroll myszą
- Automatyczna rotacja modelu; kliknięcie w drzwi/frunk/trunk zatrzymuje auto-rotację na 4 sekundy

### BottomBar

- Regulacja temperatury kierowcy i pasażera (przyciski góra/dół)
- Przełącznik MANUAL/AUTO
- Sterowanie ogrzewaniem szyb, podgrzewaniem siedzeń, telefonem i odtwarzaczem muzyki
- Regulacja głośności (suwak + ikona)

## Technologie

- **Qt Quick/QML** - Framework UI
- **Qt Quick 3D** - Renderowanie 3D modelu pojazdu
- **Qt Location** - Mapy i geolokalizacja
- **OpenStreetMap** - Dostawca map
- **C++** - Backend aplikacji

## Rozwój

Projekt jest w trakcie rozwoju. Planowane funkcje:

- [ ] Integracja z systemem pojazdu
- [ ] Więcej kontroli i ustawień
- [ ] Pełna funkcjonalność LeftScreen
- [ ] Animacje i przejścia

## Licencja

Ten projekt jest projektem edukacyjnym/demonstracyjnym inspirowanym interfejsem Tesli Model 3.

## Autor

[pikuskrystian](https://github.com/pikuskrystian)

## Podziękowania

- Tesla Inc. - za inspirację designem interfejsu
- Qt Project - za framework Qt
- OpenStreetMap - za dane mapowe

## Wersja Demo

![Demo](./ui/assets/demo_tesla_cut.gif)
