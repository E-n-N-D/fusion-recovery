import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fusion_recovery/models/fraModel.dart';
import 'package:fusion_recovery/models/frcModel.dart';
import 'package:fusion_recovery/models/frrModel.dart';

const String FRC_COLLECTION_REF = "frc";
const String FRA_COLLECTION_REF = "fra";
const String FRR_COLLECTION_REF = "frr";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _frcRef;
  late final CollectionReference _fraRef;
  late final CollectionReference _frrRef;

  DatabaseService() {
    _frcRef = _firestore
        .collection(FRC_COLLECTION_REF)
        .withConverter<FusionRecoveryCentersModel>(
            fromFirestore: (snapshots, _) =>
                FusionRecoveryCentersModel.fromJson(snapshots.data()!),
            toFirestore: (frc, _) => frc.toJson());

    _fraRef = _firestore
        .collection(FRA_COLLECTION_REF)
        .withConverter<FusionRecoveryAlbany>(
            fromFirestore: (snapshots, _) =>
                FusionRecoveryAlbany.fromJson(snapshots.data()!),
            toFirestore: (fra, _) => fra.toJson());

    _frrRef = _firestore
        .collection(FRR_COLLECTION_REF)
        .withConverter<Fusion820RiverResidential>(
            fromFirestore: (snapshots, _) =>
                Fusion820RiverResidential.fromJson(snapshots.data()!),
            toFirestore: (frr, _) => frr.toJson());
  }

  Future<List<Map<String, dynamic>>?> getDataJson(
      String collectionName) async {
    List<Map<String, dynamic>> jsonData = [];

    CollectionReference frRef = collectionName == 'frc'
        ? _frcRef
        : collectionName == 'fra'
            ? _fraRef
            : _frrRef;

    try {
      QuerySnapshot snapshot =
          await frRef.orderBy('forDate', descending: true).get();

      if (snapshot.docs.isEmpty) {
        return [];
      }
      for (var doc in snapshot.docs) {
        dynamic data;
        if (collectionName == 'frc') {
          data = doc.data() as FusionRecoveryCentersModel;
        }else if(collectionName == 'fra'){
          data = doc.data() as FusionRecoveryAlbany;
        }else{
          data = doc.data() as Fusion820RiverResidential;
        }
        jsonData.add(data.toJson());
      }
      return jsonData;
    } catch (e) {
      return null;
    }
  }

  void addAll(FusionRecoveryCentersModel frc, FusionRecoveryAlbany fra,
      Fusion820RiverResidential frr) async {
    _frcRef.add(frc);
    _fraRef.add(fra);
    _frrRef.add(frr);
  }

  void editAll(FusionRecoveryCentersModel frc, FusionRecoveryAlbany fra,
      Fusion820RiverResidential frr, String forDate) async {
    QuerySnapshot frcSnapshot = await _frcRef
        .where('forDate', isEqualTo: forDate)
        .limit(1) // Limit to the first matching document
        .get();

    await _frcRef.doc(frcSnapshot.docs.first.id).update(frc.toJson());

    QuerySnapshot fraSnapshot = await _fraRef
        .where('forDate', isEqualTo: forDate)
        .limit(1) // Limit to the first matching document
        .get();

    await _fraRef.doc(fraSnapshot.docs.first.id).update(fra.toJson());

    QuerySnapshot frrSnapshot = await _frrRef
        .where('forDate', isEqualTo: forDate)
        .limit(1) // Limit to the first matching document
        .get();

    await _frrRef.doc(frrSnapshot.docs.first.id).update(frr.toJson());
  }

  Future<void> deleteAll(String forDate) async {
    // Delete FRC
    QuerySnapshot frcSnapshot = await _frcRef
        .where('forDate', isEqualTo: forDate)
        .get();
    for (var doc in frcSnapshot.docs) {
      await _frcRef.doc(doc.id).delete();
    }

    // Delete FRA
    QuerySnapshot fraSnapshot = await _fraRef
        .where('forDate', isEqualTo: forDate)
        .get();
    for (var doc in fraSnapshot.docs) {
      await _fraRef.doc(doc.id).delete();
    }

    // Delete FRR
    QuerySnapshot frrSnapshot = await _frrRef
        .where('forDate', isEqualTo: forDate)
        .get();
    for (var doc in frrSnapshot.docs) {
      await _frrRef.doc(doc.id).delete();
    }
  }
}
