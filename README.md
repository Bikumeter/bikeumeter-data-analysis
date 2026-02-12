<h1>bikumeter data analysis</h1>
<h3>Analysis of the data gathered from tracking my commutes to calculate the amortization & amortization time</h3>
<p>Stack</p>
<ol>
<li>SQL</li>
<li>DuckDB</li>
  <li>ChatGPT</li>
</ol>

<h2>Amortization</h2>
<img width="857" height="130" alt="image" src="https://github.com/user-attachments/assets/3f89a3e5-a5b8-4704-bff9-0aebc8d1067d" />

<h2>Amortization threshold</h2>
<img width="1030" height="132" alt="image" src="https://github.com/user-attachments/assets/1a2054c6-8520-41a2-99a4-5806d95a8cc8" />

<h2>Monthly saved money</h2>
<img width="833" height="239" alt="image" src="https://github.com/user-attachments/assets/1d81888b-28bb-4ab5-ae15-90bae358e5e9" />

<h2>Semester analysis</h2>
<img width="1251" height="127" alt="image" src="https://github.com/user-attachments/assets/9b999dae-c0ae-488b-ac3f-83b1217cac2e" />

<h2>E-bike analysis</h2>
<img width="1448" height="145" alt="image" src="https://github.com/user-attachments/assets/80283c73-015d-47fe-8d94-a3f446e2bd06" />



<h6>* I had introduced a file with sensitive information. It could be found in all commits. I then ran git-filter-repo to remove this file from the repo and rewrite the commit history so that it could not be found in the entire repo. This is why in most of the previous commits, there is a file missing, but it is called in the SQL queries.</h6>



# Bikeumeter Analysis

This project analyzes bicycle usage versus public transport in 2025, calculating time and money savings and determining how long it takes to amortize the cost of a bike.

## Methodology

### 1. Data Import
- Datasets (`bikeumeter_activities.csv` and `bikeumeter_bike_costs.csv`) were imported using **DuckDB’s `read_csv_auto`**.
- Activities data includes date, start/end city, ride duration, and public transport fare.
- Bike cost data provides a single constant representing the bike’s purchase price.

### 2. Data Cleaning and Preparation
- **Dates:** Extracted the date portion from timestamps and computed months for aggregation.
- **Fare Cleaning:** Removed the `€` symbol from public transport fares and cast values to `DECIMAL(10,2)`.
- **Time Conversion:** Ride durations in minutes were aggregated and converted to hours (`DOUBLE`), since sub-minute precision is unnecessary.

### 3. Aggregation and Calculations
- **Monthly Aggregation:** Calculated total rides, total hours ridden, and total public transport costs saved per month.
- **Semester Averages:** Computed average rides, hours ridden, and money saved for the semester.
- **Amortization Calculation:** 
  - Calculated cumulative savings from using the bike instead of public transport.
  - AMORTIZATION => Subtracted the bike purchase cost to determine when the investment is fully amortized.
  - THRESHOLD => Identified the date and duration (days/months) until amortization.

### 4. Data Types and Precision
- Monetary values are cast to **`DECIMAL(10,2)`** for accurate representation of euros and cents.
- Hours ridden are stored as `DOUBLE`.
- DuckDB may promote aggregated decimals internally (`DECIMAL(38,2)`), but final outputs are rounded or cast consistently.

### 5. Output
- All results are exported to CSV files:
  - `bike_monthly_savings_analysis.csv` - monthly aggregation of rides, time, and money saved.
  - `bike_semester_analysis.csv` - semester averages.
  - `bike_amortization_threshold.csv` - date when the bike cost is fully amortized.
  - `e_bike_savings.csv` - first 2 months of same results but with the electric bike.

