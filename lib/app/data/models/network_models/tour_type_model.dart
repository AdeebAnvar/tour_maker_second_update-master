// class TourTypesModel {
//   TourTypesModel({this.tourType, this.tours});
//   String? tourType;
//   List<Tours>? tours;

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'tour_type': tourType,
//         'tours': tours!.map((Tours v) => v.toJson()).toList()
//       };
//   static TourTypesModel fromJson(Map<String, dynamic> json) => TourTypesModel(
//         tourType: json['tour_type'] == null ? '' : json['tour_type'] as String,
//         tours: json['tours'] != null
//             ? (json['tours'] as List<dynamic>)
//                 .map((dynamic e) => Tours.fromJson(e as Map<String, dynamic>))
//                 .toList()
//             : <Tours>[],
//       );
// }

// class Tours {
//   Tours({this.destination, this.id, this.image, this.name});
//   String? destination;
//   int? id;
//   String? image;
//   String? name;

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'destination': destination,
//         'id': id,
//         'image': image,
//         'name': name,
//       };

//   static Tours fromJson(Map<String, dynamic> json) => Tours(
//         destination:
//             json['destination'] == null ? '' : json['destination'] as String,
//         id: json['id'] == null ? 0 : json['id'] as int,
//         image: json['image'] == null ? '' : json['image'] as String,
//         name: json['name'] == null ? '' : json['name'] as String,
//       );
// }
class TourTypeModel {
  String? message;
  List<TourTypeResult>? result;
  bool? success;

  TourTypeModel({this.message, this.result, this.success});

  TourTypeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <TourTypeResult>[];
      json['result'].forEach((v) {
        result!.add(new TourTypeResult.fromJson(v));
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

class TourTypeResult {
  String? tourType;
  List<TourTypesListModel>? tours;

  TourTypeResult({this.tourType, this.tours});

  TourTypeResult.fromJson(Map<String, dynamic> json) {
    tourType = json['tour_type'];
    if (json['tours'] != null) {
      tours = <TourTypesListModel>[];
      json['tours'].forEach((v) {
        tours!.add(new TourTypesListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tour_type'] = this.tourType;
    if (this.tours != null) {
      data['tours'] = this.tours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TourTypesListModel {
  String? destination;
  int? id;
  String? image;
  String? name;

  TourTypesListModel({this.destination, this.id, this.image, this.name});

  TourTypesListModel.fromJson(Map<String, dynamic> json) {
    destination = json['destination'];
    id = json['id'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['destination'] = this.destination;
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    return data;
  }
}
