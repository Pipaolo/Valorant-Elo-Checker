import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:valorant_elo_tracker/repository/user/models/user.dart';
import 'package:valorant_elo_tracker/repository/valorant/models/valorant_match.dart';
import 'package:valorant_elo_tracker/repository/valorant/valorant_repository.dart';

part 'valorant_event.dart';
part 'valorant_state.dart';

class ValorantBloc extends Bloc<ValorantEvent, ValorantState> {
  ValorantBloc({
    @required ValorantRepository valorantRepository,
    @required Logger logger,
  })  : assert(valorantRepository != null),
        assert(logger != null),
        _valorantRepository = valorantRepository,
        _logger = logger,
        super(ValorantInitial());

  final ValorantRepository _valorantRepository;
  final Logger _logger;

  @override
  Stream<ValorantState> mapEventToState(
    ValorantEvent event,
  ) async* {
    if (event is ValorantCompetitiveDetailsFetched) {
      try {
        yield ValorantLoading();
        final matches =
            await _valorantRepository.getCompetitiveDetails(event.user);

        // Default to 0 if the player does not have any ranked matches.
        final latestRankedMatch = matches.firstWhere(
            (match) => match.competitiveMovement != "MOVEMENT_UNKNOWN",
            orElse: () => ValorantMatch.empty);

        // Default to 0 if the player does not have any ranked matches.
        final elo = _computeElo(latestRankedMatch);

        // Default to 0 if the player does not have any ranked matches.
        final rp = _computeRP(latestRankedMatch);

        final latestThreeGames = _computeThreeLatestGames(matches);

        yield ValorantSuccess(
            matches, latestRankedMatch, latestThreeGames, elo, rp);
      } on Exception catch (e) {
        _logger.e(
            """
         FINDING MATCH ERROR :< :

        $e
        
        --------------------------------------------------

        Kindly take a screenshot of this error and open an issue in the
        repository. I will try to fix this issue as soon as possible. 
        Thank you and sorry for the inconvenience.
        

        Github link: https://github.com/Pipaolo/Valorant-Elo-Checker

        -------------------------------------------------""");
        yield ValorantFailure(
            errorMessage: e.toString().replaceAll("Exception: ", ""));
      }
    }
  }

  int _computeRP(ValorantMatch latestRankedMatch) {
    int rp = 0;
    if (latestRankedMatch != ValorantMatch.empty) {
      rp = latestRankedMatch.tierProgressAfterUpdate;
    } else {
      _logger.w(
          """Player latest ranked match not found!
           ----------------------------------------------------------------------- 
          This means that the player has not played ranked games within the last 20 days.
          in order to fix this the player needs to play games in order for the app to compute their RP.""");
    }
    return rp;
  }

  int _computeElo(ValorantMatch latestRankedMatch) {
    int elo = 0;

    if (latestRankedMatch != ValorantMatch.empty) {
      elo = (latestRankedMatch.tierAfterUpdate * 100) -
          300 +
          latestRankedMatch.tierProgressAfterUpdate;
    } else {
      _logger.w(
          """
          Player latest ranked match not found!
          ----------------------------------------------------------------------- 
          This means that the player has not played ranked games in the last 20 matches.
          in order to fix this the player needs to play games in order for the app to compute their ELO.
          
          """);
    }
    return elo;
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
