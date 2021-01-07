import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valorant_elo_tracker/authentication/bloc/authentication_bloc.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';
import 'package:valorant_elo_tracker/consts/valorant_rankings.dart';
import 'package:valorant_elo_tracker/home/view/match_rating.dart';

import 'package:valorant_elo_tracker/valorant/bloc/valorant_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<ValorantBloc, ValorantState>(
          builder: (context, state) {
            if (state is ValorantSuccess) {
              return AppBar(
                title: Text(valorantRankings[
                    state.latestRankedMatch.tierAfterUpdate.toString()]),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      children: [
                        Text('${state.rp} RP'),
                        VerticalDivider(
                          width: 8,
                          color: Colors.white,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Text('${state.elo} ELO')
                      ],
                    ),
                  ),
                ],
              );
            }
            return AppBar(
              title: const Text('Home'),
            );
          },
        ),
      ),
      body: BlocBuilder<ValorantBloc, ValorantState>(
        builder: (context, state) {
          if (state is ValorantSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                return await _refresh(context);
              },
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        _renderRankLogo(
                            state.latestRankedMatch.tierAfterUpdate),
                        const SizedBox(
                          height: 100,
                        ),
                        _renderThreeMatchRatings(
                            state.latestThreeRatingChanges),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ValorantLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(VALORANT_RED),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<Null> _refresh(BuildContext context) async {
    final currentUser = BlocProvider.of<AuthenticationBloc>(context).state.user;
    BlocProvider.of<ValorantBloc>(context)
      ..add(ValorantCompetitiveDetailsFetched(user: currentUser));
    return null;
  }

  _renderRankLogo(int rank) {
    if (rank == 1 || rank == 2) {
      return Image(
        image: AssetImage('assets/images/1.png'),
        width: 150,
        height: 150,
      );
    } else {
      return Image(
        image: AssetImage('assets/images/$rank.png'),
        width: 150,
        height: 150,
      );
    }
  }

  _renderThreeMatchRatings(List<int> points) {
    return Row(
      children: points
          .map((e) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MatchRating(rating: e),
                ),
              ))
          .toList(),
    );
  }
}
