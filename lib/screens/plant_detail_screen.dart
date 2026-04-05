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
    // ✅ first available size auto select
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

                  // 📸 IMAGE (Firebase OR Assets)
                  Stack(
                    children: [

                      plant.image.startsWith("http")
                          ? Image.network(
                              plant.image,
                              height: 260,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Center(child: Icon(Icons.image, color: Colors.white)),
                            )
                          : Image.asset(
                              plant.image,
                              height: 260,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                      Container(
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),

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

                      Positioned(
                        bottom: 15,
                        left: 15,
                        child: Text(
                          plant.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 💎 CONTENT
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                                "🪴 වර්ගය: ${widget.category}",
                                style: const TextStyle(color: Colors.white70),
                              ),

                              const SizedBox(height: 10),

                              // 📝 Description
                              Text(
                                plant.description,
                                style: const TextStyle(color: Colors.white70),
                              ),

                              const SizedBox(height: 15),

                              // 📏 Dynamic Size Buttons
                              const Text(
                                "📏 ප්‍රමාණය තෝරන්න",
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
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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

                              // 💰 PRICE
                              Text(
                                "💰 මිල: ${getPriceText()}",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // 📦 STOCK
                              Text(
                                "📦 Stock: ${plant.stock} පමණ තිබේ",
                                style: const TextStyle(color: Colors.white70),
                              ),

                              const SizedBox(height: 20),

                              // 🔢 Quantity
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  const Text("ගණන:", style: TextStyle(color: Colors.white)),

                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
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
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(height: 25),

                              // 🛒 BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 50,
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
                                    "Order Now 🛒",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}