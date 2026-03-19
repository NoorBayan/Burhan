import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:ijaaz_app/data/surah_names_ar.dart';

enum RhetoricType {
  simile,
  metaphor,
  allusion,
  metonymy,
  conciseness,
  antithesis,
}

extension RhetoricTypeExt on RhetoricType {
  String get nameAr {
    switch (this) {
      case RhetoricType.simile: return 'التشبيه';
      case RhetoricType.metaphor: return 'الاستعارة';
      case RhetoricType.allusion: return 'الكناية';
      case RhetoricType.metonymy: return 'المجاز';
      case RhetoricType.conciseness: return 'الإيجاز';
      case RhetoricType.antithesis: return 'الطباق';
    }
  }

  String get jsonFile {
    switch (this) {
      case RhetoricType.simile: return 'assets/data/similes_data.json';
      case RhetoricType.metaphor: return 'assets/data/metaphors_data.json';
      default: return 'assets/data/similes_data.json';
    }
  }

  String get analysisKey {
    switch (this) {
      case RhetoricType.simile: return 'similes';
      case RhetoricType.metaphor: return 'metaphors';
      default: return 'similes';
    }
  }
}

class RhetoricAnalysisPage extends StatefulWidget {
  final int chapterNo;
  final int verseNo;
  final RhetoricType type;

  const RhetoricAnalysisPage({
    Key? key,
    required this.chapterNo,
    required this.verseNo,
    required this.type,
  }) : super(key: key);

  @override
  _RhetoricAnalysisPageState createState() => _RhetoricAnalysisPageState();
}

class _RhetoricAnalysisPageState extends State<RhetoricAnalysisPage> {
  late List<String> _menuItems;
  late Map<String, String> _menuItemToJsonKey;

