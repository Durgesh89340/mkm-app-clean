import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MKMRealEstateApp());
}

// ==========================================
// THEME & COLOR PALETTE
// ==========================================
class MKMTheme {
  static const Color primaryNavy = Color(0xFF0A192F);
  static const Color secondaryNavy = Color(0xFF172A45);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF3E5AB);
  static const Color darkGold = Color(0xFFAA7C11);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color emeraldGreen = Color(0xFF10B981);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryNavy,
        primary: primaryNavy,
        secondary: accentGold,
        surface: surfaceWhite,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryNavy,
        foregroundColor: surfaceWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: accentGold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ==========================================
// DATA MODELS
// ==========================================
class Plot {
  final String id;
  final String title;
  final int sizeSqFt;
  final double ratePerSqFt;
  final String location;
  final String imageUrl;
  final String zoneType;
  final bool isFeatured;
  final List<String> highlights;

  const Plot({
    required this.id,
    required this.title,
    required this.sizeSqFt,
    required this.ratePerSqFt,
    required this.location,
    required this.imageUrl,
    required this.zoneType,
    this.isFeatured = false,
    required this.highlights,
  });

  double get totalPrice => sizeSqFt * ratePerSqFt;

  String get formattedPrice {
    if (totalPrice >= 10000000) {
      return '₹${(totalPrice / 10000000).toStringAsFixed(2)} Cr';
    } else if (totalPrice >= 100000) {
      return '₹${(totalPrice / 100000).toStringAsFixed(2)} Lakhs';
    }
    return '₹${totalPrice.toStringAsFixed(0)}';
  }
}

class AgentProfile {
  String name;
  String phone;
  String agentId;
  String designation;
  String avatarUrl;

  AgentProfile({
    required this.name,
    required this.phone,
    required this.agentId,
    required this.designation,
    required this.avatarUrl,
  });
}

// Sample Initial Mock Data
final List<Plot> mockPlots = [
  const Plot(
    id: 'MKM-P101',
    title: 'Imperial Crown Villa Plots',
    sizeSqFt: 2400,
    ratePerSqFt: 3500,
    location: 'Emerald Hills, Sector 45',
    imageUrl:
        'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=900&q=80',
    zoneType: 'Gated Township',
    isFeatured: true,
    highlights: ['Corner Plot', '30ft Wide Road', 'Clubhouse Facing', 'RERA Approved'],
  ),
  const Plot(
    id: 'MKM-P102',
    title: 'Green Valley Premium Estate',
    sizeSqFt: 1800,
    ratePerSqFt: 2850,
    location: 'Outer Ring Corridor, Phase 2',
    imageUrl:
        'https://images.unsplash.com/photo-1524813686514-a57563d77d61?w=900&q=80',
    zoneType: 'Residential Area',
    isFeatured: false,
    highlights: ['East Facing', 'Underground Utilities', 'Immediate Registry'],
  ),
  const Plot(
    id: 'MKM-P103',
    title: 'Skyline Boulevard Commercial',
    sizeSqFt: 4500,
    ratePerSqFt: 6200,
    location: 'Central Business Expressway',
    imageUrl:
        'https://images.unsplash.com/photo-1628744448840-55bdb2497bd4?w=900&q=80',
    zoneType: 'Commercial SCO',
    isFeatured: true,
    highlights: ['Main Highway Frontage', '150ft Wide Road', 'High ROI'],
  ),
  const Plot(
    id: 'MKM-P104',
    title: 'Serene Palms Farm Plots',
    sizeSqFt: 10890, // ~0.25 Acre
    ratePerSqFt: 1200,
    location: 'Lake View Enclave, South Zone',
    imageUrl:
        'https://images.unsplash.com/photo-1500076656116-558758c991c1?w=900&q=80',
    zoneType: 'Farmhouse / Agri',
    isFeatured: false,
    highlights: ['Fruit Trees Planted', 'Drip Irrigation', 'Fenced Boundary'],
  ),
];

// ==========================================
// MAIN APP ROOT
// ==========================================
class MKMRealEstateApp extends StatelessWidget {
  const MKMRealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKM Real Estate Marketing',
      debugShowCheckedModeBanner: false,
      theme: MKMTheme.lightTheme,
      home: const PlotListScreen(),
    );
  }
}

// ==========================================
// SCREEN 1: PLOT LISTINGS SCREEN
// ==========================================
class PlotListScreen extends StatefulWidget {
  const PlotListScreen({super.key});

  @override
  State<PlotListScreen> createState() => _PlotListScreenState();
}

