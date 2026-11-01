CREATE TABLE dim_vessels (
    vessel_id VARCHAR(10) PRIMARY KEY,
    vessel_name VARCHAR(50),
    vessel_class VARCHAR(20),
    dwt INT,
    daily_opex INT
);

CREATE TABLE dim_routes (
    route_id VARCHAR(10) PRIMARY KEY,
    origin_region VARCHAR(50),
    destination_region VARCHAR(50),
    distance_nm INT
);

CREATE TABLE fact_market_data (
    date DATE PRIMARY KEY,
    bunker_price_mt NUMERIC(10,2),
    iron_ore_index NUMERIC(10,2),
    baltic_dry_index INT
);

CREATE TABLE fact_voyages (
    voyage_id VARCHAR(20) PRIMARY KEY,
    vessel_id VARCHAR(10) REFERENCES dim_vessels(vessel_id),
    route_id VARCHAR(10) REFERENCES dim_routes(route_id),
    start_date DATE,
    end_date DATE,
    cargo_tonnes INT,
    freight_rate_per_tonne NUMERIC(10,2),
    total_bunker_cost NUMERIC(10,2),
    port_and_canal_costs NUMERIC(10,2)
);