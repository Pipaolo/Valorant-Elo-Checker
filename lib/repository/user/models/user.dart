import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String accessToken;
  final String entitlementsToken;

  const User({
    this.accessToken,
    this.entitlementsToken,
    this.id,
  });

  static const empty = User(accessToken: "", entitlementsToken: "", id: "");

  @override
  List<Object> get props => [accessToken, entitlementsToken, id];
}
