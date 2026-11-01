# Maritime Commercial Analytics: Dry Bulk TCE Forecasting

A data engineering and predictive analytics pipeline designed to forecast Time Charter Equivalent (TCE) rates across Capesize, Panamax, and Supramax asset classes. By integrating simulated historical voyage financials with macro-level market indicators, this project provides a structured framework for evaluating commercial vessel deployment.

### Executive Summary

Standard commercial maritime operations often rely on lagged metrics to price voyages. This architecture addresses this by modeling the mathematical relationship between the Baltic Dry Index (BDI) and vessel-specific profitability. Utilizing an XGBoost regression model trained on synthetic data designed to accurately reflect real-world shipping dynamics, the pipeline estimates daily returns. It enforces strict temporal validation to ensure the forecasts reflect realistic market conditions. The resulting data is written back to a relational warehouse and served through a centralized BI layer for commercial review.

### Technical Architecture

**Relational Data Engineering**
The foundation of the project is a PostgreSQL data warehouse designed to enforce referential integrity. Raw commercial data is ingested into a normalized star schema defined in `sql/schema.sql`. To optimize downstream performance, aggregations and metric calculations are decoupled from the raw data layer using analytical reporting views stored in `sql/analytical_views.sql`. This abstraction reduces the computational load on the business intelligence environment.

**Predictive Pipeline**
The forecasting engine leverages Python and gradient boosted trees to estimate daily profitability. Initial exploratory data analysis utilizing Seaborn explores the elasticity between BDI fluctuations and TCE variance by vessel class. The XGBoost pipeline, located in `scripts/1_freight_rate_forecasting.ipynb`, enforces strict chronological train-test splits following the standard 80-20 machine learning rule. This temporal validation supports out-of-sample reliability, evaluating the model on its ability to forecast future market states rather than interpolating historical noise. Model outputs are then exported back to the `predicted_voyage_financials` table in the PostgreSQL warehouse. Throughout the development cycle, standard engineering etiquette was maintained, including clean Git commit histories, modular script design, and reproducible environment management.

### Commercial Intelligence & Visualization

The Power BI layer translates the predictive backend into actionable reporting, providing a clear reconciliation of model expectations versus market reality.

**Portfolio & Geographic Variance**
The core interface tracks revenue execution across major discharge regions, including China, Europe, and India. It provides a side-by-side reconciliation of Actual TCE versus the model's Predicted TCE, allowing operators to identify regional pricing variations at a glance.

![Geographic Overview](Screenshot%20(18).png)

**Asset-Specific Deep Dives**
Dynamic cross-filtering allows teams to isolate performance by individual vessel classes. Isolating the Capesize fleet, for instance, recalculates the geographic matrix and top-line KPI cards, displaying an Actual TCE of $160.22K against a Predicted TCE of $163.60K.

![Asset Class Filtering](Screenshot%20(19).png)

**Market Cycle Tracking**
Custom temporal DAX measures map macro-level market cycles to identify shifts in freight pricing. This visualization tracks long-term trends, including the peak in average daily TCE during the 2022 trading year prior to the subsequent market correction.

![Market Cycle Trends](Screenshot%20(20).png)

### Repository Map

*   **`dashboard/maritime_commercial_dashboard.pbix`** – Core BI interface and custom DAX measures.
*   **`scripts/1_freight_rate_forecasting.ipynb`** – ML pipeline and statistical diagnostics.
*   **`sql/schema.sql`** – Database initialization and structural definitions.
*   **`sql/analytical_views.sql`** – Pre-aggregated reporting views for the BI layer.
*   **`requirements.txt`** – Python environment dependencies.

### Project Team  
**Nikoletta Moirouli**  
**Ioannis Andronidis**  
**Charalambos Balachamis**  
