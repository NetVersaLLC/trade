-- Spherical Law of Cosines
SELECT *, (DEGREES( ACOS( SIN(RADIANS(@la)) * SIN(RADIANS(latitude)) + COS(RADIANS(@la)) * COS(RADIANS(latitude)) * COS(RADIANS(@lo - longitude)))) * 60 * 1.1515) AS distance FROM contributors WHERE latitude is not null and longitude is not null ORDER BY distance ASC LIMIT 20 \G
-- Haversine Formula
SELECT * , ((2 * 3960 * ATAN2(SQRT(POWER(SIN((RADIANS(@la - latitude))/2), 2) + COS(RADIANS(latitude)) * COS(RADIANS(@la )) * POWER(SIN((RADIANS(@lo - longitude))/2), 2)),SQRT(1-(POWER(SIN((RADIANS(@la - latitude))/2), 2) + COS(RADIANS(latitude)) * COS(RADIANS(@la)) * POWER(SIN((RADIANS(@lo - longitude))/2), 2)))))) AS distance FROM contributors where latitude is not null and longitude is not null  ORDER BY distance LIMIT 20
-- Spherical Law of Cosines 2
SELECT * , ((2 * 3960 * ASIN( SQRT( POWER(SIN((RADIANS(@la - latitude))/2), 2) + COS(RADIANS(latitude)) * COS(RADIANS(@la )) * POWER(SIN((RADIANS(@lo - longitude))/2), 2) ) ) )) AS distance FROM contributors where latitude is not null and longitude is not null ORDER BY distance LIMIT 20 \G
