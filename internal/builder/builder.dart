import 'dart:io';

main(List<String> args) async {

  String cmd = args[0];

  // need to get the environment variable for dart find its path and use that here
  Map<String, String> envVars = Platform.environment;

  // error check this and if there is an error send message that says that
  String? dartroot = envVars['DARTROOT'];
  print("DARTROOT: ${dartroot}");

  var dartexe = ""; 

  if (Platform.isLinux) {
    dartexe = "${dartroot}/bin/dart";

  } else if (Platform.isMacOS) {
    dartexe = "${dartroot}/bin/dart";

  } else if (Platform.isWindows) {
    dartexe = "${dartroot}/bin/dart.exe";

  } else {
    print("Platform not supported for environment variables");

  }

  // Not all of these fucntions need to be implemented but it was a simple way to lay everything out to start
  // As things get more complicated each switch statement should be put in its own seperate file and be called as a function
  // This is just a simple version to build up from
  // The build tool will have to be modified to take those files as a lib or something

  switch(cmd) { 
    case "compile": {
      var result = await Process.run(dartexe , args);
      stdout.write(result.stdout);
      stderr.write(result.stderr);
    } 
    break; 
    
    case "test": {  print("test"); } 
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

    case "pub": {  print("pub"); } 
    break;
    
    default: { print("Invalid choice"); } 
    break; 
  } 
}
