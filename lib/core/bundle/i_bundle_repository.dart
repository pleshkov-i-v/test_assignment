abstract interface class IBundleRepository {
  Future<String> getAsString(String sourceName);
}
