use ipl;
-- Problem Statement:

-- The problem statement is to use the SQL queries to find the various insights from the above-given data. Also, write your insights based on the results that you will get from the queries that you will be using.
-- Example:
-- Let’s say You have written a complex query that showed you the results as “The XXX team won 8 matches out of 10 matches in XXX Stadium” and also it showed you that the majority of the teams that won the matches, won the toss as well and had chosen the fielding first.
-- Therefore, Your insight would be: 
-- The Stadium must be a fielding pitch, which means that it favors the bowling because of various reasons, so the chasing team could control the opponent team with their bowling. Hence the teams that had won the toss and chosen the fielding, It is more likely to win the matches as well.
-- A few Questions have been provided to solve, Try to frame more questions if required.



--  Questions – Write SQL queries to get data for the following requirements:


-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
-- solution:
select bp.BIDDER_ID,(sum(bd.BID_STATUS='Won')/count(*))*100 as perc_wins
from ipl_bidder_points bp join ipl_bidding_details bd on
bp.BIDDER_ID=bd.BIDDER_ID
group by bp.BIDDER_ID
order by perc_wins desc; -- 30 rows

/*insight:
“The win-percentage analysis reveals that a few bidders consistently predict match outcomes accurately, 
indicating stronger analytical decision-making. High win percentage does not always translate to the highest total points, 
as the points system rewards high-risk predictions as well. Some bidders show 0% win rate despite many bids, 
highlighting weaker prediction strategies. Overall, the data suggests that strategic bidding and 
selective participation lead to higher accuracy, whereas frequent bidding without analysis reduces win percentage.”*/





-- 2.	Display the number of matches conducted at each stadium with the stadium name and city.
-- solution:
select count(M.MATCH_ID),S.STADIUM_NAME,S.CITY FROM ipl_match_schedule M
join ipl_stadium S on 
M.STADIUM_ID=S.STADIUM_ID
group by S.STADIUM_NAME,S.CITY; -- 10 rows

/*Insights:
“The match count shows that some stadiums and cities are preferred IPL venues, hosting more matches than others.”*/





-- 3.	In a given stadium, what is the percentage of wins by a team that has won the toss?
-- solution:
SELECT s.STADIUM_NAME,
(SUM(CASE WHEN m.TOSS_WINNER = m.MATCH_WINNER THEN 1 END) / COUNT(*)) * 100 AS toss_win_percentage
FROM IPL_MATCH m
JOIN IPL_MATCH_SCHEDULE ms ON m.MATCH_ID = ms.MATCH_ID
JOIN IPL_STADIUM s ON ms.STADIUM_ID = s.STADIUM_ID
GROUP BY s.STADIUM_NAME;  -- 122 rows

/*Insights:
“Some stadiums show a higher percentage of matches where the toss-winning team also wins, 
indicating pitch conditions favor the toss winner.” */





-- 4.	Show the total bids along with the bid team and team name.
-- solutions:
select sum(B.BIDDER_ID)AS TOTAL_BIDS,B.BID_TEAM ,T.TEAM_NAME FROM IPL_BIDDING_DETAILS B JOIN
IPL_TEAM T ON
T.TEAM_ID=B.BID_TEAM
group by B.BID_TEAM,T.TEAM_NAME
ORDER BY TOTAL_BIDS DESC;  -- 8 ROWS

/*Insights: 
“Some teams receive significantly more bids, showing they are more popular or stronger according to bidders.”*/






-- 5.	Show the team ID who won the match as per the win details.
-- solutions:
select T.TEAM_ID ,T.TEAM_NAME,M.WIN_DETAILS,M.MATCH_WINNER FROM ipl_match M
JOIN ipl_team T ON
M.MATCH_WINNER = T.TEAM_ID
WHERE M.MATCH_WINNER IS NOT NULL;  -- 120 rows

/* Insights:
1.Win details clearly show which team dominated each match, either by runs or wickets.

2.Match-winner IDs help identify consistently strong teams across the tournament.

3.Teams winning by large margins indicate stronger performance and better match control. 
*/





