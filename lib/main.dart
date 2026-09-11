import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MKMEnterpriseApp());
}

class MKMEnterpriseApp extends StatelessWidget {
  const MKMEnterpriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKM Real Estate Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          primary: const Color(0xFF0D47A1),
          secondary: const Color(0xFFFFB300),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const AuthGateScreen(),
    );
  }
}

// ==================== DATA MODELS ====================

enum UserRole { admin, agent }

class UserAccount {
  final String id;
  final String name;
  final String phone;
  final String email;
  final UserRole role;

  UserAccount({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
  });
}

class PropertyItem {
  String id;
  String title;
  String location;
  String size;
  double priceNumeric;
  String priceDisplay;
  String badge;
  String imageUrl;

  PropertyItem({
    required this.id,
    required this.title,
    required this.location,
    required this.size,
    required this.priceNumeric,
    required this.priceDisplay,
    required this.badge,
    required this.imageUrl,
  });
}

// Global App State (Mock database for stateful session)
class AppDatabase {
  static UserAccount? currentUser;

  static List<PropertyItem> properties = [
    PropertyItem(
      id: 'PROP-101',
      title: 'MKM Green Paradise',
      location: 'Sector 15, Near National Highway',
      size: '1500 sq.ft (30x50)',
      priceNumeric: 1875000,
      priceDisplay: '₹1,250 / sq.ft (Total ₹18.75L)',
      badge: 'Immediate Registry',
      imageUrl: 'https://picsum.photos/seed/mkmprop1/900/600',
    ),
    PropertyItem(
      id: 'PROP-102',
      title: 'MKM Royal Residency',
      location: 'Airport Road, Ring Road Junction',
      size: '1800 sq.ft (Corner Plot)',
      priceNumeric: 2970000,
      priceDisplay: '₹1,650 / sq.ft (Total ₹29.70L)',
      badge: 'Corner Plot',
      imageUrl: 'https://picsum.photos/seed/mkmprop2/900/600',
    ),
    PropertyItem(
      id: 'PROP-103',
      title: 'MKM Smart City Township',
      location: 'Near Proposed Metro Phase 2',
      size: '1000 sq.ft (25x40)',
      priceNumeric: 999000,
      priceDisplay: '₹999 / sq.ft (Total ₹9.99L)',
      badge: 'Best Investment',
      imageUrl: 'https://picsum.photos/seed/mkmprop3/900/600',
    ),
  ];

  static List<UserAccount> registeredAgents = [
    UserAccount(
      id: 'AGT-101',
      name: 'Durgesh Tiwari',
      phone: '+91 98765 43210',
      email: 'durgesh@mkm.com',
      role: UserRole.agent,
    ),
    UserAccount(
      id: 'AGT-102',
      name: 'Ramesh Sharma',
      phone: '+91 91234 56789',
      email: 'ramesh@mkm.com',
      role: UserRole.agent,
    ),
  ];
}

