library(tidyr)
#install.packages('tidyr')
library(dplyr)
#install.packages('dplyr')
library(ggplot2)
#install.packages('ggplot2')
library(caTools)
#install.packages('caTools')
library(randomForest)
#install.packages('randomForest')
library(psych)
#install.packages('psych')
library(stringr)
#install.packages('stringr')
library(qdapTools)
#install.packages('qdapTools')
library(ROCR)
#install.packages('ROCR')
library(car)
#install.packages('car')

scoringData <- read.csv("scoringData.csv", stringsAsFactors = F)
dataset <- read.csv("analysisData.csv", stringsAsFactors = F)
split = sample.split(dataset$price, SplitRatio = 0.75)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

#zipcode factor
dataset$zipcode <- as.factor(dataset$zipcode)
training_set$zipcode <- as.factor(training_set$zipcode)
test_set$zipcode <- as.factor(test_set$zipcode)
scoringData$zipcode <- as.factor(scoringData$zipcode)

#room type
dataset$room_type <- as.factor(dataset$room_type)
training_set$room_type <- as.factor(training_set$room_type)
test_set$room_type <- as.factor(test_set$room_type)
scoringData$room_type <- as.factor(scoringData$room_type)

#neighborhood cleansed factor
dataset$neighbourhood_cleansed <- as.factor(dataset$neighbourhood_cleansed)
training_set$neighbourhood_cleansed <- as.factor(training_set$neighbourhood_cleansed)
test_set$neighbourhood_cleansed <- as.factor(test_set$neighbourhood_cleansed)
scoringData$neighbourhood_cleansed <- as.factor(scoringData$neighbourhood_cleansed)


#is bus travel ready numeric
#training_set$is_business_travel_ready[is.na(training_set$is_business_travel_ready )] <- 0
#test_set$is_business_travel_ready[is.na(test_set$is_business_travel_ready )] <- 0
#scoringData$is_business_travel_ready[is.na(scoringData$is_business_travel_ready )] <- 0

dataset$is_business_travel_ready <- as.factor(dataset$is_business_travel_ready)
training_set$is_business_travel_ready <- as.factor(training_set$is_business_travel_ready)
test_set$is_business_travel_ready <- as.factor(test_set$is_business_travel_ready)
scoringData$is_business_travel_ready <- as.factor(scoringData$is_business_travel_ready)

dataset$is_business_travel_ready <- as.numeric(dataset$is_business_travel_ready)
training_set$is_business_travel_ready <- as.numeric(training_set$is_business_travel_ready)
test_set$is_business_travel_ready <- as.numeric(test_set$is_business_travel_ready)
scoringData$is_business_travel_ready <- as.numeric(scoringData$is_business_travel_ready)


#is location exact factor
#training_set$is_location_exact[is.na(training_set$is_location_exact)] <- 1
#test_set$is_location_exact[is.na(test_set$is_location_exact)] <- 1
#scoringData$is_location_exact[is.na(scoringData$is_location_exact)] <- 1


dataset$is_location_exact <- as.factor(dataset$is_location_exact)
training_set$is_location_exact <- as.factor(training_set$is_location_exact)
test_set$is_location_exact <- as.factor(test_set$is_location_exact)
scoringData$is_location_exact <- as.factor(scoringData$is_location_exact)

dataset$is_location_exact <- as.numeric(dataset$is_location_exact)
training_set$is_location_exact <- as.numeric(training_set$is_location_exact)
test_set$is_location_exact <- as.numeric(test_set$is_location_exact)
scoringData$is_location_exact <- as.numeric(scoringData$is_location_exact)

#host is superhost
dataset$host_is_superhost <- as.factor(dataset$host_is_superhost)
training_set$host_is_superhost <- as.factor(training_set$host_is_superhost)
test_set$host_is_superhost <- as.factor(test_set$host_is_superhost)
scoringData$host_is_superhost <- as.factor(scoringData$host_is_superhost)

dataset$host_is_superhost <- as.numeric(dataset$host_is_superhost)
training_set$host_is_superhost <- as.numeric(training_set$host_is_superhost)
test_set$host_is_superhost <- as.numeric(test_set$host_is_superhost)
scoringData$host_is_superhost <- as.numeric(scoringData$host_is_superhost)


