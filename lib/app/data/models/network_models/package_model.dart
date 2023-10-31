class PackageModel {
  PackageModel(
      {this.amount,
      this.category,
      this.days,
      this.description,
      this.destination,
      this.exclusiveTour,
      this.id,
      this.image,
      this.itinerary,
      this.name,
      this.nights,
      this.priority,
      this.region,
      this.tourCode,
      this.travelType,
      this.trending,
      this.tourType,
      this.minAmount,
      this.brandName});
  num? amount;
  String? category;
  int? days;
  String? description;
  String? destination;
  String? exclusiveTour;
  String? brandName;
  int? id;
  String? image;
  String? itinerary;
  String? name;
  int? nights;
  int? priority;
  String? region;
  String? tourCode;
  String? travelType;
  bool? trending;
  String? tourType;
  num? minAmount;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'amount': amount,
        'brand_name': brandName,
        'category': category,
        'days': days,
        'description': description,
        'destination': destination,
        'exclusive_tour': exclusiveTour,
        'id': id,
        'image': image,
        'itinerary': itinerary,
        'name': name,
        'nights': nights,
        'priority': priority,
        'region': region,
        'tour_code': tourCode,
        'travel_type': travelType,
        'trending': trending,
        'tour_type': tourType,
        'min_amount': minAmount,
      };

  static PackageModel fromJson(Map<String, dynamic> json) => PackageModel(
        amount: json['amount'] == null ? 0 : json['amount'] as num,
        brandName:
            json['brand_name'] == null ? '' : json['brand_name'] as String,
        category: json['category'] == null ? '' : json['category'] as String,
        days: json['days'] == null ? 0 : json['days'] as int,
        description:
            json['description'] == null ? '' : json['description'] as String,
        destination:
            json['destination'] == null ? '' : json['destination'] as String,
        exclusiveTour: json['exclusive_tour'] == null
            ? ''
            : json['exclusive_tour'] as String,
        id: json['id'] == null ? 0 : json['id'] as int,
        image: json['image'] == null ? '' : json['image'] as String,
        itinerary: json['itinerary'] == null ? '' : json['itinerary'] as String,
        name: json['name'] == null ? '' : json['name'] as String,
        nights: json['nights'] == null ? 0 : json['nights'] as int,
        priority: json['priority'] != null ? json['priority'] as int : 0,
        region: json['region'] == null ? '' : json['region'] as String,
        tourCode: json['tour_code'] == null ? '' : json['tour_code'] as String,
        tourType: json['tour_type'] == null ? '' : json['tour_type'] as String,
        travelType:
            json['travel_type'] == null ? '' : json['travel_type'] as String,
        minAmount: json['min_amount'] == null ? 0 : json['min_amount'] as num,
        // ignore: avoid_bool_literals_in_conditional_expressions
        trending: json['trending'] == null ? false : json['trending'] as bool,
      );
}
