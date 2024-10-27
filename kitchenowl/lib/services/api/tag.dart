import 'dart:convert';
import 'package:kitchenowl/models/household.dart';
import 'package:kitchenowl/models/recipe.dart';
import 'package:kitchenowl/models/tag.dart';
import 'package:kitchenowl/services/api/api_service.dart';

extension TagApi on ApiService {
  static const baseRoute = '/tag';

  Future<Set<Tag>?> getAllTags(Household household) async {
    final res = await get(householdPath(household) + baseRoute);
    if (res.statusCode != 200) return null;

    final body = List.from(jsonDecode(res.body));

    return body.map((e) => Tag.fromJson(e)).toSet();
  }

  Future<bool> addTag(Household household, Tag tag) async {
    final res = await post(
      householdPath(household) + baseRoute,
      json.encode(tag.toJson()),
    );

    return res.statusCode == 200;
  }

  Future<bool> updateTag(Tag tag) async {
    final res = await post('$baseRoute/${tag.id}', json.encode(tag.toJson()));

    return res.statusCode == 200;
  }

  Future<bool> mergeTag(Tag tag, Tag other) async {
    final res = await post(
      '$baseRoute/${tag.id}',
      jsonEncode({
        "merge_tag_id": other.id,
      }),
    );

    return res.statusCode == 200;
  }

  Future<Tag?> getTag(Tag tag) async {
    final res = await get('$baseRoute/${tag.id}');
    if (res.statusCode != 200) return null;

    final body = jsonDecode(res.body);

    return Tag.fromJson(body);
  }

  Future<List<Recipe>?> getTagRecipes(Tag tag) async {
    final res = await get('$baseRoute/${tag.id}/recipes');
    if (res.statusCode != 200) return null;

    final body = List.from(jsonDecode(res.body));

    return body.map((e) => Recipe.fromJson(e)).toList();
  }

  Future<bool> deleteTag(Tag tag) async {
    final res = await delete('$baseRoute/${tag.id}');

    return res.statusCode == 200;
  }
}
