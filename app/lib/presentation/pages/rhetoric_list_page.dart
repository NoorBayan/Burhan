import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:ijaaz_app/presentation/pages/simile_details_page.dart';
import 'package:ijaaz_app/presentation/pages/metaphor_details_page.dart';
import 'package:ijaaz_app/data/surah_names_ar.dart';

class RhetoricListPage extends StatefulWidget {
  final String rhetoricType; // 'تشبيه' or 'استعارة'

  const RhetoricListPage({Key? key, required this.rhetoricType}) : super(key: key);

  @override
  _RhetoricListPageState createState() => _RhetoricListPageState();
}

class _RhetoricListPageState extends State<RhetoricListPage> {
  List<Map<String, dynamic>> _rhetoricItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRhetoricData();
  }

  Future<void> _loadRhetoricData() async {
    try {
      final String fileName = widget.rhetoricType == 'تشبيه' 
          ? 'assets/data/similes_data.json' 
          : 'assets/data/metaphors_data.json';

      final String jsonString = await rootBundle.loadString(fileName);
      final jsonData = json.decode(jsonString);

      if (jsonData is List) {
        final items = jsonData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        
        if (mounted) {
          setState(() {
            _rhetoricItems = items;
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

  void _navigateToDetails(int chapterNo, int verseNo) {
    if (widget.rhetoricType == 'تشبيه') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimileDetailsPage(chapterNo: chapterNo, verseNo: verseNo),
        ),
      );
    } else if (widget.rhetoricType == 'استعارة') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MetaphorDetailsPage(chapterNo: chapterNo, verseNo: verseNo),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : _rhetoricItems.isEmpty
              ? Center(child: Text('لا توجد بيانات متاحة', style: TextStyle(color: theme.hintColor, fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _rhetoricItems.length,
                  itemBuilder: (context, index) {
                    final item = _rhetoricItems[index];
                    final metadata = item['metadata'];

                    if (metadata == null) return const SizedBox.shrink();
                    
                    final int chapterNo = metadata['chapter_no'];
                    final int verseNo = metadata['verse_no'];
                    String surahName = surahNamesArabic[chapterNo - 1];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.surface : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'سورة $surahName • الآية: $verseNo',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            metadata['ayah_text_uthmani'] ?? 'الآية غير متوفرة',
                            style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8),
                              fontSize: 16,
                              fontFamily: 'UthmanicHafs',
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        onTap: () => _navigateToDetails(chapterNo, verseNo),
                        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.hintColor.withOpacity(0.5)),
                      ),
                    );
                  },
                ),
    );
  }
}
