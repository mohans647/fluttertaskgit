
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/gitHub_apiService.dart';
import '../model/IssuesState.dart';
import 'GitHubIssueNotifier.dart';

final issuesNotifierProvider = StateNotifierProvider<IssuesNotifier, IssuesState>((ref) {
  final apiService = GitHubApiService();
  return IssuesNotifier(apiService);
});
