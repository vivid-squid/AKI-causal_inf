# Counterfactual AKI Prediction

This repository provides a framework for predicting Acute Kidney Injury (AKI) using machine learning models. These include Logistic Regression, Random Forest, XGBoost, and Ordinal Logistic Regression, all implemented with data extracted from the MIMIC-III database. The focus is on model interpretability through counterfactual analysis using the DiCE library.

## Table of Contents
- [Setup](#setup)
- [Dependencies](#dependencies)
- [Data Preparation](#data-preparation)
- [Model Training](#model-training)
- [Counterfactual Analysis](#counterfactual-analysis)
- [References](#references)

## Setup

1. Obtain access to the MIMIC-III dataset by following the steps outlined [here](https://medium.com/@awlong20/getting-access-to-mimic-iii-hospital-database-for-data-science-projects-791813feb735).
2. After receiving credentials, download the necessary files from the [PhysioNet website](https://physionet.org/content/mimiciii/1.4/).
3. Clone the MIMIC-III code repository:
    ```bash
    git clone https://github.com/MIT-LCP/mimic-code/
    ```
4. Install PostgreSQL and set up the MIMIC-III database by following this [YouTube tutorial](https://www.youtube.com/watch?v=5rg1p7sg2Qo).
5. Execute the following SQL scripts from the MIMIC-III code repository:
    - `mimic-iii/concepts/echo-data.sql`
    - `mimic-iii/concepts/demographics/icustay_detail.sql`
    - `mimic-iii/concepts/durations/weight-durations.sql`
    - `mimic-iii/concepts/durations/vasopressor-durations.sql`
    - `mimic-iii/concepts/durations/ventilation-durations.sql`
    - `mimic-iii/concepts/fluid-balance/urine-output.sql`
    - `mimic-iii/concepts/organfailure/kdigo-creatinine.sql`
    - `mimic-iii/concepts/organfailure/kdigo-stages-48hr.sql`
    - `mimic-iii/concepts/organfailure/kdigo-stages-7day.sql`
    - `mimic-iii/concepts/organfailure/kdigo-stages.sql`
    - `mimic-iii/concepts/organfailure/kdigo-uo.sql`
6. Run the additional SQL scripts located in the `sql` directory. Ensure to run `extract_data.sql` after all the other scripts.

## Dependencies

The following dependencies are required:
- Python 3.8+
- `torch`, `numpy`, `scikit-learn`, `pandas`
- `captum` (for interpretability with LSTM models)
- `DiCE` (for counterfactual explanations)
- `matplotlib`, `seaborn`

Install them using:
pip install torch numpy scikit-learn pandas captum dice-ml matplotlib seaborn

## Data Preparation

Data is extracted from the MIMIC-III database using the provided SQL scripts. The expected files after extraction are:

`kdigo_stages_measured.csv`: Contains time-series measurements for creatinine and urine output over various intervals.
`icustay_detail-kdigo_stages_measured.csv`: Non-temporal patient demographics, such as age, gender, ethnicity, and admission type.
`labs-kdigo_stages_measured.csv`, `vitals-kdigo_stages_measured.csv`, `vents-vasopressor-sedatives-kdigo_stages_measured.csv`: Contain additional lab results, vitals, and treatments data.

## Model Training

The following machine learning models are implemented for predicting AKI:

`Logistic Regression`: A simple and interpretable binary classification model.
`Random Forest`: An ensemble learning method providing robustness and feature importance.
`XGBoost`: A gradient boosting algorithm for better accuracy and complex relationship handling.
`Ordinal Logistic Regression`: A multi-class classification method used for predicting AKI severity.
The Jupyter notebooks provided in the notebooks directory allow for the training and evaluation of each model.

## Counterfactual Analysis

Counterfactual analysis is used to enhance model interpretability, specifically with DiCE (Diverse Counterfactual Explanations). This helps clinicians understand how minor changes in input features could influence the model's prediction.

### DiCE Integration:

DiCE is used to process models built with either TensorFlow or PyTorch, treating them as black-box classifiers.
Counterfactuals provide actionable insights by indicating minimal changes needed to alter prediction outcomes.
This analysis improves transparency and trust, making causal relationships between features and predictions clearer for clinicians.

## References

This project draws on the following key references for data extraction:

Johnson, A. E. W. et al. MIMIC-III, a freely accessible critical care database. Sci. Data 3:160035. DOI: 10.1038/sdata.2016.35
Vagliano, I., Lvova, O., & Schut, M. C. (2021). Interpretable and Continuous Prediction of Acute Kidney Injury in the Intensive Care. Public Health and Informatics. DOI: 10.3233/SHTI210129
