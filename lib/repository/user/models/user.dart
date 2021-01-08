import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String accessToken;
  final String entitlementsToken;
  final String region;

  const User({
    this.accessToken,
    this.entitlementsToken,
    this.id,
    this.region,
  });

  static const empty =
      User(accessToken: "", entitlementsToken: "", id: "", region: "");

  @override
  List<Object> get props => [accessToken, entitlementsToken, id, region];
}
