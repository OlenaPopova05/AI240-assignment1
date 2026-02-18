# AI240-assignment1

## Dataset Selection
I retrieved data about Near-Earth Objects using the [NASA API](https://api.nasa.gov). 
To collect the data, I wrote a [Python script](https://github.com/OlenaPopova05/AI240-assignment1/blob/main/nasa_asteroids_retrieve.py) that retrieves information about near-Earth asteroids during 2025 and saves it into a `.json` file. 

The resulting file size is 10.6 MB. The dataset contains nested structures and arrays.

## Data Parsing and Data Analysis Using Window Functions
The semi-structured JSON data was transformed into a structured, queryable format using DuckDB. After normalization, analytical queries were performed using SQL window functions.

The following insights were derived:

- The month with the highest number of potentially hazardous asteroids.
- The top 3 closest asteroid approaches per month.

The SQL queries used for this analysis can be found in [this file](https://github.com/OlenaPopova05/AI240-assignment1/blob/main/sql_script.sql).

## Visualization
Based on the results of the SQL analysis, the following visualizations were created:

- The ratio of hazardous vs safe asteroids per month
- The closest asteroid approach recorded per month

These visualizations illustrate both [the distribution of potentially hazardous objects](https://github.com/OlenaPopova05/AI240-assignment1/blob/main/Hazardous%20vs%20Safe%20Asteroids%20per%20Month.png) and [the monthly trend of minimum approach distances](https://github.com/OlenaPopova05/AI240-assignment1/blob/main/Closest%20Asteroid%20Approaches%20per%20Month.png).

[Visualization Notebook](https://github.com/OlenaPopova05/AI240-assignment1/blob/main/visualization.ipynb)
