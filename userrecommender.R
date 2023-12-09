library(dplyr)
library(tidyr)
library(recommenderlab)
library(reshape2)
library(data.table)
library(Matrix)
library(factoextra)

load("anime_eval_schemes.rda")
load("ibcf_models.rda")
load("ubcf_models.rda")
load("als_models.rda")
load("svd_models.rda")
load("hybrid_models.rda")
load("prediction_models.rda")
load("ratingmats.rda")

rating_select <- c(1,2,3,4,5,6,7,8,9,10)
rating_select <- as.data.frame(rating_select)
colnames(rating_select) <- c('Rating')

getAnimeNames <- function(df) {
  # function that takes as input a list of MAL_ID, 
  # and returns a data frame containing the corresponding English names
  out = as.data.frame(matrix(ncol=1,nrow=5))
  names(out)[1] <- 'Anime Name'
  for(i in 1:nrow(df)) {
    value <- df[[i,1]]
    row <- which(anime_df_sample[["MAL_ID"]]==value)
    out[i,1] <- anime_df_sample[row,5]
  }
  return(out)
}

get_ibcf_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5,anime_1_rating,anime_2_rating,anime_3_rating,anime_4_rating,anime_5_rating) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  # create user rating matrix using user input anime
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating)
  user_ratings <- data.frame(user,item,rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings<-as.data.frame(user_ratings)
  
  # make sure rating matrix has correct data types
  ratingmat_sample_df <- as(ratingmat_sample, "data.frame")
  ratingmat_sample_df$user <- as.numeric(ratingmat_sample_df$user)
  ratingmat_sample_df$item <- as.character(ratingmat_sample_df$item)
  # reorder rating matrix based on row number
  ratingmat_sample_df<-ratingmat_sample_df[order(as.numeric(row.names(ratingmat_sample_df))),]
  # combine user rating matrix with original ratings matrix
  rating_mat_combined <- rbind(user_ratings,ratingmat_sample_df)
  # make sure rating matrix has correct data types
  rating_mat_combined$user <- as.numeric(rating_mat_combined$user)
  rating_mat_combined$item <- as.character(rating_mat_combined$item)
  rating_mat_combined_rrm <- as(rating_mat_combined, "realRatingMatrix")
  
  # the first row of rating_mat_combined_rrm is the user
  ibcf_recom <- predict(ibcf_model2, rating_mat_combined_rrm[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(ibcf_recom,"list"))))
}

get_ubcf_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5,anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  # create user rating matrix using user input anime
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating)
  user_ratings <- data.frame(user,item,rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings<-as.data.frame(user_ratings)
  
  # make sure rating matrix has correct data types
  ratingmat_sample_df <- as(ratingmat_sample, "data.frame")
  ratingmat_sample_df$user <- as.numeric(ratingmat_sample_df$user)
  ratingmat_sample_df$item <- as.character(ratingmat_sample_df$item)
  # reorder rating matrix based on row number
  ratingmat_sample_df<-ratingmat_sample_df[order(as.numeric(row.names(ratingmat_sample_df))),]
  # combine user rating matrix with original ratings matrix
  rating_mat_combined <- rbind(user_ratings,ratingmat_sample_df)
  # make sure rating matrix has correct data types
  rating_mat_combined$user <- as.numeric(rating_mat_combined$user)
  rating_mat_combined$item <- as.character(rating_mat_combined$item)
  rating_mat_combined_rrm <- as(rating_mat_combined, "realRatingMatrix")
  
  # create new model that combines original data with user data
  user_ubcf_model <- Recommender(rating_mat_combined_rrm, method = "UBCF",param = list(normalize = "center",method="Cosine",nn=50))
  # the first row of rating_mat_combined_rrm is the user
  ubcf_recom <- predict(user_ubcf_model, rating_mat_combined_rrm[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(ubcf_recom,"list"))))
}

