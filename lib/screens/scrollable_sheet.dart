import 'dart:convert';
import 'package:api_future/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScrollableSheet extends StatefulWidget {
  const ScrollableSheet({Key? key}) : super(key: key);

  @override
  State<ScrollableSheet> createState() => _ScrollableSheetState();
}

class _ScrollableSheetState extends State<ScrollableSheet> {
  DraggableScrollableController controller = DraggableScrollableController();

  String endpoint = 'https://reqres.in/api/users?page=2';

  Future<List<UserModel>> getUser() async {
    print("Fetch Data");
    http.Response response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => UserModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        controller: controller,
        initialChildSize: 0.2,
        minChildSize: 0.2,
        builder: (BuildContext context, ScrollController scrollController) {
          return Material(
              color: Colors.grey[200],
              child: CustomScrollView(controller: scrollController, slivers: [
                FutureBuilder<List<UserModel>>(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                          print("Build List");
                          return ListTile(
                            title: Text(snapshot.data![index].firstname),
                            subtitle: Text(snapshot.data![index].lastname),
                            trailing: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data![index].avatar),
                            ),
                          );
                        }, childCount: snapshot.data!.length));
                      } else {
                        return SliverToBoxAdapter(child: Text('loading'));
                      }
                    }),
              ]));
        });
  }
}