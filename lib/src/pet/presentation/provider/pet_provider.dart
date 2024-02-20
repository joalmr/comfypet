import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:petmeals/config/storage/storage.data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmeals/src/pet/data/models/attentions_model.dart';
import 'package:petmeals/src/pet/data/models/pet_model.dart';
import 'package:petmeals/src/pet/domain/usecases/pet_usecase.dart';

class PetProvider extends ChangeNotifier {
  final PetUseCase petUseCase;

  PetProvider({required this.petUseCase}) {
    MyStorage().box.listen(() {
      userId = MyStorage().uid;
      loadStream().listen((event) {
        if (event.isNotEmpty) {
          myPet(event.first);
        }
      });
    });

    loadStream().listen((event) {
      if (event.isNotEmpty) {
        myPet(event.first);
      }
    });
  }

  String userId = MyStorage().uid;
  PetModel? pet;
  int specie = 0;
  bool sex = false;
  DateTime borndate = DateTime.now();
  bool sterillized = false;
  XFile? _imagen;
  FileImage? imageFile;

  List<AttentionsModel> attentions = [];

  //Mascota
  Stream<List<PetModel>> loadStream() => petUseCase.loadPets(userId);

  addPet(PetModel? newPet) {
    final addPet = newPet!.copyWith(
      borndate: borndate,
      specie: specie,
      sex: sex,
      sterillized: sterillized,
      userId: [userId],
    );
    final img = File(_imagen!.path);

    petUseCase.addPet(addPet, img, userId).then((value) {
      if (value) {
        _cleanPet();
      }
    });
  }

  Future<PetModel?> updatePet(PetModel updatePet) {
    File? img;
    if (_imagen != null) {
      img = File(_imagen!.path);
    }
    final updPet = updatePet.copyWith(
      borndate: borndate,
      specie: specie,
      sex: sex,
      sterillized: sterillized,
      userId: [userId],
    );

    return petUseCase.updatePet(updPet, userId, img).then((value) {
      if (value != null) {
        _cleanPet();
      }
      return value;
    });
  }

  Future<PetModel?> foodPet(PetModel updatePet) async {
    return await petUseCase.foodPet(updatePet, userId).then((value) {
      if (value != null) {
        pet = value;
        notifyListeners();
        Logger().i('Comida registrada');
      }
      return value;
    });
  }

  Future<PetModel?> actionPet(PetModel updatePet) async {
    return await petUseCase.actionPet(updatePet, userId).then((value) {
      if (value != null) {
        pet = value;
        notifyListeners();
        Logger().i('Acción registrada');
      }
      return value;
    });
  }

  deletePet(String id) async {
    await petUseCase.deletePet(id, userId).then((value) => _cleanPet());
  }

  //Atenciones
  getAttentions(String petId, String type) async {
    attentions = [];
    attentions = await petUseCase.getAttentions(petId, type);
    notifyListeners();
    Logger().i('**Lista de atenciones: $attentions');
  }

  addAttention(AttentionsModel attention, String petId) async {
    await petUseCase.addAttention(attention, petId);
  }

  deleteAttention(String id, String petId) async {
    await petUseCase.deleteAttention(id, petId);
  }

  //* Funciones
  //actualizar el modelo de mascota para mostrar
  void myPet(PetModel myPet) {
    pet = myPet;
    notifyListeners();
  }

  //cambiar imagen para mascota
  void procesarImagen(ImageSource origen) async {
    _imagen = await ImagePicker().pickImage(source: origen, imageQuality: 80);
    imageFile = FileImage(File(_imagen!.path));
    notifyListeners();
  }

  //limpiar
  void _cleanPet() {
    specie = 0;
    sex = false;
    borndate = DateTime.now();
    sterillized = false;
    _imagen = null;
    imageFile = null;
  }
}
