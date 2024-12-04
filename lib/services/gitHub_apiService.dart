import 'package:dio/dio.dart';

import '../model/Issue.dart';
import '../utils/server_config.dart';

class GitHubApiService {
  final Dio _dio = Dio();

  Future<List<Issue>> fetchIssues(String repo, String state,
      {int page = 1,String sort = 'desc', String? labels}) async {
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer ${Base_Url_key.Githup_APIKey}',
      };
      final response = await _dio.get(
        '${Base_Url_key.Base_apiUrl}$repo/issues',
        queryParameters: {
          'state': state,
          'sort': 'created',
          'direction': sort,
          'page': page.toString(),
          if (labels != null) 'labels': labels,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Issue.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load issues');
      }
    } catch (e) {
      throw Exception('Failed to fetch issues: $e');
    }
  }
}
