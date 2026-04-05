import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plant_model.dart';

class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Plant>> getPlants() {
    return _db.collection('plants').snapshots().map((snapshot) {

      return snapshot.docs.map((doc) {
        return Plant.fromFirestore(
          doc.data(),     // data
          doc.id,         // ✅ FIXED (id add kala)
        );
      }).toList(); // ✅ now correct type
    });
  }
}