import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refashioned_app/home_screen/category_widget.dart';
import 'package:refashioned_app/models/category_bloc.dart';
import 'package:refashioned_app/models/category_event.dart';
import 'package:refashioned_app/models/category_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final CategoryBloc categoryBloc = CategoryBloc(httpClient: http.Client());
  final _scrollThreshold = 200.0;

  _HomePageState() {
    _scrollController.addListener(_onScroll);
    categoryBloc.dispatch(Fetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: categoryBloc,
      builder: (BuildContext context, CategoryState state) {
        if (state.isInitializing) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.isError) {
          return Center(
            child: Text('failed to fetch'),
          );
        }
        if (state.categories.isEmpty) {
          return Center(
            child: Text('no categories'),
          );
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return CategoryWidget(category: state.categories[index]);
          },
          itemCount:
          state.hasReachedMax ? state.categories.length : state.categories.length + 1,
          controller: _scrollController,
        );
      },
    );
  }

  @override
  void dispose() {
    categoryBloc.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      categoryBloc.dispatch(Fetch());
    }
  }
}