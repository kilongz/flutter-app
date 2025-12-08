import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/item.dart';
import '../../widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Item> items = [];
  int page = 1;
  bool loading = true;
  bool hasMore = true;
  bool loadingMore = false;

  @override
  void initState() {
    super.initState();
    fetchItems();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMore &&
          !loadingMore) {
        fetchMoreItems();
      }
    });
  }

  fetchItems() async {
    final res = await api.getItems(page);
    if (res != null) {
      setState(() {
        items = res['items'];
        page = res['nextPage'] ?? page;
        hasMore = res['nextPage'] != null;
        loading = false;
      });
    }
  }

  fetchMoreItems() async {
    setState(() {
      loadingMore = true;
    });

    final res = await api.getItems(page);
    if (res != null) {
      setState(() {
        items.addAll(res['items']);
        page = res['nextPage'] ?? page;
        hasMore = res['nextPage'] != null;
        loadingMore = false;
      });
    }
  }

  Future<void> reloadPage() async {
    setState(() {
      loading = true;
      page = 1;
      items.clear();
      hasMore = true;
    });

    await fetchItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Items List")),
        automaticallyImplyLeading: false,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: reloadPage,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index < items.length) {
                    return ItemCard(item: items[index]);
                  } else {
                    return hasMore
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const Center(
                            child: Text(
                              'No more items...',
                              style: TextStyle(
                                fontSize: 25,
                                backgroundColor: Color.fromARGB(
                                  255,
                                  255,
                                  112,
                                  102,
                                ),
                              ),
                            ),
                          );
                  }
                },
              ),
            ),
    );
  }
}
