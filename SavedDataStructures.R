# This file contains the code for data structures that we use in other .r or .rmd files.
# These computations take a long time, and its more efficient to save them as data structures,
# and simply load them into the other files.

# Evaluation Schemes
anime_eval_split_min <- evaluationScheme(data = ratingmat_sample,
                                         method = "split",
                                         train = 0.8,
                                         given = min(rowCounts(ratingmat_sample)),
                                         goodRating = 7)
anime_eval_split_allbut5 <- evaluationScheme(data = ratingmat_sample,
                                             method = "split",
                                             train = 0.8,
                                             given = -5, 
                                             goodRating = 7) 
anime_eval_cross_allbut5 <- evaluationScheme(data = ratingmat_sample,
                                             method = "cross",
                                             k=4,
                                             given = -5, 
                                             goodRating = 7)
anime_eval_cross_min <- evaluationScheme(data = ratingmat_sample,
                                         method = "cross", 
                                         k=4,
                                         given = min(rowCounts(ratingmat_sample)),
                                         goodRating = 7)
save(anime_eval_split_min, anime_eval_split_allbut5,anime_eval_cross_allbut5, anime_eval_cross_min,file="anime_eval_schemes.rda")
load("anime_eval_schemes.rda")

# Calculating Errors for different K-Values for IBCF using anime_eval_split_min
error_10 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=10)), 
                                           type="ratings"))
error_20 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=20)), 
                                           type="ratings"))
error_30 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=30)), 
                                           type="ratings"))
error_40 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=40)), 
                                           type="ratings"))
error_50 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=50)), 
                                           type="ratings"))
error_60 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=60)), 
                                           type="ratings"))
error_70 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=70)), 
                                           type="ratings"))
error_80 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=80)), 
                                           type="ratings"))
error_90 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=90)), 
                                           type="ratings"))
error_100 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                        method = "IBCF",
                                                        param = list(
                                                          normalize = "center",
                                                          method="Cosine",
                                                          k=100)), 
                                            type="ratings"))
kvalue_error_IBCF_split_min <- as.data.frame(rbind(error_10,error_20,error_30,error_40,error_50,error_60,error_70,error_80,error_90,error_100))
kvalue_error_IBCF_split_min$k_value <- c(10,20,30,40,50,60,70,80,90,100)
save(kvalue_error_IBCF_split_min,file="kvalue_error_IBCF_split_min.rda")

# Calculating Errors for different nn-values for UBCF using anime_eval_split_min
error_10 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=10)), 
                                           type="ratings"))
error_20 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=20)), 
                                           type="ratings"))
error_30 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=30)), 
                                           type="ratings"))
error_40 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=40)),
                                           type="ratings"))
error_50 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=50)), 
                                           type="ratings"))
error_60 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=60)),
                                           type="ratings"))
error_70 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=70)), 
                                           type="ratings"))
error_80 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=80)),
                                           type="ratings"))
error_90 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=90)),
                                           type="ratings"))
error_100 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_min,"train"), 
                                                        method = "UBCF",
                                                        param = list(
                                                          normalize = "center",
                                                          method="Cosine",
                                                          nn=100)),
                                            type="ratings"))
nn_error_UBCF_split_min <- as.data.frame(rbind(error_10,error_20,error_30,error_40,error_50,error_60,error_70,error_80,error_90,error_100))
nn_error_UBCF_split_min$nn_number <- c(10,20,30,40,50,60,70,80,90,100)
save(nn_error_UBCF_split_min,file="nn_error_UBCF_split_min.rda")

# Calculating Errors for different K-Values for IBCF using anime_eval_split_allbut5
error_10 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=10)),
                                           type="ratings"))
error_20 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=20)),
                                           type="ratings"))
error_30 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=30)),
                                           type="ratings"))
error_40 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=40)),
                                           type="ratings"))
error_50 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=50)),
                                           type="ratings"))
error_60 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=60)),
                                           type="ratings"))
error_70 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=70)),
                                           type="ratings"))
error_80 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=80)),
                                           type="ratings"))
error_90 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "IBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         k=90)),
                                           type="ratings"))
error_100 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                        method = "IBCF",
                                                        param = list(
                                                          normalize = "center",
                                                          method="Cosine",
                                                          k=100)),
                                            type="ratings"))
kvalue_error_IBCF_split_allbut5 <- as.data.frame(rbind(error_10,error_20,error_30,error_40,error_50,error_60,error_70,error_80,error_90,error_100))
kvalue_error_IBCF_split_allbut5$k_value <- c(10,20,30,40,50,60,70,80,90,100)
save(kvalue_error_IBCF_split_allbut5,file="kvalue_error_IBCF_split_allbut5.rda")

# Calculating Errors for different nn-values for UBCF using anime_eval_split_allbut5
error_10 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=10)),
                                           type="ratings"))
error_20 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=20)),
                                           type="ratings"))
error_30 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=30)),
                                           type="ratings"))
error_40 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=40)),
                                           type="ratings"))
error_50 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=50)),
                                           type="ratings"))
error_60 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=60)),
                                           type="ratings"))
error_70 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=70)),
                                           type="ratings"))
error_80 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=80)),
                                           type="ratings"))
error_90 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                       method = "UBCF",
                                                       param = list(
                                                         normalize = "center",
                                                         method="Cosine",
                                                         nn=90)),
                                           type="ratings"))
error_100 <- calcPredictionAccuracy(predict(Recommender(getData(anime_eval_split_allbut5,"train"), 
                                                        method = "UBCF",
                                                        param = list(
                                                          normalize = "center",
                                                          method="Cosine",
                                                          nn=100)), 
                                            type="ratings"))
nn_error_UBCF_split_allbut5 <- as.data.frame(rbind(error_10,error_20,error_30,error_40,error_50,error_60,error_70,error_80,error_90,error_100))
nn_error_UBCF_split_allbut5$nn_number <- c(10,20,30,40,50,60,70,80,90,100)
save(kvalue_error_IBCF_split_min, kvalue_error_IBCF_split_allbut5, nn_error_UBCF_split_allbut5, nn_error_UBCF_split_min,file="kvalue_nn_errors.rda")