// ==================== AUTH / LOGIN SCREEN ====================

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  bool isAdminTab = false;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  void _handleLogin() {
    setState(() => errorMessage = null);
    final id = _idController.text.trim();
    final pass = _passwordController.text.trim();

    if (isAdminTab) {
      // Hardcoded Admin Passcode for demonstration
      if (pass == 'admin123') {
        AppDatabase.currentUser = UserAccount(
          id: 'ADMIN-001',
          name: 'Master Admin',
          phone: '+91 90000 00000',
          email: 'admin@mkmgroup.com',
          role: UserRole.admin,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainAppNavigationScreen()),
        );
      } else {
        setState(() => errorMessage = 'Invalid Admin Passcode! (Default: admin123)');
      }
    } else {
      // Agent Login
      final agent = AppDatabase.registeredAgents.firstWhere(
        (a) => a.id.toLowerCase() == id.toLowerCase() || a.phone.contains(id),
        orElse: () => UserAccount(
          id: '',
          name: '',
          phone: '',
          email: '',
          role: UserRole.agent,
        ),
      );

      if (agent.id.isNotEmpty) {
        AppDatabase.currentUser = agent;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainAppNavigationScreen()),
        );
      } else {
        setState(() => errorMessage = 'Agent ID or Phone not found! Try: AGT-101');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFFF4F6F9)],
              stops: [0.0, 0.4, 0.4],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: const Icon(Icons.domain_add, size: 54, color: Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 12),
              const Text(
                'MKM REAL ESTATE',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const Text(
                'Enterprise Marketing & CRM System',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Mode Selector
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Agent Login')),
                              selected: !isAdminTab,
                              onSelected: (val) => setState(() {
                                isAdminTab = false;
                                errorMessage = null;
                              }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Center(child: Text('Admin Panel')),
                              selected: isAdminTab,
                              onSelected: (val) => setState(() {
                                isAdminTab = true;
                                errorMessage = null;
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (!isAdminTab) ...[
                        TextField(
                          controller: _idController,
                          decoration: const InputDecoration(
                            labelText: 'Agent ID or Mobile Number',
                            hintText: 'e.g. AGT-101',
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ] else ...[
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Admin Master Passcode',
                            hintText: 'admin123',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                      if (errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _handleLogin,
                          child: Text(isAdminTab ? 'Access Admin Console' : 'Login as Agent', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isAdminTab ? 'Default Pass: admin123' : 'Quick Demo ID: AGT-101',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== MAIN SHELL NAVIGATION ====================

class MainAppNavigationScreen extends StatefulWidget {
  const MainAppNavigationScreen({super.key});

  @override
  State<MainAppNavigationScreen> createState() => _MainAppNavigationScreenState();
}

class _MainAppNavigationScreenState extends State<MainAppNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = AppDatabase.currentUser!;
    final isAdmin = user.role == UserRole.admin;

    final List<Widget> screens = [
      const PropertyDirectoryScreen(),
      const EMICalculatorScreen(),
      if (isAdmin) const AdminDashboardScreen() else const AgentProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_work_outlined), selectedIcon: Icon(Icons.home_work), label: 'Properties'),
          const NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'EMI Calculator'),
          if (isAdmin)
            const NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), selectedIcon: Icon(Icons.admin_panel_settings), label: 'Admin Desk')
          else
            const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'My Agent Profile'),
        ],
      ),
    );
  }
}

// ==================== PROPERTY LIST SCREEN ====================

class PropertyDirectoryScreen extends StatefulWidget {
  const PropertyDirectoryScreen({super.key});

  @override
  State<PropertyDirectoryScreen> createState() => _PropertyDirectoryScreenState();
}

class _PropertyDirectoryScreenState extends State<PropertyDirectoryScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AppDatabase.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MKM Available Plots', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('Logged as: ${user.name} (${user.role == UserRole.admin ? 'Admin' : user.id})', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF0D47A1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AppDatabase.currentUser = null;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthGateScreen()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: AppDatabase.properties.length,
        itemBuilder: (context, index) {
          final prop = AppDatabase.properties[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      prop.imageUrl,
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => Container(
                        height: 190,
                        color: Colors.blueGrey.shade200,
                        child: const Center(child: Icon(Icons.landscape, size: 50)),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB300),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Text(
                          prop.badge,
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prop.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Expanded(child: Text(prop.location, style: TextStyle(color: Colors.grey.shade700, fontSize: 13))),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Plot Size', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              Text(prop.size, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Offering Price', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              Text(prop.priceDisplay, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PosterDesignStudio(property: prop, agent: user),
                              ),
                            );
                          },
                          icon: const Icon(Icons.auto_awesome, size: 18),
                          label: const Text('Generate Branded Poster'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==================== DYNAMIC POSTER STUDIO ====================

class PosterDesignStudio extends StatefulWidget {
  final PropertyItem property;
  final UserAccount agent;

  const PosterDesignStudio({super.key, required this.property, required this.agent});

  @override
  State<PosterDesignStudio> createState() => _PosterDesignStudioState();
}

class _PosterDesignStudioState extends State<PosterDesignStudio> {
  String selectedBadge = 'Special Festive Offer';
  final List<String> availableBadges = [
    'Special Festive Offer',
    'Immediate Registry',
    'Bank Loan Approved',
    'Corner Plot Available',
    'Prime Location',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poster Generator Studio', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Promotional Tagline:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: availableBadges.map((badge) {
                final isSelected = selectedBadge == badge;
              