-- 6.	Display the total matches played, total matches won and total matches lost by the team along with its team name.
-- solutions:
select sum(M.MATCHES_PLAYED) AS TOT_MATCH_PLAYED,SUM(M.MATCHES_WON) AS TOT_MATCH_WON,SUM(M.MATCHES_LOST) AS TOT_MATCH_LOST,
T.TEAM_NAME,T.TEAM_ID
FROM ipl_team_standings M JOIN 
ipl_team T on
T.TEAM_ID=M.TEAM_ID
group by T.TEAM_NAME,T.TEAM_ID
order by TOT_MATCH_WON DESC;

/*Insights:
“The results show each team’s overall performance, 
revealing which teams have played more matches and which have the strongest win–loss ratios.” */





-- 7.	Display the bowlers for the Mumbai Indians team.
-- SOLUTIONS:
select PL.PLAYER_NAME,P.PLAYER_ROLE,T.TEAM_NAME,T.TEAM_ID
FROM ipl_team_players P
JOIN ipl_team T ON
T.TEAM_ID=P.TEAM_ID JOIN
ipl_player PL ON
PL.PLAYER_ID=P.PLAYER_ID
where P.PLAYER_ROLE = 'Bowler' AND T.TEAM_NAME = 'Mumbai Indians';  -- 9 ROWS

/* Insights:
“Mumbai Indians has a strong set of bowlers, and listing them helps analyze the team’s bowling depth.”*/





-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 
-- all-rounders in descending order.
-- solutions:
select sum(P.PLAYER_ROLE='All-Rounder') AS TOT_all_rounders,T.TEAM_NAME
FROM ipl_team_players P JOIN
ipl_team T ON
T.TEAM_ID=P.TEAM_ID
WHERE p.PLAYER_ROLE='ALL-Rounder'
GROUP BY T.TEAM_NAME,P.PLAYER_ROLE
HAVING TOT_all_rounders>4
ORDER BY TOT_all_rounders DESC; -- 5 rows

/*Insights:
“Only a few teams have more than four all-rounders, showing strong depth in both batting and bowling.”*/







/* 9.Write a query to get the total bidders' points for each bidding status of those bidders 
 who bid on CSK when they won the match in M. Chinnaswamy Stadium bidding year-wise.
 Note the total bidders’ points in descending order and the year is the bidding year.
 Display columns: bidding status, bid date as year, total bidder’s points  */

-- SOLUTIONS:
SELECT 
    B.BID_STATUS,
    YEAR(B.BID_DATE) AS bid_year,
    SUM(P.TOTAL_POINTS) AS total_points
FROM ipl_bidding_details B
JOIN ipl_bidder_points P 
    ON B.BIDDER_ID = P.BIDDER_ID
JOIN ipl_team T
    ON T.TEAM_ID = B.BID_TEAM
JOIN ipl_match_schedule MS
    ON B.SCHEDULE_ID = MS.SCHEDULE_ID
JOIN ipl_match M
    ON M.MATCH_ID = MS.MATCH_ID
JOIN ipl_stadium S
    ON S.STADIUM_ID = MS.STADIUM_ID
WHERE 
      T.REMARKS = 'CSK' 
  AND M.MATCH_WINNER = T.TEAM_ID
  AND S.STADIUM_NAME = 'M. Chinnaswamy Stadium'
GROUP BY 
    B.BID_STATUS,
    YEAR(B.BID_DATE)
ORDER BY 
    total_points DESC;  -- 2 ROWS
/* Insights:
This query reveals how different bidding statuses performed year-wise for bidders 
who placed bets on CSK during its winning matches at M. Chinnaswamy Stadium, highlighting
 engagement trends, point accumulation patterns, and venue-specific behavior.*/
 





-- 10.	Extract the Bowlers and All-Rounders that are in the 5 highest number of wickets.
-- Note 
-- 1. Use the performance_dtls column from ipl_player to get the total number of wickets
--  2. Do not use the limit method because it might not give appropriate results when players have the same number of wickets
-- 3.	Do not use joins in any cases.
-- 4.	Display the following columns teamn_name, player_name, and player_role.

