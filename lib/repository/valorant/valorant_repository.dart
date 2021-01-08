import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:valorant_elo_tracker/repository/user/models/user.dart';
import 'package:valorant_elo_tracker/repository/valorant/models/valorant_match.dart';

class ValorantRepository {
  Future<List<ValorantMatch>> getCompetitiveDetails(User user) async {
    final response = await http.get(
      'https://pd.${user.region}.a.pvp.net/mmr/v1/players/${user.id}/competitiveupdates?startIndex=0&endIndex=20',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.accessToken}',
        'X-Riot-Entitlements-JWT': '${user.entitlementsToken}',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final rawMatches = jsonDecode(response.body)['Matches'];

      final matches = (rawMatches as List<dynamic>)
          .map((match) => ValorantMatch.fromJson(match))
          .toList();

      if (matches.isEmpty) {
        throw Exception("Your account does not exist in this region.");
      }

      return matches;
    } else {
      throw Exception('Failed to get compi details');
    }
  }
}
