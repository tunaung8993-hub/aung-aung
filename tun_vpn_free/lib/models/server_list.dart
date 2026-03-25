import 'server_model.dart';

/// Public/demo V2Ray server configurations.
/// In production, these should be fetched from your backend API.
/// Format: vmess://<base64> or vless://<uuid>@<host>:<port>?...
///
/// NOTE: These are placeholder configs. Replace with real server configs
/// from your own V2Ray/Xray servers or a public server provider.
/// Free public servers can be found at:
/// - https://freevpnplanet.com/
/// - https://vpnjantit.com/
/// - https://www.vpngate.net/ (OpenVPN)
///
/// For V2Ray specifically, you need a running V2Ray/Xray server.
/// The configs below are structured examples — replace with real ones.

const List<Map<String, dynamic>> kServerData = [
  {
    'id': 'sg-01',
    'country': 'Singapore',
    'city': 'Singapore',
    'flag': '🇸🇬',
    'protocol': 'VMess',
    // Replace with real vmess:// link
    'configLink': 'vmess://eyJhZGQiOiJzZy12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiMTIzNDU2NzgtMTIzNC0xMjM0LTEyMzQtMTIzNDU2Nzg5MDEyIiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6IlNHLVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
  {
    'id': 'th-01',
    'country': 'Thailand',
    'city': 'Bangkok',
    'flag': '🇹🇭',
    'protocol': 'VMess',
    'configLink': 'vmess://eyJhZGQiOiJ0aC12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiMjIyMjIyMjItMjIyMi0yMjIyLTIyMjItMjIyMjIyMjIyMjIyIiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6IlRILVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
  {
    'id': 'hk-01',
    'country': 'Hong Kong',
    'city': 'Hong Kong',
    'flag': '🇭🇰',
    'protocol': 'VLESS',
    'configLink': 'vmess://eyJhZGQiOiJoay12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiMzMzMzMzMzMtMzMzMy0zMzMzLTMzMzMtMzMzMzMzMzMzMzMzIiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6IkhLLVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
  {
    'id': 'jp-01',
    'country': 'Japan',
    'city': 'Tokyo',
    'flag': '🇯🇵',
    'protocol': 'VMess',
    'configLink': 'vmess://eyJhZGQiOiJqcC12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiNDQ0NDQ0NDQtNDQ0NC00NDQ0LTQ0NDQtNDQ0NDQ0NDQ0NDQ0IiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6IkpQLVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
  {
    'id': 'us-01',
    'country': 'United States',
    'city': 'Los Angeles',
    'flag': '🇺🇸',
    'protocol': 'VMess',
    'configLink': 'vmess://eyJhZGQiOiJ1cy12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiNTU1NTU1NTUtNTU1NS01NTU1LTU1NTUtNTU1NTU1NTU1NTU1IiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6IlVTLVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
  {
    'id': 'de-01',
    'country': 'Germany',
    'city': 'Frankfurt',
    'flag': '🇩🇪',
    'protocol': 'VMess',
    'configLink': 'vmess://eyJhZGQiOiJkZS12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiNjY2NjY2NjYtNjY2Ni02NjY2LTY2NjYtNjY2NjY2NjY2NjY2IiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6IkRFLVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
  {
    'id': 'kr-01',
    'country': 'South Korea',
    'city': 'Seoul',
    'flag': '🇰🇷',
    'protocol': 'VMess',
    'configLink': 'vmess://eyJhZGQiOiJrci12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiNzc3Nzc3NzctNzc3Ny03Nzc3LTc3NzctNzc3Nzc3Nzc3Nzc3IiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6IktSLVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
  {
    'id': 'nl-01',
    'country': 'Netherlands',
    'city': 'Amsterdam',
    'flag': '🇳🇱',
    'protocol': 'VMess',
    'configLink': 'vmess://eyJhZGQiOiJubC12cG4uZXhhbXBsZS5jb20iLCJhaWQiOiIwIiwiaG9zdCI6IiIsImlkIjoiODg4ODg4ODgtODg4OC04ODg4LTg4ODgtODg4ODg4ODg4ODg4IiwibmV0IjoidGNwIiwicGF0aCI6IiIsInBvcnQiOiI0NDMiLCJwcyI6Ik5MLVZQTi0wMSIsInNjeSI6ImF1dG8iLCJzbmkiOiIiLCJ0bHMiOiIiLCJ0eXBlIjoibm9uZSIsInYiOiIyIn0=',
  },
];

List<VpnServer> getDefaultServers() {
  return kServerData
      .map(
        (data) => VpnServer(
          id: data['id'],
          country: data['country'],
          city: data['city'],
          flag: data['flag'],
          protocol: data['protocol'],
          configLink: data['configLink'],
        ),
      )
      .toList();
}
