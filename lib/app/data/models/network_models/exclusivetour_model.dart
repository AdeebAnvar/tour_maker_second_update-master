class ExclusiveToursModel {
  ExclusiveToursModel({this.id, this.name, this.image});
  int? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': image,
      };

  static ExclusiveToursModel fromJson(Map<String, dynamic> json) =>
      ExclusiveToursModel(
        id: json['id'] as int,
        name: json['name'] == null ? '' : json['name'] as String,
        image: json['image'] as String,
      );
}

/////
///
///
///
class ExclusiveToursModels {
  String? message;
  List<Exclusive>? result;
  bool? success;

  ExclusiveToursModels({this.message, this.result, this.success});

  ExclusiveToursModels.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <Exclusive>[];
      json['result'].forEach((v) {
        result!.add(new Exclusive.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Exclusive {
  int? id;
  String? name;
  String? image;

  Exclusive({this.id, this.name, this.image});

  Exclusive.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
