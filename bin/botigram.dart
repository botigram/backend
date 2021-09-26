import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show get;
import 'package:mustache_template/mustache.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final botsUrl = Uri.parse(
  'https://raw.githubusercontent.com/botigram/lists/main/bots.json',
);

void main(List<String> arguments) {
  final app = Router(
    notFoundHandler: (r) => Response.notFound('uhhhhhhhhh not found'),
  );

  app.get('/', (Request request) async {
    var template = Template(
      File('./static/template.html').readAsStringSync(),
      lenient: true,
    );

    var json = jsonDecode(utf8.decode((await get(botsUrl)).bodyBytes)) as List;

    return Response.ok(
      template.renderString(json..shuffle()),
      headers: {'Content-Type': 'text/html'},
    );
  });

  serve(app, '0.0.0.0', 1337).then(
    (value) => print(
      'Serving at http://0.0.0.0:1337',
    ),
  );
}
