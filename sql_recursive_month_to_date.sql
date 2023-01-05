SET
    TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE 
    @StartDate DATE,                --Declare the start date of the range parameter
    @EndDate DATE		            --Declare the end date of the range parameter

SET
    @StartDate = '2022-01-01';      --Set the start date of the range parameter
SET    
    @EndDate = '2022-12-31';        --Set the end date of the range parameter
    
WITH goals as(
SELECT 
       [StartDate] = CAST( DATEADD(month, DATEDIFF(month, 0, dbGoals.[MONTH_ID]), 0) as DATE)
	  ,[EndDate] = CAST( EOMONTH(dbGoals.[MONTH_ID]) AS DATE)
	  ,[DATE] = CAST( DATEADD(month, DATEDIFF(month, 0, dbGoals.[MONTH_ID]), 0) as DATE)
      ,dbGoals.[TEAM]
      ,dbGoals.[TARGET_1]
      ,dbGoals.[TARGET_2]
      ,dbGoals.[TARGET_3]
  FROM [db].[schema].[table] dbGoals
  WHERE dbGoals.[MONTH_ID] >= @StartDate AND dbGoals.[MONTH_ID] <= @EndDate
UNION ALL

SELECT 
       [StartDate]
	  ,[EndDate]
	  ,[DATE] = DATEADD(DAY,1,[DATE])
      ,[TEAM]
      ,[TARGET_1]
      ,[TARGET_2]
      ,[TARGET_4]
  FROM goals
  WHERE DATEADD(DAY,1,[DATE]) <= eomonth([EndDate])
	
  )

 SELECT 
       [TEAM]
      ,[DATE]
      ,[TARGET_1]
      ,[TARGET_2]
      ,[TARGET_4]
 FROM goals
 ORDER BY [TEAM],[DATE]
 OPTION (maxrecursion 0)