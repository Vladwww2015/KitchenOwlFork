import 'dart:convert';
import 'package:kitchenowl/models/household.dart';
import 'package:kitchenowl/models/member.dart';
import 'package:kitchenowl/models/user.dart';
import 'package:kitchenowl/services/api/api_service.dart';

extension HouseholdApi on ApiService {
  static const baseRoute = '/household';

  Future<List<Household>?> getAllHouseholds() async {
    final res = await get(baseRoute);
    if (res.statusCode != 200) return null;

    final body = List.from(jsonDecode(res.body));

    return body.map((e) => Household.fromJson(e)).toList();
  }

  Future<Household?> getHousehold(Household household) async {
    final res = await get("$baseRoute/${household.id}");
    if (res.statusCode != 200) return null;

    return Household.fromJson(jsonDecode(res.body));
  }

  Future<bool> updateHousehold(Household household) async {
    final res = await post(
      '$baseRoute/${household.id}',
      jsonEncode(household.toJson()),
    );

    return res.statusCode == 200;
  }

  Future<Household?> addHousehold(Household household) async {
    final res = await post(
      baseRoute,
      jsonEncode(household.toJson()
        ..addAll({
          if (household.member != null)
            "member": household.member!.map((e) => e.id).toList(),
        })),
    );

    if (res.statusCode != 200) return null;

    return Household.fromJson(jsonDecode(res.body));
  }

  Future<bool> deleteHousehold(Household household) async {
    final res = await delete('$baseRoute/${household.id}');

    return res.statusCode == 200;
  }

  Future<bool> removeHouseholdMember(
    Household household,
    User user,
  ) async {
    final res = await delete('$baseRoute/${household.id}/member/${user.id}');

    return res.statusCode == 200;
  }

  Future<bool> putHouseholdMember(
    Household household,
    Member member,
  ) async {
    final res = await put(
      '$baseRoute/${household.id}/member/${member.id}',
      jsonEncode(member.toJson()),
    );

    return res.statusCode == 200;
  }
}
