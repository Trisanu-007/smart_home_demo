class CostData {
  String date;
  String time;
  String value;
  String message;

  CostData({this.date, this.time, this.value});

  CostData.fromJson(Map<String, dynamic> json) {
    var val = json["field3"] ?? "Not there";
    this.value = val == "Not there" ? "NA" : json["field3"];
    var x = json["created_at"].toString().split('T');
    //print(x[0]);
    //print(x[1]);
    this.date = x[0];
    this.time = x[1].replaceAll('Z', '');
    this.message = json["field3"] == null
        ? "Could not fetch your data for that day"
        : "Fetched successfully";
  }
}
