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
  String matchID;
  String mapID;
  int matchStartTime;
  int tierAfterUpdate;
  int tierBeforeUpdate;
  int tierProgressAfterUpdate;
  int tierProgressBeforeUpdate;
  int rankedRatingEarned;
  String competitiveMovement;

  ValorantMatch(
      {this.matchID,
      this.mapID,
      this.matchStartTime,
      this.tierAfterUpdate,
      this.tierBeforeUpdate,
      this.tierProgressAfterUpdate,
      this.tierProgressBeforeUpdate,
      this.rankedRatingEarned,
      this.competitiveMovement});

  ValorantMatch.fromJson(Map<String, dynamic> json) {
    matchID = json['MatchID'];
    mapID = json['MapID'];
    matchStartTime = json['MatchStartTime'];
    tierAfterUpdate = json['TierAfterUpdate'];
    tierBeforeUpdate = json['TierBeforeUpdate'];
    tierProgressAfterUpdate = json['TierProgressAfterUpdate'];
    tierProgressBeforeUpdate = json['TierProgressBeforeUpdate'];
    rankedRatingEarned = json['RankedRatingEarned'];

    competitiveMovement = json['CompetitiveMovement'];
  }
}
