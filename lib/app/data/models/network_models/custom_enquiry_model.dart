class CustomEnquiryModel {
  CustomEnquiryModel(
      {this.tourId,
      this.noOfKids,
      this.noOfAdults,
      this.dateOfTravel,
      this.otherRequirements});
  int? tourId;
  int? noOfKids;
  int? noOfAdults;
  String? dateOfTravel;
  String? otherRequirements;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tour_id': tourId,
        'no_of_kids': noOfKids,
        'no_of_adults': noOfAdults,
        'date_of_travel': dateOfTravel,
        'other_requirements': otherRequirements,
      };
}
