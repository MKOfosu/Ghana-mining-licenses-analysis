# Ghana Mining Licensing Analysis

## Project Overview

This analysis investigates the licensing trends of the Minerals Commission of Ghana, the regulatory body for the nation's mining sector. Amidst growing public concern regarding "Galamsey" (illegal mining), this project evaluates the legal framework of small-scale mining by examining the volume and nature of licenses granted between 2016 and 2025.

The scope is limited to official licensing data and does not assess the on-the-ground environmental compliance of the licensed entities.

## Credit
[Ghana mining repository](https://ghana.revenuedev.org/license)

## Objectives

1. Quantify the total number of licenses granted by type.
2. Identify the status of current licenses (Active vs. Inactive).
3. Analyze temporal trends with a focus on peak years and months.
4. Evaluate the correlation between licensing frequency and election years.
5. Determine the geographic distribution of mining activities by region and district.
6. Identify the primary minerals extracted under small-scale licenses.

## Technical Framework

* **Data Science:** Python (Pandas, NumPy), R
* **Database Management:** MySQL, SQLAlchemy
* **Business Intelligence:** Power BI

---

## Data Cleaning & Methodology

### 1. Data Cleaning

A significant portion of this project was dedicated to transforming raw, unstructured data into a machine-readable format. The cleaning process involved:

- **Feature Engineering:** The raw data lacked separate columns for administrative boundaries. I parsed the `region` column to create distinct `Region` and `District` features. The date column was also parsed into `day`, `month` and `year` to aid the time series analysis.

- **Structural Standardization:** Applied snake_case naming conventions for the columns and corrected datatype irregularities (converting strings to `datetime` objects) to enable time-series analysis.

- **Integrity Validation:** Identified and removed 3 critical duplicate records and handled missing values by dropping rows that lacked essential licensing metadata.

- **Categorical Normalization:** Cleaned the `license_type` column by extracting the only license_type from the column. The `minerals` column was also cleaned to make the data more consistent.

 **Before & After: Regional Data Transformation**

- **Raw State:** A single string column containing mixed data: `"Western Region \n Tarkwa Nsuaem Municipal"`
- **Cleaned State:** Two distinct, filterable columns: `Region: Western` | `District: Tarkwa Nsuaem`
- **Impact:** This allowed for the first-ever granular heat-mapping of mining activities at the district level in this dataset.

### 2. Technical Challenges

- **String Parsing Complexity:** The primary challenge involved the `region` column, where some licensed entities operated in more than 1 regions. I had to implement robust string manipulation and join logic to ensure entities were accurately mapped to their respective regions without data loss.


### 3. Exploratory Data Analysis

The cleaned data was exported to `.csv format` and subsequently connected to **Power BI**. 
Trends were uncovered using count and distinct count measures to handle the categorical nature of the licensing data.

---

## Key Findings

<p align="center">
  <img src= "Small scale License analysis.png" width="1200"/>
</p>

### Licensing Volume and Status

A total of 589 small-scale licenses have been granted, followed by 443 service licenses and 194 prospecting licenses. Within the small-scale category, **98.5%** of licenses are currently active.

### Temporal Trends and Political Correlation

The analysis revealed a significant increase in licenses granted starting in 2020. Notably:

- **2024** recorded the highest volume with **194** licenses.

- **Peak Months:** December (**132**) and July (**115**) recorded the highest activity.

- **Election Correlation:** There is a discernible spike in licenses granted during the 2020 and 2024 election years, compared to minimal activity in 2016.

### Geographic Distribution

Small-scale mining is concentrated in four primary regions:

- **Western:** 168

- **Ashanti:** 150

- **Eastern:** 101

- **Central:** 99

Regions such as **Bono, Bono East, Greater Accra, and Volta** show no registered small-scale mining activity in the current dataset.

### Mineral Classification

Gold is the predominant mineral (**496 licenses**), followed by Diamonds (**92**).

---

## Recommendations

- **Enhanced Oversight:** The Minerals Commission should implement a rigorous monitoring framework to ensure licensed operators adhere to environmental safety protocols.

- **Regulatory Reform:** Licensing criteria should be updated to include more stringent environmental impact assessments.

---

## Conclusion

Small-scale mining licenses for gold extraction saw a dramatic increase between 2020 and 2024. The correlation between election years and license spikes suggests a need for further investigation into the policy drivers behind these trends.

---

## Contact Information

**Mathias Ofosu**

- **Email:** mathiasofosu2@gmail.com

- **LinkedIn:** [linkedin.com/in/mathias-ofosu](https://linkedin.com/in/mathias-ofosu)

- **GitHub:** [github.com/MKOfosu](https://github.com/MKOfosu)