Future<Map<String, dynamic>> retrieveTranslations() async {
  await Future.delayed(const Duration(milliseconds: 300));
  // throw Exception("Failed to connect");
  return {
    "version": 1,
    "pt": {"helloWorld": "E ai mundão!!!!!!!!!!!!!!"},
  };
}
