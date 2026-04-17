-- 1

WITH grp AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY [Step Number]) -
           ROW_NUMBER() OVER (PARTITION BY Status ORDER BY [Step Number]) AS g
    FROM Groupings
)
SELECT 
    MIN([Step Number]) AS [Min Step Number],
    MAX([Step Number]) AS [Max Step Number],
    Status,
    COUNT(*) AS [Consecutive Count]
FROM grp
GROUP BY Status, g
ORDER BY [Min Step Number];


-- 2

WITH years AS (
    SELECT 1975 AS y
    UNION ALL
    SELECT y + 1
    FROM years
    WHERE y < YEAR(GETDATE())
),
hired AS (
    SELECT DISTINCT YEAR(HIRE_DATE) AS y
    FROM EMPLOYEES_N
),
missing AS (
    SELECT y
    FROM years
    WHERE y NOT IN (SELECT y FROM hired)
),
grp AS (
    SELECT y,
           y - ROW_NUMBER() OVER (ORDER BY y) AS g
    FROM missing
)
SELECT 
    MIN(y) AS [StartYear],
    MAX(y) AS [EndYear]
FROM grp
GROUP BY g
ORDER BY [StartYear]
OPTION (MAXRECURSION 0);
