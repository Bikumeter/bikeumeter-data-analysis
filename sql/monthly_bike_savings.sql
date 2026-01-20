WITH bikeumeter_activities AS (
    SELECT date, start_city, end_city, public_transport_fare, ride_duration_minutes
    FROM read_csv_auto('data/bikeumeter_commute_activities.csv') AS activities
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
-- d) Get the last 6 months
monthly_activities AS (
    SELECT start_city, end_city, public_transport_fare, ride_duration_minutes,
            MONTHNAME(date_only) AS month
    FROM clean_date
    ORDER BY date_only -- always order by date not by month name
)


SELECT * FROM monthly_activities;
-- 2) Public transport fare sum
    -- a) Cummulative sum of fare per month
    -- b) Get average from this
    -- c) Calculate average from the latest 6 months