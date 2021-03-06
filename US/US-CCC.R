
#load the R packages
library(tidyverse)
library(sf)
library(tmap)
library(spData)
library(viridis)
library(lubridate)


# Read the CSV file of the confirmed cases
Confirmed<- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
# Select the newest data when I write the essay
Confirmed_Newest<- dplyr::select(Confirmed, `Province_State`, `Country_Region`, Lat, Long_,`1/7/21`)

#Select the updated data of the US
US_Newest <- Confirmed_Newest %>% 
  filter(`Country_Region`=="US") %>% 
  select(-`Country_Region`) %>% 
  rename(State=`Province_State`, Confirmed=`1/7/21`)

#Load the us states geographic data from the package spData
data(us_states)
cov_US <- left_join(us_states, US_Newest, by = c("NAME" = "State"))
nrow(cov_US)

#Set the breaks
breaks <- c(10, 5000, 800000)

##use tmap functions to plot the map
tm_shape(cov_US) +
  tm_polygons(border.col="white", 
              lwd=2, 
              col="Confirmed", 
              style = "cont",
              breaks=breaks, 
              title="Confirmed rate", 
              palette=viridis(n=5, direction=-1, option="A")) +
  tm_legend(position=c("left", "bottom"), 
            legend.title.size=1.5, 
            legend.text.size=1) +
  tm_layout(bg.color = "grey90")

summary(cov_US)
