COPY (
    WITH bikeumeter_activities AS (
            SELECT date, start_city, end_city, public_transport_fare, ride_duration_minutes, distance_mt
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
            SELECT date_part('month', date_only) AS month_number, MONTHNAME(date_only) AS month, 
                    public_transport_fare, ride_duration_minutes, distance_mt
            FROM clean_date
            WHERE date_part('year', date_only) = 2025
            ORDER BY date_only -- always order by date not by month name
        ),

        cleaned_fare_euros AS (
            SELECT month_number, month, ride_duration_minutes, 
                    REPLACE(public_transport_fare, '€', '') AS cleaned_fare_euros, 
                    distance_mt
            FROM monthly_activities
        ),
        -- 2) Public transport fare sum
            -- a) Cummulative sum of fare per month
        monthly_rides AS (
            SELECT  month,
                    COUNT(*) AS rides_per_month,
                    SUM(ride_duration_minutes) AS time_ridden,
                    SUM(distance_mt) AS mts_per_month,
                    SUM(CAST(cleaned_fare_euros AS DECIMAL(10,2))) AS saved_money_euros
            FROM cleaned_fare_euros
            GROUP BY month
        ),

        -- 3) Semester average results
        semester_averages AS (
            SELECT  ROUND(AVG(rides_per_month), 2) AS semester_avg_rides,
                    CAST((AVG(time_ridden) / 60.0) AS DECIMAL(10, 2)) AS semester_avg_hours_ridden, -- no need to round as I am already returning a decimal(10, 2) int
                    CAST((AVG(mts_per_month) / 1000.0) AS DECIMAL(10,2)) AS semester_avg_kms,
                    CAST(ROUND(AVG(saved_money_euros), 2) AS DECIMAL(10,2)) AS semester_avg_saved_money
            FROM monthly_rides
        )

        SELECT semester_avg_rides, semester_avg_hours_ridden, semester_avg_kms,
                CAST(semester_avg_kms / semester_avg_rides AS DECIMAL(10,2)) AS semester_avg_ride_dt_km,
                semester_avg_saved_money
        FROM semester_averages;
)
TO 'results/bike_semester_analysis.csv'
WITH (HEADER, DELIMETER ',');