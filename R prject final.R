setwd('C:\\Desktop\\Data Science\\R\\pro')
getwd()


#loading csv data to dataframe
df<-read.csv('stroke.csv')
View(df)

#getting Familier with data
dim(df)
colnames(df)
str(df)


#checking head of the data
head(df,5)

#checking tail of the data
tail(df)

#summary
summary(df)


#for EDA above libraries installed
install.packages('tidyverse')
install.packages('funModeling')
install.packages('Hmisc')
install.packages('plotly')
install.packages('skimr')

library(plotly)
library(skimr)
library(funModeling)
library(tidyverse)
library(Hmisc)
library(naniar)
library(rpart)
library(rpart.plot)
library(infer)
library(randomForest)


#finding duplicated data
duplicated(df)
sum(duplicated((df)))


#reviewing data by structure
glimpse(df)



#drop ID column
df['id']<-NULL
df


#Q1:

#found one column containing irralavant (other) value and eliminate it
df <- df[which(df$gender!= "Other"), ]
freq(df$gender)

#Q2:
#We create an interval for age to analyze.
df$age_interval <- cut_interval(df$age, n=5)

df$glucose_interval <- cut_interval(df$avg_glucose_level, n=5)

#boxblot
df %>% boxplot(avg_glucose_level~gender, data=. , main="gender vs glucosa", col= c("pink", "blue"))

#Q3:

df %>% boxplot(age~gender, data=. , main="Age Vs Gender", col= c("pink", "blue"))

#Q4:
# The variables of hypertension, heart disease and stroke are binomial.
# we will convert them to factors
df1 <- df 
df1$hypertension <- factor(df1$hypertension,levels = c(0,1), labels = c("No", "Yes"))  
df1$heart_disease <- factor(df1$heart_disease, levels = c(0,1), labels = c("No", "Yes"))
df1$stroke_n <- df$stroke
df1$stroke <- factor(df1$stroke, levels = c(0,1), labels = c("No", "Yes"))


df1$gender_hypertension<-paste(df1$age, df1$hypertension, sep = "_")

tbl<-table(data1$hypertension)
tbl
tbl<-tbl[2:3]
tbl


# Simple Horizontal Bar Plot with Added Labels
counts <- table(df1$hypertension)
barplot(counts, main="Hypertension",ylab="Number",col = 'brown',horiz=FALSE,
        names.arg=c("Yes", "No"))




#Q5:
#The bmi variable is numeric, but due to null values we will have to handle it.

df1$bmi <- as.numeric(df1$bmi)
sum(is.na(df1$bmi))
df1$bmi %>% gg_miss_var()
df1 <- df1[which(is.na(df1$bmi)==FALSE),] 





#Q6:
# Let's check for null values. We already saw that in BMI there are. We will review the rest
is.na(df1)
sum(is.na(df1))
df1 %>% gg_miss_var()
#convert missing value to NA
df[df=='']<-NA


#Q7: 

#Relationship between BMI and Stroke
counts <- table(df1$stroke, df1$bmi)
BS<-barplot(counts, main="stroke Vs hypertension",
           xlab="stroke", col=c("darkblue","orange"),
           legend = rownames(counts),beside=TRUE)
BS

#Q8:
#Relationship age between age and Stroke
counts <- table(df1$stroke, df1$age)
sh<-barplot(counts, main="stroke Vs age",
           xlab="stroke", col=c("darkblue","red"),
           legend = rownames(counts),beside=TRUE)
sh

#Q9:
#Analysing stroke VS hypertension


df1 %>%
  select(hypertension, stroke) %>%
  table() %>%
  prop.table(margin = 1) %>%
  round(digits = 2)

#Q10:
# :Analysing stroke VS smoking status
df1%>%
  select(smoking_status, stroke) %>%
  table() %>%
  prop.table(margin = 1) %>%
  round(digits = 2) 
