get_als_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5,anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  # create user rating matrix using user input anime
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating)
  user_ratings <- data.frame(user,item,rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings<-as.data.frame(user_ratings)
  
  # make sure rating matrix has correct data types
  ratingmat_sample_df <- as(ratingmat_sample, "data.frame")
  ratingmat_sample_df$user <- as.numeric(ratingmat_sample_df$user)
  ratingmat_sample_df$item <- as.character(ratingmat_sample_df$item)
  # reorder rating matrix based on row number
  ratingmat_sample_df<-ratingmat_sample_df[order(as.numeric(row.names(ratingmat_sample_df))),]
  # combine user rating matrix with original ratings matrix
  rating_mat_combined <- rbind(user_ratings,ratingmat_sample_df)
  # make sure rating matrix has correct data types
  rating_mat_combined$user <- as.numeric(rating_mat_combined$user)
  rating_mat_combined$item <- as.character(rating_mat_combined$item)
  rating_mat_combined_rrm <- as(rating_mat_combined, "realRatingMatrix")
  
  # the first row of rating_mat_combined_rrm is the user
  als_recom <- predict(als_model2, rating_mat_combined_rrm[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(als_recom,"list"))))
}

get_svd_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5,anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating) {

  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  # create user rating matrix using user input anime
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating)
  user_ratings <- data.frame(user,item,rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings<-as.data.frame(user_ratings)
  
  # make sure rating matrix has correct data types
  ratingmat_sample_df <- as(ratingmat_sample, "data.frame")
  ratingmat_sample_df$user <- as.numeric(ratingmat_sample_df$user)
  ratingmat_sample_df$item <- as.character(ratingmat_sample_df$item)
  # reorder rating matrix based on row number
  ratingmat_sample_df<-ratingmat_sample_df[order(as.numeric(row.names(ratingmat_sample_df))),]
  # combine user rating matrix with original ratings matrix
  rating_mat_combined <- rbind(user_ratings,ratingmat_sample_df)
  # make sure rating matrix has correct data types
  rating_mat_combined$user <- as.numeric(rating_mat_combined$user)
  rating_mat_combined$item <- as.character(rating_mat_combined$item)
  rating_mat_combined_rrm <- as(rating_mat_combined, "realRatingMatrix")
  
  # create new model that combines original data with user data
  user_svd_model <- Recommender(rating_mat_combined_rrm, method = "SVD",param = list(normalize = "center"))
  # the first row of rating_mat_combined_rrm is the user
  svd_recom <- predict(user_svd_model, rating_mat_combined_rrm[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(svd_recom,"list"))))
}

get_hybrid_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5,anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  # create user rating matrix using user input anime
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(anime_1_rating, anime_2_rating, anime_3_rating, anime_4_rating, anime_5_rating)
  user_ratings <- data.frame(user,item,rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings<-as.data.frame(user_ratings)
  
  # make sure rating matrix has correct data types
  ratingmat_sample_df <- as(ratingmat_sample, "data.frame")
  ratingmat_sample_df$user <- as.numeric(ratingmat_sample_df$user)
  ratingmat_sample_df$item <- as.character(ratingmat_sample_df$item)
  # reorder rating matrix based on row number
  ratingmat_sample_df<-ratingmat_sample_df[order(as.numeric(row.names(ratingmat_sample_df))),]
  # combine user rating matrix with original ratings matrix
  rating_mat_combined <- rbind(user_ratings,ratingmat_sample_df)
  # make sure rating matrix has correct data types
  rating_mat_combined$user <- as.numeric(rating_mat_combined$user)
  rating_mat_combined$item <- as.character(rating_mat_combined$item)
  rating_mat_combined_rrm <- as(rating_mat_combined, "realRatingMatrix")
  
  #create new model that combines original data with user data
  hybrid_user_model <- HybridRecommender(
      Recommender(data = getData(anime_eval_split_allbut5, "train"), method = "IBCF", param = list(normalize = "center", method="Cosine", k=50)),
      Recommender(data = getData(anime_eval_split_allbut5, "train"), method = "UBCF", param = list(normalize = "center", method="Cosine", nn=50)),
      Recommender(data = getData(anime_eval_split_allbut5, "train"), method = "SVD"),
      Recommender(data = getData(anime_eval_split_allbut5, "train"), method = "POPULAR"),
      weights = c(0.4, 0.2, 0.2, 0.2))
  
  # the first row of rating_mat_combined_rrm is the user
  hybrid_recom <- predict(hybrid_user_model, rating_mat_combined_rrm[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(hybrid_recom,"list"))))
}
