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

// DATA MODELS
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
  final String id;
  final String title;
  final String location;
  final String size;
  final double priceNumeric;
  final String priceDisplay;
  final String badge;
  final String imageUrl;

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

// MOCK DB
class AppDatabase {
  static UserAccount? currentUser;

  static List<PropertyItem> properties = [
    PropertyItem(
      id: 'PROP-101',
      title: 'MKM Green Paradise',
      location: 'Sector 15, Near Highway',
      size: '1500 sq.ft (30x50)',
      priceNumeric: 1875000,
      priceDisplay: '₹1,250 / sq.ft (Total ₹18.75L)',
      badge: 'Immediate Registry',
      imageUrl: 'https://picsum.photos/seed/mkmprop1/900/600',
    ),
    PropertyItem(
      id: 'PROP-102',
      title: 'MKM Royal Residency',
      location: 'Airport Road, Ring Road',
      size: '1800 sq.ft (Corner Plot)',
      priceNumeric: 2970000,
      priceDisplay: '₹1,650 / sq.ft (Total ₹29.70L)',
      badge: 'Corner Plot',
      imageUrl: 'https://picsum.photos/seed/mkmprop2/900/600',
    ),
    PropertyItem(
      id: 'PROP-103',
      title: 'MKM Smart City Township',
      location: 'Near Proposed Metro Station',
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

// AUTH SCREEN
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
        setState(() => errorMessage = 'Invalid Admin Passcode! (Use: admin123)');
      }
    } else {
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
        setState(() => errorMessage = 'Agent ID not found! Enter: AGT-101');
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
                'Marketing & Agent CRM Portal',
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
                      if (!isAdminTab)
                        TextField(
                          controller: _idController,
                          decoration: const InputDecoration(
                            labelText: 'Agent ID',
                            hintText: 'e.g. AGT-101',
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder(),
                          ),
                        )
                      else
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Admin Password',
                            hintText: 'admin123',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
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
                          child: Text(isAdminTab ? 'Open Admin Panel' : 'Login as Agent', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isAdminTab ? 'Admin Pass: admin123' : 'Demo Agent ID: AGT-101',
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

// NAVIGATION SHELL
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
    final bool isAdmin = user.role == UserRole.admin;

    final pages = [
      const PropertyDirectoryScreen(),
      const EMICalculatorScreen(),
      if (isAdmin) const AdminDashboardScreen() else const AgentProfileScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_work_outlined), selectedIcon: Icon(Icons.home_work), label: 'Plots'),
          const NavigationDestination(icon: Icon(Icons.calculate_outlined), selectedIcon: Icon(Icons.calculate), label: 'EMI'),
          if (isAdmin)
            const NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), selectedIcon: Icon(Icons.admin_panel_settings), label: 'Admin Desk')
          else
            const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// PROPERTY LIST SCREEN
