import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newtask/providers/issuesNotifierProvider.dart';
import '../../model/Issue.dart';
import '../../model/IssuesState.dart';
import '../widgets/IssueTile.dart';
import '../widgets/custom_loadingWidget.dart';
import '../widgets/network_ErrorDialog.dart';
import '../widgets/custom_alert_dialog.dart';

class IssueTrackerPage extends ConsumerStatefulWidget {
  const IssueTrackerPage({super.key});

  @override
  _IssueTrackerPageState createState() => _IssueTrackerPageState();
}

class _IssueTrackerPageState extends ConsumerState<IssueTrackerPage>
    with SingleTickerProviderStateMixin {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  IssuesState issuesState = IssuesState();
  int page = 1;
  bool isConnected = true;
  bool isTabControllerInitialized = false;
  bool isDialogVisible = false; // Track if the dialog is visible
  String selectedSort = 'Newest';
  String selectedFilter = 'All';
  bool isLoadingNextPage = false;

  final List<String> filters = ['All', 'Bug', 'Feature', 'Documentation'];

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    Future.microtask(() async {
      await _checkInitialConnectivity();
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = connectivityResult;
      isConnected = connectivityResult != ConnectivityResult.none;
    });

    if (!isConnected) {
      _showNetworkErrorDialog();
    } else {
      _dismissNetworkErrorDialog();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('You\'re connected to a ${_connectionStatus.name} network'),
      ));
      setState(() {
        _tabController = TabController(length: 2, vsync: this);
        _tabController.addListener(_onTabChange);
        _scrollController.addListener(_onScroll);
        isTabControllerInitialized = true;
      });
    }
  }

  void _onScroll() {
    // Check if the user has scrolled near the bottom and the page is not already loading
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingNextPage) {
      if (isConnected) {
        setState(() {
          isLoadingNextPage = true; // Set loading flag
        });

        // Fetch next page issues
        ref
            .read(issuesNotifierProvider.notifier)
            .fetchIssues(
              _searchController.text,
              _tabController.index == 0 ? 'open' : 'closed',
              page: ++page,
            )
            .then((_) {
          setState(() {
            isLoadingNextPage = false; // Reset loading flag
          });
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const NetworkErrorDialog();
            },
          );
        });
      }
    }
  }

  void _showNetworkErrorDialog() {
    if (!isDialogVisible) {
      setState(() {
        isDialogVisible = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const NetworkErrorDialog();
          },
        );
      });
    }
  }

  void _dismissNetworkErrorDialog() {
    if (isDialogVisible) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
      setState(() {
        isDialogVisible = false;
      });
    }
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     if (isConnected) {
  //       ref.read(issuesNotifierProvider.notifier).fetchIssues(
  //             _searchController.text,
  //             _tabController.index == 0 ? 'open' : 'closed',
  //             page: ++page,
  //           );
  //     } else {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return const NetworkErrorDialog();
  //           },
  //         );
  //       });
  //     }
  //   }
  // }

  void _updateIssues() {
    final sortOrder = selectedSort == 'Newest' ? 'desc' : 'asc';
    final filterLabel = selectedFilter == 'All' ? null : selectedFilter;

    ref.read(issuesNotifierProvider.notifier).fetchIssues(
          _searchController.text,
          _tabController.index == 0 ? 'open' : 'closed',
          sort: sortOrder,
          labels: filterLabel,
          page: 1,
        );
  }

  void _onTabChange() {
    if (_tabController.index != _tabController.previousIndex) {
      page = 1;
      final issueState = _tabController.index == 0 ? 'open' : 'closed';

      if (isConnected) {
        if (_searchController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a  repository name')),
          );
        } else {
          ref.read(issuesNotifierProvider.notifier).fetchIssues(
                _searchController.text,
                issueState,
                page: page,
              );
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const NetworkErrorDialog();
            },
          );
        });
      }
    }
  }

  List<Issue> _applySortingAndFiltering(List<Issue> issues) {
    List<Issue> sortedIssues = List.from(issues);
    if (selectedSort == 'Newest') {
      sortedIssues.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt)); // descending order
    } else {
      sortedIssues.sort(
          (a, b) => a.createdAt.compareTo(b.createdAt)); // ascending order
    }

    if (selectedFilter != 'All') {
      sortedIssues = sortedIssues
          .where((issue) => issue.labels.contains(selectedFilter))
          .toList();
    }

    return sortedIssues;
  }

  void _searchRepo(String repo) {
    page = 1; // Reset page on new search
    if (isConnected) {
      ref.read(issuesNotifierProvider.notifier).fetchIssues(
            repo,
            _tabController.index == 0 ? 'open' : 'closed',
            page: page,
          );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const NetworkErrorDialog();
          },
        );
      });
    }
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
      isConnected = result != ConnectivityResult.none;
    });

    if (!isConnected) {
      _showNetworkErrorDialog();
    } else {
      _dismissNetworkErrorDialog();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (isTabControllerInitialized) {
      _tabController.removeListener(_onTabChange);
      _tabController.dispose();
    }
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final issuesState = ref.watch(issuesNotifierProvider);

    return

      Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110), // Adjusted height for the AppBar
          child: AppBar(
            title: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter owner/repo (e.g., flutter/flutter)',
                      hintStyle: TextStyle(color: Colors.purple.shade200),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.purple, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.purple, width: 2),
                      ),
                    ),
                    onSubmitted: _searchRepo,
                    style: const TextStyle(color: Colors.purple),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (_searchController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a repository name')),
                      );
                    } else {
                      _searchRepo(_searchController.text);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ],
            ),
            bottom: isTabControllerInitialized
                ? TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Open Issues'),
                Tab(text: 'Closed Issues'),
              ],
              indicatorColor: Colors.purple,
              labelColor: Colors.purple,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 3.0,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            )
                : null,
          ),
        ),
        body: isTabControllerInitialized
            ? Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sorting Dropdown with animation
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300), // Animation duration
                        child: DropdownButton<String>(
                          key: ValueKey<String>(selectedSort), // Unique key for the widget
                          value: selectedSort,
                          isExpanded: true,
                          items: ['Newest', 'Oldest']
                              .map((sortOption) => DropdownMenuItem(
                            value: sortOption,
                            child: Text(sortOption),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSort = value!;
                            });
                            _updateIssues();
                          },
                        ),
                      ),
                    ),
                  ),

                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: DropdownButton<String>(
                          key: ValueKey<String>(selectedFilter),
                          value: selectedFilter,
                          isExpanded: true,
                          items: filters
                              .map((filterOption) => DropdownMenuItem(
                            value: filterOption,
                            child: Text(filterOption),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFilter = value!;
                            });
                            _updateIssues();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Wrap TabBarView in Expanded
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildIssueList(issuesState, 'open'),
                  _buildIssueList(issuesState, 'closed'),
                ],
              ),
            ),
          ],
        )
            : const Center(
          child: SpinKitFadingCircle(
            color: Colors.purple,
            size: 50.0,
          ),
        ),
      );

  }

  Widget _buildIssueList(IssuesState issuesState, String issueState) {
    if (issuesState.isLoading && issuesState.issues.isEmpty) {
      return const Center(child: LoadingWidget());
    }

    final sortedAndFilteredIssues =
        _applySortingAndFiltering(issuesState.issues);

    if (sortedAndFilteredIssues.isEmpty && !issuesState.isLoading) {
      return const Center(
        child: CustomAlertDialog(
          title: 'GitHub',
          description: 'Please enter a valid user/repo.',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        page = 1;
        if (isConnected) {
          await ref.read(issuesNotifierProvider.notifier).fetchIssues(
                _searchController.text,
                issueState,
                page: page,
              );
        } else {
          _showNetworkErrorDialog();
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount:
            sortedAndFilteredIssues.length + (issuesState.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == sortedAndFilteredIssues.length && isLoadingNextPage) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: LoadingWidget()),
            );
          }

          final issue = sortedAndFilteredIssues[index];
          return IssueTile(
            issue: issue,
            repositoryName: _searchController.text,
          );
        },
      ),
    );
  }
}
