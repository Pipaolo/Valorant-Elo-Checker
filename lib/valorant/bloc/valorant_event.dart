part of 'valorant_bloc.dart';

abstract class ValorantEvent extends Equatable {
  const ValorantEvent();

  @override
  List<Object> get props => [];
}

class ValorantCompetitiveDetailsFetched extends ValorantEvent {
  final User user;

  ValorantCompetitiveDetailsFetched({@required this.user});

  @override
  List<Object> get props => [user];
}

class ValorantCompetitiveDetailsRefreshed extends ValorantEvent {
  ValorantCompetitiveDetailsRefreshed();
  @override
  List<Object> get props => [];
}
