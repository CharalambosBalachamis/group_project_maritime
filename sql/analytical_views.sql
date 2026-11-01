CREATE OR REPLACE VIEW vw_voyage_profitability AS
SELECT 
    v.voyage_id,
    v.start_date,
    v.end_date,
    GREATEST((v.end_date - v.start_date), 1) AS voyage_days,
    
    ves.vessel_name,
    ves.vessel_class,
    ves.daily_opex,
    
    r.origin_region,
    r.destination_region,
    r.distance_nm,
    
    -- Exposing the raw variable here
    v.cargo_tonnes,
    
    (v.cargo_tonnes * v.freight_rate_per_tonne) AS gross_revenue,
    v.total_bunker_cost,
    v.port_and_canal_costs,
    (v.total_bunker_cost + v.port_and_canal_costs) AS total_voyage_costs,
    (ves.daily_opex * GREATEST((v.end_date - v.start_date), 1)) AS total_fixed_costs,
    
    ((v.cargo_tonnes * v.freight_rate_per_tonne) - v.total_bunker_cost - v.port_and_canal_costs - (ves.daily_opex * GREATEST((v.end_date - v.start_date), 1))) AS net_profit,
    ROUND(
        ((v.cargo_tonnes * v.freight_rate_per_tonne) - v.total_bunker_cost - v.port_and_canal_costs) 
        / GREATEST((v.end_date - v.start_date), 1), 
    2) AS tce_per_day

FROM fact_voyages v
JOIN dim_vessels ves ON v.vessel_id = ves.vessel_id
JOIN dim_routes r ON v.route_id = r.route_id;