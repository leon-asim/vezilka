****Synthetic Macedonian Dataset (synthpop, R)****

This project generates a synthetic socio-economic dataset in Macedonian using the synthpop package in R.

**Variables**

vozrast – Age (18–65)

pol – Gender (Машки, Женски)

obrazovanie – Education level

grad – City

vrabotuvanje – Employment status

plata – Monthly salary (денари)

klasa – Derived socio-economic class

**Approach**

Rule-based generation of realistic base data

Dependency modeling using a custom predictor matrix

Salary constraints (e.g., unemployed → salary = 0)

Post-processing to enforce logical consistency

Statistical comparison between original and synthetic data

**Why Synthetic Data?**

Preserves statistical properties

Reduces privacy risks

Safe for experimentation and research

**Output**

sinteticki_podatoci_mk.csv (UTF-8 encoded)
