import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final int selectedPage;
  final int pagenav;
  final String verified;
  final String heightmin;
  final String heightmax;
  final String minphotolenght;
  final String hasbio;
  final List<String>? passion;
  final String doExercise;
  final String dotheydrink;
  final String dotheysmoke;
  final List? languagetheyknow;
  final String kids;
  final String sunSign;
  final String religion;
  final String politics;
  final String pets;
  const FilterState(
      {this.selectedPage = 0,
      this.pagenav = 0,
      this.verified = '',
      this.heightmin = '',
      this.heightmax = '',
      this.minphotolenght = '',
      this.hasbio = '',
      this.passion,
      this.doExercise = '',
      this.dotheydrink = '',
      this.dotheysmoke = '',
      this.languagetheyknow,
      this.kids = '',
      this.sunSign = '',
      this.religion = '',
      this.politics = '',
      this.pets = ''});
  @override
  List<Object?> get props => [
        selectedPage,
        pagenav,
        verified,
        heightmin,
        heightmax,
        minphotolenght,
        hasbio,
        passion,
        doExercise,
        dotheydrink,
        dotheysmoke,
        languagetheyknow,
        kids,
        sunSign,
        religion,
        politics,
        pets
      ];
  FilterState copyWith(
      {int? selectedPage,
      int? pagenav,
      String? verified,
      String? heightmin,
      String? heightmax,
      String? minphotolenght,
      String? hasbio,
      List<String>? passion,
      String? doExercise,
      String? dotheydrink,
      String? dotheysmoke,
      List? languagetheyknow,
      String? kids,
      String? sunSign,
      String? religion,
      String? politics,
      String? pets}) {
    return FilterState(
        selectedPage: selectedPage ?? this.selectedPage,
        pagenav: pagenav ?? this.pagenav,
        verified: verified ?? this.verified,
        heightmin: heightmin ?? this.heightmin,
        heightmax: heightmax ?? this.heightmax,
        minphotolenght: minphotolenght ?? this.minphotolenght,
        hasbio: hasbio ?? this.hasbio,
        passion: passion ?? this.passion,
        doExercise: doExercise ?? this.doExercise,
        dotheydrink: dotheydrink ?? this.dotheydrink,
        dotheysmoke: dotheysmoke ?? this.dotheysmoke,
        languagetheyknow: languagetheyknow ?? this.languagetheyknow,
        kids: kids ?? this.kids,
        sunSign: sunSign ?? this.sunSign,
        religion: religion ?? this.religion,
        politics: politics ?? this.politics,
        pets: pets ?? this.pets);
  }
}
