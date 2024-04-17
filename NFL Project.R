library(tidyverse)
library(mosaic)
library(HH)
library(leaps)
library(boot)
library(Rfit)

setwd("/Users/vaughn/Desktop/Data for NFL Project") #CHANGE THIS TO WHATEVER FOLDER YOU'RE USING

#First we'll get the combine file names into one place
file_names <- vector()
for(year in 2000:2022){
  file_names <- c(file_names, paste(year, "_combine.csv", sep = ""))
}

#Check to make sure the loop worked (it did!)
print(file_names)

#Now import all the files into R

#first make an empty list
data_list <- list()

for (i in 1:length(file_names)){
  
  file_path <- file_names[i]
  data_list[[i]] <- read.csv(file_path)
  data_list[[i]]$Year = 1999+i
}

# Now combine the files
combined_data <- do.call(rbind, data_list)

#Export combined data file
write.csv(combined_data, "combined_data.csv", row.names = FALSE)

#Read in receiver stats
receiver_stats <- read.csv("2022 Receiver Stats.csv")
receiver_stats$Player = receiver_stats$Name

merged_data <- merge(combined_data, receiver_stats, by = "Player", all.y = TRUE)

#Export combined data file
write.csv(merged_data, "merged_data.csv", row.names = FALSE)

summary(merged_data)

defensive_ratings <- read.csv("Defensive Ratings.csv")
defensive_ratings$Player = defensive_ratings$name

merged_defense <- merge(combined_data, defensive_ratings, by = "Player", all.y = TRUE)

write.csv(merged_defense, "merged_defense.csv", row.names = FALSE)

merged_defense$inches <- sapply(merged_defense$Ht, function(x) {
  parts <- unlist(strsplit(x, "-"))
  as.numeric(parts[1]) * 12 + as.numeric(parts[2])
})


#First, multiple linear regression
NFLData=read.csv(file=file.choose())
NFLData=na.omit(NFLData)
nrow(NFLData)

NFLData$inches <- sapply(NFLData$Ht, function(x) {
  parts <- unlist(strsplit(x, "-"))
  as.numeric(parts[1]) * 12 + as.numeric(parts[2])
})

NFLData <- NFLData[NFLData$Player != "Michael Thomas", ]
NFLData <- NFLData[NFLData$Player != "Tony Brown", ]

NFLmod1<-lm(epa~inches+Wt+X40yd+Vertical+Bench+Broad.Jump+X3Cone+Shuttle+as.factor(Year)+as.factor(Pos)+n_throws+inc_rate+int_rate,data=NFLData)
summary(NFLmod1)
vif(NFLmod1)
qqnorm(NFLmod1$residuals)
qqline(NFLmod1$residuals)
plot(NFLmod1$fitted.values,NFLmod1$residuals)
abline(0,0)

NFLmod2<-lm(epa~inches+Wt+X40yd+Vertical+Broad.Jump+X3Cone+Shuttle+as.factor(Year)+as.factor(Pos)+n_throws+inc_rate+int_rate,data=NFLData)
summary(NFLmod2)

NFLmod3<-lm(epa~inches+X40yd+Vertical+Broad.Jump+X3Cone+Shuttle+as.factor(Year)+as.factor(Pos)+n_throws+inc_rate+int_rate,data=NFLData)
summary(NFLmod3)

NFLmod4<-lm(epa~inches+X40yd+Vertical+Broad.Jump+Shuttle+as.factor(Year)+as.factor(Pos)+n_throws+inc_rate+int_rate,data=NFLData)
summary(NFLmod4)

NFLmod5<-lm(epa~inches+X40yd+Vertical+Broad.Jump+as.factor(Year)+as.factor(Pos)+n_throws+inc_rate+int_rate,data=NFLData)
summary(NFLmod5)

NFLmod6<-lm(epa~inches+X40yd+Vertical+Broad.Jump+as.factor(Year)+as.factor(Pos)+inc_rate+int_rate,data=NFLData)
summary(NFLmod6)

NFLmod7<-lm(epa~inches+X40yd+Vertical+as.factor(Year)+as.factor(Pos)+inc_rate+int_rate,data=NFLData)
summary(NFLmod7)

FinalMod<-lm(epa~inches+Vertical+as.factor(Year)+as.factor(Pos)+inc_rate+int_rate,data=NFLData)
summary(FinalMod)
vif(FinalMod)
qqnorm(FinalMod$residuals)
qqline(FinalMod$residuals)
plot(FinalMod$fitted.values,FinalMod$residuals)
abline(0,0)

FinalModNonparametric<-rfit(epa~inches+Vertical+as.factor(Year)+as.factor(Pos)+inc_rate+int_rate,data=NFLData)
summary(FinalModNonparametric)
vif(FinalMod)
qqnorm(FinalMod$residuals)
qqline(FinalMod$residuals)
plot(FinalMod$fitted.values,FinalMod$residuals)
abline(0,0)


NFLmod9<-lm(epa~inches+Wt+X40yd+Vertical+Bench+Broad.Jump+X3Cone+Shuttle+as.factor(Year)+as.factor(Pos)+n_throws,data=NFLData)
summary(NFLmod9)


#Finally, clustering algorithm!

clusterdata <- NFLData %>%
  select(inches, Wt, X40yd, Bench, Broad.Jump, X3Cone, Shuttle)

# Fitting K-Means clustering Model 
# to training dataset 
set.seed(135) # Setting seed 
kmeans.re <- kmeans(clusterdata, centers = 4, nstart = 20) 
kmeans.re 

# Cluster identification for 
# each observation 
kmeans.re$cluster 

NFLData <- NFLData %>%
  mutate(Cluster = kmeans.re$cluster)

sum((NFLData$Pos == "CB") & (NFLData$Cluster == 1)) #45 corners
sum((NFLData$Pos == "S") & (NFLData$Cluster == 1)) #4 safeties

#Group 2: 4 lineman, one defensive end (actually also grouped with offensive lineman)

sum((NFLData$Pos == "CB") & (NFLData$Cluster == 3))#9 corners
sum((NFLData$Pos == "S") & (NFLData$Cluster == 3))#21 safeties

sum((NFLData$Cluster == 4)) #36 linebackers, 1 defensive end



## Visualizing clusters 
y_kmeans <- kmeans.re$cluster 
clusplot(clusterdata[, c("Wt", "X40yd")], 
         y_kmeans, 
         lines = 0, 
         shade = TRUE, 
         color = TRUE, 
         labels = 4, 
         plotchar = FALSE, 
         span = TRUE, 
         main = paste("Cluster Groupings"), 
         xlab = 'Weight (lbs)', 
         ylab = '40 Yard Dash Time (sec)') 
