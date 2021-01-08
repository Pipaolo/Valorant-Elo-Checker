import 'dart:convert';

enum ValorantCompetitiveMovement {
  unknown,
  promoted,
  demoted,
  decrease,
  majorDecrease,
  increase,
  majorIncrease,
}

class ValorantMatch {
  final String matchID;
  final String mapID;
  final int matchStartTime;
  final int tierAfterUpdate;
  final int tierBeforeUpdate;
  final int tierProgressAfterUpdate;
  final int tierProgressBeforeUpdate;
  final int rankedRatingEarned;
  final String competitiveMovement;

  const ValorantMatch(
      {this.matchID,
      this.mapID,
      this.matchStartTime,
      this.tierAfterUpdate,
      this.tierBeforeUpdate,
      this.tierProgressAfterUpdate,
      this.tierProgressBeforeUpdate,
      this.rankedRatingEarned,
      this.competitiveMovement});

  static const empty = ValorantMatch(
      matchID: "",
      mapID: "",
      matchStartTime: 0,
      tierAfterUpdate: 0,
      tierBeforeUpdate: 0,
      tierProgressAfterUpdate: 0,
      tierProgressBeforeUpdate: 0,
      rankedRatingEarned: 0,
      competitiveMovement: 'MOVEMENT_UNKNOWN');

  Map<String, dynamic> toMap() {
    return {
      'MatchID': matchID,
      'MapID': mapID,
      'MatchStartTime': matchStartTime,
      'TierAfterUpdate': tierAfterUpdate,
      'TierBeforeUpdate': tierBeforeUpdate,
      'TierProgressAfterUpdate': tierProgressAfterUpdate,
      'TierProgressBeforeUpdate': tierProgressBeforeUpdate,
      'RankedRatingEarned': rankedRatingEarned,
      'CompetitiveMovement': competitiveMovement,
    };
  }

  factory ValorantMatch.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return ValorantMatch(
      matchID: map['MatchID'],
      mapID: map['MapID'],
      matchStartTime: map['MatchStartTime'],
      tierAfterUpdate: map['TierAfterUpdate'],
      tierBeforeUpdate: map['TierBeforeUpdate'],
      tierProgressAfterUpdate: map['TierProgressAfterUpdate'],
      tierProgressBeforeUpdate: map['TierProgressBeforeUpdate'],
      rankedRatingEarned: map['RankedRatingEarned'],
      competitiveMovement: map['CompetitiveMovement'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ValorantMatch.fromJson(String source) =>
      ValorantMatch.fromMap(json.decode(source));
}
