
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilesGridView extends StatelessWidget {
  final List<XFile>? filePaths;
  final String sss;
  const FilesGridView({super.key, required this.filePaths, this.sss = "ss"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filePaths?.length,
        itemBuilder: (context, index) {
          return Card(
            child: Center(
                child: Column(
                  children: [
                    Image.file(File(filePaths?[index].path ?? "")),
                    GestureDetector(
                        onTap: () {
                          filePaths?.removeAt(index);
                        },
                        child: Icon(Icons.abc))
                  ],
                )

              /*  , */
            ),
          );
        },
      ),
    );
  }
}
