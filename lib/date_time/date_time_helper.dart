// convert date time objet to yymmdd

String convertDateTimeToString(DateTime dateTime){
  // year in the format -> yyyy
  String year = dateTime.year.toString();

  // month in the formart -> mm
  String month = dateTime.month.toString();
  if(month.length == 1){
    month = '0' + month;
  }

  // day in the format -> dd
  String day = dateTime.day.toString();
  if(day.length==1){
    day = '0' + day;
  }

  // return yymmdd
  String yymmdd = year + month + day;
  return yymmdd;
}