

import 'package:json_annotation/json_annotation.dart';

part 'shouts_model.g.dart';

@JsonSerializable()
class ShoutModel
{

  int? status;
  List<Shout>? user_all_promises;
  String? message;
  ShoutModel(this.status,this.user_all_promises,this.message);

  factory ShoutModel.fromJson(Map<String, dynamic> json) => _$ShoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShoutModelToJson(this);
}


@JsonSerializable()
class Shout{
  int? id;
  int? user_id;
  String? promise;
  int? status;
  String? created_at;
  String? updated_at;

  Shout(this.id,this.user_id,this.promise,this.status,this.created_at,this.updated_at);
  factory Shout.fromJson(Map<String, dynamic> json) => _$ShoutFromJson(json);

  Map<String, dynamic> toJson() => _$ShoutToJson(this);

}
