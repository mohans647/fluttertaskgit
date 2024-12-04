import 'package:flutter/material.dart';
import '../../model/Issue.dart';
import '../Screen/Issue_WebView.dart';

class IssueTile extends StatelessWidget {
  final Issue issue;
  final String repositoryName;

  const IssueTile({required this.issue, required this.repositoryName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
        title: Column(
          children: [
            Text(issue.title,style: TextStyle(color: Colors.blueGrey),),
            Text(issue.labels.join(', '),style: TextStyle(color: Colors.deepPurple),),
          ],
        ),
        subtitle: Text('#${issue.number} by ${issue.author}'),
        trailing: Text(issue.createdAt,style: TextStyle(color: Colors.green),),
        onTap: () {
          final url = 'https://github.com/$repositoryName/issues/${issue.number}';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IssueWebView(url: url),
            ),
          );
        },
            ),
      );
  }
}


