class CityModel {
  const CityModel({
    required this.id,
    required this.name,
    required this.nameAr,
  });

  final int id;
  final String name;
  final String nameAr;

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'nameAr': nameAr,
      };
}
