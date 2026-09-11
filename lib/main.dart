import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MKMRealEstateApp());
}

class MKMRealEstateApp extends StatelessWidget {
  const MKMRealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKM Real Estate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const PlotListScreen(),
    );
  }
}

class Property {
  final String title;
  final String location;
  final String size;
  final String rate;
  final String imageUrl;

  const Property({
    required this.title,
    required this.location,
    required this.size,
    required this.rate,
    required this.imageUrl,
  });
}

final List<Property> sampleProperties = [
  const Property(
    title: 'MKM Green Paradise',
    location: 'Sector 15, Near Highway',
    size: '1200 - 2400 sq.ft',
    rate: '₹1,250 / sq.ft',
    imageUrl: 'https://picsum.photos/seed/mkm1/800/800',
  ),
  const Property(
    title: 'MKM Royal Residency',
    location: 'Airport Road, Ring Road',
    size: '1000 - 1800 sq.ft',
    rate: '₹1,650 / sq.ft',
    imageUrl: 'https://picsum.photos/seed/mkm2/800/800',
  ),
  const Property(
    title: 'MKM Smart City Enclave',
    location: 'Near Metro Station',
    size: '800 - 1500 sq.ft',
    rate: '₹999 / sq.ft',
    imageUrl: 'https://picsum.photos/seed/mkm3/800/800',
  ),
];

class PlotListScreen extends StatefulWidget {
  const PlotListScreen({super.key});

  @override
  State<PlotListScreen> createState() => _PlotListScreenState();
}

class _PlotListScreenState extends State<PlotListScreen> {
  String agentName = 'Durgesh Tiwari';
  String agentPhone = '+91 98765 43210';
  String agentId = 'MKM-7890';

  void _editAgentProfile() {
    final nameCtrl = TextEditingController(text: agentName);
    final phoneCtrl = TextEditingController(text: agentPhone);
    final idCtrl = TextEditingController(text: agentId);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Agent Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Agent Name')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'WhatsApp / Phone')),
            TextField(controller: idCtrl, decoration: const InputDecoration(labelText: 'Agent ID / Code')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                agentName = nameCtrl.text;
                agentPhone = phoneCtrl.text;
                agentId = idCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MKM Plots', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: _editAgentProfile,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sampleProperties.length,
        itemBuilder: (context, index) {
          final item = sampleProperties[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    item.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 180,
                      color: Colors.blueGrey.shade100,
                      child: const Center(child: Icon(Icons.landscape, size: 48)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Text(item.location, style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.size, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(item.rate, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D47A1),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PosterStudioScreen(
                                  property: item,
                                  agentName: agentName,
                                  agentPhone: agentPhone,
                                  agentId: agentId,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.brush),
                          label: const Text('Create My Poster'),
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

class PosterStudioScreen extends StatelessWidget {
  final Property property;
  final String agentName;
  final String agentPhone;
  final String agentId;

  const PosterStudioScreen({
    super.key,
    required this.property,
    required this.agentName,
    required this.agentPhone,
    required this.agentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Poster', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          property.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(color: Colors.grey.shade800),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D47A1).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('MKM REAL ESTATE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
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
                                colors: [Colors.black, Color(0xFF0D47A1)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.amber,
                                  child: Icon(Icons.person, color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(agentName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                      Text('Call / WhatsApp: $agentPhone', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w600)),
                                      Text('Agent ID: $agentId', style: const TextStyle(color: Colors.white70, fontSize: 11)),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Poster Ready for WhatsApp Status!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share to WhatsApp', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
