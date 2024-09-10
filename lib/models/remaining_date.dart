class GetDate {
  String? remainingDate;

  GetDate({this.remainingDate});
  factory GetDate.fromJson(Map<String, dynamic> json) {
    return GetDate(
      remainingDate: json['remaining_date'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'remaining_date': remainingDate,
    };
  }
}
