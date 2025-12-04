# 📖 Burhan: A Database of Rhetorical Analysis of Similes in the Holy Quran

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Data Format](https://img.shields.io/badge/Format-JSON-blue)](https://www.json.org/)
[![Language](https://img.shields.io/badge/Language-Arabic%20(Diacritized)-green)]()

---

### 👋 About The Project

**Burhan** is a specialized, open-source digital database focused on collecting and documenting the rhetorical analyses of similes (*Tashbih*) found in the Holy Quran. The project aims to provide a rich and reliable academic resource for researchers, students, and anyone interested in Quranic rhetoric (*Balaagha*) and Arabic eloquence.

The name "Burhan" (برهان) was chosen because it means "proof" or "evidence" in Arabic. This project seeks to present the "proofs" of the Quran's rhetorical inimitability (*I'jaz*) by meticulously analyzing one of its most prominent figures of speech: the simile.

### 🎯 Database Contents

The database contains a collection of detailed rhetorical analyses for selected Quranic verses that include various forms of similes. Each analysis adheres to the principles of classical Arabic rhetoric (*Balaagha*) and systematically covers the following aspects:

1.  **Precise classification of the simile type** (e.g., *Mursal*, *Baleegh*, *Dhimni*, *Tamthili*).
2.  **Identification of the simile's components** (the four pillars):
    - The Compared (*Al-Mushabbah*)
    - The Compared-to (*Al-Mushabbah bihi*)
    - The Tool of Comparison (*Adat al-Tashbih*)
    - The Point of Resemblance (*Wajh al-Shabah*)
3.  **The simile's syntactic position** and its impact on the verse's context.
4.  **Explanation of the rhetorical function** and its purpose (e.g., to magnify, horrify, denigrate).
5.  **Analysis of the aesthetic and illustrative effect** within the Quranic context.
6.  **Elucidation of implicit and connotative meanings**, including symbolic or emotional significance.
7.  **Comparison with similar instances** in the Quran, noting any rhetorical differences.
8.  **Presentation of the views of classical scholars** of rhetoric and exegesis (*Mufassirun*), such as Al-Zamakhshari, Ibn Ashur, Al-Razi, and others.

# Quranic Similes Dataset: Structured Rhetorical Analysis


## 📖 Overview

This repository hosts a high-fidelity, structured dataset dedicated to the rhetorical analysis of **Similes (Tashbih)** in the Holy Quran. It transforms complex, unstructured scholarly exegesis into a machine-readable **JSON format**, preserving the full depth of Arabic rhetorical studies.

The dataset is designed to bridge the gap between traditional Islamic sciences and modern Computational Linguistics/NLP, providing a granular breakdown of imagery, syntactic structures, and scholarly interpretations with full Arabic vocalization (Tashkeel).

## ✨ Key Features

- **Strict Schema Compliance:** Data follows a rigorous JSON schema ensuring consistency across all records.
- **Full Vocalization:** All Arabic text (Quranic verses and analysis) utilizes full diacritics (Tashkeel) to ensure linguistic accuracy.
- **Granular Analysis:** Each simile is deconstructed into:
  - **Classification:** Main types (e.g., *Tamthili*, *Mursal*) and sub-types with reasoning.
  - **Components:** Subject (*Mushabbah*), Image (*Mushabbah Bihi*), Tool, and Point of Similarity.
  - **Syntactic Structure:** Grammatical position and its rhetorical effect.
  - **Imagery & Aesthetics:** Analysis of the sensory and psychological impact.
- **Scholarly Insights:** Aggregated interpretations from major exegetes (e.g., Al-Zamakhshari, Ibn Ashur).
- **Comparative Analysis:** Rhetorical comparisons with other Quranic verses.

## 🗂️ Data Structure

The data is organized into a hierarchical JSON structure. Below is a high-level overview of the schema:

| Field | Description |
| :--- | :--- |
| `metadata` | Basic verse information (Chapter, Verse, Uthmani Text). |
| `literary_preamble` | Intro and concluding literary context. |
| `rhetorical_analysis` | The core container for the analysis. |
| ↳ `similes` | Array of similes found in the verse. |
| ↳ `classification` | Hierarchical classification (`main_type` & `types`). |
| ↳ `components` | The four pillars of the simile (Subject, Image, Tool, Point). |
| ↳ `functions` | Rhetorical functions (e.g., Vilification, Clarification). |
| ↳ `scholarly_interpretations` | Quotes and insights from classical scholars. |

## 📝 Sample Record

Here is an example of a processed record (Surah Al-Baqarah, Verse 101), demonstrating the depth of the analysis:

```json
{
  "record_id": 7,
  "metadata": {
    "chapter_no": 2,
    "verse_no": 101,
    "ayah_text_uthmani": "وَلَمَّا جَآءَهُمْ رَسُولٌ مِّنْ عِندِ ٱللَّهِ مُصَدِّقٌ لِّمَا مَعَهُمْ نَبَذَ فَرِيقٌ مِّنَ ٱلَّذِينَ أُوتُوا۟ ٱلْكِتَٰبَ كِتَٰبَ ٱللَّهِ وَرَآءَ ظُهُورِهِمْ كَأَنَّهُمْ لَا يَعْلَمُونَ",
    "has_simile": true
  },
  "rhetorical_analysis": {
    "similes": [
      {
        "id": 1,
        "simile_identity": {
          "segment_text": "كَأَنَّهُمْ لَا يَعْلَمُونَ"
        },
        "classification": {
          "main_type": "تَشْبِيهٌ تَمْثِيلِيٌّ مُرْسَلٌ مُجْمَلٌ",
          "types": [
            {
              "label": "تَشْبِيهٌ تَمْثِيلِيٌّ",
              "reason": "لِأَنَّهُ لَا يَعْمِدُ إِلَى تَشْبِيهِ مُفْرَدٍ بِمُفْرَدٍ، بَلْ يُشَبِّهُ *هَيْئَةً مُرَكَّبَةً* بِهَيْئَةٍ مُرَكَّبَةٍ أُخْرَى..."
            }
          ]
        },
        "components": {
          "tool": "كَأَنَّ",
          "point_of_similarity": "الْهَيْئَةُ الْخَارِجِيَّةُ الدَّالَّةُ عَلَى الْإِعْرَاضِ التَّامِّ وَعَدَمِ الِاكْتِرَاثِ..."
        },
        "functions": [
          {
            "title": "التَّقْبِيحُ (Vilification)",
            "detail": "يَعْمَلُ التَّشْبِيهُ عَلَى تَصْوِيرِ فِعْلِهِمْ فِي أَبْشَعِ صُورَةٍ مُمْكِنَةٍ..."
          }
        ]
      }
    ]
  }
}
