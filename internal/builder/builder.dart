import 'dart:io';

main(List<String> args) async {

  String cmd = args[0];

  // Not all of these fucntions need to be implemented but it was a simple way to lay everything out to start
  // As things get more complicated what happens is each switch statement should be put in its own seperate file and be called as a function
  // This is just a simple version to build up from
  // The build tool will have to be modified to take those files as a lib or something

  switch(cmd) { 
    case "compile": {
      var result = await Process.run('dart',args);
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
