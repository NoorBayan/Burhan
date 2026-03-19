import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('C:/Users/Ameen/Desktop/ijaaz_app/assets/data/Amthal-main/data/processed/instances.json');
  final jsonString = await file.readAsString();
  final List<dynamic> instances = json.decode(jsonString);
  
  Set<String> childConcepts = {};
  for (var inst in instances) {
    if (inst['Child_Concept'] != null) {
      childConcepts.add(inst['Child_Concept'].toString());
    }
  }
  
  final outFile = File('C:/Users/Ameen/Desktop/ijaaz_app/lib/application/amthal_translator.dart');
  
  StringBuffer code = StringBuffer();
  code.writeln("class AmthalTranslator {");
  code.writeln("  static const Map<String, String> _childConceptsAr = {");
  for (var c in childConcepts) {
    code.writeln('    "$c": "$c",');
  }
  code.writeln("  };");
  code.writeln("}");
  
  await outFile.writeAsString(code.toString(), encoding: utf8);
  print('Done.');
}
