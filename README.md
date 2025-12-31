📊 Streaming Platform Engagement Analysis (SQL)

📌 Project Overview
This project analyses user engagement data from a fictional streaming platform to identify shows with high viewer drop-off. The aim is to understand which series users start but do not finish, helping content teams improve retention and pacing.

🧠 Business Question
Which shows have the highest number of users who start watching but fail to complete all available episodes?

🗂️ Dataset Structure
The analysis is based on four relational tables:
users – user signup information
shows – show metadata (title, genre, release year)
episodes – episode-level data linked to shows
views – user viewing behaviour per episode

These tables reflect a realistic streaming analytics schema.

🛠️ Tools Used
PostgreSQL
SQL (joins, aggregations, CTEs)
Postico 2 (Mac SQL client)

🔍 Analytical Approach
Count the total number of episodes available per show
Count how many episodes each user watched per show
Identify users who watched fewer episodes than available
Aggregate results to find shows with the highest drop-off
This method focuses on completion behaviour, not just total views.
