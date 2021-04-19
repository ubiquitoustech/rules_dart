import 'dart:io';

main(List<String> args) async {

  String cmd = args[0];
  // need to get working directory for dart and the depth of the working directory

  // need to get the environment variable for dart find its path and use that here
  Map<String, String> envVars = Platform.environment;

  // error check this and if there is an error send message that says that
  String? dartroot = envVars['DARTROOT'];
  print("DARTROOT: ${dartroot}");

  var dartexe = "";
  var path = {"":""}; 

  if (Platform.isLinux) {
    dartexe = "${dartroot}/bin/dart";

  } else if (Platform.isMacOS) {
    dartexe = "${dartroot}/bin/dart";

  } else if (Platform.isWindows) {
    dartexe = "${dartroot}/bin/dart.exe";
    path = {
        // This needs to be updated automatically depending on what package you are trying to compile
        "PATH":"../../${dartroot}/bin",
        // this should point to a shared cache or use external dependencies like other bazel rules ex: rules_go
        "PUB_CACHE": ".",
        // this environment variable is from here: https://github.com/dart-lang/test/blob/5569fabbec6647f01f957b684e235125edbb67ec/pkgs/test_core/lib/src/executable.dart#L27
        // "LOCALAPPDATA": ".",
        "DART_TEST_CONFIG": ".",
      };

  } else {
    print("Platform not supported for environment variables");

  }

  // Not all of these fucntions need to be implemented but it was a simple way to lay everything out to start
  // As things get more complicated each switch statement should be put in its own seperate file and be called as a function
  // This is just a simple version to build up from
  // The build tool will have to be modified to take those files as a lib or something

  switch(cmd) { 
    case "compile": {
      // var test = await Process.run(dartexe, ['test', 'test/package_simple_test.dart',], workingDirectory: "tests/package_simple"); // {workingDirectory = ""}
      //var test = await Process.run(dartexe, ['pub', 'get',]); //, workingDirectory: "tests/package_simple");
      // var get = await Process.run('dart', ['pub', 'get', '--precompile'], runInShell: true, workingDirectory: "tests/package_simple", environment: path);
      // stdout.write(get.stdout);
      // stderr.write(get.stderr);
      var test = await Process.run('dart', ['test'], runInShell: true, workingDirectory: "tests/package_simple", environment: path);
      stdout.write(test.stdout);
      stderr.write(test.stderr);
      // var see = await Process.run('dir', [], runInShell: true, workingDirectory: "tests/package_simple"); //, workingDirectory: "tests/package_simple");
      // stdout.write(see.stdout);
      // stderr.write(see.stderr);
      // print(args);
      var result = await Process.run(dartexe , args);
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    } 
    break; 
    
    case "test": {
      var test = await Process.run('dart', ['test'], runInShell: true, workingDirectory: "tests/package_simple", environment: path);
      stdout.write(test.stdout);
      stderr.write(test.stderr);
    } 
    break;

    case "analyze": {  print("analyze"); } 
    break; 

    case "create": {  print("create"); } 
    break; 

    case "fix": {  print("fix"); } 
    break; 

    case "format": {  print("format"); } 
    break;

    case "migrate": {  print("migrate"); } 
    break;

    case "pub": {
      var get = await Process.run('dart', ['pub', 'get', '--precompile'], runInShell: true, workingDirectory: "tests/package_simple", environment: path);
      stdout.write(get.stdout);
      stderr.write(get.stderr);
    } 
    break;
    
    default: { print("Invalid choice"); } 
    break; 
  } 
}
