// To parse this JSON data, do
//
//     final PetModel = PetModelFromJson(jsonString);

import 'dart:convert';

List<PetModel> petModelFromJson(String str) =>
    List<PetModel>.from(json.decode(str).map((x) => PetModel.fromJson(x)));

String petModelToJson(List<PetModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PetModel {
  final String? id;
  final Specie? specie;
  final List<String>? userId;
  final bool? sex;
  final String? name;
  final String? photo;
  final DateTime? borndate;
  final dynamic deletedAt;
  final dynamic sterillized;

  PetModel({
    this.id,
    this.specie,
    this.userId,
    this.sex,
    this.name,
    this.photo,
    this.borndate,
    this.deletedAt,
    this.sterillized,
  });

  PetModel copyWith({
    String? id,
    Specie? specie,
    List<String>? userId,
    bool? sex,
    String? name,
    String? photo,
    DateTime? borndate,
    dynamic deletedAt,
    dynamic sterillized,
  }) =>
      PetModel(
        id: id ?? this.id,
        specie: specie ?? this.specie,
        userId: userId ?? this.userId,
        sex: sex ?? this.sex,
        name: name ?? this.name,
        photo: photo ?? this.photo,
        borndate: borndate ?? this.borndate,
        deletedAt: deletedAt ?? this.deletedAt,
        sterillized: sterillized ?? this.sterillized,
      );

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
        id: json["id"],
        specie: Specie.fromJson(json["specie"]),
        userId: List<String>.from(json["user_id"].map((x) => x)),
        sex: json["sex"],
        name: json["name"],
        photo: json["photo"],
        borndate: DateTime.parse(json["borndate"]),
        deletedAt: json["deleted_at"],
        sterillized: json["sterillized"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "borndate":
            "${borndate!.year.toString().padLeft(4, '0')}-${borndate!.month.toString().padLeft(2, '0')}-${borndate!.day.toString().padLeft(2, '0')}",
        "specie": specie!.toJson(),
        "sex": sex,
        "sterillized": sterillized,
        "user_id": List<dynamic>.from(userId!.map((x) => x)),
        "photo": photo,
      };
}

class Specie {
  final String? name;
  final String? id;

  Specie({
    this.name,
    this.id,
  });

  Specie copyWith({
    String? name,
    String? id,
  }) =>
      Specie(
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory Specie.fromJson(Map<String, dynamic> json) => Specie(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
