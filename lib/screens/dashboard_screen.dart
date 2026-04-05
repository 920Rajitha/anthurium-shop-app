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
    "Livium","Jaguwar","Rainbow","Lili","Million",
    "Ceuro","Bambino Red","Cardinal","Black Love","Cirano",
  ];

  int selectedIndex = 0;
  String searchQuery = "";

  Future<void> refreshData() async {
    setState(() {});
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
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                // 💎 HEADER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [

                      const Expanded(
                        child: Text(
                          "Anthurium Shop 🌸",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfileScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.green),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => searchQuery = value.toLowerCase());
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search plants...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🪴 CATEGORY CHIPS
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {

                      bool isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
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

                // 🌸 GRID
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
                          child: Text("Error ❌", style: TextStyle(color: Colors.white)),
                        );
                      }

                      List<Plant> allPlants = snapshot.data ?? [];

                      List<Plant> plants = allPlants
                          .where((p) =>
                              p.category == selectedCategory &&
                              p.name.toLowerCase().contains(searchQuery))
                          .toList();

                      if (plants.isEmpty) {
                        return const Center(
                          child: Text(
                            "No plants found 🌿",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return RefreshIndicator(
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

                            return TweenAnimationBuilder(
                              tween: Tween(begin: 0.9, end: 1.0),
                              duration: const Duration(milliseconds: 300),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale as double,
                                  child: child,
                                );
                              },
                              child: GestureDetector(
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [

                                      Positioned.fill(
                                        child: Image.asset(
                                          plant.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      Container(
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
                                              ),
                                            ),

                                            Text(
                                              plant.prices["Small"] ?? "",
                                              style: const TextStyle(
                                                color: Colors.greenAccent,
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