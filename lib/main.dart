import 'package:flutter/material.dart';
import 'package:rental_mobil/core/drawer/app_drawer.dart';
import 'package:rental_mobil/core/theme/app_theme.dart';
import 'package:rental_mobil/features/auth/presentation/screens/dashboard.dart';
import 'package:rental_mobil/features/auth/presentation/screens/dashboard_owner.dart';
import 'package:rental_mobil/features/auth/presentation/screens/login.dart';
import 'package:rental_mobil/features/auth/presentation/screens/master_data.dart';
import 'package:rental_mobil/features/auth/presentation/screens/notification.dart';
import 'package:rental_mobil/features/report/report.dart';
import 'package:rental_mobil/features/auth/presentation/screens/transaction.dart';
import 'package:rental_mobil/features/setting/setting.dart';


void main() {
  runApp(const MultiRentCarApp());
}

class MultiRentCarApp extends StatefulWidget {
  const MultiRentCarApp({super.key});

  @override
  State<MultiRentCarApp> createState() => _MultiRentCarAppState();
}

class _MultiRentCarAppState extends State<MultiRentCarApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MULTI RENTCAR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: AppShell(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String? _userRole; // 'admin' or 'owner'
  String _currentPage = 'dashboard';

  void _handleLogin(String role) {
    setState(() {
      _userRole = role;
      _currentPage = 'dashboard';
    });
  }

  void _handleLogout() {
    setState(() {
      _userRole = null;
      _currentPage = 'dashboard';
    });
  }

  void _navigateTo(String page) {
    setState(() {
      _currentPage = page;
    });
    Navigator.of(context).pop(); // close drawer
  }

  Widget _buildCurrentPage() {
    if (_userRole == 'owner') {
      return const OwnerDashboardScreen();
    }
    switch (_currentPage) {
      case 'dashboard':
        return const DashboardScreen();
      case 'master-data':
        return const MasterDataScreen();
      case 'transactions':
        return const TransactionsScreen();
      case 'reports':
        return const ReportsScreen();
      case 'notifications':
        return const NotificationsScreen();
      case 'settings':
        return SettingsScreen(
          themeMode: widget.themeMode,
          onToggleTheme: widget.onToggleTheme,
        );
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userRole == null) {
      return LoginScreen(onLogin: _handleLogin);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MULTI RENTCAR'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: widget.themeMode == ThemeMode.light
                ? 'Dark Mode'
                : 'Light Mode',
          ),
        ],
      ),
      drawer: AppDrawer(
        currentPage: _currentPage,
        userRole: _userRole!,
        onNavigate: _navigateTo,
        onLogout: _handleLogout,
        themeMode: widget.themeMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      body: _buildCurrentPage(),
    );
  }
}
