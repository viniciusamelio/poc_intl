Future<Map<String, dynamic>> retrieveTranslations() async {
  await Future.delayed(const Duration(milliseconds: 300));
  // throw Exception("Failed to connect");
  return {
    "version": 2,
    "pt": {
      "appTitle": "API title here",
      "helloWorld": "Hello, {name}, you are {age} years old",
      "@helloWorld": {
        "description":
            "A saudação convencional do programador ao iniciar em uma nova tecnologia",
        "placeholders": {
          "name": {
            "description": "O nome do usuário",
            "type": "String",
          },
          "age": {
            "description": "A idade do usuário",
            "type": "int",
          },
        }
      },
    },
  };
}
