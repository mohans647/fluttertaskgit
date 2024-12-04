import 'package:newtask/model/Issue.dart';



class IssuesState {
  final List<Issue> issues;
  final bool isLoading;
  final String? error;

  IssuesState({this.issues = const [], this.isLoading = false, this.error});

  IssuesState copyWith({List<Issue>? issues, bool? isLoading, String? error}) {
    return IssuesState(
      issues: issues ?? this.issues,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}