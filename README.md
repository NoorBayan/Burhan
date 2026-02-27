
# 📖 Burhan: The QR-Rhetoric Computational Semantic Dataset for Classical Arabic

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Data Format](https://img.shields.io/badge/Format-JSON-blue)](https://www.json.org/)
[![Language](https://img.shields.io/badge/Language-Classical%20Arabic-green)]()
[![Status](https://img.shields.io/badge/Status-Under%20Peer%20Review-orange)]()

---

### 👋 Introduction

Welcome to **Burhan** (برهان), the official repository hosting the **QR-Rhetoric** dataset. 

Figurative language—specifically metaphor and simile—introduces semantic non-compositionality that vector-based NLP models struggle to process. To bridge this "semantic gap" in Arabic NLP, we introduce a constraint-based engineering framework designed to formalize classical Arabic rhetorical semantics for machine processing.

Extracted from the highly stable and orthographically consistent Quranic corpus, this dataset provides 1,367 rigorously annotated instances (402 similes, 965 metaphors) structured as Composite Semantic Objects (CSOs). By mapping concrete Source Domains to abstract Target Domains and encoding pragmatic functions alongside cognitive processing effort, this resource establishes a foundational semantic infrastructure for Explainable AI (XAI), Knowledge Graph (KG) integration, and Neurosymbolic reasoning in Arabic NLP.

---

### 🏛️ Architectural Framework & Schema

Unlike flat, binary-labeled datasets (e.g., Metaphor vs. Literal), this dataset is governed by a strict, constraint-aware **JSON Schema**. It operationalizes figurative analysis through four interlocked dimensions:

1.  **Ontological Grounding:** Explicit $Source \rightarrow Target$ conceptual domain mappings utilizing a controlled 23$\times$18 ontology matrix.
2.  **Structural Components:** Span-level character offsets anchoring Tenor, Vehicle, Ground, and rhetorical tools to the canonical text.
3.  **Pragmatic Force:** Enum-restricted speech-act taxonomy (e.g., *Directive*, *Assertive*) coupling grammatical form with communicative intent.
4.  **Cognitive Complexity:** An operationalized ordinal variable (`processing_effort`) derived from structural density to guide curriculum learning.

---


### 🧪 Reproducibility & Research Data

In strict adherence to Open Science and FAIR data principles, we provide the raw data alongside the schema specifications and analytical scripts required for full reproducibility of the statistics reported in the study.

- 📦 **Dataset Availability:** The complete JSON corpus is hosted in the `data/` directory of this repository.
- 📜 **Schema Definition:** The formal JSON Schema validator (`schema.json`) is provided to ensure strict data typing and relational integrity.
- 📊 **Exploratory Data Analysis (EDA):** We provide an interactive environment to explore the dataset's structural dimensions, including the distribution of cognitive effort, the form-function mappings, and the semantic ontology matrices.

To facilitate peer review and independent verification of the corpus statistics (e.g., the prevalence of verbal structures in metaphors vs. particle-driven similes), we have published a comprehensive **Jupyter Notebook** hosted on Google Colab.

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1oFBLq1i1ZkPQAMJMAXxJGyxtsdKJWp_n?usp=sharing)


---


---

### 🕌 Ethical Usage & Corpus Integrity

The Holy Quran is a sacred text held in reverence by billions. The Quranic corpus was selected for this data engineering task due to its maximal linguistic consistency and orthographic stability, providing a noise-reduced environment for NLP benchmarking. We request all researchers utilizing this repository to adhere to the following guidelines:

1.  **Textual Integrity:** Ensure that the Uthmani script and diacritics (*Tashkeel*) of the text segments remain unaltered in any preprocessing pipeline.
2.  **Contextual Accuracy:** Algorithmic inferences should not be presented as definitive theological exegesis, but rather as computational linguistic models grounded in classical rhetorical taxonomy.
3.  **Respectful Representation:** Maintain an academic and respectful tone when publishing visualizations or downstream applications derived from this dataset.

---


### 🗂️ Data Structure & Schema Specifications

The dataset represents figurative language as deeply nested **Composite Semantic Objects (CSOs)**. Each record in the JSON file adheres to a strict schema, ensuring deterministic validation and machine-readability. 

The data is logically divided into Metadata, Literary Preamble, and the Core Rhetorical Analysis (which accommodates both Similes and Metaphors). Below is an overview of the schema fields and the **Controlled Vocabularies** enforced across the dataset.

#### 1. Core Record Structure
Every entry in the corpus follows this root architecture:
- `record_id` (Integer): Unique identifier for the instance.
- `metadata` (Object): Contains canonical alignment including `chapter_no`, `verse_no`, `ayah_text_uthmani`, and a `has_simile` boolean flag.
- `literary_preamble` (Object): Optional contextual strings (`intro_text`, `conclusion_text`).
- `rhetorical_analysis` (Array of Objects): The primary analytical engine containing structural, conceptual, syntactic, and pragmatic layers.

#### 2. The Rhetorical Object (CSO Layers)
Within `rhetorical_analysis`, each figurative device (Simile or Metaphor) is parsed into the following constrained dimensions:

**A. Identity & Classification**
- `segment_text`: The exact text span where the figurative language occurs.
- `main_type`: The classical Arabic rhetorical classification (e.g., *Isti'ara Tasrihiyya*, *Tashbih Mursal*).
- `processing_effort`: Derived cognitive complexity score.
  - *Allowed Values:* `Low`, `Medium`, `High`.

**B. Semantic Components & Ontological Mapping**
This layer explicitly maps the cross-domain transfer.
- `subject` / `image`: The Tenor (Moshabbah) and Vehicle (Moshabbah Bih).
- `point_of_similarity`: The conceptual overlap (Ground).
- `tool` / `borrowed_text`: The explicit particle (Simile) or the borrowed word (Metaphor).
- `sensory_mode`: The perceptual channel of the image.
  - *Allowed Values:* `visual`, `auditory`, `tactile`, `kinetic`, `gustatory`, `abstract_cognitive`, `composite`.
- `source_domain` & `target_domain`: Explicit mapping matrix.
  - *Target Domains:* `SPIRITUAL_PSYCHOLOGY`, `DEEDS_AND_BEHAVIOR`, `ESCHATOLOGY`, `THEOLOGY`, `REVELATION_AND_GUIDANCE`, `COSMOLOGY_AND_NATURE`, `HUMAN_AGENTS_AND_GROUPS`, `WORLDLY_LIFE`.
  - *Source Domains:* Drawn from a 23-domain inventory including `BODY_AND_PHYSIOLOGY`, `HISTORY_AND_TRADITION`, `NATURE_FLORA`, `TRAVEL_AND_PATH`, `WAR_AND_CONFLICT`, etc.

**C. Morphosyntactic Realization**
- `grammatical_position`: The functional syntax role in the sentence.
- `grammatical_structure`: The broader syntactic configuration.
  - *Allowed Values:* `verbal_structure`, `nominal_structure`, `adverbial_structure`, `adjectival_structure`, `discourse_structure`.
- *(For Metaphors Only)* `metaphor_linguistic_form`: The precise morphological form of the borrowed text (e.g., `verbal_past`, `nominal_masdar`, `idafa_simple`).

**D. Pragmatic Force & Speech Acts**
This multi-valued array maps grammatical form to communicative intent.
- `pragmatic_function_tag`: The rhetorical purpose.
  - *Allowed Values:* `Clarification & Imagery`, `Condemnation & Criticism`, `Warning & Intimidation`, `Glorification & Exaltation`, `Argumentation & Persuasion`, `Affirmation & Establishment`, `Incentive & Attraction`, `Consolation & Reassurance`.
- `speech_act`: The illocutionary force.
  - *Allowed Values:* `ASSERTIVE`, `DIRECTIVE_DETERRENCE`, `DIRECTIVE_INDUCEMENT`, `EXPRESSIVE_DEPRECATION`, `EXPRESSIVE_EXALTATION`.

**E. Symbolism, Implications & Scholarly Grounding**
- `implicature_strength`: Evaluates the depth of the symbolic inference.
  - *Allowed Values:* `weak_poetic_array`, `moderate_enriched`, `strong_determinate`.
- `comparative_analysis`: Cross-referencing similar structures across the corpus.
- `scholarly_interpretations`: Array of grounded validations from authoritative exegeses (*Tafsir*), capturing the `scholar`, `book`, and `full_text` of the interpretation.



---

### 🤝 Contributing

We welcome contributions from the computational linguistics and semantic web communities! If you find a schema inconsistency or wish to propose an extension to the domain ontology, please open an **Issue** or submit a **Pull Request**. 

