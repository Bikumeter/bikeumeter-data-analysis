
COPY (
    WITH bikeumeter_activities AS (
        SELECT date, start_city, end_city, public_transport_fare, ride_duration_minutes
        FROM read_csv_auto('data/bikeumeter_activities.csv') AS activities
    ),

    -- 1) Date manipulation
        -- a) Keep only date portion of timestamp
    clean_date AS (
        SELECT *,
                CAST(date AS DATE) AS date_only
        FROM bikeumeter_activities
    ),

    -- b) Turn date into month -- monthname(date) function
    -- c) Group activities by date
    monthly_activities AS (
        SELECT date_part('month', date_only) AS month_number, MONTHNAME(date_only) AS month, public_transport_fare, ride_duration_minutes,
        FROM clean_date
        WHERE date_part('year', date_only) = 2025
        ORDER BY date_only -- always order by date not by month name
    ),

    cleaned_fare_euros AS (
        SELECT month_number, month, ride_duration_minutes, 
                REPLACE(public_transport_fare, '€', '') AS cleaned_fare_euros
        FROM monthly_activities
    ),
    -- 2) Public transport fare sum
        -- a) Cummulative sum of fare per month
    monthly_rides AS (
        SELECT month_number, month,
                COUNT(*) AS rides_per_month,
                SUM(ride_duration_minutes) AS time_ridden,
                SUM(CAST(cleaned_fare_euros AS DECIMAL(10,2))) AS saved_money_euros
        FROM cleaned_fare_euros
        GROUP BY month_number, month
        ORDER BY month_number ASC
    ),

    clean_monthly_rides AS (
        SELECT month_number, month, rides_per_month,
                CAST((time_ridden / 60) AS DECIMAL(10, 2)) AS hours_ridden,
                saved_money_euros
        FROM monthly_rides
    )

    SELECT * FROM clean_monthly_rides;
)
TO 'results/bike_monthly_savings_analysis.csv'
WITH (HEADER, DELIMETER ',');