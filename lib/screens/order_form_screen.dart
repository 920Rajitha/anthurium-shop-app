import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/plant_model.dart';

class OrderFormScreen extends StatefulWidget {
  final Plant plant;
  final String category;
  final String size;
  final int quantity;

  const OrderFormScreen({
    super.key,
    required this.plant,
    required this.category,
    required this.size,
    required this.quantity,
  });

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;

  Future<File> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Anthurium Order", style: pw.TextStyle(fontSize: 22)),
            pw.SizedBox(height: 10),
            pw.Text("Plant: ${widget.plant.name}"),
            pw.Text("Category: ${widget.category}"),
            pw.Text("Size: ${widget.size}"),
            pw.Text("Quantity: ${widget.quantity}"),
            pw.SizedBox(height: 10),
            pw.Text("Customer: ${nameController.text}"),
            pw.Text("Phone: ${phoneController.text}"),
            pw.Text("Address: ${addressController.text}"),
          ],
        ),
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/order.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> sendWhatsApp() async {
    String message = """
📦 නව ඇණවුමක්!

🌸 ${widget.plant.name}
🪴 ${widget.category}
📏 ${widget.size}
🔢 Qty: ${widget.quantity}

👤 ${nameController.text}
📞 ${phoneController.text}
🏠 ${addressController.text}
""";

    String phone = "94750979908";

    String url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

    await launchUrl(Uri.parse(url));
  }

  void confirmOrder() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("සියලුම තොරතුරු පුරවන්න ⚠️")),
      );
      return;
    }

    setState(() => isLoading = true);

    await generatePdf();
    await sendWhatsApp();

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order Sent ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          // 🌿 Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF052e16),
                  Color(0xFF14532D),
                  Color(0xFF16A34A),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // 🔝 HEADER
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Spacer(),
                        Text(
                          "Order Details 🛒",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // 📸 PLANT PREVIEW
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(widget.plant.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // 💎 AUTO DETAILS
                  buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("📦 ඔබ තෝරාගත් පැළය",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

                        SizedBox(height: 10),

                        Text("🌸 ${widget.plant.name}", style: TextStyle(color: Colors.white70)),
                        Text("🪴 ${widget.category}", style: TextStyle(color: Colors.white70)),
                        Text("📏 ${widget.size}", style: TextStyle(color: Colors.white70)),
                        Text("🔢 Qty: ${widget.quantity}", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  // 📝 FORM CARD
                  buildGlassCard(
                    child: Column(
                      children: [
                        buildInput("👤 නම", nameController),
                        SizedBox(height: 12),
                        buildInput("📞 දුරකථන", phoneController),
                        SizedBox(height: 12),
                        buildInput("🏠 ලිපිනය", addressController),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  // 🛒 BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : confirmOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.green)
                            : Text("Confirm Order 🚀"),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // 💎 Glass Card
  Widget buildGlassCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // ✨ Input
  Widget buildInput(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}