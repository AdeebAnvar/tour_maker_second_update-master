class SingleTourTypeModel {
  SingleTourTypeModel(
      {this.iD,
      this.name,
      this.image,
      this.destination,
      this.description,
      this.days,
      this.nights,
      this.priority,
      this.trending,
      this.exclusiveTour,
      this.tourCode,
      this.category,
      this.itinerary,
      this.travelType,
      this.region,
      this.tourType});
  int? iD;
  String? name;
  String? image;
  String? destination;
  String? description;
  int? days;
  int? nights;
  int? priority;
  String? trending;
  String? exclusiveTour;
  String? tourCode;
  String? category;
  String? itinerary;
  String? travelType;
  String? region;
  String? tourType;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ID': iD,
        'name': name,
        'image': image,
        'destination': destination,
        'description': description,
        'days': days,
        'nights': nights,
        'priority': priority,
        'trending': trending,
        'exclusive_tour': exclusiveTour,
        'tour_code': tourCode,
        'category': category,
        'itinerary': itinerary,
        'travel_type': travelType,
        'region': region,
        'tour_type': tourType,
      };

  static SingleTourTypeModel fromJson(Map<String, dynamic> json) =>
      SingleTourTypeModel(
        iD: json['ID'] == null ? 0 : json['ID'] as int,
        name: json['name'] == null ? '' : json['name'] as String,
        image: json['image'] == null ? '' : json['image'] as String,
        destination:
            json['destination'] == null ? '' : json['destination'] as String,
        description:
            json['description'] == null ? '' : json['description'] as String,
        days: json['days'] == null ? 0 : json['days'] as int,
        nights: json['nights'] == null ? 0 : json['nights'] as int,
        priority: json['priority'] == null ? 0 : json['priority'] as int,
        trending: json['trending'] == null ? '' : json['trending'] as String,
        exclusiveTour: json['exclusive_tour'] == null
            ? ''
            : json['exclusive_tour'] as String,
        tourCode: json['tour_code'] == null ? '' : json['tour_code'] as String,
        category: json['category'] == null ? '' : json['category'] as String,
        itinerary: json['itinerary'] == null ? '' : json['itinerary'] as String,
        travelType:
            json['travel_type'] == null ? '' : json['travel_type'] as String,
        region: json['region'] == null ? '' : json['region'] as String,
        tourType: json['tour_type'] == null ? '' : json['tour_type'] as String,
      );
}
