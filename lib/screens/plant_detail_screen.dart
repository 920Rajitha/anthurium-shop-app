import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import 'order_form_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;
  final String category;

  const PlantDetailScreen({
    super.key,
    required this.plant,
    required this.category,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {

  int quantity = 1;
  late String selectedSize;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.plant.prices.keys.first;
  }

  String getPriceText() {
    return widget.plant.prices[selectedSize] ?? "";
  }

  @override
  Widget build(BuildContext context) {

    final plant = widget.plant;

    return Scaffold(
      body: Stack(
        children: [

          // 🌿 PREMIUM BACKGROUND (MULTI LAYER)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF022c22),
                  Color(0xFF052e16),
                  Color(0xFF14532D),
                  Color(0xFF16A34A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ✨ glow overlay
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // 📸 IMAGE WITH DEPTH
                  Stack(
                    children: [

                      plant.image.startsWith("http")
                          ? Image.network(
                              plant.image,
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              plant.image,
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // 🔙 Back button
                      Positioned(
                        top: 10,
                        left: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),

                      // 🌸 Title
                      Positioned(
                        bottom: 20,
                        left: 15,
                        child: Text(
                          plant.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 💎 FLOATING CARD
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // 🪴 Category
                                Text(
                                  "🪴 ${widget.category}",
                                  style: const TextStyle(color: Colors.white70),
                                ),

                                const SizedBox(height: 10),

                                // 📝 Description
                                Text(
                                  plant.description,
                                  style: const TextStyle(color: Colors.white70),
                                ),

                                const SizedBox(height: 20),

                                // 📏 SIZE
                                const Text(
                                  "📏 ප්‍රමාණය",
                                  style: TextStyle(color: Colors.white),
                                ),

                                const SizedBox(height: 10),

                                Wrap(
                                  spacing: 10,
                                  children: plant.prices.keys.map((size) {

                                    bool selected = selectedSize == size;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedSize = size;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          size,
                                          style: TextStyle(
                                            color: selected ? Colors.green : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 15),

                                // 💰 PRICE (GLOW)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "💰 ${getPriceText()}",
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // 📦 STOCK
                                Text(
                                  "📦 Stock: ${plant.stock}",
                                  style: const TextStyle(color: Colors.white70),
                                ),

                                const SizedBox(height: 20),

                                // 🔢 QUANTITY
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    const Text("ගණන:", style: TextStyle(color: Colors.white)),

                                    Row(
                                      children: [

                                        IconButton(
                                          icon: const Icon(Icons.remove, color: Colors.white),
                                          onPressed: () {
                                            if (quantity > 1) {
                                              setState(() => quantity--);
                                            }
                                          },
                                        ),

                                        Text("$quantity",
                                            style: const TextStyle(color: Colors.white)),

                                        IconButton(
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          onPressed: () {
                                            setState(() => quantity++);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),

                                const SizedBox(height: 25),

                                // 🛒 BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => OrderFormScreen(
                                            plant: plant,
                                            category: widget.category,
                                            size: selectedSize,
                                            quantity: quantity,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Order Now 🚀",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}