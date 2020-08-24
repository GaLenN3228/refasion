import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';

class ScaffoldChildrenContent extends StatelessWidget {
  final ScaffoldChildrenData data;
  final ScrollController scrollController;
  final EdgeInsets padding;

  const ScaffoldChildrenContent(
      {Key key, this.data, this.scrollController, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.child != null) return data.child;

    if (data.children != null)
      return ListView(
        controller: scrollController,
        padding: padding,
        children: data.children,
      );

    if (data.itemCount != null && data.itemBuilder != null) {
      if (data.separatorBuilder != null)
        return ListView.separated(
          padding: padding,
          controller: scrollController,
          itemBuilder: data.itemBuilder,
          separatorBuilder: data.separatorBuilder,
          itemCount: data.itemCount,
        );
      else
        return ListView.builder(
          padding: padding,
          controller: scrollController,
          itemBuilder: data.itemBuilder,
          itemCount: data.itemCount,
        );
    }

    return Center(
      child: Text(
        data.message ?? "Не переданы данные",
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