-- solutions:
WITH wicket_rank AS (
    SELECT 
        p.player_id,
        p.player_name,
        
        /* extract wickets from performance_dtls: Wkt-17 → 17 */
        CAST(
            SUBSTRING_INDEX(
                SUBSTRING_INDEX(p.performance_dtls, 'Wkt-', -1),
            ' ', 1
            ) AS UNSIGNED
        ) AS wickets,
        
        /* get role without join */
        (SELECT tp.player_role 
         FROM ipl_team_players tp 
         WHERE tp.player_id = p.player_id
        ) AS player_role,

        /* get team name without join */
        (SELECT t.team_name 
         FROM ipl_team t 
         WHERE t.team_id = (
             SELECT tp.team_id 
             FROM ipl_team_players tp 
             WHERE tp.player_id = p.player_id
         )
        ) AS team_name,

        /* rank players based on wickets */
        DENSE_RANK() OVER (
            ORDER BY 
                CAST(
                    SUBSTRING_INDEX(
                        SUBSTRING_INDEX(p.performance_dtls, 'Wkt-', -1),
                    ' ', 1
                    ) AS UNSIGNED
                ) DESC
        ) AS rnk
    FROM ipl_player p
)
SELECT 
    team_name,
    player_name,
    player_role
FROM wicket_rank
WHERE rnk <= 5           -- top 5 wicket-takers
ORDER BY rnk;  -- 9 rows
/* Insights:
The query extracts only Bowlers and All-Rounders from the ipl_player table.

It pulls the wickets value from the performance_dtls column by taking the last number after the comma.

It uses DENSE_RANK() to rank players by wicket count without using LIMIT, ensuring ties are handled properly.

A CTE (wicket_rank) is used to calculate ranks and then filter only the Top 5 wicket-takers.

No joins are used — everything is processed from a single table using window functions and string functions.

Final result shows team_name, player_name, and player_role for the top performers.
*/







-- 11.	show the percentage of toss wins of each bidder and display the results in descending order
-- based on the percentage
-- solutions:
SELECT 
    B.bidder_id,
    CONCAT(
        ROUND(
            (SUM(CASE WHEN M.toss_winner = B.bid_team THEN 1 ELSE 0 END) 
            / COUNT(*)) * 100, 2
        ), '%'
    ) AS toss_win_percentage
FROM 
    ipl_bidding_details B
JOIN 
    ipl_match_schedule MS ON B.schedule_id = MS.schedule_id
JOIN 
    ipl_match M ON MS.match_id = M.match_id
GROUP BY 
    B.bidder_id
ORDER BY 
    (SUM(CASE WHEN M.toss_winner = B.bid_team THEN 1 ELSE 0 END) 
    / COUNT(*)) DESC; -- 30 rows
/*Insights:
It calculates how accurately each bidder predicted the toss winner across all the matches they bid on.*/







-- 12.	find the IPL season which has a duration and max duration.
-- Output columns should be like the below:
--  Tournment_ID, Tourment_name, Duration column, Duration
-- solutions:
SELECT TOURNMT_ID,TOURNMT_NAME,
CONCAT(FROM_DATE, ' TO ', TO_DATE) AS Duration_Column,
DATEDIFF(TO_DATE, FROM_DATE) AS Duration
FROM ipl_tournament
ORDER BY Duration DESC; -- 11 ROWS

/*Insights:
The Max duration of the tournmt has 53 days */





-- 13.	Write a query to display to calculate the total points month-wise for the 2017 bid year. 
-- sort the results based on total points in descending order and month-wise in ascending order.
-- Note: Display the following columns:
-- 1.	Bidder ID, 2. Bidder Name, 3. Bid date as Year, 4. Bid date as Month, 5. Total points
-- Only use joins for the above query queries.
-- solutions:
select BD.BIDDER_ID,BD.BIDDER_NAME,YEAR(B.BID_DATE) AS BID_DATE_YEAR,MONTH(B.BID_DATE) AS BID_MONTH,
SUM(BP.TOTAL_POINTS) AS TOT_POINTS FROM ipl_bidder_details BD 
JOIN ipl_bidder_points BP ON
BD.BIDDER_ID=BP.BIDDER_ID
JOIN ipl_bidding_details B on
B.BIDDER_ID=BP.BIDDER_ID
WHERE YEAR(B.BID_DATE)=2017
group by BD.BIDDER_ID,BD.BIDDER_NAME,YEAR(B.BID_DATE),
MONTH(B.BID_DATE) 
ORDER BY TOT_POINTS DESC,BID_MONTH ASC;  -- 55 ROWS

