-- 1) join both bikeumeter_activities + bikeumeter_bike_costs
-- 2) get the total which is the amount I spent on the bike
-- 3) do a running total = cumulative sum
-- 4) check to see when it crosses 0 using running total against total spent on bike

SELECT *
FROM read_csv_auto('data/bikeumeter_activities.csv')
LIMIT 10;
