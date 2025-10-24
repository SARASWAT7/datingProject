// import 'dart:developer';
// import 'package:demoproject/component/commonfiles/appcolor.dart';
// import 'package:demoproject/component/reuseable_widgets/apploder.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:reels_viewer/reels_viewer.dart';
// import '../../component/apihelper/urls.dart';
// import 'cubit/myreels/myreelscubit.dart';
// import 'cubit/myreels/myreelsstate.dart';
//
//
// class Reals extends StatefulWidget {
//   const Reals({Key? key}) : super(key: key);
//
//   @override
//   State<Reals> createState() => _RealsState();
// }
//
// class _RealsState extends State<Reals> {
//   List<ReelModel> reelsList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchReels();
//   }
//
//   void _fetchReels() {
//     context.read<ProfileReelsCubit>().fetchProfileReels(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         title: const Text(''),
//       ),
//       backgroundColor: Colors.black,
//       body: BlocBuilder<ProfileReelsCubit, ProfileReelsState>(
//         builder: (context, state) {
//           if (state.status == ApiStates.loading) {
//             return AppLoader();
//           }
//
//           if (state.status == ApiStates.success) {
//             reelsList = state.response?.result?.getUserReels?.map((e) {
//               return ReelModel(
//                 e.video ?? "",
//                 'User',
//                 reelDescription: e.caption ?? "",
//                 profileUrl: 'https://example.com/profile.jpg',
//               );
//             }).toList() ?? [];
//
//             return ReelsViewer(
//               reelsList: reelsList,
//               appbarTitle: '',
//               onShare: (url) {
//                 log('Shared reel url ==> $url');
//               },
//               onLike: (url) {
//                 log('Liked reel url ==> $url');
//               },
//               onFollow: () {
//                 log('======> Clicked on follow <======');
//               },
//               onComment: (comment) {
//                 log('Comment on reel ==> $comment');
//               },
//               onClickMoreBtn: () {
//                 log('======> Clicked on more option <======');
//               },
//               onClickBackArrow: () {
//                 log('======> Clicked on back arrow <======');
//               },
//               onIndexChanged: (index) {
//                 log('======> Current Index ======> $index <========');
//               },
//               showProgressIndicator: true,
//               showVerifiedTick: true,
//               showAppbar: false,
//             );
//           }
//
//           if (state.status == ApiStates.error) {
//             return Center(
//               child: Text(
//                 'Error: ${state.errorMessage}',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             );
//           }
//
//           return const Center(child: Text('No data available.'));
//         },
//       ),
//     );
//   }
// }