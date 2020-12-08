# AirBNB Price Prediction

## Project Goal ## 

*To provide a predictive model for price of an AirBNB listing based on a combination of the most significant variables.*

To do this, a dataset was provided with over 70 variables and 6500 records of its anlaysis data. The dataset consisted of information varying from account specific information for the renter/ tenant as well as apartment specific details for the listing. 

Amongst the most significant variables that were used in the final model were: 
- Neighborhood
- Reviews
- Room Type

## Analysis Done ## 

- Ways of identifying correlation: 

*Lasso:* This was a very useful technique that helped me identify a significant number of variables which would ultimately be the most important in my model:
        
        - Zipcode: By using the lasso model to run with just the zipcode variable, I identified which zip codes were 
        most significant importance to price. I then tested performance of all non-0 coefficient zip codes provided by
        the lasso model to identify which coefficients had the highest performance. I identified that  the variables 
        above a 20 coefficient were most significant, therefore took all zipcodes with a higher coefficient than 20 and
        made them into a separate logical variable (as a numeric data type).  
        - Cleaning_fee: When running a lasso model on several testing iterations, it identified cleaning_fee as a very 
        important variable in the model. This variable was a very significant one with the only complication being that
        there were NA’s within the variables. I made these 0 as many apartments did not have an associated cleaning fee
        (generally, for NA’s, I tried to input the median or mean value of the variable). 

- Different models used for predicting final model: 

*Random forest:* Through the majority of the project, I found the best results with random forest model. The formula was extremely flexible with various data types and consistently provided amongst the best performance results. In order to get a better visual understanding of a tree structure, I would use my highest performing variables, create a model and plot decision trees using rpart. I would often times take the information gained through lasso feature selection or through corrplots and incorporate them within random forest. Random forest models with the same variables performed approximately a half an RMSE point better than models generally considered to be more powerful such as boosting. One limitation which I came across first using Random Forest was the computational limitation of my workstation. I would generally test the performance of a new set of variables with 100 trees, and then run to get optimal results with 1000 trees, as anything above that level would not be able to be computed by the resources provided in the Lenovo Yoga i5 2 core laptop that I utilized.

*Boosting/ XGBoost:* While different boosting methods did not give me the best RMSE, I had gotten a sense of the effectiveness of these models, and these approaches is what I want to spend most time on learning more from what was covered this semester. One experience that shocked me was a gbm boosting model on 10,000 trees took more than 12 hours to complete. 
When I tried XGBoost, the train and test data results were all promising, with train data always being in the low 40’s for RMSE and on the test it was consistently in the 50’s. From knowing the general theory around how boosting works (i.e that it sequentially runs forest models and improves on the error of the previous), boosting models should show an improvement off of random forest, therefore I would like to continue familiarizing my understanding of various hyperparameters applied. 

## Results ## 

## Notes and Recommendations ##

