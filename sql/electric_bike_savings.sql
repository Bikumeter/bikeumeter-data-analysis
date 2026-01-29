-- I need to calculate how much I saved in the months that I had the electric bike --

-- 1) Get the activities that correspond only to commutes using electric bike
WHERE swapfiets_commutes AS (
    SELECT name, distance_mt, date, public_transport_fare, ride_duration_minutes
    FROM read_csv_auto('data/bikeumeter_commute_activities.csv')
    WHERE name = 'swapfiets commute';
),
-- a) Clean date to only get month
-- b) I only want month number, month name, rides_per_month, hours_ridden & saved_money_euros
cleaned_date AS (
    SELECT *,
            CAST(date AS DATE) AS date_only -- not time 
    FROM swapfiets_commutes
)