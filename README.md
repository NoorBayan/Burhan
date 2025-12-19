# 📖 Burhan: A Corpus-Pragmatic Dataset of Qur'anic Imagery

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Data Format](https://img.shields.io/badge/Format-JSON-blue)](https://www.json.org/)
[![Language](https://img.shields.io/badge/Language-Arabic%20(Diacritized)-green)]()
[![Status](https://img.shields.io/badge/Status-Under%20Review-orange)]()

---

### 👋 Introduction

**Burhan** is a specialized, open-source annotated corpus focused on the cognitive and pragmatic analysis of figurative language (*Simile/Tashbih* and *Metaphor/Isti'ara*) in the Holy Quran.

The name **"Burhan"** (برهان), meaning "decisive proof" in Arabic, reflects our mission: to provide rigorous, attested evidence of the Qur'an's rhetorical inimitability (*I'jaz*) through the lens of modern linguistics. By bridging classical Arabic rhetoric (*Balāgha*) with contemporary frameworks like **Relevance Theory** and **Conceptual Metaphor Theory**, Burhan aims to be a vital resource for computational linguists, religious scholars, and students alike.

---

### 🧪 Reproducibility & Research Data

To ensure transparency and scientific reproducibility (Open Science), we have provided the raw data alongside the statistical analysis code used to generate the findings in the paper.

- **Dataset Availability:** The full JSON corpus is hosted in this repository.
- **Analysis Notebook:** The statistical results (frequency distributions, form-function mapping, and correlation matrices) cited in the paper can be reproduced using the accompanying Jupyter/Colab Notebook.
  - [**View Analysis Notebook**](#) *(Link to your Google Colab/Cloud file)*

> **Note:** As the paper is currently under review, this data is provided for peer review validation and academic research purposes. The notebook demonstrates how the raw JSON data translates into the pragmatic patterns discussed in the study.

---

### 🕌 Ethical Usage & Sanctity of Text

The Holy Quran is a sacred text held in reverence by billions. While we encourage computational analysis, NLP modeling, and linguistic inquiry, we kindly request all users to adhere to the following ethical guidelines:

1.  **Integrity:** Ensure that the diacritized text of the Verses (*Ayat*) remains unaltered in any display or processing pipeline.
2.  **Contextual Awareness:** Algorithmic interpretations should be cross-referenced with the provided authoritative exegetical notes (*Tafsir*) to avoid misleading conclusions.
3.  **Respectful Representation:** When visualizing data or publishing results, please maintain a tone of respect appropriate to the source material.

---

### ✨ Key Features

- **Multi-Layered Annotation:** Integrates three analytical layers:
  - **Structural:** Morpho-syntactic components (Subject, Image, Tool, Point of Similarity).
  - **Conceptual:** Source and Target domains based on Conceptual Metaphor Theory (CMT).
  - **Pragmatic:** Illocutionary functions (e.g., *Taqrīr*, *Tawbīkh*) and cognitive effects.
- **Strict Schema Compliance:** Data follows a rigorous JSON schema ensuring consistency for machine learning tasks.
- **Full Vocalization:** All Arabic text utilizes full diacritics (*Tashkeel*) to ensure linguistic and prosodic accuracy.
- **Scholarly Grounding:** Annotations are verified against major classical exegeses to ensure hermeneutic validity.

---

### 🗂️ Data Structure & Samples

The corpus is richly annotated. Below are actual samples from the dataset illustrating the depth of analysis for both Similes and Metaphors.

#### 1. Simile Sample (*Tashbih*)
**Context:** Surah Al-Baqarah (2:13) - A complex compound simile analyzing the hypocrites' view of faith.

```json
{
  "record_id": 0,
  "metadata": {
    "chapter_no": 2,
    "verse_no": 13,
    "ayah_text_uthmani": "وَإِذَا قِيلَ لَهُمْ ءَامِنُوا۟ كَمَآ ءَامَنَ ٱلنَّاسُ قَالُوٓا۟ أَنُؤْمِنُ كَمَآ ءَامَنَ ٱلسُّفَهَآءُ...",
    "has_simile": true
  },
  "rhetorical_analysis": {
    "similes": [
      {
        "id": 1,
        "segment_text": "أَنُؤْمِنُ كَمَآ ءَامَنَ ٱلسُّفَهَآءُ",
        "classification": {
          "main_type": "تَشْبِيهٌ تَمْثِيلِيٌّ مُرْسَلٌ",
          "processing_effort": "High",
          "reason": "Simulating a complex state of belief as perceived by them."
        },
        "components": {
          "subject": "Our Hypothetical Faith",
          "image": "The Faith of the Foolish (as they perceive it)",
          "source_domain": "PSYCHOLOGY_AND_EMOTION",
          "target_domain": "SPIRITUAL_PSYCHOLOGY",
          "tool": "Particle Ka-Ma (كَمَا)",
          "point_of_similarity": "The act of believing that leads to loss of worldly interest."
        },
        "syntactic_structure": {
          "grammatical_structure": "verbal_structure",
          "rhetorical_effect": "Focuses on the 'manner' of faith to mock the believers."
        },
        "functions": [
          {
            "title": "Vilification & Mockery",
            "pragmatic_tag": "Condemnation & Criticism",
            "speech_act": "EXPRESSIVE_DEPRECATION",
            "detail": "It exposes their internal arrogance, viewing true faith as stupidity."
          }
        ],
        "symbolism_and_implications": {
          "implicature_strength": "weak_poetic_array",
          "implications": [
            {
              "type": "Inversion of Values",
              "content": "What is actually wisdom (faith) is perceived by them as foolishness."
            }
          ]
        }
      }
    ]
  }
}
```

#### 2. Metaphor Sample (*Isti'ara*)
**Context:** Surah Al-Fatiha (1:6) - The foundational prayer for guidance, showcasing an explicit original metaphor.

```json
{
  "record_id": 1,
  "metadata": {
    "chapter_no": 1,
    "verse_no": 6,
    "ayah_text_uthmani": "ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ",
    "has_simile": false
  },
  "rhetorical_analysis": {
    "similes": [
      {
        "id": 1,
        "segment_text": "ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ",
        "classification": {
          "main_type": "اِسْتِعَارَةٌ تَصْرِيحِيَّةٌ أَصْلِيَّةٌ",
          "processing_effort": "Medium",
          "reason": "The 'True Religion' (Subject) is omitted, and 'The Straight Path' (Image) is explicitly stated."
        },
        "components": {
          "subject": "Islam / The True Religion (Omitted)",
          "image": "The Straight Physical Path",
          "source_domain": "TRAVEL_AND_PATH",
          "target_domain": "REVELATION_AND_GUIDANCE",
          "metaphor_linguistic_form": "nominal_common",
          "relation": "Similarity: Delivering the traveler to the destination safely."
        },
        "syntactic_structure": {
          "grammatical_position": "Second Object of the verb 'Guide'",
          "rhetorical_effect": "Make the 'Path' the ultimate goal of the guidance."
        },
        "functions": [
          {
            "title": "Personification & Clarification",
            "pragmatic_tag": "Clarification & Imagery",
            "speech_act": "ASSERTIVE",
            "detail": "Converting an abstract concept (Truth) into a tangible sensory image (Path)."
          }
        ],
        "imagery_and_aesthetics": {
          "features": [
            {
              "title": "Dynamic Imagery",
              "description": "Depicts faith not as a static state, but as a continuous journey."
            }
          ]
        }
      }
    ]
  }
}
```




---

### 🤝 Contributing

We welcome contributions! If you find a typo or wish to propose an enhanced analysis for a verse, please open an **Issue** or submit a **Pull Request**. Please ensure all contributions cite a valid linguistic or exegetical source.
```
