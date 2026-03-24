# Flutter auf Windows Desktop (Symlinks)

Wenn du siehst:

```text
Error: Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
Run start ms-settings:developers
```

## 1. Entwicklermodus (Standard-Fix)

1. Einstellungen öffnen: **`Win` + `I`**
2. **System** → **Für Entwickler** (oder **Datenschutz und Sicherheit** → **Für Entwickler**, je nach Windows-Version)
3. **Entwicklermodus** auf **Ein**

Oder in PowerShell/Cmd:

```bat
start ms-settings:developers
```

Danach Terminal **neu starten** und erneut:

```bash
cd app/mobile/flutter_app
flutter clean
flutter pub get
flutter run -d windows
```

## 2. Projekt liegt in Nextcloud / anderer Sync

Synchronisierte Ordner können Symlinks verzögern oder stören. Wenn es nach Entwicklermodus weiter knallt:

- Repository **zusätzlich** nach z. B. `C:\src\pocketclaw` (nur **NTFS**, nicht ReFS-„Dev Drive“ ohne Symlink-Support) klonen und dort `flutter run -d windows` testen.

## 3. ReFS / Dev Drive

Auf manchen **ReFS**-Laufwerken (z. B. Windows Dev Drive) sind Symlinks eingeschränkt — dann Projekt auf ein normales **NTFS**-Laufwerk legen (siehe [Flutter issue zu ReFS](https://github.com/flutter/flutter/issues/182742)).

## 4. Fehler: `atlstr.h` / `flutter_secure_storage_windows`

Wenn der Build nach Entwicklermodus so endet:

```text
fatal error C1083: ... "atlstr.h": No such file or directory
```

fehlen die **C++-ATL**-Header (Active Template Library). Flutter-Plugins wie `flutter_secure_storage_windows` kompilieren native Windows-Code und brauchen die vollständige **Desktop-C++**-Toolchain mit ATL.

**Fix (Visual Studio Installer):**

1. **Visual Studio Installer** öffnen → bei **Visual Studio 2022** auf **Ändern**.
2. Workload **„Desktopentwicklung mit C++“** aktivieren.
3. Rechts unter **Einzelne Komponenten** (oder im Detail der Workload) zusätzlich aktivieren:
   - **C++-ATL für neueste v143-Buildtools (x86 und x64)**  
     (engl.: *C++ ATL for latest v143 build tools (x86 & x64)*)
4. Installation abschließen, **neues Terminal** öffnen, dann erneut:

```bash
cd app/mobile/flutter_app
flutter clean
flutter pub get
flutter run -d windows
```

Nur **Build Tools for Visual Studio** reichen auch, wenn dieselbe Workload + ATL-Komponente gewählt wird.

## 5. Prüfen

```bash
flutter doctor -v
```

Unter **Windows** sollte die Desktop-Toolchain ohne rote Fehler durchlaufen.
