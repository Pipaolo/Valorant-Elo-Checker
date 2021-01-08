import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valorant_elo_tracker/authentication/bloc/authentication_bloc.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';
import 'package:valorant_elo_tracker/home/view/home_appbar.dart';
import 'package:valorant_elo_tracker/home/view/home_fab_menu.dart';
import 'package:valorant_elo_tracker/home/view/match_rating.dart';
import 'package:valorant_elo_tracker/router/router.gr.dart';

import 'package:valorant_elo_tracker/valorant/bloc/valorant_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(),
      body: BlocConsumer<ValorantBloc, ValorantState>(
        listener: (context, state) {
          if (state is ValorantFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('ERROR: ${state.errorMessage}'),
                ),
              );
            // Reset Authentication and Navigate to Login Screen
            BlocProvider.of<AuthenticationBloc>(context)
                .add(AuthenticationLogoutRequested());
            AutoRouter.of(context).replace(LoginPageRoute());
          }
        },
        builder: (context, state) {
          if (state is ValorantSuccess) {
            return _renderSuccessState(context, state);
          } else if (state is ValorantLoading) {
            return _renderLoadingState();
          }
          return Container();
        },
      ),
      floatingActionButton: HomeFabMenu(),
    );
  }

  Widget _renderSuccessState(BuildContext context, ValorantSuccess state) {
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
                _renderRankLogo(state.latestRankedMatch.tierAfterUpdate),
                const SizedBox(
                  height: 100,
                ),
                _renderThreeMatchRatings(state.latestThreeRatingChanges),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(VALORANT_RED),
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
    if (rank == 1 || rank == 2 || rank == 0) {
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
