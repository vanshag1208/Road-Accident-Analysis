select * from road_accident


/*Find the number of current year casualties */
select SUM(number_of_casualties) as CY_Casualties 
from road_accident 
where YEAR(accident_date) = '2022'

/*Find the number of current year casualties for dry conditions */
select SUM(number_of_casualties) as CY_Casualties 
from road_accident 
where YEAR(accident_date) = '2022' and road_surface_conditions= 'dry'

/*Find the number of current year accidents */
select COUNT(Distinct accident_index) as CY_Accidents
from road_accident 
where YEAR(accident_date) = '2022'

/*Find the number of current year fatal casualties  */
select SUM(number_of_casualties) as CY_Fatal_Casualties 
from road_accident 
where YEAR(accident_date) = '2022' and accident_severity= 'fatal'

/*Find the number of current year serious casualties  */
select SUM(number_of_casualties) as CY_Serious_Casualties 
from road_accident 
where YEAR(accident_date) = '2022' and accident_severity= 'serious'

/*Find the number of current year slight casualties  */
select SUM(number_of_casualties) as CY_Slight_Casualties 
from road_accident 
where YEAR(accident_date) = '2022' and accident_severity= 'slight'

/*Find the number of previous year casualties */
select SUM(number_of_casualties) as PY_Casualties 
from road_accident 
where YEAR(accident_date) = '2021'

/*Find the number of previous year accidents */
select COUNT(Distinct accident_index) as PY_Accidents
from road_accident 
where YEAR(accident_date) = '2021'

/*Find the number of previous year fatal casualties  */
select SUM(number_of_casualties) as PY_Fatal_Casualties 
from road_accident 
where YEAR(accident_date) = '2021' and accident_severity= 'fatal'

/*Find the number of previous year serious casualties  */
select SUM(number_of_casualties) as PY_Serious_Casualties 
from road_accident 
where YEAR(accident_date) = '2021' and accident_severity= 'serious'

/*Find the number of previous year slight casualties  */
select SUM(number_of_casualties) as PY_Slight_Casualties 
from road_accident 
where YEAR(accident_date) = '2021' and accident_severity= 'slight'

/* Find the number of CY casualties by Vehicle Type */
select
case 
when vehicle_type In ('Agricultural vehicle') THEN 'Agricultural'
when vehicle_type In ('Car','Taxi/Private hire car') THEN 'Cars'
when vehicle_type In ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Bike'
when vehicle_type In ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Bus'
when vehicle_type In ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
else 'Other'
end AS Vehicle_Type , SUM(number_of_casualties) as CY_Casualties 
from road_accident 
where YEAR(accident_date) = '2022'
group by 
case 
when vehicle_type In ('Agricultural vehicle') THEN 'Agricultural'
when vehicle_type In ('Car','Taxi/Private hire car') THEN 'Cars'
when vehicle_type In ('Motorcycle 125cc and under','Motorcycle 50cc and under','Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') THEN 'Bike'
when vehicle_type In ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Bus'
when vehicle_type In ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
else 'Other'
END

/*Find the number of casualities for the previous and current year monthly */
SELECT 
    DATENAME(Month, accident_date) AS Month_Name,
    SUM(CASE WHEN YEAR(accident_date) = 2022 THEN number_of_casualties ELSE 0 END) AS CY_Casualties,
    SUM(CASE WHEN YEAR(accident_date) = 2021 THEN number_of_casualties ELSE 0 END) AS PY_Casualties
FROM 
    road_accident
GROUP BY 
    DATENAME(Month, accident_date), MONTH(accident_date)
ORDER BY 
    MONTH(accident_date);

/*Find the number of casualities by road_type*/
select road_type,SUM(number_of_casualties) as CY_Casualties From road_accident
where YEAR(accident_date)='2022'
group by road_type

/*Find the number of casualities by Urban/Rural area */
select urban_or_rural_area,Cast( Cast (SUM(number_of_casualties) AS decimal(10,2))* 100/(select Cast (SUM(number_of_casualties) AS decimal(10,2)) From road_accident
where YEAR(accident_date)='2022'  ) As decimal(10,2)) As percentage_of_casualties
From road_accident
where YEAR(accident_date)='2022'
group by urban_or_rural_area

/*Find the number of casualities by Urban/Rural area */
select urban_or_rural_area,Cast( Cast (SUM(number_of_casualties) AS decimal(10,2))* 100/(select Cast (SUM(number_of_casualties) AS decimal(10,2)) From road_accident
where YEAR(accident_date)='2022'  ) As decimal(10,2)) As percentage_of_casualties
From road_accident
where YEAR(accident_date)='2022'
group by urban_or_rural_area

/*Find the number of casualities by Location */
select Top 10 local_authority,SUM(number_of_casualties) As Total_Casualties
From road_accident
group by local_authority 
order by Total_Casualties DESC

/*Find the number of current year casualities by Accident Severity */
select accident_severity,Cast( Cast (SUM(number_of_casualties) AS decimal(10,2))* 100/(select Cast (SUM(number_of_casualties) AS decimal(10,2)) From road_accident
where YEAR(accident_date)='2022'  ) As decimal(10,2)) As percentage_of_casualties
From road_accident
where YEAR(accident_date)='2022'
group by accident_severity

/*Find the YoY Growth on  casualities */
select  Distinct Cast (((select Cast(SUM(number_of_casualties) AS decimal(10,2))  from road_accident 
where YEAR(accident_date) = '2022') - (select Cast(SUM(number_of_casualties) AS decimal(10,2)) from road_accident 
where YEAR(accident_date) = '2021')) * 100 / (select Cast(SUM(number_of_casualties) AS decimal(10,2)) from road_accident 
where YEAR(accident_date) = '2021') AS decimal(10,2)) As YoY_Growth 
from road_accident