class _PlotListScreenState extends State<PlotListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Gated Township', 'Residential Area', 'Commercial SCO', 'Farmhouse / Agri'];

  // Global default agent state
  final AgentProfile _currentAgent = AgentProfile(
    name: 'Rajesh Sharma',
    phone: '+91 98765 43210',
    agentId: 'MKM-DIR-884',
    designation: 'Senior Property Advisor',
    avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&q=80',
  );

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedFilter == 'All'
        ? mockPlots
        : mockPlots.where((p) => p.zoneType == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('MKM REAL ESTATE'),
            Text(
              'MARKETING & SALES PORTAL',
              style: GoogleFonts.montserrat(
                fontSize: 9,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Agent Profile',
            icon: const Icon(Icons.account_circle_outlined, color: MKMTheme.accentGold),
            onPressed: () => _editAgentDialog(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Filter Chips Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: MKMTheme.surfaceWhite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() => _selectedFilter = filter);
                        },
                        selectedColor: MKMTheme.primaryNavy,
                        labelStyle: TextStyle(
                          color: isSelected ? MKMTheme.accentGold : MKMTheme.textDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        backgroundColor: MKMTheme.backgroundLight,
                        checkmarkColor: MKMTheme.accentGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? MKMTheme.accentGold : Colors.black12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Plots List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final plot = filteredList[index];
                  return PlotCard(
                    plot: plot,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlotDetailScreen(
                            plot: plot,
                            agent: _currentAgent,
                          ),
                        ),
                      );
                    },
                    onGeneratePoster: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PosterStudioScreen(
                            plot: plot,
                            agent: _currentAgent,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: filteredList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editAgentDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: _currentAgent.name);
    final phoneCtrl = TextEditingController(text: _currentAgent.phone);
    final idCtrl = TextEditingController(text: _currentAgent.agentId);
    final desigCtrl = TextEditingController(text: _currentAgent.designation);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Agent Branding Info',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Agent Name'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone / WhatsApp'),
              ),
              TextField(
                controller: desigCtrl,
                decoration: const InputDecoration(labelText: 'Designation'),
              ),
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'Agent / RERA ID'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MKMTheme.primaryNavy,
              foregroundColor: MKMTheme.accentGold,
            ),
            onPressed: () {
              setState(() {
                _currentAgent.name = nameCtrl.text;
                _currentAgent.phone = phoneCtrl.text;
                _currentAgent.agentId = idCtrl.text;
                _currentAgent.designation = desigCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// COMPONENT: PLOT CARD
// ==========================================
class PlotCard extends StatelessWidget {
  final Plot plot;
  final VoidCallback onTap;
  final VoidCallback onGeneratePoster;

  const PlotCard({
    super.key,
    required this.plot,
    required this.onTap,
    required this.onGeneratePoster,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image with Badges
            Stack(
              children: [
                Image.network(
                  plot.imageUrl,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 190,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 190,
                    color: MKMTheme.secondaryNavy,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white54, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: MKMTheme.primaryNavy.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: MKMTheme.accentGold, width: 0.8),
                    ),
                    child: Text(
                      plot.zoneType,
                      style: GoogleFonts.montserrat(
                        color: MKMTheme.accentGold,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      plot.formattedPrice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plot.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MKMTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: MKMTheme.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          plot.location,
                          style: const TextStyle(fontSize: 12, color: MKMTheme.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 0.8),
                  
                  // Key Specs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecItem(Icons.aspect_ratio, 'Area Size', '${plot.sizeSqFt} sq.ft'),
                      _buildSpecItem(Icons.payments_outlined, 'Rate', '₹${plot.ratePerSqFt.toStringAsFixed(0)} /sq.ft'),
                      _buildSpecItem(Icons.verified_outlined, 'Status', 'Ready'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Quick Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.info_outline, size: 16),
                          label: const Text('Details'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: MKMTheme.primaryNavy,
                            side: const BorderSide(color: MKMTheme.primaryNavy),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onGeneratePoster,
                          icon: const Icon(Icons.campaign, size: 18),
                          label: const Text('Poster'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MKMTheme.primaryNavy,
                            foregroundColor: MKMTheme.accentGold,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: MKMTheme.textMuted),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: MKMTheme.textMuted)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: MKMTheme.textDark),
        ),
      ],
    );
  }
}

// ==========================================
// SCREEN 2: PLOT DETAIL SCREEN
// ==========================================
class PlotDetailScreen extends StatelessWidget {
  final Plot plot;
  final AgentProfile agent;

  const PlotDetailScreen({super.key, required this.plot, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plot.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
     
