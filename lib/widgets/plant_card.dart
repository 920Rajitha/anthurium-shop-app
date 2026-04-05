import 'package:flutter/material.dart';
import '../models/plant_model.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;

  const PlantCard({super.key, required this.plant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                plant.image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(plant.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(plant.description, maxLines: 2),
                  Text("Rs. ${plant.price}", style: TextStyle(color: Colors.green)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onTap,
                    child: Text("Order Now"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}