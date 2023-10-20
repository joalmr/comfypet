import 'dart:developer';
import 'dart:io';
import 'package:petmeals/app/data/pet/datasources/pets_data.dart';
import 'package:petmeals/app/data/pet/models/pet_model.dart';
import 'package:petmeals/app/data/pet/models/specie_model.dart';
import 'package:petmeals/config/storage/storage.data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetProvider extends ChangeNotifier {
  final PetsData petData;

  PetProvider({required this.petData}) {
    loadStream().listen((event) {
      if (event.isNotEmpty) {
        pet = event.first;
      }
    });
  }

  String userId = MyStorage().uid;
  //? OBTIENE USER ID

  List<PetModel> myPets = [];
  PetModel? pet;

  int specie = 0;
  bool sex = false;
  DateTime borndate = DateTime.now();
  bool sterillized = false;
  int actions = 0;

  final specieJson = {
    0: Specie(id: '0', name: 'Gato'),
    1: Specie(id: '1', name: 'Perro'),
  };

  XFile? _imagen;
  FileImage? imageFile;

  Stream<List<PetModel>> loadStream() => petData.getPetStream(userId);

  void myPet(PetModel myPet) async {
    pet = myPet;
    notifyListeners();
  }

  Future<bool> addPet(PetModel? newPet) async {
    newPet = PetModel(
      name: newPet!.name,
      borndate: borndate,
      specie: specieJson[specie]!,
      sex: sex,
      sterillized: sterillized,
      userId: [userId],
    );
    inspect(newPet);
    final img = File(_imagen!.path);
    final response = await petData.addPeT(newPet, img, userId);
    if (response) {
      specie = 0;
      sex = false;
      borndate = DateTime.now();
      sterillized = false;
      _imagen = null;
      imageFile = null;
    }

    return response;
  }

  Future<void> deletePet(String id) async {
    await petData.deletePet(id, userId);
    if (myPets.isNotEmpty) {
      pet = myPets.first;
    }
    notifyListeners();
  }

  void procesarImagen(ImageSource origen) async {
    _imagen = await ImagePicker().pickImage(source: origen, imageQuality: 80);
    imageFile = FileImage(File(_imagen!.path));
    notifyListeners();
  }

  void actionSet(int action) {
    actions = action;
    notifyListeners();
  }
}
