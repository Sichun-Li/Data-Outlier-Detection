USE booksales;

SELECT * FROM newsletter;
SELECT * FROM web;
SELECT * FROM store;

-- 
SELECT UserID, ROUND(SUM(PurchaseAmount),2) AS Purchases_Online, COUNT(PurchaseAmount) AS Visits_Online
FROM web
GROUP BY UserID;

SELECT UserID, ROUND(SUM(PurchaseAmount),2) AS Purchases_Store, COUNT(PurchaseAmount) AS Visits_Store
FROM store
GROUP BY UserID;


-- 
SELECT UserID, "Online" AS Location, ROUND(SUM(PurchaseAmount),2) AS Purchases, COUNT(PurchaseAmount) AS Visits
FROM web
GROUP BY UserID
UNION
SELECT UserID, "Store" AS Location, ROUND(SUM(PurchaseAmount),2) AS Purchases, COUNT(PurchaseAmount) AS Visits
FROM store
GROUP BY UserID
ORDER BY UserID;

-- 
SELECT summary.UserID, Location, Purchases, Visits,
		CASE
			WHEN Newsletter.UserID IS NULL THEN 0
            ELSE 1
		END AS Newsletter
FROM
(
	SELECT UserID, "Online" AS Location, ROUND(SUM(PurchaseAmount),2) AS Purchases, COUNT(PurchaseAmount) AS Visits
	FROM web
	GROUP BY UserID
	UNION
	SELECT UserID, "Store" AS Location, ROUND(SUM(PurchaseAmount),2) AS Purchases, COUNT(PurchaseAmount) AS Visits
	FROM store
	GROUP BY UserID
) AS summary
LEFT JOIN Newsletter ON summary.UserID = Newsletter.UserID
ORDER BY UserID;

CREATE TABLE salesdw_long AS
SELECT summary.UserID, Location, Purchases, Visits,
		CASE
			WHEN Newsletter.UserID IS NULL THEN 0
            ELSE 1
		END AS Newsletter
FROM
(
	SELECT UserID, "Online" AS Location, ROUND(SUM(PurchaseAmount),2) AS Purchases, COUNT(PurchaseAmount) AS Visits
	FROM web
	GROUP BY UserID
	UNION
	SELECT UserID, "Store" AS Location, ROUND(SUM(PurchaseAmount),2) AS Purchases, COUNT(PurchaseAmount) AS Visits
	FROM store
	GROUP BY UserID
) AS summary
LEFT JOIN Newsletter ON summary.UserID = Newsletter.UserID
ORDER BY UserID;

--
SELECT 	Newsletter, Location,
		SUM(Purchases) AS Purchases_Total, SUM(Visits) AS Visits, SUM(Purchases)/SUM(Visits) AS Visit_Avg
FROM salesdw_long
GROUP BY Newsletter, Location WITH ROLLUP;

SELECT Visits, COUNT(*) AS Freq
FROM salesdw_long
WHERE Location = "Online"
GROUP BY Visits WITH ROLLUP;

SELECT Location, Visits, COUNT(*) AS Freq
FROM salesdw_long
GROUP BY Location, Visits WITH ROLLUP;