class PropertyDirectoryScreen extends StatelessWidget {
  const PropertyDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppDatabase.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MKM Plot Inventory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('${user.name} (${user.role == UserRole.admin ? 'Admin' : user.id})', style: const TextStyle(fontSize: 11, color: Colors.white70)),
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
                              const Text('Dimensions', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              Text(prop.size, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Rate & Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
                              Text(prop.priceDisplay, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
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
                          label: const Text('Create Branded Poster'),
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

// POSTER STUDIO
class PosterDesignStudio extends StatefulWidget {
  final PropertyItem property;
  final UserAccount agent;

  const PosterDesignStudio({super.key, required this.property, required this.agent});

  @override
  State<PosterDesignStudio> createState() => _PosterDesignStudioState();
}

class _PosterDesignStudioState extends State<PosterDesignStudio> {
  String selectedBadge = 'Immediate Registry';

  final List<String> availableBadges = [
    'Immediate Registry',
    'Bank Loan Approved',
    'Corner Plot Available',
    'Festive Offer',
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
            const Text('Choose Promotional Tag:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final badge in availableBadges)
                  ChoiceChip(
                    label: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 11,
                        color: selectedBadge == badge ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: selectedBadge == badge,
                    selectedColor: const Color(0xFF0D47A1),
                    onSelected: (val) => setState(() => selectedBadge = badge),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: AspectRatio(
                aspectRatio: 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10)],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.property.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => Container(color: Colors.grey.shade900),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0D47A1), Colors.transparent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.domain, color: Colors.amber, size: 20),
                                  const SizedBox(width: 6),
                                  Text('MKM REAL ESTATE', style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                                child: Text(selectedBadge, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 84,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.property.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(widget.property.location, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.property.size, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 12)),
                                  Text(widget.property.priceDisplay, style: const TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF002171), Color(0xFF0D47A1)],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.amber,
                                child: Icon(Icons.person, color: Colors.black, size: 26),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(widget.agent.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.verified, color: Colors.amber, size: 14),
                                      ],
                                    ),
                                    Text('Contact: ${widget.agent.phone}', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600)),
                                    Text('Agent ID: ${widget.agent.id}', style: const TextStyle(color: Colors.white60, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Poster for ${widget.agent.name} is ready for WhatsApp!'),
                      backgroundColor: Colors.green.shade800,
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share to WhatsApp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// EMI CALCULATOR
class EMICalculatorScreen extends StatefulWidget {
  const EMICalculatorScreen({super.key});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  double totalAmount = 1500000;
  double downPayment = 300000;
  double interestRate = 8.5;
  int tenureYears = 10;

  double get monthlyEMI {
    final principal = totalAmount - downPayment;
    if (principal <= 0) return 0;
    final r = (interestRate / 12) / 100;
    final n = tenureYears * 12;
    return (principal * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
  }

  @override
  Widget build(BuildContext context) {
    final loanAmount = max(0.0, totalAmount - downPayment);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plot EMI Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              color: const Color(0xFF0D47A1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Estimated Monthly Payment', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(
                      '₹${monthlyEMI.toStringAsFixed(0)} / mo',
                      style: const TextStyle(color: Colors.amber, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.white24, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Loan Amount', style: TextStyle(color: Colors.white60, fontSize: 11)),
                            Text('₹${(loanAmount / 100000).toStringAsFixed(2)} Lakhs', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Tenure', style: TextStyle(color: Colors.white60, fontSize: 11)),
                            Text('$tenureYears Years', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _sliderTile('Total Plot Cost', totalAmount, 500000, 10000000, 50000, '₹${(totalAmount / 100000).toStringAsFixed(1)}L', (val) => setState(() => totalAmount = val)),
            _sliderTile('Down Payment', downPayment, 0, totalAmount, 25000, '₹${(downPayment / 100000).toStringAsFixed(1)}L', (val) => setState(() => downPayment = val)),
            _sliderTile('Interest Rate (% P.A)', interestRate, 6.0, 15.0, 0.25, '${interestRate.toStringAsFixed(2)}%', (val) => setState(() => interestRate = val)),
            _sliderTile('Tenure (Years)', tenureYears.toDouble(), 1, 30, 1, '$tenureYears Yrs', (val) => setState(() => tenureYears = val.toInt())),
          ],
        ),
      ),
    );
  }

  Widget _sliderTile(String title, double val, double min, double max, double step, String display, ValueChanged<double> onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(display, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
              ],
            ),
            Slider(
              value: val.clamp(min, max),
              min: min,
              max: max,
              divisions: ((max - min) / step).round(),
              activeColor: const Color(0xFF0D47A1),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ADMIN DASHBOARD
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  void _openAddPropertyModal() {
    final titleCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final sizeCtrl = TextEditingController();
    final rateCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Plot Listing'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Plot / Project Title')),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location / Landmark')),
              TextField(controller: sizeCtrl, decoration: const InputDecoration(labelText: 'Dimensions (e.g. 1500 sq.ft)')),
              TextField(controller: rateCtrl, decoration: const InputDecoration(labelText: 'Rate (e.g. ₹1,200/sq.ft)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  AppDatabase.properties.insert(
                    0,
                    PropertyItem(
                      id: 'PROP-${DateTime.now().millisecondsSinceEpoch}',
                      title: titleCtrl.text,
                      location: locCtrl.text,
                      size: sizeCtrl.text,
                      priceNumeric: 1500000,
                      priceDisplay: rateCtrl.text,
                      badge: 'New Launch',
                      imageUrl: 'https://picsum.photos/seed/${Random().nextInt(999)}/900/600',
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Publish Plot'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MKM Admin Control Console', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _kpiCard('Active Plots', '${AppDatabase.properties.length}', Icons.landscape, Colors.blue),
                const SizedBox(width: 10),
                _kpiCard('Agents', '${AppDatabase.registeredAgents.length}', Icons.groups, Colors.amber.shade800),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Manage Plot Inventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), foregroundColor: Colors.white),
                  onPressed: _openAddPropertyModal,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Plot'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...AppDatabase.properties.map((prop) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.home_work, color: Color(0xFF0D47A1)),
                    title: Text(prop.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${prop.location} • ${prop.size}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() => AppDatabase.properties.removeWhere((p) => p.id == prop.id));
                      },
                    ),
                  ),
                )),
            const SizedBox(height: 24),
            const Text('Authorized MKM Agents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...AppDatabase.registeredAgents.map((agt) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(agt.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${agt.id} • ${agt.phone}'),
                    trailing: const Chip(label: Text('Active', style: TextStyle(fontSize: 10)), backgroundColor: Colors.lightGreenAccent),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// AGENT PROFILE
class AgentProfileScreen extends StatelessWidget {
  const AgentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppDatabase.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Agent Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF0D47A1),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('ID: ${user.id}', style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact Number'),
              subtitle: Text(user.phone),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email ID'),
              subtitle: Text(user.email),
            ),
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Designation'),
              subtitle: const Text('Authorized Senior Property Advisor'),
            ),
          ],
        ),
      ),
    );
  }
}