  int _selectedIndex = 0;
  Map<String, dynamic>? _verseData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupMenu();
    _loadRhetoricData();
  }

  void _setupMenu() {
    if (widget.type == RhetoricType.simile) {
      _menuItems = ['المقدمة', 'تفاصيل التشبيه', 'أركان التشبيه', 'أقوال العلماء', 'الغرض البلاغي'];
      _menuItemToJsonKey = {
        'المقدمة': 'literary_preamble',
        'تفاصيل التشبيه': 'details',
        'أركان التشبيه': 'elements',
        'أقوال العلماء': 'scholarly_insights',
        'الغرض البلاغي': 'rhetorical_purpose',
      };
    } else {
      _menuItems = ['المقدمة', 'تفاصيل ${widget.type.nameAr}', 'الأركان', 'أقوال العلماء'];
      _menuItemToJsonKey = {
        'المقدمة': 'literary_preamble',
        'تفاصيل ${widget.type.nameAr}': 'details',
        'الأركان': 'elements',
        'أقوال العلماء': 'scholarly_insights',
      };
    }
  }

  Future<void> _loadRhetoricData() async {
    try {
      final String jsonString = await rootBundle.loadString(widget.type.jsonFile);
      final jsonData = json.decode(jsonString);

      if (jsonData is List) {
        final verseData = jsonData.firstWhere(
          (item) {
            if (item is! Map || item['metadata'] == null) return false;
            final meta = item['metadata'];
            return int.tryParse(meta['chapter_no'].toString()) == widget.chapterNo &&
                int.tryParse(meta['verse_no'].toString()) == widget.verseNo;
          },
          orElse: () => null,
        );

        if (mounted) {
          setState(() {
            _verseData = verseData != null ? Map<String, dynamic>.from(verseData) : null;
            _isLoading = false;
          });
        }
      } else {
         if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تحليل ${widget.type.nameAr}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.primary),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _verseData == null
                ? const Center(child: Text('لا توجد بيانات لهذه الآية.'))
                : Column(
                    children: [
                      _buildAyahCard(theme, isDark),
                      _buildHorizontalMenu(theme, isDark),
                      Expanded(child: _buildContentContainer(theme, isDark)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildAyahCard(ThemeData theme, bool isDark) {
    String suraName = widget.chapterNo > 0 && widget.chapterNo <= surahNamesArabic.length 
        ? surahNamesArabic[widget.chapterNo - 1] 
        : "سورة ${widget.chapterNo}";
        
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text('سورة $suraName - الآية: ${widget.verseNo}', style: TextStyle(color: theme.colorScheme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(_verseData?['metadata']?['ayah_text_uthmani'] ?? '', 
              style: const TextStyle(fontSize: 20, fontFamily: 'UthmanicHafs', height: 1.6), 
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHorizontalMenu(ThemeData theme, bool isDark) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.white10 : Colors.grey[100]),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(child: Text(_menuItems[index], style: TextStyle(color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color?.withOpacity(0.7), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentContainer(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: _buildContentWidget(theme),
    );
  }

  Widget _buildContentWidget(ThemeData theme) {
    final jsonKey = _menuItemToJsonKey[_menuItems[_selectedIndex]];
    final analysis = _verseData?['rhetorical_analysis'];
    
    // الحل: البحث في كلا المفتاحين (metaphors و similes) كما تفعل صفحة تفاصيل الاستعارة
    final list = analysis?['metaphors'] ?? analysis?['similes'] ?? analysis?[widget.type.analysisKey];
    final root = (list is List && list.isNotEmpty) ? list[0] : null;

    dynamic data;
    if (jsonKey == 'literary_preamble') {
      data = _verseData?['literary_preamble'];
    } else if (root != null) {
      switch (jsonKey) {
        case 'details':
          data = root['classification'] ?? root['details'] ?? root['type_details'];
          break;
        case 'elements':
          // إضافة 'components' للبحث عنها لضمان التوافق
          data = root['components'] ?? root['elements'] ?? root['pillars'];
          break;
        case 'scholarly_insights':
          data = root['scholarly_interpretations']?['details'] ?? root['scholarly_insights'] ?? root['interpretations'];
          break;
        case 'rhetorical_purpose':
          data = root['functions'] ?? root['purposes'] ?? root['rhetorical_purpose'];
          break;
      }
    }

    if (data == null || (data is String && data.trim().isEmpty) || (data is List && data.isEmpty)) {
      return const Center(child: Text('لا توجد بيانات متوفرة لهذا القسم حالياً.'));
    }

    final subtitleStyle = TextStyle(color: theme.colorScheme.primary, fontSize: 17, fontWeight: FontWeight.bold);
    final contentStyle = TextStyle(fontSize: 15, height: 1.7);

    switch (jsonKey) {
      case 'literary_preamble': 
        return SingleChildScrollView(child: Text(data['intro_text'] ?? data.toString(), style: contentStyle));
      case 'details':
        if (data is! Map) return SingleChildScrollView(child: Text(data.toString(), style: contentStyle));
        return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('النوع الرئيسي:', style: subtitleStyle),
          Text(data['main_type'] ?? 'غير محدد', style: contentStyle),
          const SizedBox(height: 16),
          Text('التفاصيل:', style: subtitleStyle),
          if (data['types'] is List) ...data['types'].map<Widget>((t) => Padding(padding: const EdgeInsets.only(top: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('• ${t['label'] ?? ''}', style: contentStyle.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            Text(t['reason'] ?? '', style: contentStyle),
          ]))).toList()
          else if (data['description'] != null) Text(data['description'], style: contentStyle),
        ]));
      case 'elements':
        if (data is! Map) return SingleChildScrollView(child: Text(data.toString(), style: contentStyle));
        return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildElementBox(widget.type == RhetoricType.simile ? 'المشبه:' : 'المستعار له (المشبه المحذوف):', data['subject'] ?? data['mushabba'], theme),
          _buildElementBox(widget.type == RhetoricType.simile ? 'المشبه به:' : 'المستعار منه (المشبه به):', data['image'] ?? data['mushabba_bih'], theme),
          _buildElementBox('العلاقة (وجه الشبه):', data['relation'] ?? data[' وجه_الشبه'], theme),
          _buildElementBox('القرينة / الأداة:', data['evidence'] ?? data['tool'] ?? data['adaat'], theme),
        ]));
      case 'scholarly_insights':
        if (data is! List) return SingleChildScrollView(child: Text(data.toString(), style: contentStyle));
        return ListView.builder(itemCount: data.length, itemBuilder: (c, i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data[i]['scholar'] ?? 'عالم غير محدد', style: subtitleStyle.copyWith(fontSize: 15)),
            if (data[i]['book'] != null) Text(data[i]['book'], style: TextStyle(color: theme.hintColor, fontSize: 12, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(data[i]['full_text'] ?? data[i]['insight'] ?? '', style: contentStyle),
          ]),
        ));
      case 'rhetorical_purpose':
        if (data is! List) return SingleChildScrollView(child: Text(data.toString(), style: contentStyle));
        return ListView.separated(itemCount: data.length, separatorBuilder: (_, __) => const Divider(height: 30), itemBuilder: (c, i) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data[i]['title'] ?? 'فائدة بلاغية', style: subtitleStyle),
          const SizedBox(height: 5),
          Text(data[i]['detail'] ?? data[i]['description'] ?? '', style: contentStyle),
        ]));
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildElementBox(String title, String? val, ThemeData theme) {
    if (val == null || val.isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(color: theme.colorScheme.primary, fontSize: 13, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Text(val, style: const TextStyle(fontSize: 15))),
    ]));
  }
}
