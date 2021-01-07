part of 'valorant_bloc.dart';

abstract class ValorantState extends Equatable {
  const ValorantState();

  @override
  List<Object> get props => [];
}

class ValorantInitial extends ValorantState {}

class ValorantLoading extends ValorantState {}

class ValorantSuccess extends ValorantState {
  final List<ValorantMatch> matches;
  final ValorantMatch latestRankedMatch;
  final int elo;
  final int rp;
  final List<int> latestThreeRatingChanges;

  ValorantSuccess(this.matches, this.latestRankedMatch,
      this.latestThreeRatingChanges, this.elo, this.rp);

  @override
  List<Object> get props => [matches];
}

class ValorantFailure extends ValorantState {
  final String errorMessage;

  ValorantFailure({this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
