// hB: Has Balaqah (يستخدم لإظهار الأيقونة الذهبية فوراً لتحسين الأداء)
const List pageData = [
  [
    {"surah": 1, "start": 1, "end": 7}
  ],
  [
    {"surah": 2, "start": 1, "end": 5}
  ],
  [
    {"surah": 2, "start": 6, "end": 16}
  ],
  [
    {"surah": 2, "start": 17, "end": 24, "hB": true} // البقرة 17-20 تحتوي على تشبيهات
  ],
  [
    {"surah": 2, "start": 25, "end": 29, "hB": true} // البقرة 26 تشبيه (بعوضة)
  ],
  [
    {"surah": 2, "start": 30, "end": 37}
  ],
  [
    {"surah": 2, "start": 38, "end": 48}
  ],
  [
    {"surah": 2, "start": 49, "end": 57}
  ],
  [
    {"surah": 2, "start": 58, "end": 61}
  ],
  [
    {"surah": 2, "start": 62, "end": 69}
  ],
  [
    {"surah": 2, "start": 70, "end": 76}
  ],
  [
    {"surah": 2, "start": 77, "end": 83}
  ],
  [
    {"surah": 2, "start": 84, "end": 88}
  ],
  [
    {"surah": 2, "start": 89, "end": 93}
  ],
  [
    {"surah": 2, "start": 94, "end": 101}
  ],
  [
    {"surah": 2, "start": 102, "end": 105}
  ],
  [
    {"surah": 2, "start": 106, "end": 112}
  ],
  [
    {"surah": 2, "start": 113, "end": 119}
  ],
  [
    {"surah": 2, "start": 120, "end": 126}
  ],
  [
    {"surah": 2, "start": 127, "end": 134}
  ],
  [
    {"surah": 2, "start": 135, "end": 141}
  ],
  [
    {"surah": 2, "start": 142, "end": 145}
  ],
  [
    {"surah": 2, "start": 146, "end": 153}
  ],
  [
    {"surah": 2, "start": 154, "end": 163}
  ],
  [
    {"surah": 2, "start": 164, "end": 169}
  ],
  [
    {"surah": 2, "start": 170, "end": 176, "hB": true} // البقرة 171 تشبيه
  ],
  [
    {"surah": 2, "start": 177, "end": 181}
  ],
  [
    {"surah": 2, "start": 182, "end": 186}
  ],
  [
    {"surah": 2, "start": 187, "end": 190, "hB": true} // البقرة 187 استعارة (لباس لكم)
  ],
  [
    {"surah": 2, "start": 191, "end": 196}
  ],
  [
    {"surah": 2, "start": 197, "end": 202}
  ],
  [
    {"surah": 2, "start": 203, "end": 210}
  ],
  [
    {"surah": 2, "start": 211, "end": 215}
  ],
  [
    {"surah": 2, "start": 216, "end": 219}
  ],
  [
    {"surah": 2, "start": 220, "end": 224, "hB": true} // البقرة 223 تشبيه (حرث لكم)
  ],
  [
    {"surah": 2, "start": 225, "end": 230}
  ],
  [
    {"surah": 2, "start": 231, "end": 233}
  ],
  [
    {"surah": 2, "start": 234, "end": 237}
  ],
  [
    {"surah": 2, "start": 238, "end": 245}
  ],
  [
    {"surah": 2, "start": 246, "end": 248}
  ],
  [
    {"surah": 2, "start": 249, "end": 252}
  ],
  [
    {"surah": 2, "start": 253, "end": 256}
  ],
  [
    {"surah": 2, "start": 257, "end": 259, "hB": true} // البقرة 259 تشبيه
  ],
  [
    {"surah": 2, "start": 260, "end": 264, "hB": true} // البقرة 261 تشبيه حبة، 264 تشبيه صفوان
  ],
  [
    {"surah": 2, "start": 265, "end": 269, "hB": true} // البقرة 265 تشبيه جنة بربوة
  ],
  [
    {"surah": 2, "start": 270, "end": 274}
  ],
  [
    {"surah": 2, "start": 275, "end": 281, "hB": true} // البقرة 275 تشبيه الذي يتخبطه الشيطان
  ],
  [
    {"surah": 2, "start": 282, "end": 282}
  ],
  [
    {"surah": 2, "start": 283, "end": 286}
  ],
  [
    {"surah": 3, "start": 1, "end": 9, "hB": true} // آل عمران 7 استعارة (أم الكتاب)
  ],
  [
    {"surah": 3, "start": 10, "end": 15}
  ],
  [
    {"surah": 3, "start": 16, "end": 22}
  ],
  [
    {"surah": 3, "start": 23, "end": 29}
  ],
  [
    {"surah": 3, "start": 30, "end": 37}
  ],
  [
    {"surah": 3, "start": 38, "end": 45}
  ],
  [
    {"surah": 3, "start": 46, "end": 52}
  ],
  [
    {"surah": 3, "start": 53, "end": 61}
  ],
  [
    {"surah": 3, "start": 62, "end": 70}
  ],
  [
    {"surah": 3, "start": 71, "end": 77}
  ],
  [
    {"surah": 3, "start": 78, "end": 83}
  ],
  [
    {"surah": 3, "start": 84, "end": 91}
  ],
  [
    {"surah": 3, "start": 92, "end": 100}
  ],
  [
    {"surah": 3, "start": 101, "end": 108, "hB": true} // آل عمران 103 استعارة (حبل الله)
  ],
  [
    {"surah": 3, "start": 109, "end": 115, "hB": true} // آل عمران 112 استعارة (حبل من الله)
  ],
  [
    {"surah": 3, "start": 116, "end": 121, "hB": true} // آل عمران 117 تشبيه ريح فيها صر
  ],
  [
    {"surah": 3, "start": 122, "end": 132}
  ],
  [
    {"surah": 3, "start": 133, "end": 140}
  ],
  [
    {"surah": 3, "start": 141, "end": 148}
  ],
  [
    {"surah": 3, "start": 149, "end": 153}
  ],
  [
    {"surah": 3, "start": 154, "end": 157}
  ],
  [
    {"surah": 3, "start": 158, "end": 165}
  ],
  [
    {"surah": 3, "start": 166, "end": 173}
  ],
  [
    {"surah": 3, "start": 174, "end": 180}
  ],
  [
    {"surah": 3, "start": 181, "end": 186}
  ],
  [
    {"surah": 3, "start": 187, "end": 194}
  ],
  [
    {"surah": 3, "start": 195, "end": 200}
  ],
  [
    {"surah": 4, "start": 1, "end": 6}
  ],
  [
    {"surah": 4, "start": 7, "end": 11, "hB": true} // النساء 10 استعارة (يأكلون في بطونهم ناراً)
  ],
  [
    {"surah": 4, "start": 12, "end": 14}
  ],
  [
    {"surah": 4, "start": 15, "end": 19}
  ],
  [
    {"surah": 4, "start": 20, "end": 23}
  ],
  [
    {"surah": 4, "start": 24, "end": 26}
  ],
  [
    {"surah": 4, "start": 27, "end": 33}
  ],
  [
    {"surah": 4, "start": 34, "end": 37}
  ],
  [
    {"surah": 4, "start": 38, "end": 44}
  ],
  [
    {"surah": 4, "start": 45, "end": 51}
  ],
  [
    {"surah": 4, "start": 52, "end": 59}
  ],
  [
    {"surah": 4, "start": 60, "end": 65}
  ],
  [
    {"surah": 4, "start": 66, "end": 74}
  ],
  [
    {"surah": 4, "start": 75, "end": 79}
  ],
  [
    {"surah": 4, "start": 80, "end": 86}
  ],
  [
    {"surah": 4, "start": 87, "end": 91}
  ],
  [
    {"surah": 4, "start": 92, "end": 94}
  ],
  [
    {"surah": 4, "start": 95, "end": 101}
  ],
  [
    {"surah": 4, "start": 102, "end": 105}
  ],
  [
    {"surah": 4, "start": 106, "end": 113}
  ],
  [
    {"surah": 4, "start": 114, "end": 121}
  ],
  [
    {"surah": 4, "start": 122, "end": 127}
  ],
  [
    {"surah": 4, "start": 128, "end": 134}
  ],
  [
    {"surah": 4, "start": 135, "end": 140}
  ],
  [
    {"surah": 4, "start": 141, "end": 147, "hB": true} // النساء 143 تشبيه المذبذبين
  ],
  [
    {"surah": 4, "start": 148, "end": 154}
  ],
  [
    {"surah": 4, "start": 155, "end": 162, "hB": true} // النساء 155 استعارة (قلوبنا غلف)
  ],
  [
    {"surah": 4, "start": 163, "end": 170}
  ],
  [
    {"surah": 4, "start": 171, "end": 175, "hB": true} // النساء 174 استعارة (نور مبين)
  ],
  [
    {"surah": 4, "start": 176, "end": 176},
    {"surah": 5, "start": 1, "end": 2}
  ],
  [
    {"surah": 5, "start": 3, "end": 5}
  ],
  [
    {"surah": 5, "start": 6, "end": 9}
  ],
  [
    {"surah": 5, "start": 10, "end": 13}
  ],
  [
    {"surah": 5, "start": 14, "end": 17, "hB": true} // المائدة 15، 16 استعارات النور
  ],
  [
    {"surah": 5, "start": 18, "end": 23}
  ],
  [
    {"surah": 5, "start": 24, "end": 31}
  ],
  [
    {"surah": 5, "start": 32, "end": 36}
  ],
  [
    {"surah": 5, "start": 37, "end": 41}
  ],
  [
    {"surah": 5, "start": 42, "end": 45}
  ],
  [
    {"surah": 5, "start": 46, "end": 50, "hB": true} // المائدة 46 استعارة النور والهدى
  ],
  [
    {"surah": 5, "start": 51, "end": 57}
  ],
  [
    {"surah": 5, "start": 58, "end": 64}
  ],
  [
    {"surah": 5, "start": 65, "end": 70}
  ],
  [
    {"surah": 5, "start": 71, "end": 77}
  ],
  [
    {"surah": 5, "start": 78, "end": 83}
  ],
  [
    {"surah": 5, "start": 84, "end": 90}
  ],
  [
    {"surah": 5, "start": 91, "end": 95}
  ],
  [
    {"surah": 5, "start": 96, "end": 103}
  ],
  [
    {"surah": 5, "start": 104, "end": 108}
  ],
  [
    {"surah": 5, "start": 109, "end": 113}
  ],
  [
    {"surah": 5, "start": 114, "end": 120}
  ],
  [
    {"surah": 6, "start": 1, "end": 8}
  ],
  [
    {"surah": 6, "start": 9, "end": 18}
  ],
  [
    {"surah": 6, "start": 19, "end": 27}
  ],
  [
    {"surah": 6, "start": 28, "end": 35}
  ],
  [
    {"surah": 6, "start": 36, "end": 44, "hB": true} // الأنعام 39 تشبيه الصم والبكم
  ],
  [
    {"surah": 6, "start": 45, "end": 52}
  ],
  [
    {"surah": 6, "start": 53, "end": 59}
  ],
  [
    {"surah": 6, "start": 60, "end": 68}
  ],
  [
    {"surah": 6, "start": 69, "end": 73}
  ],
  [
    {"surah": 6, "start": 74, "end": 81}
  ],
  [
    {"surah": 6, "start": 82, "end": 90}
  ],
  [
    {"surah": 6, "start": 91, "end": 94}
  ],
  [
    {"surah": 6, "start": 95, "end": 101}
  ],
  [
    {"surah": 6, "start": 102, "end": 110}
  ],
  [
    {"surah": 6, "start": 111, "end": 118}
  ],
  [
    {"surah": 6, "start": 119, "end": 124, "hB": true} // الأنعام 122 استعارة (أو من كان ميتاً فأحييناه)
  ],
  [
    {"surah": 6, "start": 125, "end": 130, "hB": true} // الأنعام 125 تشبيه يصعد في السماء
  ],
  [
    {"surah": 6, "start": 131, "end": 137}
  ],
  [
    {"surah": 6, "start": 138, "end": 142}
  ],
  [
    {"surah": 6, "start": 143, "end": 146}
  ],
  [
    {"surah": 6, "start": 147, "end": 151}
  ],
  [
    {"surah": 6, "start": 152, "end": 157}
  ],
  [
    {"surah": 6, "start": 158, "end": 165}
  ],
  [
    {"surah": 7, "start": 1, "end": 11}
  ],
  [
    {"surah": 7, "start": 12, "end": 22, "hB": true} // الأعراف 17، 22 استعارات
  ],
  [
    {"surah": 7, "start": 23, "end": 30, "hB": true} // الأعراف 26 استعارة لباس التقوى
  ],
  [
    {"surah": 7, "start": 31, "end": 37, "hB": true} // الأعراف 37 استعارة
  ],
  [
    {"surah": 7, "start": 38, "end": 43, "hB": true} // الأعراف 40 تشبيه الجمل في سم الخياط
  ],
  [
    {"surah": 7, "start": 44, "end": 51, "hB": true} // الأعراف 50 استعارة
  ],
  [
    {"surah": 7, "start": 52, "end": 57, "hB": true} // الأعراف 57 تشبيه البلد الطيب والبلد الخبيث
  ],
  [
    {"surah": 7, "start": 58, "end": 67}
  ],
  [
    {"surah": 7, "start": 68, "end": 73}
  ],
  [
    {"surah": 7, "start": 74, "end": 81}
  ],
  [
    {"surah": 7, "start": 82, "end": 87}
  ],
  [
    {"surah": 7, "start": 88, "end": 95}
  ],
  [
    {"surah": 7, "start": 96, "end": 104}
  ],
  [
    {"surah": 7, "start": 105, "end": 120}
  ],
  [
    {"surah": 7, "start": 121, "end": 130}
  ],
  [
    {"surah": 7, "start": 131, "end": 137}
  ],
  [
    {"surah": 7, "start": 138, "end": 143}
  ],
  [
    {"surah": 7, "start": 144, "end": 149}
  ],
  [
    {"surah": 7, "start": 150, "end": 155}
  ],
  [
    {"surah": 7, "start": 156, "end": 159}
  ],
  [
    {"surah": 7, "start": 160, "end": 163}
  ],
  [
    {"surah": 7, "start": 164, "end": 170}
  ],
  [
    {"surah": 7, "start": 171, "end": 178, "hB": true} // الأعراف 175، 176 تشبيه الكلب
  ],
  [
    {"surah": 7, "start": 179, "end": 187, "hB": true} // الأعراف 179 تشبيه بالأنعام
  ],
  [
    {"surah": 7, "start": 188, "end": 195}
  ],
  [
    {"surah": 7, "start": 196, "end": 206}
  ],
  [
    {"surah": 8, "start": 1, "end": 8}
  ],
  [
    {"surah": 8, "start": 9, "end": 16}
  ],
  [
    {"surah": 8, "start": 17, "end": 25}
  ],
  [
    {"surah": 8, "start": 26, "end": 33}
  ],
  [
    {"surah": 8, "start": 34, "end": 40}
  ],
  [
    {"surah": 8, "start": 41, "end": 45}
  ],
  [
    {"surah": 8, "start": 46, "end": 52}
  ],
  [
    {"surah": 8, "start": 53, "end": 61}
  ],
  [
    {"surah": 8, "start": 62, "end": 69}
  ],
  [
    {"surah": 8, "start": 70, "end": 75}
  ],
  [
    {"surah": 9, "start": 1, "end": 6}
  ],
  [
    {"surah": 9, "start": 7, "end": 13}
  ],
  [
    {"surah": 9, "start": 14, "end": 20}
  ],
  [
    {"surah": 9, "start": 21, "end": 26}
  ],
  [
    {"surah": 9, "start": 27, "end": 31}
  ],
  [
    {"surah": 9, "start": 32, "end": 36}
  ],
  [
    {"surah": 9, "start": 37, "end": 40}
  ],
  [
    {"surah": 9, "start": 41, "end": 47}
  ],
  [
    {"surah": 9, "start": 48, "end": 54}
  ],
  [
    {"surah": 9, "start": 55, "end": 61}
  ],
  [
    {"surah": 9, "start": 62, "end": 68}
  ],
  [
    {"surah": 9, "start": 69, "end": 72}
  ],
  [
    {"surah": 9, "start": 73, "end": 79}
  ],
  [
    {"surah": 9, "start": 80, "end": 86}
  ],
  [
    {"surah": 9, "start": 87, "end": 93}
  ],
  [
    {"surah": 9, "start": 94, "end": 99}
  ],
  [
    {"surah": 9, "start": 100, "end": 106}
  ],
  [
    {"surah": 9, "start": 107, "end": 111, "hB": true} // التوبة 109 تشبيه جرف هار
  ],
  [
    {"surah": 9, "start": 112, "end": 117}
  ],
  [
    {"surah": 9, "start": 118, "end": 122}
  ],
  [
    {"surah": 9, "start": 123, "end": 129}
  ],
  [
    {"surah": 10, "start": 1, "end": 6}
  ],
  [
    {"surah": 10, "start": 7, "end": 14}
  ],
  [
    {"surah": 10, "start": 15, "end": 20}
  ],
  [
    {"surah": 10, "start": 21, "end": 25, "hB": true} // يونس 24 تشبيه الحياة الدنيا بماء
  ],
  [
    {"surah": 10, "start": 26, "end": 33}
  ],
  [
    {"surah": 10, "start": 34, "end": 42}
  ],
  [
    {"surah": 10, "start": 43, "end": 53}
  ],
  [
    {"surah": 10, "start": 54, "end": 61}
  ],
  [
    {"surah": 10, "start": 62, "end": 70}
  ],
  [
    {"surah": 10, "start": 71, "end": 78}
  ],
  [
    {"surah": 10, "start": 79, "end": 88}
  ],
  [
    {"surah": 10, "start": 89, "end": 97}
  ],
  [
    {"surah": 10, "start": 98, "end": 106}
  ],
  [
    {"surah": 10, "start": 107, "end": 109},
    {"surah": 11, "start": 1, "end": 5}
  ],
  [
    {"surah": 11, "start": 6, "end": 12}
  ],
  [
    {"surah": 11, "start": 13, "end": 19}
  ],
  [
    {"surah": 11, "start": 20, "end": 28, "hB": true} // هود 24 تشبيه الفريقين (أعمى وأصم)
  ],
  [
    {"surah": 11, "start": 29, "end": 37}
  ],
  [
    {"surah": 11, "start": 38, "end": 45, "hB": true} // هود 42 تشبيه الموج بالجبال
  ],
  [
    {"surah": 11, "start": 46, "end": 53}
  ],
  [
    {"surah": 11, "start": 54, "end": 62}
  ],
  [
    {"surah": 11, "start": 63, "end": 71}
  ],
  [
    {"surah": 11, "start": 72, "end": 81}
  ],
  [
    {"surah": 11, "start": 82, "end": 88}
  ],
  [
    {"surah": 11, "start": 89, "end": 97}
  ],
  [
    {"surah": 11, "start": 98, "end": 108}
  ],
  [
    {"surah": 11, "start": 109, "end": 117}
  ],
  [
    {"surah": 11, "start": 118, "end": 123},
    {"surah": 12, "start": 1, "end": 4}
  ],
  [
    {"surah": 12, "start": 5, "end": 14}
  ],
  [
    {"surah": 12, "start": 15, "end": 22}
  ],
  [
    {"surah": 12, "start": 23, "end": 30}
  ],
  [
    {"surah": 12, "start": 31, "end": 37}
  ],
  [
    {"surah": 12, "start": 38, "end": 43}
  ],
  [
    {"surah": 12, "start": 44, "end": 52}
  ],
  [
    {"surah": 12, "start": 53, "end": 63}
  ],
  [
    {"surah": 12, "start": 64, "end": 69}
  ],
  [
    {"surah": 12, "start": 70, "end": 78}
  ],
  [
    {"surah": 12, "start": 79, "end": 86}
  ],
  [
    {"surah": 12, "start": 87, "end": 95}
  ],
  [
    {"surah": 12, "start": 96, "end": 103}
  ],
  [
    {"surah": 12, "start": 104, "end": 111}
  ],
  [
    {"surah": 13, "start": 1, "end": 5}
  ],
  [
    {"surah": 13, "start": 6, "end": 13}
  ],
  [
    {"surah": 13, "start": 14, "end": 18, "hB": true} // الرعد 14 تشبيه باسط كفيه، 17 تشبيه السيل والزبد
  ],
  [
    {"surah": 13, "start": 19, "end": 28}
  ],
  [
    {"surah": 13, "start": 29, "end": 34}
  ],
  [
    {"surah": 13, "start": 35, "end": 42}
  ],
  [
    {"surah": 13, "start": 43, "end": 43},
    {"surah": 14, "start": 1, "end": 5}
  ],
  [
    {"surah": 14, "start": 6, "end": 10}
  ],
  [
    {"surah": 14, "start": 11, "end": 18, "hB": true} // إبراهيم 18 تشبيه أعمال الكفار برماد
  ],
  [
    {"surah": 14, "start": 19, "end": 24, "hB": true} // إبراهيم 24 تشبيه الكلمة الطيبة بالشجرة
  ],
  [
    {"surah": 14, "start": 25, "end": 33, "hB": true} // إبراهيم 26 تشبيه الكلمة الخبيثة
  ],
  [
    {"surah": 14, "start": 34, "end": 42}
  ],
  [
    {"surah": 14, "start": 43, "end": 52}
  ],
  [
    {"surah": 15, "start": 1, "end": 15}
  ],
  [
    {"surah": 15, "start": 16, "end": 31}
  ],
  [
    {"surah": 15, "start": 32, "end": 51}
  ],
  [
    {"surah": 15, "start": 52, "end": 70}
  ],
  [
    {"surah": 15, "start": 71, "end": 90, "hB": true} // الحجر 88 استعارة جناح الذل
  ],
  [
    {"surah": 15, "start": 91, "end": 99},
    {"surah": 16, "start": 1, "end": 6}
  ],
  [
    {"surah": 16, "start": 7, "end": 14}
  ],
  [
    {"surah": 16, "start": 15, "end": 26, "hB": true} // النحل 26 استعارة
  ],
  [
    {"surah": 16, "start": 27, "end": 34}
  ],
  [
    {"surah": 16, "start": 35, "end": 42}
  ],
  [
    {"surah": 16, "start": 43, "end": 54}
  ],
  [
    {"surah": 16, "start": 55, "end": 64}
  ],
  [
    {"surah": 16, "start": 65, "end": 72}
  ],
  [
    {"surah": 16, "start": 73, "end": 79, "hB": true} // النحل 75، 76 تشبيهات العبد المملوك والأبكم
  ],
  [
    {"surah": 16, "start": 80, "end": 87}
  ],
  [
    {"surah": 16, "start": 88, "end": 93, "hB": true} // النحل 92 تشبيه التي نقضت غزلها
  ],
  [
    {"surah": 16, "start": 94, "end": 102}
  ],
  [
    {"surah": 16, "start": 103, "end": 110}
  ],
  [
    {"surah": 16, "start": 111, "end": 118, "hB": true} // النحل 112 تشبيه القرية الآمنة
  ],
  [
    {"surah": 16, "start": 119, "end": 128}
  ],
  [
    {"surah": 17, "start": 1, "end": 7}
  ],
  [
    {"surah": 17, "start": 8, "end": 17}
  ],
  [
    {"surah": 17, "start": 18, "end": 27, "hB": true} // الإسراء 24 استعارة جناح الذل
  ],
  [
    {"surah": 17, "start": 28, "end": 38, "hB": true} // الإسراء 29 تشبيه اليد المغلولة والمبسوطة
  ],
  [
    {"surah": 17, "start": 39, "end": 49}
  ],
  [
    {"surah": 17, "start": 50, "end": 58}
  ],
  [
    {"surah": 17, "start": 59, "end": 66}
  ],
  [
    {"surah": 17, "start": 67, "end": 75}
  ],
  [
    {"surah": 17, "start": 76, "end": 86}
  ],
  [
    {"surah": 17, "start": 87, "end": 96}
  ],
  [
    {"surah": 17, "start": 97, "end": 104}
  ],
  [
    {"surah": 17, "start": 105, "end": 111},
    {"surah": 18, "start": 1, "end": 4}
  ],
  [
    {"surah": 18, "start": 5, "end": 15}
  ],
  [
    {"surah": 18, "start": 16, "end": 20, "hB": true} // الكهف 18 تشبيه لوليت منهم فراراً
  ],
  [
    {"surah": 18, "start": 21, "end": 27}
  ],
  [
    {"surah": 18, "start": 28, "end": 34}
  ],
  [
    {"surah": 18, "start": 35, "end": 45, "hB": true} // الكهف 45 تشبيه الحياة الدنيا بماء
  ],
  [
    {"surah": 18, "start": 46, "end": 53}
  ],
  [
    {"surah": 18, "start": 54, "end": 61}
  ],
  [
    {"surah": 18, "start": 62, "end": 74}
  ],
  [
    {"surah": 18, "start": 75, "end": 83}
  ],
  [
    {"surah": 18, "start": 84, "end": 97}
  ],
  [
    {"surah": 18, "start": 98, "end": 110, "hB": true} // الكهف 109 تشبيه البحر بالمداد
  ],
  [
    {"surah": 19, "start": 1, "end": 11, "hB": true} // مريم 4 استعارة اشتعال الرأس شيباً
  ],
  [
    {"surah": 19, "start": 12, "end": 25}
  ],
  [
    {"surah": 19, "start": 26, "end": 38}
  ],
  [
    {"surah": 19, "start": 39, "end": 51}
  ],
  [
    {"surah": 19, "start": 52, "end": 64}
  ],
  [
    {"surah": 19, "start": 65, "end": 76}
  ],
  [
    {"surah": 19, "start": 77, "end": 95, "hB": true} // مريم 88، 90، 91 استعارات
  ],
  [
    {"surah": 19, "start": 96, "end": 98},
    {"surah": 20, "start": 1, "end": 12}
  ],
  [
    {"surah": 20, "start": 13, "end": 37}
  ],
  [
    {"surah": 20, "start": 38, "end": 51}
  ],
  [
    {"surah": 20, "start": 52, "end": 64}
  ],
  [
    {"surah": 20, "start": 65, "end": 76}
  ],
  [
    {"surah": 20, "start": 77, "end": 87}
  ],
  [
    {"surah": 20, "start": 88, "end": 98}
  ],
  [
    {"surah": 20, "start": 99, "end": 113}
  ],
  [
    {"surah": 20, "start": 114, "end": 125}
  ],
  [
    {"surah": 20, "start": 126, "end": 135}
  ],
  [
    {"surah": 21, "start": 1, "end": 10}
  ],
  [
    {"surah": 21, "start": 11, "end": 24, "hB": true} // الأنبياء 18 استعارة قذف الحق على الباطل
  ],
  [
    {"surah": 21, "start": 25, "end": 35}
  ],
  [
    {"surah": 21, "start": 36, "end": 44}
  ],
  [
    {"surah": 21, "start": 45, "end": 57}
  ],
  [
    {"surah": 21, "start": 58, "end": 72}
  ],
  [
    {"surah": 21, "start": 73, "end": 81}
  ],
  [
    {"surah": 21, "start": 82, "end": 90}
  ],
  [
    {"surah": 21, "start": 91, "end": 101, "hB": true} // الأنبياء 100 استعارة
  ],
  [
    {"surah": 21, "start": 102, "end": 112, "hB": true} // الأنبياء 104 تشبيه طي السماء كالسجل
  ],
  [
    {"surah": 22, "start": 1, "end": 5, "hB": true} // الحج 2 تشبيه السكرى، 5 استعارة الأرض الهامدة
  ],
  [
    {"surah": 22, "start": 6, "end": 15}
  ],
  [
    {"surah": 22, "start": 16, "end": 23}
  ],
  [
    {"surah": 22, "start": 24, "end": 30}
  ],
  [
    {"surah": 22, "start": 31, "end": 38, "hB": true} // الحج 31 تشبيه من يشرك بالله بمن خر من السماء
  ],
  [
    {"surah": 22, "start": 39, "end": 46}
  ],
  [
    {"surah": 22, "start": 47, "end": 55}
  ],
  [
    {"surah": 22, "start": 56, "end": 64}
  ],
  [
    {"surah": 22, "start": 65, "end": 72}
  ],
  [
    {"surah": 22, "start": 73, "end": 78, "hB": true} // الحج 73 تشبيه الذباب
  ],
  [
    {"surah": 23, "start": 1, "end": 17}
  ],
  [
    {"surah": 23, "start": 18, "end": 27}
  ],
  [
    {"surah": 23, "start": 28, "end": 42}
  ],
  [
    {"surah": 23, "start": 43, "end": 59}
  ],
  [
    {"surah": 23, "start": 60, "end": 74}
  ],
  [
    {"surah": 23, "start": 75, "end": 89}
  ],
  [
    {"surah": 23, "start": 90, "end": 104}
  ],
  [
    {"surah": 23, "start": 105, "end": 118}
  ],
  [
    {"surah": 24, "start": 1, "end": 10}
  ],
  [
    {"surah": 24, "start": 11, "end": 20}
  ],
  [
    {"surah": 24, "start": 21, "end": 27}
  ],
  [
    {"surah": 24, "start": 28, "end": 31}
  ],
  [
    {"surah": 24, "start": 32, "end": 36, "hB": true} // النور 35 تشبيه النور بالمشكاة
  ],
  [
    {"surah": 24, "start": 37, "end": 43, "hB": true} // النور 39 تشبيه أعمال الكفار بسراب، 40 تشبيه بالظلمات، 43 تشبيه السحب بالجبال
  ],
  [
    {"surah": 24, "start": 44, "end": 53}
  ],
  [
    {"surah": 24, "start": 54, "end": 58}
  ],
  [
    {"surah": 24, "start": 59, "end": 61}
  ],
  [
    {"surah": 24, "start": 62, "end": 64},
    {"surah": 25, "start": 1, "end": 2}
  ],
  [
    {"surah": 25, "start": 3, "end": 11}
  ],
  [
    {"surah": 25, "start": 12, "end": 20}
  ],
  [
    {"surah": 25, "start": 21, "end": 32}
  ],
  [
    {"surah": 25, "start": 33, "end": 43, "hB": true} // الفرقان 43 استعارة
  ],
  [
    {"surah": 25, "start": 44, "end": 55, "hB": true} // الفرقان 44 تشبيه بالأنعام، 45 استعارة ظل الشمس، 48 استعارة الرياح بشراً
  ],
  [
    {"surah": 25, "start": 56, "end": 67}
  ],
  [
    {"surah": 25, "start": 68, "end": 77}
  ],
  [
    {"surah": 26, "start": 1, "end": 19}
  ],
  [
    {"surah": 26, "start": 20, "end": 39}
  ],
  [
    {"surah": 26, "start": 40, "end": 60, "hB": true} // الشعراء 44 استعارة
  ],
  [
    {"surah": 26, "start": 61, "end": 83, "hB": true} // الشعراء 63 تشبيه فلق البحر بالجبل
  ],
  [
    {"surah": 26, "start": 84, "end": 111}
  ],
  [
    {"surah": 26, "start": 112, "end": 136}
  ],
  [
    {"surah": 26, "start": 137, "end": 159}
  ],
  [
    {"surah": 26, "start": 160, "end": 183}
  ],
  [
    {"surah": 26, "start": 184, "end": 206}
  ],
  [
    {"surah": 26, "start": 207, "end": 227, "hB": true} // الشعراء 225 تشبيه الشعراء
  ],
  [
    {"surah": 27, "start": 1, "end": 13}
  ],
  [
    {"surah": 27, "start": 14, "end": 22}
  ],
  [
    {"surah": 27, "start": 23, "end": 35}
  ],
  [
    {"surah": 27, "start": 36, "end": 44, "hB": true} // النمل 44 تشبيه القصر باللجة
  ],
  [
    {"surah": 27, "start": 45, "end": 55}
  ],
  [
    {"surah": 27, "start": 56, "end": 63}
  ],
  [
    {"surah": 27, "start": 64, "end": 76}
  ],
  [
    {"surah": 27, "start": 77, "end": 88, "hB": true} // النمل 88 تشبيه الجبال بالسحاب
  ],
  [
    {"surah": 27, "start": 89, "end": 93},
    {"surah": 28, "start": 1, "end": 5}
  ],
  [
    {"surah": 28, "start": 6, "end": 13}
  ],
  [
    {"surah": 28, "start": 14, "end": 21}
  ],
  [
    {"surah": 28, "start": 22, "end": 28}
  ],
  [
    {"surah": 28, "start": 29, "end": 35}
  ],
  [
    {"surah": 28, "start": 36, "end": 43}
  ],
  [
    {"surah": 28, "start": 44, "end": 50}
  ],
  [
    {"surah": 28, "start": 51, "end": 59}
  ],
  [
    {"surah": 28, "start": 60, "end": 70}
  ],
  [
    {"surah": 28, "start": 71, "end": 77}
  ],
  [
    {"surah": 28, "start": 78, "end": 84}
  ],
  [
    {"surah": 28, "start": 85, "end": 88},
    {"surah": 29, "start": 1, "end": 6}
  ],
  [
    {"surah": 29, "start": 7, "end": 14}
  ],
  [
    {"surah": 29, "start": 15, "end": 23}
  ],
  [
    {"surah": 29, "start": 24, "end": 30}
  ],
  [
    {"surah": 29, "start": 31, "end": 38}
  ],
  [
    {"surah": 29, "start": 39, "end": 45, "hB": true} // العنكبوت 41 تشبيه أعمال الكفار ببيت العنكبوت، 43 استعارة الأمثال
  ],
  [
    {"surah": 29, "start": 46, "end": 52}
  ],
  [
    {"surah": 29, "start": 53, "end": 63}
  ],
  [
    {"surah": 29, "start": 64, "end": 69, "hB": true} // العنكبوت 64 استعارة الحياة الدنيا لهو ولعب
  ],
  [
    {"surah": 30, "start": 6, "end": 15}
  ],
  [
    {"surah": 30, "start": 16, "end": 24}
  ],
  [
    {"surah": 30, "start": 25, "end": 32}
  ],
  [
    {"surah": 30, "start": 33, "end": 41}
  ],
  [
    {"surah": 30, "start": 42, "end": 50, "hB": true} // الروم 50 استعارة (كيف يحيي الأرض بعد موتها)
  ],
  [
    {"surah": 30, "start": 51, "end": 60, "hB": true} // الروم 54 استعارة مراحل الإنسان
  ],
  [
    {"surah": 31, "start": 1, "end": 11}
  ],
  [
    {"surah": 31, "start": 12, "end": 19, "hB": true} // لقمان 19 تشبيه صوت الحمير
  ],
  [
    {"surah": 31, "start": 20, "end": 28, "hB": true} // لقمان 27 تشبيه البحر بالمداد
  ],
  [
    {"surah": 31, "start": 29, "end": 34}
  ],
  [
    {"surah": 32, "start": 1, "end": 11}
  ],
  [
    {"surah": 32, "start": 12, "end": 20}
  ],
  [
    {"surah": 32, "start": 21, "end": 30}
  ],
  [
    {"surah": 33, "start": 1, "end": 6, "hB": true} // الأحزاب 4 استعارة (ما جعل الله لرجل من قلبين)
  ],
  [
    {"surah": 33, "start": 7, "end": 15, "hB": true} // الأحزاب 10 استعارة (بلغت القلوب الحناجر)
  ],
  [
    {"surah": 33, "start": 16, "end": 22, "hB": true} // الأحزاب 19 تشبيه الذي يغشى عليه من الموت
  ],
  [
    {"surah": 33, "start": 23, "end": 30}
  ],
  [
    {"surah": 33, "start": 31, "end": 35}
  ],
  [
    {"surah": 33, "start": 36, "end": 43, "hB": true} // الأحزاب 41 استعارة النور
  ],
  [
    {"surah": 33, "start": 44, "end": 50, "hB": true} // الأحزاب 46 استعارة سراجاً منيراً
  ],
  [
    {"surah": 33, "start": 51, "end": 54}
  ],
  [
    {"surah": 33, "start": 55, "end": 62}
  ],
  [
    {"surah": 33, "start": 63, "end": 73, "hB": true} // الأحزاب 72 استعارة عرض الأمانة
  ],
  [
    {"surah": 34, "start": 1, "end": 7}
  ],
  [
    {"surah": 34, "start": 8, "end": 14}
  ],
  [
    {"surah": 34, "start": 15, "end": 22, "hB": true} // سبأ 16 استعارة أكل خمط، 19 استعارة ومزقناهم كل ممزق
  ],
  [
    {"surah": 34, "start": 23, "end": 31}
  ],
  [
    {"surah": 34, "start": 32, "end": 39}
  ],
  [
    {"surah": 34, "start": 40, "end": 48}
  ],
  [
    {"surah": 34, "start": 49, "end": 54},
    {"surah": 35, "start": 1, "end": 3}
  ],
  [
    {"surah": 35, "start": 4, "end": 11}
  ],
  [
    {"surah": 35, "start": 12, "end": 18, "hB": true} // فاطر 12 تشبيه البحرين، 13 استعارة يولج الليل
  ],
  [
    {"surah": 35, "start": 19, "end": 30, "hB": true} // فاطر 19-22 تشبيهات الأعمى والبصير، الظلمات والنور، الأحياء والأموات
  ],
  [
    {"surah": 35, "start": 31, "end": 38}
  ],
  [
    {"surah": 35, "start": 39, "end": 44}
  ],
  [
    {"surah": 35, "start": 45, "end": 45},
    {"surah": 36, "start": 1, "end": 12, "hB": true} // يس 8 استعارة الأغلال، 9 استعارة السد
  ],
  [
    {"surah": 36, "start": 13, "end": 27, "hB": true} // يس 13 تشبيه أصحاب القرية
  ],
  [
    {"surah": 36, "start": 28, "end": 40, "hB": true} // يس 30 استعارة، 37 استعارة نسلخ منه النهار، 39 تشبيه القمر بالعرجون القديم
  ],
  [
    {"surah": 36, "start": 41, "end": 54}
  ],
  [
    {"surah": 36, "start": 55, "end": 70}
  ],
  [
    {"surah": 36, "start": 71, "end": 83}
  ],
  [
    {"surah": 37, "start": 1, "end": 24}
  ],
  [
    {"surah": 37, "start": 25, "end": 51, "hB": true} // الصافات 49 تشبيه كأنهن بيض مكنون
  ],
  [
    {"surah": 37, "start": 52, "end": 76, "hB": true} // الصافات 65 تشبيه طلع شجرة الزقوم برؤوس الشياطين
  ],
  [
    {"surah": 37, "start": 77, "end": 102}
  ],
  [
    {"surah": 37, "start": 103, "end": 126}
  ],
  [
    {"surah": 37, "start": 127, "end": 153}
  ],
  [
    {"surah": 37, "start": 154, "end": 182}
  ],
  [
    {"surah": 38, "start": 1, "end": 16}
  ],
  [
    {"surah": 38, "start": 17, "end": 26}
  ],
  [
    {"surah": 38, "start": 27, "end": 42}
  ],
  [
    {"surah": 38, "start": 43, "end": 61}
  ],
  [
    {"surah": 38, "start": 62, "end": 83}
  ],
  [
    {"surah": 38, "start": 84, "end": 88},
    {"surah": 39, "start": 1, "end": 5, "hB": true} // الزمر 5 استعارة يكور الليل على النهار
  ],
  [
    {"surah": 39, "start": 6, "end": 10}
  ],
  [
    {"surah": 39, "start": 11, "end": 21}
  ],
  [
    {"surah": 39, "start": 22, "end": 31, "hB": true} // الزمر 23 تشبيه الكتاب، 29 تشبيه الرجل فيه شركاء
  ],
  [
    {"surah": 39, "start": 32, "end": 40}
  ],
  [
    {"surah": 39, "start": 41, "end": 47}
  ],
  [
    {"surah": 39, "start": 48, "end": 56}
  ],
  [
    {"surah": 39, "start": 57, "end": 67}
  ],
  [
    {"surah": 39, "start": 68, "end": 74}
  ],
  [
    {"surah": 39, "start": 75, "end": 75},
    {"surah": 40, "start": 1, "end": 7}
  ],
  [
    {"surah": 40, "start": 8, "end": 16}
  ],
  [
    {"surah": 40, "start": 17, "end": 25}
  ],
  [
    {"surah": 40, "start": 26, "end": 33}
  ],
  [
    {"surah": 40, "start": 34, "end": 40}
  ],
  [
    {"surah": 40, "start": 41, "end": 49}
  ],
  [
    {"surah": 40, "start": 50, "end": 58}
  ],
  [
    {"surah": 40, "start": 59, "end": 66}
  ],
  [
    {"surah": 40, "start": 67, "end": 77}
  ],
  [
    {"surah": 40, "start": 78, "end": 85}
  ],
  [
    {"surah": 41, "start": 1, "end": 11, "hB": true} // فصلت 5 استعارة أكنة، وقر، حجاب
  ],
  [
    {"surah": 41, "start": 12, "end": 20, "hB": true} // فصلت 17 استعارة صاعقة العذاب الهون
  ],
  [
    {"surah": 41, "start": 21, "end": 29}
  ],
  [
    {"surah": 41, "start": 30, "end": 38}
  ],
  [
    {"surah": 41, "start": 39, "end": 46, "hB": true} // فصلت 39 استعارة الأرض خاشعة
  ],
  [
    {"surah": 41, "start": 47, "end": 54}
  ],
  [
    {"surah": 42, "start": 1, "end": 10}
  ],
  [
    {"surah": 42, "start": 11, "end": 15, "hB": true} // الشورى 11 استعارة (فاطر السماوات والأرض)
  ],
  [
    {"surah": 42, "start": 16, "end": 22}
  ],
  [
    {"surah": 42, "start": 23, "end": 31}
  ],
  [
    {"surah": 42, "start": 32, "end": 44, "hB": true} // الشورى 32 تشبيه الجواري كالأعلام
  ],
  [
    {"surah": 42, "start": 45, "end": 51, "hB": true} // الشورى 51 استعارة حجاب
  ],
  [
    {"surah": 42, "start": 52, "end": 53},
    {"surah": 43, "start": 1, "end": 10, "hB": true} // الشورى 52 استعارة الروح والنور
  ],
  [
    {"surah": 43, "start": 11, "end": 22}
  ],
  [
    {"surah": 43, "start": 23, "end": 33}
  ],
  [
    {"surah": 43, "start": 34, "end": 47}
  ],
  [
    {"surah": 43, "start": 48, "end": 60}
  ],
  [
    {"surah": 43, "start": 61, "end": 73}
  ],
  [
    {"surah": 43, "start": 74, "end": 89}
  ],
  [
    {"surah": 44, "start": 1, "end": 18, "hB": true} // الدخان 10 استعارة دخان مبين
  ],
  [
    {"surah": 44, "start": 19, "end": 39, "hB": true} // الدخان 29 استعارة فما بكت عليهم السماء
  ],
  [
    {"surah": 44, "start": 40, "end": 59, "hB": true} // الدخان 45 تشبيه المهل يغلي في البطون
  ],
  [
    {"surah": 45, "start": 1, "end": 13}
  ],
  [
    {"surah": 45, "start": 14, "end": 22, "hB": true} // الجاثية 21 استعارة سواء محياهم ومماتهم
  ],
  [
    {"surah": 45, "start": 23, "end": 32, "hB": true} // الجاثية 23 استعارة ختم على سمعه وقلبه
  ],
  [
    {"surah": 45, "start": 33, "end": 37},
    {"surah": 46, "start": 1, "end": 5}
  ],
  [
    {"surah": 46, "start": 6, "end": 14}
  ],
  [
    {"surah": 46, "start": 15, "end": 20}
  ],
  [
    {"surah": 46, "start": 21, "end": 28, "hB": true} // الأحقاف 24 استعارة عارضاً مستقبلاً
  ],
  [
    {"surah": 46, "start": 29, "end": 35, "hB": true} // الأحقاف 35 تشبيه كأنهم يوم يرون ما يوعدون
  ],
  [
    {"surah": 47, "start": 1, "end": 11, "hB": true} // محمد 1 استعارة أضل أعمالهم
  ],
  [
    {"surah": 47, "start": 12, "end": 19, "hB": true} // محمد 12 تشبيه الأنعام، 15 تشبيه الجنة
  ],
  [
    {"surah": 47, "start": 20, "end": 29, "hB": true} // محمد 20 تشبيه الموت، 24 استعارة أقفال القلوب
  ],
  [
    {"surah": 47, "start": 30, "end": 38}
  ],
  [
    {"surah": 48, "start": 1, "end": 9, "hB": true} // الفتح 1 استعارة فتحاً مبيناً
  ],
  [
    {"surah": 48, "start": 10, "end": 15, "hB": true} // الفتح 10 استعارة يد الله فوق أيديهم
  ],
  [
    {"surah": 48, "start": 16, "end": 23}
  ],
  [
    {"surah": 48, "start": 24, "end": 28}
  ],
  [
    {"surah": 48, "start": 29, "end": 29, "hB": true} // الفتح 29 تشبيه الزرع
  ],
  [
    {"surah": 49, "start": 5, "end": 11}
  ],
  [
    {"surah": 49, "start": 12, "end": 18, "hB": true} // الحجرات 12 تشبيه أكل لحم الأخ ميتاً
  ],
  [
    {"surah": 50, "start": 1, "end": 15, "hB": true} // ق 11 استعارة وأحيينا به بلدة ميتاً
  ],
  [
    {"surah": 50, "start": 16, "end": 35, "hB": true} // ق 19 استعارة سكرة الموت، 22 استعارة كشف الغطاء
  ],
  [
    {"surah": 50, "start": 36, "end": 45}
  ],
  [
    {"surah": 51, "start": 7, "end": 30}
  ],
  [
    {"surah": 51, "start": 31, "end": 51}
  ],
  [
    {"surah": 51, "start": 52, "end": 60},
    {"surah": 52, "start": 1, "end": 14, "hB": true} // الطور 9 استعارة تمور السماء
  ],
  [
    {"surah": 52, "start": 15, "end": 31, "hB": true} // الطور 24 تشبيه لؤلؤ مكنون
  ],
  [
    {"surah": 52, "start": 32, "end": 49}
  ],
  [
    {"surah": 53, "start": 1, "end": 26, "hB": true} // النجم 1 استعارة النجم إذا هوى
  ],
  [
    {"surah": 53, "start": 27, "end": 44}
  ],
  [
    {"surah": 53, "start": 45, "end": 62},
    {"surah": 54, "start": 1, "end": 6, "hB": true} // القمر 1 استعارة انشقاق القمر
  ],
  [
    {"surah": 54, "start": 7, "end": 27, "hB": true} // القمر 7 تشبيه الجراد المنتشر، 13 استعارة ذات ألواح ودسر، 20 تشبيه أعجاز نخل منقعر
  ],
  [
    {"surah": 54, "start": 28, "end": 49, "hB": true} // القمر 31 تشبيه بهشيم المحتظر
  ],
  [
    {"surah": 54, "start": 50, "end": 55},
    {"surah": 55, "start": 1, "end": 18}
  ],
  [
    {"surah": 55, "start": 19, "end": 41, "hB": true} // الرحمن 24 تشبيه الجوار كالأعلام، 37 تشبيه الوردة كالدهان
  ],
  [
    {"surah": 55, "start": 42, "end": 69, "hB": true} // الرحمن 58 تشبيه الياقوت والمرجان
  ],
  [
    {"surah": 55, "start": 70, "end": 78},
    {"surah": 56, "start": 1, "end": 16, "hB": true} // الواقعة 6 تشبيه الهباء المنبث
  ],
  [
    {"surah": 56, "start": 17, "end": 50, "hB": true} // الواقعة 22، 23 تشبيه لؤلؤ مكنون
  ],
  [
    {"surah": 56, "start": 51, "end": 76, "hB": true} // الواقعة 55 تشبيه شرب الهيم
  ],
  [
    {"surah": 56, "start": 77, "end": 96}
  ],
  [
    {"surah": 57, "start": 4, "end": 11, "hB": true} // الحديد 9 استعارة النور والظلمات
  ],
  [
    {"surah": 57, "start": 12, "end": 18, "hB": true} // الحديد 12، 13 استعارات النور، 16 استعارة قسوة القلوب
  ],
  [
    {"surah": 57, "start": 19, "end": 24, "hB": true} // الحديد 20 تشبيه الحياة الدنيا بماء
  ],
  [
    {"surah": 57, "start": 25, "end": 29, "hB": true} // الحديد 28 استعارة النور
  ],
  [
    {"surah": 58, "start": 1, "end": 6}
  ],
  [
    {"surah": 58, "start": 7, "end": 11}
  ],
  [
    {"surah": 58, "start": 12, "end": 21}
  ],
  [
    {"surah": 58, "start": 22, "end": 22},
    {"surah": 59, "start": 1, "end": 3}
  ],
  [
    {"surah": 59, "start": 4, "end": 9}
  ],
  [
    {"surah": 59, "start": 10, "end": 16, "hB": true} // الحشر 14 استعارة بأسهم بينهم شديد
  ],
  [
    {"surah": 59, "start": 17, "end": 24, "hB": true} // الحشر 21 تشبيه الجبل الخاشع
  ],
  [
    {"surah": 60, "start": 1, "end": 5}
  ],
  [
    {"surah": 60, "start": 6, "end": 11}
  ],
  [
    {"surah": 60, "start": 12, "end": 13},
    {"surah": 61, "start": 1, "end": 5}
  ],
  [
    {"surah": 61, "start": 6, "end": 14, "hB": true} // الصف 4 تشبيه البنيان المرصوص، 8 استعارة نور الله
  ],
  [
    {"surah": 62, "start": 1, "end": 8, "hB": true} // الجمعة 5 تشبيه الحمار يحمل أسفاراً
  ],
  [
    {"surah": 62, "start": 9, "end": 11},
    {"surah": 63, "start": 1, "end": 4, "hB": true} // المنافقون 4 تشبيه الخشب المسندة
  ],
  [
    {"surah": 63, "start": 5, "end": 11}
  ],
  [
    {"surah": 64, "start": 1, "end": 9}
  ],
  [
    {"surah": 64, "start": 10, "end": 18}
  ],
  [
    {"surah": 65, "start": 1, "end": 5}
  ],
  [
    {"surah": 65, "start": 6, "end": 12}
  ],
  [
    {"surah": 66, "start": 1, "end": 7}
  ],
  [
    {"surah": 66, "start": 8, "end": 12, "hB": true} // التحريم 8 استعارة النور
  ],
  [
    {"surah": 67, "start": 1, "end": 12, "hB": true} // الملك 10 استعارة
  ],
  [
    {"surah": 67, "start": 13, "end": 26, "hB": true} // الملك 22 تشبيه من يمشي مكباً على وجهه
  ],
  [
    {"surah": 67, "start": 27, "end": 30},
    {"surah": 68, "start": 1, "end": 16, "hB": true} // القلم 16 استعارة سنسمه على الخرطوم
  ],
  [
    {"surah": 68, "start": 17, "end": 42, "hB": true} // القلم 20 تشبيه كالصريم، 42 استعارة يكشف عن ساق
  ],
  [
    {"surah": 68, "start": 43, "end": 52, "hB": true} // القلم 44 استعارة سنستدرجهم من حيث لا يعلمون
  ],
  [
    {"surah": 69, "start": 9, "end": 35, "hB": true} // الحاقة 23 استعارة قطوفها دانية
  ],
  [
    {"surah": 69, "start": 36, "end": 52}
  ],
  [
    {"surah": 70, "start": 11, "end": 40}
  ],
  [
    {"surah": 70, "start": 41, "end": 44, "hB": true} // المعارج 43 تشبيه إلى نصب يوفضون
  ],
  [
    {"surah": 71, "start": 11, "end": 28, "hB": true} // نوح 17 تشبيه إنبات الإنسان من الأرض
  ],
  [
    {"surah": 72, "start": 1, "end": 13}
  ],
  [
    {"surah": 72, "start": 14, "end": 28}
  ],
  [
    {"surah": 73, "start": 1, "end": 19, "hB": true} // المزمل 14 تشبيه الجبال كثيباً مهيلاً
  ],
  [
    {"surah": 73, "start": 20, "end": 20},
    {"surah": 74, "start": 1, "end": 18, "hB": true} // المدثر 8 استعارة نقر في الناقور
  ],
  [
    {"surah": 74, "start": 19, "end": 47, "hB": true} // المدثر 32 استعارة والقمر، والليل، والصبح
  ],
  [
    {"surah": 74, "start": 48, "end": 56, "hB": true} // المدثر 50 تشبيه حمر مستنفرة
  ],
  [
    {"surah": 75, "start": 20, "end": 40}
  ],
  [
    {"surah": 76, "start": 6, "end": 25, "hB": true} // الإنسان 19 تشبيه لؤلؤ منثور
  ],
  [
    {"surah": 76, "start": 26, "end": 31},
    {"surah": 77, "start": 1, "end": 19, "hB": true} // المرسلات 10 استعارة نسفت الجبال
  ],
  [
    {"surah": 77, "start": 20, "end": 50, "hB": true} // المرسلات 32، 33 تشبيه القصر والجمالات الصفر
  ],
  [
    {"surah": 78, "start": 1, "end": 30, "hB": true} // النبأ 6، 7 تشبيه الأرض مهاد والجبال أوتاد
  ],
  [
    {"surah": 78, "start": 31, "end": 40, "hB": true} // النبأ 33 تشبيه وكواعب أتراباً
  ],
  [
    {"surah": 79, "start": 17, "end": 46}
  ],
  [
    {"surah": 80, "start": 1, "end": 40}
  ],
  [    {"surah": 80, "start": 41, "end": 42}
    ,
    {"surah": 81, "start": 1, "end": 29, "hB": true} // التكوير 17، 18 استعارة الليل والصبح
  ],
  [
    {"surah": 82, "start": 1, "end": 19},
    {"surah": 83, "start": 1, "end": 4, "hB": true} // المطففين 4 استعارة مبعوثون
  ],
  [
    {"surah": 83, "start": 5, "end": 33, "hB": true} // المطففين 14 استعارة ران على قلوبهم
  ],
  [
    {"surah": 83, "start": 34, "end": 36},
    {"surah": 84, "start": 1, "end": 24, "hB": true} // الانشقاق 1-4 استعارات السماء والأرض
  ],
  [    {"surah": 84, "start": 25, "end": 25}
    ,
    {"surah": 85, "start": 1, "end": 22}
  ],
  [
    {"surah": 86, "start": 1, "end": 17},
    {"surah": 87, "start": 1, "end": 10, "hB": true} // الأعلى 4، 5 تشبيه غثاء أحوى
  ],
  [
    {"surah": 87, "start": 11, "end": 19},
    {"surah": 88, "start": 1, "end": 22}
  ],
  [    {"surah": 88, "start": 23, "end": 26}
    ,
    {"surah": 89, "start": 1, "end": 22}
  ],
  [
    {"surah": 89, "start": 23, "end": 30}
  ],
  [    {"surah": 90, "start": 19, "end": 20}
    ,
    {"surah": 91, "start": 1, "end": 15, "hB": true} // الشمس 1-4 استعارات الشمس والقمر والنهار والليل
  ],
  [
    {"surah": 92, "start": 1, "end": 9},
    {"surah": 93, "start": 1, "end": 11},
    {"surah": 94, "start": 1, "end": 2, "hB": true} // الشرح 2 استعارة وضعنا عنك وزرك
  ],
  [    {"surah": 94, "start": 3, "end": 8}
    ,
    {"surah": 95, "start": 1, "end": 8},
    {"surah": 96, "start": 1, "end": 12, "hB": true} // العلق 15 استعارة لنسفعاً بالناصية
  ],
  [    {"surah": 96, "start": 13, "end": 19},

    {"surah": 97, "start": 1, "end": 5},
    {"surah": 98, "start": 1, "end": 5}
  ],
  [    {"surah": 98, "start": 6, "end": 8},

    {"surah": 99, "start": 1, "end": 8},
    {"surah": 100, "start": 1, "end": 5, "hB": true} // العاديات 1-5 استعارات الخيل
  ],
  [    {"surah": 100, "start": 6, "end": 11}
    ,
    {"surah": 101, "start": 1, "end": 11, "hB": true}, // القارعة 4، 5 تشبيه الفراش المبثوث والعهن المنفوش
    {"surah": 102, "start": 1, "end": 8}
  ],
  [
    {"surah": 103, "start": 1, "end": 3},
    {"surah": 104, "start": 1, "end": 9},
    {"surah": 105, "start": 1, "end": 5, "hB": true} // الفيل 5 تشبيه كعصف مأكول
  ],
  [
    {"surah": 106, "start": 1, "end": 4},
    {"surah": 107, "start": 1, "end": 7},
    {"surah": 108, "start": 1, "end": 3}
  ],
  [
    {"surah": 109, "start": 1, "end": 6},
    {"surah": 110, "start": 1, "end": 3},
    {"surah": 111, "start": 1, "end": 5}
  ],
  [
    {"surah": 112, "start": 1, "end": 4},
    {"surah": 113, "start": 1, "end": 5},
    {"surah": 114, "start": 1, "end": 6}
  ]
];