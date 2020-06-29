import 'package:equatable/equatable.dart';

import 'package:refashioned_app/models/category.dart';

abstract class CategoryState extends Equatable {
  CategoryState([Iterable props]) : super(props);
}

class CategoryUninitialized extends CategoryState {
  @override
  String toString() => 'CategoryUninitialized';
}

class CategoryInitialized extends CategoryState {
  final List<Category> categories;
  final bool hasError;
  final bool hasReachedMax;
  final String status;

  CategoryInitialized({
    this.hasError,
    this.categories,
    this.hasReachedMax,
    this.status
  }) : super([categories, hasError, hasReachedMax, status]);

  factory CategoryInitialized.success(List<Category> posts) {
    return CategoryInitialized(
      categories: posts,
      hasError: false,
      hasReachedMax: false,
    );
  }

  factory CategoryInitialized.failure() {
    return CategoryInitialized(
      categories: [],
      hasError: true,
      hasReachedMax: false,
      status: ""
    );
  }

  CategoryInitialized copyWith({
    List<Category> posts,
    bool hasError,
    bool hasReachedMax,
    String status
  }) {
    return CategoryInitialized(
      categories: posts ?? this.categories,
      hasError: hasError ?? this.hasError,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status
    );
  }

  @override
  String toString() =>
      'CategoryInitialized { posts: ${categories.length}, hasError: $hasError, hasReachedMax: $hasReachedMax, status: $status }';
}