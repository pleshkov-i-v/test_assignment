import 'package:flutter/services.dart';
import 'package:test_case/core/bundle/i_bundle_repository.dart';

class BundleRepository implements IBundleRepository {
  BundleRepository();

  @override
  Future<String> getAsString(String sourceName) async {
    return rootBundle.loadString(sourceName);
  }
}
