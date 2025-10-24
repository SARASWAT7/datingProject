import 'package:demoproject/ui/dashboard/filter/cubit/filterstate.dart';
import 'package:demoproject/ui/dashboard/filter/dotheydrink.dart';
import 'package:demoproject/ui/dashboard/filter/dotheyexercise.dart';
import 'package:demoproject/ui/dashboard/filter/dotheysmoke.dart';
import 'package:demoproject/ui/dashboard/filter/filterbio.dart';
import 'package:demoproject/ui/dashboard/filter/filterheight.dart';
import 'package:demoproject/ui/dashboard/filter/filterminphotos.dart';
import 'package:demoproject/ui/dashboard/filter/filterpassion.dart';
import 'package:demoproject/ui/dashboard/filter/filterverfied.dart';
import 'package:demoproject/ui/dashboard/filter/flutterpets.dart';
import 'package:demoproject/ui/dashboard/filter/flutterwantkids.dart';
import 'package:demoproject/ui/dashboard/filter/languagetheyknow.dart';
import 'package:demoproject/ui/dashboard/filter/religion.dart';
import 'package:demoproject/ui/dashboard/filter/sunsign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState());
  void resetFilter() {
    emit(FilterState()); // Reset to initial state
  }

  verifiedUpdate(String verify) {
    emit(state.copyWith(verified: verify));
  }

  void heightUpdate(String minHeight, String maxHeight) {

    emit(state.copyWith(heightmin: minHeight, heightmax: maxHeight));
  }

  minNumberPhotoUpdate(String minNumberPhoto) {
    emit(state.copyWith(minphotolenght: minNumberPhoto));
  }

  hasBioUpdate(String hasbio) {
    emit(state.copyWith(hasbio: hasbio));
  }

  passionUpdate(List<String> passion) {
    emit(state.copyWith(passion: passion ?? []));
  }

  doExerciseUpdate(String doExercise) {
    emit(state.copyWith(doExercise: doExercise));
  }

  doDrinkUpdate(String dotheydrink) {
    emit(state.copyWith(dotheydrink: dotheydrink));
  }

  doSmokeUpdate(String dotheysmoke) {
    emit(state.copyWith(dotheysmoke: dotheysmoke));
  }

  languageUpdate(List<String> languagetheyknow) {
    emit(state.copyWith(languagetheyknow: languagetheyknow));
  }

  kidsUpdate(String kids) {
    emit(state.copyWith(kids: kids));
  }

  sunSignUpdate(String sunSign) {
    emit(state.copyWith(sunSign: sunSign));
  }

  religionUpdate(String religion) {
    emit(state.copyWith(religion: religion));
  }

  petsUpdate(String pets) {
    emit(state.copyWith(pets: pets));
  }

  selectedIndex(BuildContext context, int height) {
    switchCase(height, context);
    emit(state.copyWith(selectedPage: height));
  }

  switchCase(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ViewVerified(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FilterHeight(),
          ),
        );
        break;
      case 2:
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MinimumPhotos(initialSelection: state.minphotolenght),
          ),
        );
        break;
      case 3:
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => FilterBio(initialBio: state.hasbio),
          ),
        );
        break;
      case 4:
        Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => FilterPassion(initialPassions: state.passion ?? []),
          ),
        );
        break;
      case 5:
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => const FilterDoTheyExercise(),
          ),
        );
        break;
      case 6:
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => const FilterDoTheyDrink(),
          ),
        );
        break;
      case 7:
        Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (_) => const FilterDoTheySmoke(),
          ),
        );
        break;
      case 8:
        Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => const Languagetheyknow(),
          ),
        );
        break;
      case 9:
        Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => const FlutterWantKids(),
          ),
        );
        break;
      case 10:
        Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => const FlutterSunShine(),
          ),
        );
        break;
      case 11:
        Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => const FilterReligion(),
          ),
        );
        break;
      case 12:
        Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => const FilterPets(),
          ),
        );
        break;
      default:
        print('Invalid day');
        break;
    }
  }
}
