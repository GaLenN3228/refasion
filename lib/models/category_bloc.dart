import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/models/category_event.dart';
import 'package:refashioned_app/models/category_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final http.Client httpClient;

  CategoryBloc({@required this.httpClient});

  @override
  Stream<CategoryEvent> transform(Stream<CategoryEvent> events) {
    return (events as Observable<CategoryEvent>)
        .debounce(Duration(milliseconds: 500));
  }

  @override
  get initialState => CategoryState.initial();

  @override
  Stream<CategoryState> mapEventToState(currentState, event) async* {
    if (event is Fetch && !currentState.hasReachedMax) {
      try {
        final posts = await fetchPosts();
        if (posts.isEmpty) {
          yield currentState.copyWith(hasReachedMax: true);
        } else {
          yield CategoryState.success(currentState.categories + posts);
        }
      } catch (_) {
        yield CategoryState.failure();
      }
    }
  }

  Future<List<Category>> fetchPosts() async {
    final response = await httpClient.get(
        'http://151.248.123.50:8002/v1/catalog/categories/');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Category(
          id: rawPost['id'],
          name: rawPost['name'],
          children: rawPost['children'],
        );
      }).toList();
    } else {
      throw Exception('error');
    }
  }
}