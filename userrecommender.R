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

getAnimeNames <- function(df) {
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
  
  #find corresponding row for Anime
  anime_1_id <- anime_df[(which(anime_df[,5]== anime_1)),1]
  anime_2_id <- anime_df[(which(anime_df[,5]== anime_2)),1]
  anime_3_id <- anime_df[(which(anime_df[,5]== anime_3)),1]
  anime_4_id <- anime_df[(which(anime_df[,5]== anime_4)),1]
  anime_5_id <- anime_df[(which(anime_df[,5]== anime_5)),1]
  
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(7,7,7,7,7)
  user_ratings <- data.frame(item, rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings<-as.data.frame(user_ratings)
  
  temp1 <- dcast(ratingmat_sample_df, user~item, value.var = "rating", na.rm=FALSE)
  temp2 <- temp1[,-1]
  tmp = matrix(NA,1,3140)
  colnames(tmp)=colnames(temp2)
  tmp[1, user_ratings$item] = user_ratings$rating
  
  #user_rating_mat <- rbind(user_ratings,ratingmat_sample_df)
  #user_rating_mat2 <- as(user_rating_mat, "realRatingMatrix")
  #user_rating_mat3 <- normalize(user_rating_mat2)
  #row_value <- as.numeric(which(user_rating_mat3@data@Dimnames[[1]]=="9"))
  #user_recommend_popular <- Recommender(user_rating_mat3, method = "Popular")
  recom<-predict(ibcf_model, as(tmp, "realRatingMatrix"),n=5)
  return(getAnimeNames(as.data.frame(as(recom,"list"))))
}

get_ubcf_recs <- function(anime_1,anime_2,anime_3,anime_4,anime_5) {
  
  #find corresponding row for Anime
  anime_1_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_1)),1]
  anime_2_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_2)),1]
  anime_3_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_3)),1]
  anime_4_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_4)),1]
  anime_5_id <- anime_df_sample[(which(anime_df_sample[,5]== anime_5)),1]
  
  
  user <- c(9,9,9,9,9)
  item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  rating <- c(9,8,9,9,8)
  user_ratings <- data.frame(user,item,rating)
  user_ratings$item <- as.character(unlist(user_ratings$item))
  user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  user_ratings<-as.data.frame(user_ratings)
  ratingmat_sample_df <- as(ratingmat_sample, "data.frame")
  ratingmat_sample_df$user <- as.numeric(ratingmat_sample_df$user)
  ratingmat_sample_df$item <- as.character(ratingmat_sample_df$item)
  ratingmat_sample_df<-ratingmat_sample_df[order(as.numeric(row.names(ratingmat_sample_df))),]
  user_rating_mat5 <- rbind(user_ratings,ratingmat_sample_df)
  user_rating_mat5$user <- as.numeric(user_rating_mat5$user)
  user_rating_mat5$item <- as.character(user_rating_mat5$item)
  user_rating_mat6<- as(user_rating_mat5, "realRatingMatrix")
  
  
  user_ubcf_model <- Recommender(user_rating_mat6, method = "UBCF")
  recom<-predict(user_ubcf_model, user_rating_mat6[1] ,n=5)
  return(getAnimeNames(as.data.frame(as(recom,"list"))))
  
  # item <- c(anime_1_id, anime_2_id, anime_3_id, anime_4_id, anime_5_id)
  # rating <- c(7,8,9,8,9)
  # user_ratings <- data.frame(item, rating)
  # user_ratings$item <- as.character(unlist(user_ratings$item))
  # user_ratings$rating <- as.numeric(unlist(user_ratings$rating))
  # user_ratings<-as.data.frame(user_ratings)
  # 
  # temp1 <- dcast(ratingmat_sample_df, user~item, value.var = "rating", na.rm=FALSE)
  # tmp = matrix(NA,1,3140)
  # temp2 <- temp1[,-1]
  # colnames(tmp)=colnames(temp2)
  # tmp[1, user_ratings$item] = user_ratings$rating
  # user_rating_mat <- rbind(tmp,temp2)
  # user_rating_mat <- as.matrix(user_rating_mat)
  # user_rating_mat <- as(user_rating_mat,"realRatingMatrix")
  # user_ubcf_model <- Recommender(user_rating_mat, method = "UBCF",param=list(method="Cosine",nn=30))
  # recom<-predict(user_ubcf_model, as(tmp, "realRatingMatrix"),n=5)
  # return(getAnimeNames(as.data.frame(as(recom,"list"))))
}