#Amenities
dataset$amenities <- as.factor(dataset$amenities)
training_set$amenities <- as.factor(training_set$amenities)
test_set$amenities <- as.factor(test_set$amenities)
scoringData$amenities <- as.factor(scoringData$amenities)

#Cancelation policy
dataset$cancellation_policy <- as.factor(dataset$cancellation_policy)
training_set$cancellation_policy <- as.factor(training_set$cancellation_policy)
test_set$cancellation_policy <- as.factor(test_set$cancellation_policy)
scoringData$cancellation_policy <- as.factor(scoringData$cancellation_policy)

#Cleaning fee
dataset$cleaning_fee[is.na(dataset$cleaning_fee)] <- 0
training_set$cleaning_fee[is.na(training_set$cleaning_fee)] <- 0
test_set$cleaning_fee[is.na(test_set$cleaning_fee)] <- 0
scoringData$cleaning_fee[is.na(scoringData$cleaning_fee)] <- 0

#Security Deposit
dataset$security_deposit[is.na(dataset$security_deposit)] <- 0
training_set$security_deposit[is.na(training_set$security_deposit)] <- 0
test_set$security_deposit[is.na(test_set$security_deposit)] <- 0
scoringData$security_deposit[is.na(scoringData$security_deposit)] <- 0

#property type
dataset$property_type <- as.factor(dataset$property_type)
training_set$property_type <- as.factor(training_set$property_type)
test_set$property_type <- as.factor(test_set$property_type)
scoringData$property_type <- as.factor(scoringData$property_type)

#Room type
rmtp <- training_set$room_type == "Entire home/apt"
rmtp <- as.numeric(rmtp)
training_set2 <- cbind(training_set, rmtp)

rmtp <- test_set$room_type == "Entire home/apt"
rmtp <- as.numeric(rmtp)
test_set2 <- cbind(test_set, rmtp)

rmtp <- as.numeric(scoringData$room_type == "Entire home/apt")
scoringData2 <- cbind(scoringData, rmtp)

rmtp <- as.numeric(dataset$room_type == "Entire home/apt")
dataset2 <- cbind(dataset, rmtp)

#reviewdataset
revsum <- training_set2$review_scores_cleanliness * training_set2$review_scores_location * training_set2$review_scores_rating
training_set2 <- cbind(training_set2, revsum)

revsum <- test_set2$review_scores_cleanliness * test_set2$review_scores_location * test_set2$review_scores_rating
test_set2 <- cbind(test_set2, revsum)

revsum <- scoringData2$review_scores_cleanliness * scoringData2$review_scores_location * scoringData2$review_scores_rating
scoringData2 <- cbind(scoringData2, revsum)

revsum <- dataset2$review_scores_cleanliness * dataset2$review_scores_location * dataset2$review_scores_rating
dataset2 <- cbind(dataset2, revsum)

