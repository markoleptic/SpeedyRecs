# Speedy Recs: Anime Recommender System

## Abstract
Speedy Recs is an anime recommender system developed by Mark Cunningham, Ethan Saloom, and Branson Stickney. This system utilizes five different algorithms, including User-Based Collaborative Filtering (UBCF), Item-Based Collaborative Filtering (IBCF), Singular Value Decomposition (SVD), Alternating Least Squares (ALS), and a hybrid model. We obtained data from [Kaggle](https://www.kaggle.com/datasets/hernan4444/anime-recommendation-database-2020), which was scraped from MyAnimeList, preprocessed it using RStudio, and evaluated the models for performance using various metrics.

## Features
- Utilizes UBCF, IBCF, SVD, ALS, and a hybrid model for anime recommendations.
- Data sourced from MyAnimeList, preprocessed in RStudio.
- Evaluation based on error metrics, precision-recall curves, and ROC curves.
- User-friendly Shiny application interface for quick recommendations.

## Usage
1. Clone the repository: `git clone https://github.com/markoleptic/CS5593-Project.git`
2. Open the Shiny application using RStudio: `runApp("app.R")`
3. Input your preferences for anime to receive recommendations.

## Repository Structure
- `data`: Contains the dataset and preprocessed files.
- `src`: Source code files, including algorithm implementations and the Shiny application.
- `docs`: Documentation, including this README.

## How to Use
1. Install required packages: `install.packages(c("shiny", "recommenderlab"))`
2. Download anime.csv and rating_complete.csv from [Kaggle](https://www.kaggle.com/datasets/hernan4444/anime-recommendation-database-2020) and place into the root directory.
3. Open `app.R` in RStudio.
4. Run the Shiny application.

## Contributors
- Mark Cunningham (markcham@ou.edu)
- Ethan Saloom (esaloom@ou.edu)
- Branson Stickney (bstick2@ou.edu)

## Acknowledgments
The authors acknowledge Hernan Valdivieso for scraping anime data from MyAnimeList.
