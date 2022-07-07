library(leaflet)
library(dplyr)
library(plyr)
library(ggplot2)
library(tidyr)
library(ggpubr)
library(recommenderlab)
library(data.table)
library(reshape2)
library(Matrix)
library(factoextra)
library(knitr)
library(kableExtra)
library(stringr)
load("anime_eval_schemes.rda")
load("ibcf_models.rda")
load("ubcf_models.rda")
load("als_models.rda")
load("svd_models.rda")
load("hybrid_models.rda")
load("prediction_models.rda")

getAnimeNames <- function(df) {
  # function that takes as input a list of MAL_ID, 
  # and returns a data frame containing the corresponding English names
  out = as.data.frame(matrix(ncol=1,nrow=5))
  names(out)[1] <- 'Anime Name'
  for(i in 1:nrow(df)) {
    value <- df[[i,1]]
    row <- which(anime_df[["MAL_ID"]]==value)
    out[i,1] <- anime_df[row,5]
  }
  return(out)
}

get_ibcf_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df[(which(anime_df[,5]== anime_1)),1]
  anime_2_id <- anime_df[(which(anime_df[,5]== anime_2)),1]
  anime_3_id <- anime_df[(which(anime_df[,5]== anime_3)),1]
  anime_4_id <- anime_df[(which(anime_df[,5]== anime_4)),1]
  anime_5_id <- anime_df[(which(anime_df[,5]== anime_5)),1]
  
  # create data frame using user input anime
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  # set all ratings equal to 8
  rating <- c(8,8,8,8,8)
  user_ratings <- data.frame(item, rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings <- as.data.frame(user_ratings)
  
  # create user-anime matrix from original data
  temp1 <- dcast(ratingmat_sample_df, user~item, value.var = "rating", na.rm=FALSE)
  # remove userid column
  temp2 <- temp1[,-1]
  # create new matrix that has same number of rows as user-anime matrix
  user_matrix = matrix(NA,1,3140)
  # copy column names of user-anime matrix
  colnames(user_matrix)=colnames(temp2)
  # copy values from user data frame into new matrix
  user_matrix[1, user_ratings$item] = user_ratings$rating
  # create predictor using ibcf_model and user_matrix
  ibcf_recom<-predict(ibcf_model2, as(user_matrix, "realRatingMatrix"),n=5)
  return(getAnimeNames(as.data.frame(as(ibcf_recom,"list"))))
}

get_ubcf_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  # create user rating matrix using user input anime
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(9,8,9,9,8)
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
  user_ubcf_model <- Recommender(rating_mat_combined_rrm, method = "UBCF")
  # the first row of rating_mat_combined_rrm is the user
  ubcf_recom <- predict(user_ubcf_model, rating_mat_combined_rrm[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(ubcf_recom,"list"))))
}

get_als_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df[(which(anime_df[,5]== anime_1)),1]
  anime_2_id <- anime_df[(which(anime_df[,5]== anime_2)),1]
  anime_3_id <- anime_df[(which(anime_df[,5]== anime_3)),1]
  anime_4_id <- anime_df[(which(anime_df[,5]== anime_4)),1]
  anime_5_id <- anime_df[(which(anime_df[,5]== anime_5)),1]
  
  # create data frame using user input anime
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  # set all ratings equal to 8
  rating <- c(8,8,8,8,8)
  user_ratings <- data.frame(item, rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings <- as.data.frame(user_ratings)
  
  # create user-anime matrix from original data
  temp1 <- dcast(ratingmat_sample_df, user~item, value.var = "rating", na.rm=FALSE)
  # remove userid column
  temp2 <- temp1[,-1]
  # create new matrix that has same number of rows as user-anime matrix
  user_matrix = matrix(NA,1,3140)
  # copy column names of user-anime matrix
  colnames(user_matrix)=colnames(temp2)
  # copy values from user data frame into new matrix
  user_matrix[1, user_ratings$item] = user_ratings$rating
  # create predictor using ibcf_model and user_matrix
  als_recom<-predict(als_model2, as(user_matrix, "realRatingMatrix"),n=5)
  return(getAnimeNames(as.data.frame(as(als_recom,"list"))))
}

get_svd_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  # create user rating matrix using user input anime
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(9,8,9,9,8)
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
  user_svd_model <- Recommender(rating_mat_combined_rrm, method = "SVD")
  # the first row of rating_mat_combined_rrm is the user
  svd_recom <- predict(user_svd_model, rating_mat_combined_rrm[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(svd_recom,"list"))))
}

get_hybrid_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5) {
  
  # find corresponding MAL_ID for Anime
  anime_1_id <- anime_df[(which(anime_df[,5]== anime_1)),1]
  anime_2_id <- anime_df[(which(anime_df[,5]== anime_2)),1]
  anime_3_id <- anime_df[(which(anime_df[,5]== anime_3)),1]
  anime_4_id <- anime_df[(which(anime_df[,5]== anime_4)),1]
  anime_5_id <- anime_df[(which(anime_df[,5]== anime_5)),1]
  
  # create data frame using user input anime
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  # set all ratings equal to 8
  rating <- c(8,9,8,9,8)
  user_ratings <- data.frame(item, rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings <- as.data.frame(user_ratings)
  
  # create user-anime matrix from original data
  temp1 <- dcast(ratingmat_sample_df, user~item, value.var = "rating", na.rm=FALSE)
  # remove userid column
  temp2 <- temp1[,-1]
  # create new matrix that has same number of rows as user-anime matrix
  user_matrix = matrix(NA,1,3140)
  # copy column names of user-anime matrix
  colnames(user_matrix)=colnames(temp2)
  # copy values from user data frame into new matrix
  user_matrix[1, user_ratings$item] = user_ratings$rating
  # create predictor using ibcf_model and user_matrix
  hybrid_recom<-predict(hybrid_model2, as(user_matrix, "realRatingMatrix"),n=5)
  return(getAnimeNames(as.data.frame(as(hybrid_recom,"list"))))
}