#KeyDes
keywords <- c("view",
              "balcony",
              "gorgeous",
              "amazing",
              "clean",
              "beautiful",
              "walking distance",
              "brownstone",
              "jacuzzi", "gym",
              "king-size",
              "lovely","renovated",
              "pool","massive",
              "roofdeck","exquisite",
              "breathtaking","boutique",
              "view|
              balcony|
              gorgeous|
              amazing|
              clean|
              beautiful|
              walking distance|
              brownstone|
              jacuzzi|gym|
              king-size|lovely|renovated|
              pool|massive|roofdeck|exquisite|
              breathtaking|boutique")

keydes <- as.numeric(grepl(keywords,training_set2$description))
training_set2 <- cbind(training_set2, keydes)

keydes <- as.numeric(grepl(keywords,test_set2$description))
test_set2 <- cbind(test_set2, keydes)

keydes <- as.numeric(grepl(keywords,scoringData2$description))
scoringData2 <- cbind(scoringData2, keydes)

keydes <- as.numeric(grepl(keywords,dataset2$description))
dataset2 <- cbind(dataset2, keydes)

#ammenities

amen <- c("Washer", "Dryer","Family/kid friendly", "Suitable for events",
          'Indoor fireplace', 'Gym', 'Garden or backyard', 'Hot tub', 'Front desk/doorperson', 'Doorman',
          'Pool','BBQ grill', 'Garden or backyard','Pets allowed',
          'Patio or balcony','Washer|Dryer|Family/kid friendly|Suitable for events|Indoor fireplace|Gym|
          Garden or backyard|Hot tub|Front desk/doorperson|Patio or balcony|Doorman|Pool|BBQ grill|Garden or backyard|
          Pets allowed')


amen <- as.numeric(grepl(amen,training_set2$amenities))
training_set2 <- cbind(training_set2, amen)

amen <- as.numeric(grepl(amen,test_set2$amenities))
test_set2 <- cbind(test_set2, amen)

amen <- as.numeric(grepl(amen,scoringData2$amenities))
scoringData2 <- cbind(scoringData2, amen)

amen <- as.numeric(grepl(amen,dataset2$amenities))
dataset2 <- cbind(dataset2, amen)

#cancellation policy
canc <- as.numeric(training_set2$cancellation_policy == "super_strict_30"| training_set2$cancellation_policy == "super_strict_60")
training_set2 <- cbind(training_set2, canc)
canc <- as.numeric(test_set2$cancellation_policy == "super_strict_30"| test_set2$cancellation_policy == "super_strict_60")
test_set2 <- cbind(test_set2, canc)
canc <- as.numeric(scoringData2$cancellation_policy == "super_strict_30"| scoringData2$cancellation_policy == "super_strict_60")
scoringData2 <- cbind(scoringData2, canc)
canc <- as.numeric(dataset2$cancellation_policy == "super_strict_30"| dataset2$cancellation_policy == "super_strict_60")
dataset2 <- cbind(dataset2, canc)

#Bedroom + Beds
training_set2$beds[is.na(training_set2$beds )] <- 1
test_set2$beds[is.na(test_set2$beds )] <- 1
scoringData2$beds[is.na(scoringData2$beds )] <- 1
dataset2$beds[is.na(dataset2$beds )] <- 1

bedadd <- training_set2$bedrooms + training_set2$beds
training_set2 <- cbind(training_set2, bedadd)

bedadd <- test_set2$bedrooms + test_set2$beds
test_set2 <- cbind(test_set2, bedadd)

bedadd <- scoringData2$bedrooms + scoringData2$beds
scoringData2 <- cbind(scoringData2, bedadd)

bedadd <- dataset2$bedrooms + dataset2$beds
dataset2 <- cbind(dataset2, bedadd)

#Host neighborhood cleaned
training_set2 <- training_set2%>%group_by(neighbourhood_cleansed)%>%mutate(neighclean=round(mean(price),0))%>%ungroup()
dataset2 <- dataset2%>%group_by(neighbourhood_cleansed)%>%mutate(neighclean=round(mean(price),0))%>%ungroup()
test_set2 <- test_set2%>%group_by(neighbourhood_cleansed)%>%mutate(neighclean=round(mean(price),0))%>%ungroup()

neighclean <- as.numeric(" ")
scoringData2 <- cbind(scoringData2,neighclean)
lookupdf <- aggregate(neighclean~ neighbourhood_cleansed,dataset2[,c(40,103)],mean)
scoringData2$neighclean <- lookup_e(scoringData2$neighbourhood_cleansed,lookupdf[,c(1:2)])


#zipcode logical 
zip <- training_set2$zipcode==	"10007"	|	#	187.43
  training_set2$zipcode==	"10017"	|	#	106.73
  training_set2$zipcode==	"10014"	|	#	98.44
  training_set2$zipcode==	"10013"	|	#	94.54
  training_set2$zipcode==	"10001"	|	#	92.13
  training_set2$zipcode==	"10011"	|	#	84.17
  training_set2$zipcode==	'10010'	|	#	82.97
  training_set2$zipcode==	'10012'	|	#	80.76
  training_set2$zipcode==	"10270"	|	#	80.45
  training_set2$zipcode==	"10019"	|	#	77.72
  training_set2$zipcode==	"10016"	|	#	76.29
  training_set2$zipcode==	"10022"	|	#	75.65
  training_set2$zipcode==	"10036"	|	#	72.35
  training_set2$zipcode==	"10003"	|	#	68.50
  training_set2$zipcode==	"10018"	|	#	64.02
  training_set2$zipcode==	"11461"	|	#	63.99
  training_set2$zipcode==	"10023"	|	#	63.31
  training_set2$zipcode==	"10006"	|	#	56.34
  training_set2$zipcode==	"10282"	|	#	56.27
  training_set2$zipcode==	"10024"	|	#	47.35
  training_set2$zipcode==	"10069"	|	#	46.36
  training_set2$zipcode==	"10065"		#	42.35
training_set2 <- cbind(training_set2, zip)

zip <- test_set2$zipcode==	"10007"	|	#	187.43
  test_set2$zipcode==	"10017"	|	#	106.73
  test_set2$zipcode==	"10014"	|	#	98.44
  test_set2$zipcode==	"10013"	|	#	94.54
  test_set2$zipcode==	"10001"	|	#	92.13
  test_set2$zipcode==	"10011"	|	#	84.17
  test_set2$zipcode==	'10010'	|	#	82.97
  test_set2$zipcode==	'10012'	|	#	80.76
  test_set2$zipcode==	"10270"	|	#	80.45
  test_set2$zipcode==	"10019"	|	#	77.72
  test_set2$zipcode==	"10016"	|	#	76.29
  test_set2$zipcode==	"10022"	|	#	75.65
  test_set2$zipcode==	"10036"	|	#	72.35
  test_set2$zipcode==	"10003"	|	#	68.50
  test_set2$zipcode==	"10018"	|	#	64.02
  test_set2$zipcode==	"11461"	|	#	63.99
  test_set2$zipcode==	"10023"	|	#	63.31
  test_set2$zipcode==	"10006"	|	#	56.34
  test_set2$zipcode==	"10282"	|	#	56.27
  test_set2$zipcode==	"10024"	|	#	47.35
  test_set2$zipcode==	"10069"	|	#	46.36
  test_set2$zipcode==	"10065"		#	42.35
test_set2 <- cbind(test_set2, zip)  

zip <- scoringData2$zipcode==	"10007"	|	#	187.43
  scoringData2$zipcode==	"10017"	|	#	106.73
  scoringData2$zipcode==	"10014"	|	#	98.44
  scoringData2$zipcode==	"10013"	|	#	94.54
  scoringData2$zipcode==	"10001"	|	#	92.13
  scoringData2$zipcode==	"10011"	|	#	84.17
  scoringData2$zipcode==	'10010'	|	#	82.97
  scoringData2$zipcode==	'10012'	|	#	80.76
  scoringData2$zipcode==	"10270"	|	#	80.45
  scoringData2$zipcode==	"10019"	|	#	77.72
  scoringData2$zipcode==	"10016"	|	#	76.29
  scoringData2$zipcode==	"10022"	|	#	75.65
  scoringData2$zipcode==	"10036"	|	#	72.35
  scoringData2$zipcode==	"10003"	|	#	68.50
  scoringData2$zipcode==	"10018"	|	#	64.02
  scoringData2$zipcode==	"11461"	|	#	63.99
  scoringData2$zipcode==	"10023"	|	#	63.31
  scoringData2$zipcode==	"10006"	|	#	56.34
  scoringData2$zipcode==	"10282"	|	#	56.27
  scoringData2$zipcode==	"10024"	|	#	47.35
  scoringData2$zipcode==	"10069"	|	#	46.36
  scoringData2$zipcode==	"10065"		#	42.35
scoringData2 <- cbind(scoringData2, zip)  


zip <- dataset2$zipcode==	"10007"	|	#	187.43
  dataset2$zipcode==	"10017"	|	#	106.73
  dataset2$zipcode==	"10014"	|	#	98.44
  dataset2$zipcode==	"10013"	|	#	94.54
  dataset2$zipcode==	"10001"	|	#	92.13
  dataset2$zipcode==	"10011"	|	#	84.17
  dataset2$zipcode==	'10010'	|	#	82.97
  dataset2$zipcode==	'10012'	|	#	80.76
  dataset2$zipcode==	"10270"	|	#	80.45
  dataset2$zipcode==	"10019"	|	#	77.72
  dataset2$zipcode==	"10016"	|	#	76.29
  dataset2$zipcode==	"10022"	|	#	75.65
  dataset2$zipcode==	"10036"	|	#	72.35
  dataset2$zipcode==	"10003"	|	#	68.50
  dataset2$zipcode==	"10018"	|	#	64.02
  dataset2$zipcode==	"11461"	|	#	63.99
  dataset2$zipcode==	"10023"	|	#	63.31
  dataset2$zipcode==	"10006"	|	#	56.34
  dataset2$zipcode==	"10282"	|	#	56.27
  dataset2$zipcode==	"10024"	|	#	47.35
  dataset2$zipcode==	"10069"	|	#	46.36
  dataset2$zipcode==	"10065"		#	42.35
dataset2 <- cbind(dataset2, zip)  

dataset2$zip <- as.numeric(dataset2$zip)
training_set2$zip <- as.numeric(training_set2$zip)
test_set2$zip <- as.numeric(test_set2$zip)
scoringData2$zip <- as.numeric(scoringData2$zip)

#Parameters used in final model
training_set3 <- select(training_set2, price, room_type, property_type, bathrooms, cleaning_fee, accommodates,
                        bedrooms, longitude, amen, availability_365, latitude, revsum, keydes, zip,
                        availability_30, extra_people, minimum_nights, security_deposit, guests_included, neighclean)

test_set3 <- select(test_set2, price, room_type, property_type, bathrooms, cleaning_fee, accommodates,
                    bedrooms, longitude, amen, availability_365, latitude, revsum, keydes, zip,
                    availability_30, extra_people, minimum_nights, security_deposit, guests_included, neighclean)

scoring_set3 <- select(scoringData2,room_type, property_type, bathrooms, cleaning_fee, accommodates,
                       bedrooms, longitude, amen, availability_365, latitude, revsum, keydes, zip,
                       availability_30, extra_people, minimum_nights, security_deposit, guests_included, neighclean)

dataset3 <- select(dataset2, price, room_type, property_type, bathrooms, cleaning_fee, accommodates,
                   bedrooms, longitude, amen, availability_365, latitude, revsum, keydes, zip,
                   availability_30, extra_people, minimum_nights, security_deposit, guests_included, neighclean)

levels(test_set3$room_type) <- levels(training_set3$room_type)
levels(test_set3$property_type) <- levels(training_set3$property_type)
levels(scoring_set3$property_type) <- levels(training_set3$property_type)
levels(scoring_set3$room_type) <- levels(training_set3$room_type)

#Random Forest
library(randomForest)
library(ranger)
forestmodel = randomForest(price ~ ., data=training_set3, ntree=100)
pred = predict(forestmodel, newdata = test_set3)
rmse = sqrt(mean((pred-test_set3$price)^2))
rmse

predscor = predict(forestmodel, newdata = scoring_set3)

#Charts

#Corrplot
library(corrplot)
str(training_set3)
corrvar <- select(dataset3, price, bathrooms, cleaning_fee, accommodates, bedrooms, longitude, amen, availability_365,
                  latitude, revsum, keydes, zip, availability_30, extra_people, minimum_nights, security_deposit,
                  guests_included, neighclean)
corrplot(cor(corrvar[,-18]),method = 'square',type = 'lower',diag = F)

#Importance Variables

imp <- varImpPlot(forestmodel, sort=TRUE, n.var=min(11, nrow(forestmodel$importance)),
                  type=NULL, class=NULL, scale=TRUE)
library(dplyr)
imp <- as.data.frame(imp)
imp$varnames <- rownames(imp) # row names to column
rownames(imp) <- NULL  

library(ggplot2)
ggplot(imp, aes(x=reorder(varnames, IncNodePurity), 
                y=IncNodePurity, color = as.factor(round(scale(forestmodel$importance))),.01)) + 
  geom_point() +
  geom_segment(aes(x=varnames,xend=varnames,y=0,yend=IncNodePurity)) +
  scale_color_discrete(name="Variable Scaled Grouping") +
  ylab("Node Purity") +
  xlab("Features Used") +
  coord_flip()

forestmodel

#rpart
library(dplyr) 
library(rpart) 
library(rpart.plot) 

tree = rpart(price~., data = training_set3,cp = 5, control=rpart.control(minbucket = 5))
rpart.plot(tree)


#Lasso
x = model.matrix(price ~ .,data=dataset3)
y = dataset3$price

lassoModel = cv.glmnet(x,y, alpha=1) # Note default for alpha is 1 which corresponds to Lasso

plot.cv.glmnet(lassoModel)


