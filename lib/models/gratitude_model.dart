
class GratitudeModel {
  final List<Gratitude>? gratitudeList;

  GratitudeModel({required this.gratitudeList});

  factory GratitudeModel.fromJson(List<dynamic> parsedJson) {
    List<Gratitude> gratitudes;
    gratitudes = parsedJson.map((i) => Gratitude.fromJson(i)).toList();
    return GratitudeModel(gratitudeList: gratitudes);
  }
}

class Gratitude {
  Gratitude({
    required this.id,
    required this.user_id,
    required this.gratitude,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

   int? id;
   int? user_id;
   String? gratitude;
   int? status;
   String? created_at;
   String? updated_at;

  factory Gratitude.fromJson(Map<String, dynamic> parsedJson) {
    return Gratitude(
        id: parsedJson['id'],
        user_id: parsedJson['user_id'],
        gratitude: parsedJson['gratitude'],
        status: parsedJson['status'],
        created_at: parsedJson['created_at'],
        updated_at: parsedJson['updated_at']);
  }
}