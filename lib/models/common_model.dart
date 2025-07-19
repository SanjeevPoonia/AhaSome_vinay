
import 'package:freezed_annotation/freezed_annotation.dart';
part 'common_model.g.dart';

@JsonSerializable()
class CommonModel
{
  int status;
  String message;

  CommonModel(this.status,this.message);

  factory CommonModel.fromJson(Map<String, dynamic> json) => _$CommonModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommonModelToJson(this);

}