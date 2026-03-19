import 'package:flutter/material.dart';
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/models/concept_node.dart';

class ConceptsService {
  static Color getColorForMain(int id) {
    final colors = [
      const Color(0xFF6B3FF2),
      const Color(0xFFFF9E3A), 
      const Color(0xFF19D588), 
      const Color(0xFFE91E63), 
      const Color(0xFF00BCD4), 
      Colors.teal, 
      Colors.brown
    ];
    return colors[id % colors.length];
  }

  static Future<Map<String, ConceptNode>> processHierarchicalData() async {
    if (QuranDataLoader.allInstances.isEmpty) {
      await QuranDataLoader.loadInitialData();
    }
    
    final data = QuranDataLoader.allInstances;
    Map<String, ConceptNode> tempHierarchy = {};

    final Map<int, String> mainNames = {
      6: 'الطريق والمنهج',
      1: 'الخداع والمكر',
      2: 'النور والبصيرة',
      3: 'الظلمات والضلال',
      4: 'أحوال القلوب',
      5: 'الإيمان والكفر',
      0: 'مفاهيم عامة',
    };

    for (var inst in data) {
      int domId = inst['Dominant_Concept'] ?? 0;
      String parentName = mainNames[domId] ?? 'عام';
      // جلب الاسم العربي مباشرة من الجيسون
      String childName = inst['Child_Concept'] ?? 'متنوع';

      if (!tempHierarchy.containsKey(parentName)) {
        tempHierarchy[parentName] = ConceptNode(
          id: domId, 
          name: parentName, 
          color: getColorForMain(domId)
        );
      }
      tempHierarchy[parentName]!.addChild(childName);
    }
    
    return tempHierarchy;
  }
}
