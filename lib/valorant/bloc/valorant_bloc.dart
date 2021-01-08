import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:valorant_elo_tracker/repository/user/models/user.dart';
import 'package:valorant_elo_tracker/repository/valorant/models/valorant_match.dart';
import 'package:valorant_elo_tracker/repository/valorant/valorant_repository.dart';

part 'valorant_event.dart';
part 'valorant_state.dart';

class ValorantBloc extends Bloc<ValorantEvent, ValorantState> {
  ValorantBloc({@required ValorantRepository valorantRepository})
      : assert(valorantRepository != null),
        _valorantRepository = valorantRepository,
        super(ValorantInitial());

  final ValorantRepository _valorantRepository;

  @override
  Stream<ValorantState> mapEventToState(
    ValorantEvent event,
  ) async* {
    if (event is ValorantCompetitiveDetailsFetched) {
      try {
        yield ValorantLoading();
        final matches =
            await _valorantRepository.getCompetitiveDetails(event.user);
        final latestRankedMatch = matches.firstWhere(
            (match) => match.competitiveMovement != "MOVEMENT_UNKNOWN",
            orElse: () => ValorantMatch.empty);
        final elo = (latestRankedMatch == ValorantMatch.empty)
            ? 0
            : (latestRankedMatch.tierAfterUpdate * 100) -
                300 +
                latestRankedMatch.tierProgressAfterUpdate;
        final rp = latestRankedMatch.tierProgressAfterUpdate;
        final latestThreeGames = _computeThreeLatestGames(matches);

        yield ValorantSuccess(
            matches, latestRankedMatch, latestThreeGames, elo, rp);
      } on Exception catch (e) {
        yield ValorantFailure(
            errorMessage: e.toString().replaceAll("Exception: ", ""));
      }
    }
  }

  List<int> _computeThreeLatestGames(List<ValorantMatch> matches) {
    final points = [0, 0, 0];

    int count = 0;

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      if (match.competitiveMovement == "MOVEMENT_UNKNOWN") {
      } else if (match.competitiveMovement == "PROMOTED") {
        int before = match.tierProgressBeforeUpdate;
        int after = match.tierProgressAfterUpdate;
        int differ = (after - before) + 100;
        points[count] = differ;
        count++;
      } else if (match.competitiveMovement == "DEMOTED") {
        int before = match.tierProgressBeforeUpdate;
        int after = match.tierProgressAfterUpdate;
        int differ = (after - before) - 100;
        points[count] = differ;
        count++;
      } else {
        int before = match.tierProgressBeforeUpdate;
        int after = match.tierProgressAfterUpdate;
        int differ = (after - before);
        points[count] = differ;
        count++;
      }

      if (count >= points.length) {
        break;
      }
    }

    return points;
  }
}
