import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valorant_elo_tracker/consts/valorant_rankings.dart';
import 'package:valorant_elo_tracker/valorant/bloc/valorant_bloc.dart';

class HomeAppbar extends PreferredSize {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValorantBloc, ValorantState>(
      builder: (context, state) {
        if (state is ValorantSuccess) {
          return _renderSuccessState(state);
        }
        return _renderDefaultState();
      },
    );
  }

  _renderSuccessState(ValorantSuccess state) {
    return AppBar(
      title: Text(
          valorantRankings[state.latestRankedMatch.tierAfterUpdate.toString()]),
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

  _renderDefaultState() {
    return AppBar(
      title: const Text('Home'),
    );
  }
}
