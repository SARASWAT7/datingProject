import 'package:equatable/equatable.dart';

import '../../../../component/apihelper/common.dart';
 
class AddPhotoState extends Equatable {
  final ApiState currentState;
  final String description;
  final String id;
  final String images;
  const AddPhotoState(
      {this.images = "",this.id = "",this.description = "",this.currentState = ApiState.normal});

  @override
  List<Object?> get props => [images,id,description, currentState];

  AddPhotoState copyWith({String? images,String? id,String? description,
    ApiState? currentState,
  }) {
    return AddPhotoState(
      images: images?? this.images,
      id: id?? this.id,
        description: description?? this.description,
        currentState: currentState ?? this.currentState);
  }
}