/* Insights:
The 55 rows give a comprehensive view of bidder performance month-wise in 2017,
 showing top scorers, consistency, and peak activity periods */
 





-- 14.	Write a query for the above question using sub-queries by having the same constraints as the above question.
-- solutions:
SELECT 
    (SELECT BIDDER_ID 
     FROM ipl_bidder_details bd 
     WHERE bd.BIDDER_ID = b.BIDDER_ID) AS BIDDER_ID,

    (SELECT BIDDER_NAME 
     FROM ipl_bidder_details bd 
     WHERE bd.BIDDER_ID = b.BIDDER_ID) AS BIDDER_NAME,

    YEAR(b.BID_DATE) AS BID_DATE_YEAR,
    MONTH(b.BID_DATE) AS BID_MONTH,

    -- Subquery for total points
    (SELECT SUM(bp.TOTAL_POINTS)
     FROM ipl_bidder_points bp
     WHERE bp.BIDDER_ID = b.BIDDER_ID) AS TOT_POINTS
     
FROM ipl_bidding_details b
WHERE YEAR(b.BID_DATE) = 2017
GROUP BY 
    b.BIDDER_ID,
    YEAR(b.BID_DATE),
    MONTH(b.BID_DATE)
ORDER BY 
    TOT_POINTS DESC,
    BID_MONTH ASC;






-- 15.	Write a query to get the top 3 and bottom 3 bidders based on the total bidding points for the 2018 bidding year.
-- Output columns should be:
-- like
-- Bidder Id, Ranks (optional), Total points, Highest_3_Bidders --> columns contains name of bidder,
--  Lowest_3_Bidders  --> columns contains name of bidder;

-- soltion:
WITH bidder_totals AS (
    SELECT 
        b.BIDDER_ID,
        SUM(bp.TOTAL_POINTS) AS total_points
    FROM ipl_bidding_details b
    JOIN ipl_bidder_points bp 
        ON b.BIDDER_ID = bp.BIDDER_ID
    WHERE YEAR(b.BID_DATE) = 2018
    GROUP BY b.BIDDER_ID
),
ranked AS (
    SELECT 
        bt.BIDDER_ID,
        bt.total_points,
        RANK() OVER (ORDER BY total_points DESC) AS rank_desc,
        RANK() OVER (ORDER BY total_points ASC)  AS rank_asc
    FROM bidder_totals bt
)
SELECT 
    BIDDER_ID,
    total_points,
    
    -- Top 3 bidders' names
    CASE WHEN rank_desc <= 3 THEN 
        (SELECT BIDDER_NAME FROM ipl_bidder_details d WHERE d.BIDDER_ID = r.BIDDER_ID)
    END AS Highest_3_Bidders,

    -- Bottom 3 bidders' names
    CASE WHEN rank_asc <= 3 THEN 
        (SELECT BIDDER_NAME FROM ipl_bidder_details d WHERE d.BIDDER_ID = r.BIDDER_ID)
    END AS Lowest_3_Bidders

FROM ranked r
ORDER BY total_points DESC;   -- 29 rows

/* Insights:
. Identifies the Highest Performers of 2018

The Highest_3_Bidders column highlights the top 3 bidders who scored the maximum total points.

These bidders show strong and consistent performance in the 2018 bidding year.

Useful for recognizing star performers or rewarding top bidders.

⭐ 2. Highlights the Lowest Performers

The Lowest_3_Bidders column shows the bottom 3 bidders with the least total points.

Helps understand which bidders were least active, inconsistent, or underperforming.

Useful for performance improvement, training needs, or future bidding strategies.

⭐ 3. Ranking-Based Comparison

The query internally assigns ranking using:

rank_desc → descending (top performers)

rank_asc → ascending (low performers)

This lets you clearly see the performance gap between top and bottom bidders.

⭐ 4. Complete Visibility in One Output

Both top 3 and bottom 3 appear in the same result set.

You don’t need separate queries.

Makes analysis faster and clearer for reporting dashboards.

⭐ 5. Strategic Business Interpretation

Top 3 bidders may represent high-value customers for the platform.

Bottom 3 may need re-engagement, offers, or follow-ups to improve activity.

Useful for decision-making in loyalty programs, marketing, or customer retention.
*/



