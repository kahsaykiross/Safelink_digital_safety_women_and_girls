import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SafetyApp());
}

class SafetyApp extends StatelessWidget {
  const SafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Digital Safety Toolkit",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// -------------------------------------------------------------
// WELCOME SCREEN
// -------------------------------------------------------------
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shield, size: 120, color: Colors.purple[700]),
              const SizedBox(height: 20),
              const Text(
                "Digital Safety Toolkit",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "A safe–space app built for PowerHacks 2025 to protect women & girls online.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                child: const Text("Get Started"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// HOME PAGE
// -------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Toolkit"),
        backgroundColor: Colors.purple,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        children: [
          featureButton(
            context,
            icon: Icons.record_voice_over,
            text: "Safety Tips",
            screen: const SafetyTipsScreen(),
          ),
          featureButton(
            context,
            icon: Icons.report,
            text: "Report Incident",
            screen: const IncidentReportScreen(),
          ),
          featureButton(
            context,
            icon: Icons.sos,
            text: "SOS Emergency",
            screen: const SosScreen(),
          ),
          featureButton(
            context,
            icon: Icons.lock,
            text: "Online Protection",
            screen: const ProtectionGuides(),
          ),
        ],
      ),
    );
  }
}

Widget featureButton(BuildContext context,
    {required IconData icon, required String text, required Widget screen}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.purple),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

// -------------------------------------------------------------
// SAFETY TIPS SCREEN
// -------------------------------------------------------------
class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  final List<String> tips = const [
    "Do not share personal photos with strangers.",
    "Use strong passwords and enable 2FA.",
    "Block and report threatening accounts.",
    "Avoid clicking unknown links.",
    "Document evidence of online harassment.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Safety Tips"),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(tips[index]),
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// INCIDENT REPORT (Stored Locally)
// -------------------------------------------------------------
class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  TextEditingController reportController = TextEditingController();
  String? savedReport;

  @override
  void initState() {
    super.initState();
    loadSavedReport();
  }

  Future<void> loadSavedReport() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedReport = prefs.getString("incident_report");
    });
  }

  Future<void> saveReport() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("incident_report", reportController.text);

    setState(() {
      savedReport = reportController.text;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Report Saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Incident"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Describe what happened. This will be saved only on your device for safety.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reportController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter incident details...",
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: saveReport,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text("Save Report"),
            ),
            if (savedReport != null) ...[
              const SizedBox(height: 20),
              const Text("Saved Report:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(savedReport!),
            ]
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// SOS EMERGENCY CALLING
// -------------------------------------------------------------
class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  Future<void> callNumber(String number) async {
    final Uri url = Uri(scheme: "tel", path: number);
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SOS Emergency"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Tap to call emergency numbers:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            sosButton("911"),
            sosButton("112"),
            sosButton("999"),
            sosButton("833"),
          ],
        ),
      ),
    );
  }

  Widget sosButton(String number) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.phone, color: Colors.red),
        title: Text("Call $number"),
        onTap: () => callNumber(number),
      ),
    );
  }
}

// -------------------------------------------------------------
// ONLINE PROTECTION GUIDES
// -------------------------------------------------------------
class ProtectionGuides extends StatelessWidget {
  const ProtectionGuides({super.key});

  final List<String> guides = const [
    "How to protect your Facebook account",
    "How to protect your TikTok account",
    "How to secure your Instagram",
    "How to avoid digital stalking",
    "How to report cyberbullying",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Protection Guides"),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: guides.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.lock, color: Colors.blue),
              title: Text(guides[index]),
            ),
          );
        },
      ),
    );
  }
}
