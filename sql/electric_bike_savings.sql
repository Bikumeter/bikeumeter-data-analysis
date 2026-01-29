-- Get savings for commutes done with electric bike --

WITH bikeumeter_electric_activities AS (
    SELECT name, date, public_transport_fare, ride_duration_minutes
    FROM read_csv_auto('data/bikeumeter_commute_activities.csv') AS activities
    WHERE name = 'swapfiets commute'
),

-- 1) Date manipulation
    -- a) Keep only date portion of timestamp
clean_date AS (
    SELECT *,
            CAST(date AS DATE) AS date_only -- strip out the time portion
    FROM bikeumeter_electric_activities
),

-- b) Turn date into month -- monthname(date) function
-- c) Group activities by date
monthly_activities AS (
    SELECT date_part('year', date_only) AS year, date_part('month', date_only) AS month_number, MONTHNAME(date_only) AS month, 
            public_transport_fare, ride_duration_minutes
    FROM clean_date
    ORDER BY date_only -- always order by date not by month name
),
-- remove the € symbol
cleaned_fare_euros AS (
    SELECT year, month_number, month, ride_duration_minutes, 
            REPLACE(public_transport_fare, '€', '') AS cleaned_fare_euros
    FROM monthly_activities
),
-- 2) Public transport fare sum
    -- a) Sum of fare per month
monthly_e_rides AS (
    SELECT  year, month_number, month,
            COUNT(*) AS rides_per_month,
            ROUND(SUM(ride_duration_minutes), 2) AS time_ridden,
            SUM(CAST(cleaned_fare_euros AS INT)) AS saved_money_euros
    FROM cleaned_fare_euros
    GROUP BY year, month_number, month
    ORDER BY year ASC
)

SELECT * FROM monthly_e_rides;