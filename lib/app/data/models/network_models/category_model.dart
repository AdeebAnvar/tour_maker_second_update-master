// class CategoryModel {
//   CategoryModel({this.id, this.name, this.image});
//   int? id;
//   String? name;
//   String? image;

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'name': name,
//         'image': image,
//       };

//   static CategoryModel fromJson(Map<String, dynamic> json) => CategoryModel(
//         id: json['id'] as int,
//         name: json['name'] == null ? '' : json['name'] as String,
//         image: json['image'] == null ? '' : json['image'] as String,
//       );
// }
class CategoryModel {
  String? message;
  List<CategoriesAPIResult>? result;
  bool? success;

  CategoryModel({this.message, this.result, this.success});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <CategoriesAPIResult>[];
      json['result'].forEach((v) {
        result!.add(new CategoriesAPIResult.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] =
          this.result!.map((CategoriesAPIResult v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class CategoriesAPIResult {
  int? id;
  String? name;
  String? image;

  CategoriesAPIResult({this.id, this.name, this.image});

  CategoriesAPIResult.fromJson(Map<String, dynamic> json) {
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
