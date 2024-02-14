import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';

class FirebaseCloudFunctions {
  init() async {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }

  static call(
      {required String functionName,
      required dynamic parameters,
      String? token}) async {
    if (token != null) {
      parameters['token'] = token;
    }

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'southamerica-east1')
            .httpsCallable(
      functionName,
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );
    final resp = await callable<Map<String, dynamic>>(parameters);

    return FirebaseResponse.fromJson(resp);
  }
}

class FirebaseResponse {
  Map<String, dynamic>? data;

  FirebaseResponse({required this.data});

  FirebaseResponse.fromJson(dynamic d) {
    String s = json.encode(d.data);
    data = json.decode(s);
  }
}
