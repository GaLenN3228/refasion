import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/repositories/base.dart';
import 'package:refashioned_app/screens/components/scaffold/components/content.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';

class RefashionedScaffold extends StatefulWidget {
  final Map<Status, ScaffoldData Function()> stateData;
  final ValueNotifier<Status> state;

  final ScaffoldData data;

  const RefashionedScaffold({Key key, this.stateData, this.state, this.data})
      : assert(data != null || stateData != null && state != null);

  @override
  _RefashionedScaffoldState createState() => _RefashionedScaffoldState();
}

class _RefashionedScaffoldState extends State<RefashionedScaffold> {
  bool usingStates;
  ScaffoldData currentData;

  @override
  void initState() {
    usingStates = widget.state != null && widget.stateData != null;
    currentData =
        usingStates ? widget.stateData[widget.state.value]() : widget.data;

    if (usingStates) widget.state.addListener(stateListener);

    super.initState();
  }

  stateListener() =>
      setState(() => currentData = widget.stateData[widget.state.value]());

  @override
  void dispose() {
    if (usingStates) widget.state.removeListener(stateListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ScaffoldContent(scaffoldData: currentData);
}
