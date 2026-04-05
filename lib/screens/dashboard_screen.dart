import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../services/firestore_service.dart';
import 'plant_detail_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final List<String> categories = [
    "Livium",
    "Jaguwar",
    "Rainbow",
    "Lili",
    "Million",
    "Ceuro",
    "Bambino Red",
    "Cardinal",
    "Black Love",
    "Cirano",
  ];

  int selectedIndex = 0;

  // 🔄 Refresh
  Future<void> refreshData() async {
    setState(() {}); // rebuild (stream auto refresh)
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {

    String selectedCategory = categories[selectedIndex];

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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                // 💎 HEADER WITH PROFILE
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        "Anthurium Shop 🌸",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // 👤 PROFILE ICON
                      GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen()),
    );
  },
  child: CircleAvatar(
    backgroundColor: Colors.white,
    child: Icon(Icons.person, color: Colors.green),
  ),
)
                    ],
                  ),
                ),

                // 🪴 Categories
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {

                      bool isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: isSelected ? Colors.green : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🔥 FIRESTORE GRID + REFRESH
                Expanded(
                  child: StreamBuilder<List<Plant>>(
                    stream: FirestoreService().getPlants(),
                    builder: (context, snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Error loading data ❌",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      List<Plant> allPlants = snapshot.data ?? [];

                      List<Plant> plants = allPlants
                          .where((p) => p.category == selectedCategory)
                          .toList();

                      if (plants.isEmpty) {
                        return const Center(
                          child: Text(
                            "No plants available 😢",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: Colors.green,
                        onRefresh: refreshData,
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: plants.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {

                            final plant = plants[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlantDetailScreen(
                                      plant: plant,
                                      category: selectedCategory,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [

                                      // 📸 Image
                                      Positioned.fill(
                                        child: Image.asset(
                                          plant.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      // 🌑 Overlay
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.1),
                                                Colors.black.withOpacity(0.7),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // 📄 Details
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              plant.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),

                                            const SizedBox(height: 5),

                                            Text(
                                              plant.prices["Small"] ?? "",
                                              style: const TextStyle(
                                                color: Colors.greenAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}