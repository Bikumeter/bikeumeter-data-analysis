-- 1) create temporary table with the data in the csv files to be able to reuse without having to re import using read_csv_auto
-- 2) I need only one constant from one table and all the data from the other
COPY (
    WITH bikeumeter_activities AS (
        SELECT *, 
            -- a) a scalar subquery is the best for this, no joining
            (
                SELECT total 
                FROM read_csv_auto('data/bikeumeter_bike_costs.csv')
                LIMIT 1
            )  AS bike_cost
        FROM read_csv_auto('data/bikeumeter_activities.csv') AS activities
    ),

    -- 3) get the total which is the amount spent on the bike
        -- a) strip the public_transport_fare of the euro symbol
    cleaned_fare AS (
        SELECT *, 
                REPLACE(public_transport_fare, '€', '') AS cleaned_fare
        FROM bikeumeter_activities
    ),
        -- b) convert it to a numeric value
    numeric_fare AS (
        SELECT *,
                CAST(cleaned_fare AS DECIMAL(10, 2)) AS numeric_fare
        FROM cleaned_fare
    ),
        -- c) convert total to negative value
        -- d) do the cumulative sum
    amortization AS (
        SELECT *,
                SUM(numeric_fare) OVER( ORDER BY date) AS cumulative_sum,
                (bike_cost * -1) + cumulative_sum AS amortization
        FROM numeric_fare
    ),

    initial_date AS (
        SELECT date FROM amortization
        ORDER BY date 
        LIMIT 1
    ),

    break_amortization_threshold AS (
        SELECT date FROM amortization
        WHERE amortization >= 0
        ORDER BY date
        LIMIT 1
    )
    -- 4) get the amount of time it took to amortize it
    SELECT 
        initial_date.date AS start_date,
        break_amortization_threshold.date AS amortized_date,
        EXTRACT(DAY FROM (break_amortization_threshold.date - initial_date.date)) AS days_to_amortize,
        ROUND(days_to_amortize / 30, 2) AS months_to_amortize
    FROM initial_date, break_amortization_threshold
)
TO 'results/bike_amortization_summary.csv'
WITH (HEADER, DELIMETER ',');
