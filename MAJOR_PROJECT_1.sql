/* 1. Identify Users by Location
 Write a query to find all posts made by users in specific locations such as
 'Agra', 'Maharashtra', and 'West Bengal'.
 Hint: Focus on filtering users by location. */
 
select * from post
where location='Maharashtra';

/* 2. Determine the most Followed Hashtags
 Write a query to list the top 5 most-followed hashtags on the platform.
 Hint: Join relevant tables to calculate the total follows for each hashtag.
*/
SELECT h.hashtag_name, COUNT(hf.hashtag_id) AS Top_5_Followed_Hashtag_Name
FROM hashtags h
JOIN hashtag_follow hf ON h.hashtag_id = hf.hashtag_id
GROUP BY h.hashtag_name
ORDER BY Top_5_Followed_Hashtag_Name DESC
LIMIT 5;

/*3.Find the Most Used Hashtags
Identify the top 10 most-used hashtags in posts.
 Hint: Count how many times each hashtag appears in posts.
*/
Select h.hashtag_name, count(pt.hashtag_id) as top_10_most_used_hashtag_in_post
from hashtags h
join post_tags pt on h.hashtag_id=pt.hashtag_id
group by h.hashtag_name
order by top_10_most_used_hashtag_in_post desc
limit 10;

/*4. Identify the Most Inactive User
 Write a query to find users who have never made any posts on the-platform.
int: Use a subquery to identify these users.
*/
SELECT *
FROM users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM post
);

select u.user_id, u.username from users u
LEFT JOIN POST P ON u.user_id=p.user_id
where p.user_id is null;


/*
5. Identify the Posts with the Most Likes
Write a query to find the posts that have received the highest number of
likes.
Hint: Count the number of likes for each post.
*/

select post_id,count(*) as Posts_with_the_Most_Likes
from post_likes
group by post_id
order by Posts_with_the_Most_Likes desc
;

/*6. Calculate Average Posts per User
Write a query to determine the average number of posts made by users.
Hint: Consider dividing the total number of posts by the number of unique
users.
*/

select count(p.post_id) /count(distinct u.user_id) as Average_Posts_per_User
from users u
join post p on u.user_id=p.user_id;


/*7. Track the Number of Logins per User
Write a query to track the total number of logins made by each user.
Hint: Join user and log
*/

SELECT u.user_id, u.username, COUNT(l.login_id) AS total_number_of_logins_made_by_each_user
FROM users u
JOIN login l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username
;

/*8. Identify a User Who Liked Every Single Post
Write a query to find any user who has liked every post on the platform. 
Hint: Compare the number of posts with the number of likes by this user
*/
select u.user_id, u.username
from users u
where not exists
(
select * from post p
where not exists
(
select * from post_likes pl
where pl.user_id=u.user_id and pl.post_id=p.post_id
)
);

/*
9. Find Users Who Never Commented
Write a query to find users who have never commented on any post. 
Hint: Use a subquery to exclude users who have commented.
*/
select u.user_id, u.Username 
from users u
where not exists
(
select * from comments c
where c.user_id=u.user_id
)

/*
10. Identify a User Who Commented on Every Post
Write a query to find any user who has commented on every post on the platform.
Hint: Compare the number of posts with the number of comments by this
user.
*/

select u.user_id, u.username
from users u
join comments c on u.user_id = c.user_id
group by u.user_id, u.username
having COUNT(DISTINCT c.post_id) = (SELECT COUNT(post_id) FROM post);


/*
11. Identify Users Not Followed by Anyone
Write a query to find users who are not followed by any other users.
Hint: Use the follows table to find users who have no followers.
*/
SELECT user_id
FROM users u
JOIN follows f ON u.user_id = f.followee_id
WHERE f.follower_id IS NULL;

/*
12. Identify Users Who Are Not Following Anyone
Write a query to find users who are not following anyone.
Hint: Use the follows table to identify users who are not following others
*/
SELECT user_id
FROM users u
JOIN follows f ON u.user_id = f.follower_id
WHERE f.follower_id IS NULL;


/*
13. Find Users Who Have Posted More than 5 Times
Write a query to find users who have made more than five posts.
Hint: Group the posts by user and filter the results based on the number of
posts.
*/
select u.username
from users u
join (
    SELECT user_id
    FROM post
    GROUP BY user_id
    HAVING COUNT(*) > 5
) p ON u.user_id = p.user_id;

/*
14. Identify Users with More than 40 Followers
Write a query to find users who have more than 40 followers.
Hint: Group the followers and filter the result for those with a high follower
count.
*/
SELECT u.username
FROM users u
JOIN (
    SELECT followee_id
    FROM follows
    GROUP BY followee_id
    HAVING COUNT(follower_id) > 40
) f ON u.user_id = f.followee_id;

/*
15. Search for Specific Words in Comments
Write a query to find comments containing specific words like "good" or "beautiful."
Hint: Use regular expressions to search for these words.
*/
 SELECT *
FROM comments
WHERE comment_text LIKE '%good%' OR comment_text LIKE '%beautiful%';


/*
16. Identify the Longest Captions in Posts
Write a query to find the posts with the longest captions.
Hint: Calculate the length of each caption and sort them to find the top 5 longest ones.
*/

SELECT post_id, caption, CHAR_LENGTH(caption) AS caption_length
FROM post
ORDER BY caption_length DESC
LIMIT 5;







