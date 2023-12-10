# Speedy Recs: Anime Recommender System

## Abstract
Speedy Recs is an anime recommender system developed by Mark Cunningham, Ethan Saloom, and Branson Stickney. This system utilizes five different algorithms, including User-Based Collaborative Filtering (UBCF), Item-Based Collaborative Filtering (IBCF), Singular Value Decomposition (SVD), Alternating Least Squares (ALS), and a hybrid model. We obtained data from [Kaggle](https://www.kaggle.com/datasets/hernan4444/anime-recommendation-database-2020), which was scraped from MyAnimeList, preprocessed it using RStudio, and evaluated the models for performance using various metrics.

## Features
- Utilizes UBCF, IBCF, SVD, ALS, and a hybrid model for anime recommendations.
- Data sourced from MyAnimeList, preprocessed in RStudio.
- Evaluation based on error metrics, precision-recall curves, and ROC curves.
- User-friendly Shiny application interface for quick recommendations.

<table>
  <h2 align="center"><b>Previewing the Data</b></h2>
  <tr>
    <td width=50%>
        <img src="https://github.com/markoleptic/CS5593-Project/assets/86213229/a85e97bf-59e8-4a33-bc52-9e53594c8943" alt="Ratings Distribution Overall">
    </td>
    <td width=50%>
        <img src="https://github.com/markoleptic/CS5593-Project/assets/86213229/51f0c9e4-04c9-4460-a45a-c4bccaff792d" alt="Ratings Distribution Normalized">
    </td>
  </tr>
  <tr>
    <td width=50%>
      <img src="https://github.com/markoleptic/CS5593-Project/assets/86213229/8d3e1c28-34dd-4da4-a974-ba160ce8bdc1" alt="Ratings Per User">
    </td>
    <td width=50%>
      <img src="https://github.com/markoleptic/CS5593-Project/assets/86213229/a868bcb6-e1bb-477a-8cf1-58bf33d8926b" alt="User Similarity">
    </td>
  </tr>
</table>

<table>
  <h2 align="center"><b>Error Values for Different Algorithms</b></h2>
  <tr>
    <td width=50%><img src="https://github.com/markoleptic/CS5593-Project/assets/86213229/70a9a299-65c5-41ab-9159-92a7db03c98b" alt="Error Values Across All Algos and Schemes"></td>
    <td width=50%><img src="https://github.com/markoleptic/CS5593-Project/assets/86213229/91cd6d12-a0b5-44c2-b3bc-4c81403079d0" alt="Error Values Across All Algos and Schemes"></td>
  </tr>
</table>

<table align="center">
  <h2 align="center">
    <b>
      Shiny App User Interface
    </b>
  </h2>
  <tr align="center">
    <td align="center">
      <img src="https://github.com/markoleptic/CS5593-Project/assets/86213229/61127a25-d91f-4fb6-bc61-3c307c66ed47" alt="Shiny App User Interface">
    </td>
  </tr>
</table>

## Usage
1. Clone the repository: `git clone https://github.com/markoleptic/CS5593-Project.git`
2. Download anime.csv and rating_complete.csv from [Kaggle](https://www.kaggle.com/datasets/hernan4444/anime-recommendation-database-2020) and place into the root directory.
3. Install required packages: `install.packages(c("shiny", "recommenderlab"))` (There's probably more than just that).
4. Open the RStudio project using RStudio: `SpeedyRecs.Rproj `
5. Run the entire `Project.Rmd` file to generate all the models. This might take a while.
6. In the console, type `shiny::runApp()` to start the ShinyApp
7. Input your ratings to receive recommendations.

## Contributors
- Mark Cunningham (markcham@ou.edu)
- Ethan Saloom (esaloom@ou.edu)
- Branson Stickney (bstick2@ou.edu)

## Acknowledgments
The authors acknowledge Hernan Valdivieso for scraping anime data from MyAnimeList.
