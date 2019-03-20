# appdensitycalculation
Using R to calculate the density

Data Scientist's Toolbox Case

Group 7
Members:
- Amon, Mark Resty 
- Asejo, Alvinne
- Noguera, Renee Mary Laica
- Sultan, Jeffrey Taylor
- Ty, John Kerwin


## FOR BARANGAY DENSITY:
#### - Open population.csv and regionarea.csv in R Studio and Check the Values
#### - Determine Number of Barangay Per Region (d.f=Count)
#### - Merge the data frames (Count and RegionArea,Data Frame = Mer)
#### - Add new Column in Mer,  for computing Area for Each Barangay. (Area/#Barangay in Region)
#### - Create smaller data frame with Region and area/barangay (d.f=Edited)
#### - Merge Edited and population.
#### - Create New Column that shows Population Density, Population/AreaperBarangay
#### - Create smaller Data frame by selecting Barangay and Population Density
#### - Arrange and Slice the data frame to shot the top 5


## FOR CITY DENSITY:
### read the csv files
population <-read.csv("population.csv")
regionarea <-read.csv("regionarea.csv")

### load the dplyr package
library(dplyr)

### count the number of cityprovinces by region
by_city=group_by(population,Region)
nocity=summarise(by_city,n_distinct(CityProvince))

### merge two data frames by ID
merged <- merge(nocity,regionarea,by="Region")

### computed for the total area per region divided by number of cities
areapercity = mutate(merged,merged$Area/merged$`n_distinct(CityProvince)`)

### organized by CITY 
### group by region and city, then get the sum of total population for each city
by_pop = group_by(population,Region,CityProvince)
citypop=summarise(by_pop,sum(Population))

### merges the tables for city population and area per city
finalcitypop<-merge(citypop,areapercity,by="Region")

### renaming the derived columns
colnames(finalcitypop)[3]<-"city_population"
colnames(finalcitypop)[4]<-"no_of_cities_per_region"
colnames(finalcitypop)[5]<-"area_per_region"
colnames(finalcitypop)[6]<-"area_per_city"

### computes for the population density
popdensity=mutate(finalcitypop,`city_population`/`area_per_city`)
View(popdensity)

colnames(popdensity)[7]<-"population_density"

### gets the top 5 highest value
topfive=top_n(popdensity,5)
View(topfive)

### sorts the top 5 in descending order
sorted = arrange(topfive, desc(population_density))
View(sorted)

### writes the csv file of the sorted matrix
write.csv(sorted,file="top5citydensity.csv")
