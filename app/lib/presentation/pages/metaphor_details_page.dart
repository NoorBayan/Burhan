import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:ijaaz_app/data/surah_names_ar.dart';

class MetaphorDetailsPage extends StatefulWidget {
  final int chapterNo;
  final int verseNo;

  const MetaphorDetailsPage({Key? key, required this.chapterNo, required this.verseNo}) : super(key: key);

  @override
  _MetaphorDetailsPageState createState() => _MetaphorDetailsPageState();
}

class _MetaphorDetailsPageState extends State<MetaphorDetailsPage> {
  final List<String> _menuItems = [
    'المقدمة',
    'تفاصيل الاستعارة',
    'الأركان البلاغية',
    'أقوال العلماء',
  ];

  final Map<String, String> _menuItemToJsonKey = {
    'المقدمة': 'literary_preamble',
    'تفاصيل الاستعارة': 'metaphor_details',
    'الأركان البلاغية': 'rhetorical_elements',
    'أقوال العلماء': 'scholarly_insights',
  };

  int _selectedIndex = 0;
  Map<String, dynamic>? _verseData;
  bool _isLoading = true;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadRhetoricData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRhetoricData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/metaphors_data.json');
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
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'تفاصيل الاستعارة',
            style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.primary),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
            : _verseData == null
            ? const Center(child: Text('لا توجد بيانات لهذه الآية.'))
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? theme.colorScheme.surface : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'سورة ${surahNamesArabic[widget.chapterNo - 1]} - الآية: ${widget.verseNo}',
                          style: TextStyle(color: theme.colorScheme.primary, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _verseData?['metadata']?['ayah_text_uthmani'] ?? '',
                          style: const TextStyle(fontSize: 22, fontFamily: 'UthmanicHafs', height: 1.6),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(
                    height: 50,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected ? theme.colorScheme.primary : (isDark ? Colors.white10 : Colors.grey[200]),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                _menuItems[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.surface : Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
                        ],
                      ),
                      child: _buildContentWidget(theme),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildContentWidget(ThemeData theme) {
    final selectedMenuItem = _menuItems[_selectedIndex];
    final jsonKey = _menuItemToJsonKey[selectedMenuItem];
    dynamic data;

    final rhetoricalAnalysis = _verseData?['rhetorical_analysis'];
    final metaphorList = rhetoricalAnalysis?['metaphors'] ?? rhetoricalAnalysis?['similes'];
    final metaphorDataRoot = (metaphorList is List && metaphorList.isNotEmpty) ? metaphorList[0] : null;

    if (jsonKey == 'literary_preamble') data = _verseData?[jsonKey];
    else if (metaphorDataRoot != null) {
      switch (jsonKey) {
        case 'metaphor_details': data = metaphorDataRoot['classification']; break;
        case 'rhetorical_elements': data = metaphorDataRoot['components']; break;
        case 'scholarly_insights': data = metaphorDataRoot['scholarly_interpretations']?['details']; break;
      }
    }

    if (data == null || (data is String && data.trim().isEmpty) || (data is List && data.isEmpty)) {
      return const Center(child: Text('لا توجد بيانات لهذا القسم'));
    }

    final subtitleStyle = TextStyle(color: theme.colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold);
    final contentStyle = TextStyle(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8), fontSize: 16, height: 1.6);

    switch (jsonKey) {
      case 'literary_preamble':
        return SingleChildScrollView(child: Text(data['intro_text'] ?? '', style: contentStyle));
      case 'metaphor_details':
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('النوع الرئيسي:', style: subtitleStyle),
              Text(data['main_type'] ?? '', style: contentStyle),
              const SizedBox(height: 16),
              Text('التفاصيل:', style: subtitleStyle),
              if (data['types'] is List)
                ...data['types'].map<Widget>((type) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ${type['label'] ?? ''}', style: contentStyle.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                      Text(type['reason'] ?? '', style: contentStyle),
                    ],
                  ),
                )).toList()
            ],
          ),
        );
      case 'rhetorical_elements':
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildElementBox('المستعار له (المشبه المحذوف):', data['subject'], theme),
              _buildElementBox('المستعار منه (المشبه به):', data['image'], theme),
              _buildElementBox('العلاقة (وجه الشبه):', data['relation'], theme),
              _buildElementBox('قرينة الاستعارة:', data['evidence'], theme),
            ],
          ),
        );
      case 'scholarly_insights':
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['scholar'] ?? '', style: subtitleStyle.copyWith(fontSize: 16)),
                  if (item['book'] != null) Text(item['book'], style: TextStyle(color: theme.hintColor, fontSize: 13, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 10),
                  Text(item['full_text'] ?? item['insight'] ?? '', style: contentStyle),
                ],
              ),
            );
          },
        );
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildElementBox(String title, String? value, ThemeData theme) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: theme.colorScheme.primary, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
            child: Text(value, style: const TextStyle(fontSize: 16, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
