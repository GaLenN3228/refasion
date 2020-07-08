import 'dart:math';

import 'package:flutter/material.dart';
import '../../../models/category.dart';

class CategoryRootTile extends StatelessWidget {
  final Category category;

  const CategoryRootTile({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final subtitles = category.children
        .sublist(0, min(category.children.length, 3))
        .map((e) => e.name)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 7.5, 12, 7.5),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.name.toUpperCase(),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Color(0xFF222222)),
              ),
              subtitles.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: subtitles
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    e,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Color(0xFF959595)),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  : SizedBox(),
            ],
          )),
    );
  }
}
