import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/gitHub_apiService.dart';
import '../model/IssuesState.dart';

class IssuesNotifier extends StateNotifier<IssuesState> {
  final GitHubApiService _apiService;

  IssuesNotifier(this._apiService) : super(IssuesState());

  Future<void> fetchIssues(String repo, String issueState,
      {int page = 1, String sort = 'desc', String? labels}) async {
    try {
      if (page == 1) {
        state = state.copyWith(isLoading: true, error: null, issues: []);
      } else {
        state = state.copyWith(isLoading: true, error: null);
      }

      final issues =
          await _apiService.fetchIssues(repo, issueState, page: page);

      if (page == 1) {
        state = state.copyWith(
          isLoading: false,
          issues: issues,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          issues: [...state.issues, ...issues],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
