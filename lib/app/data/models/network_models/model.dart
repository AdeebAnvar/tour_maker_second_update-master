class TrendingToursModels {
  TrendingToursModels({this.message, this.result, this.success});

  TrendingToursModels.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <TourResult>[];
      json['result'].forEach((v) {
        result!.add(TourResult.fromJson(v));
      });
    }
    success = json['success'];
  }
  String? message;
  List<TourResult>? result;
  bool? success;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((TourResult v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class TourResult {
  TourResult({this.destination, this.image, this.minAmount});

  TourResult.fromJson(Map<String, dynamic> json) {
    destination = json['destination'];
    image = json['image'];
    minAmount = json['min_amount'];
  }
  String? destination;
  String? image;
  int? minAmount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['destination'] = destination;
    data['image'] = image;
    data['min_amount'] = minAmount;
    return data;
  }
}

class TourTypesModelS {
  TourTypesModelS({this.message, this.result, this.success});

  TourTypesModelS.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
    success = json['success'];
  }
  String? message;
  List<Result>? result;
  bool? success;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((Result v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class Result {
  Result({this.tourType, this.tours});

  Result.fromJson(Map<String, dynamic> json) {
    tourType = json['tour_type'];
    if (json['tours'] != null) {
      tours = <Tours>[];
      json['tours'].forEach((v) {
        tours!.add(Tours.fromJson(v));
      });
    }
  }
  String? tourType;
  List<Tours>? tours;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tour_type'] = tourType;
    if (tours != null) {
      data['tours'] = tours!.map((Tours v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tours {
  Tours({this.destination, this.id, this.image, this.name});

  Tours.fromJson(Map<String, dynamic> json) {
    destination = json['destination'];
    id = json['id'];
    image = json['image'];
    name = json['name'];
  }
  String? destination;
  int? id;
  String? image;
  String? name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['destination'] = destination;
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    return data;
  }
}

class TravelTypesModelS {
  TravelTypesModelS({this.message, this.result, this.success});

  TravelTypesModelS.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <TravelType>[];
      json['result'].forEach((v) {
        result!.add(TravelType.fromJson(v));
      });
    }
    success = json['success'];
  }
  String? message;
  List<TravelType>? result;
  bool? success;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((TravelType v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class TravelType {
  TravelType({this.id, this.name, this.image});

  TravelType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  int? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
