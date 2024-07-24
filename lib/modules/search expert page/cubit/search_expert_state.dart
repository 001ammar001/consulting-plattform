part of 'search_expert_cubit.dart';

@immutable
abstract class SearchExpertState {}

class SearchExpertInitial extends SearchExpertState {}

class ChangeExpertSearch extends SearchExpertState {}

class FinishExpertSearch extends SearchExpertState {}
