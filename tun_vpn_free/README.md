# Tun VPN Free — Flutter App

**Package:** `com.tun.freevpn` | **Version:** 1.0.0 | **Platform:** Android (primary), iOS (optional)

**Protocol:** V2Ray / Xray (VMess, VLESS, Trojan, Shadowsocks) via `flutter_v2ray` package

---

## App Features

| Feature | Status |
|---|---|
| Splash screen with shield logo and animation | Implemented |
| Connect/Disconnect button (green/red animated) | Implemented |
| Real-time status: IP, location, speed, timer | Implemented |
| Server list (Thailand, Singapore, HK, Japan, USA, Germany) | Implemented |
| Auto-select best server by ping | Implemented |
| Settings: auto-connect, kill switch UI, language | Implemented |
| Privacy/warning screen on first launch | Implemented |
| AdMob interstitial and banner ads | Implemented (test IDs) |
| Dark/light mode (Material Design 3) | Implemented |
| English + Burmese + Thai language support | Implemented |
| Android VPN permission handling | Implemented |
| Error handling (no internet, connection failed) | Implemented |
| V2Ray/Xray protocol via flutter_v2ray | Integrated |

---

## Project Structure

```
tun_vpn_free/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── server_model.dart        # Server data model
│   │   └── server_list.dart         # Pre-configured server list
│   ├── providers/
│   │   ├── vpn_provider.dart        # VPN state management (flutter_v2ray)
│   │   └── settings_provider.dart   # Settings with i18n
│   ├── screens/
│   │   ├── splash_screen.dart       # Animated splash with shield logo
│   │   ├── privacy_screen.dart      # First-launch privacy notice
│   │   ├── home_screen.dart         # Main screen with connect button
│   │   ├── server_list_screen.dart  # Server selection with ping
│   │   └── settings_screen.dart     # App settings
│   ├── widgets/
│   │   ├── vpn_shield_logo.dart     # Custom painted shield logo
│   │   ├── connect_button.dart      # Animated connect/disconnect button
│   │   ├── status_card.dart         # Connection status display
│   │   └── server_tile.dart         # Individual server list item
│   ├── services/
│   │   ├── ads_service.dart         # AdMob integration
│   │   └── connectivity_service.dart # Network connectivity check
│   └── theme/
│       └── app_theme.dart           # Dark/light theme configuration
├── assets/
│   ├── images/app_icon.png          # App icon (1024x1024)
│   ├── animations/                  # Lottie animation files (add here)
│   └── servers/servers.json         # Server configuration template
└── android/app/src/main/
    └── AndroidManifest.xml          # VPN permissions configured
```

---

## Quick Start

### Step 1: Add Real VPN Server Configs

The app needs real V2Ray/Xray server configs. Find free ones at:
- https://github.com/freefq/free (updated daily)
- https://github.com/aiboboxx/v2rayfree
- Telegram: @v2rayng_config

Update `lib/models/server_list.dart` with real VMess/VLESS links:

```dart
VpnServer(
  id: 'sg-01',
  country: 'Singapore',
  city: 'Singapore',
  flag: '🇸🇬',
  protocol: 'VMess',
  configLink: 'vmess://BASE64_ENCODED_CONFIG_HERE',
),
```

### Step 2: Configure AdMob

Replace test IDs in `android/app/src/main/AndroidManifest.xml` and `lib/services/ads_service.dart` with your real AdMob IDs from https://admob.google.com.

### Step 3: Build

```bash
flutter pub get
flutter build apk --release           # Release APK
flutter build appbundle --release     # Play Store AAB
```

---

## Customization

The following changes can be made with follow-up requests:

- **"Add more servers"** — expand the server list in `server_list.dart`
- **"Change button color"** — modify `AppColors.primaryGreen` in `app_theme.dart`
- **"Add kill switch"** — implement network blocking via Android VpnService
- **"Add WireGuard protocol"** — integrate `wireguard_flutter` package
- **"Add subscription/premium"** — add in-app purchase tier
- **"Change app name"** — update `AndroidManifest.xml` and `pubspec.yaml`

---

## Play Store Checklist

1. Replace all test AdMob IDs with real production IDs
2. Add real V2Ray server configurations
3. Generate release signing keystore and configure `key.properties`
4. Build release AAB: `flutter build appbundle --release`
5. Prepare store listing: screenshots, description, privacy policy URL
6. Review Google Play VPN policy requirements

---

## Dependencies

| Package | Purpose |
|---|---|
| flutter_v2ray 1.0.10 | V2Ray/Xray VPN protocol (Xray core 25.3.6) |
| provider 6.1.5 | State management |
| google_mobile_ads 5.3.1 | AdMob integration |
| shared_preferences 2.5.3 | Settings persistence |
| connectivity_plus 6.1.5 | Network status |
| google_fonts 6.3.0 | Typography |
| flutter_animate 4.5.2 | UI animations |
| lottie 3.3.1 | Lottie animations |
| http 1.6.0 | HTTP requests |
| go_router 14.8.1 | Navigation |
