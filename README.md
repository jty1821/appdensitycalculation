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

### read files
library(dplyr)
population = read.csv("population.csv")
population
View(population)

regionarea = read.csv("regionarea.csv")
regionarea
View(regionarea)


### Group the table by region and count the number of barangay
library(pastecs)
by_region = group_by(population, Region)
count = count(by_region, vars = "Barangay")
View(count)

### This is to countercheck the number of barangay in by_region
filter2 = filter(population, Region == "AUTONOMOUS REGION IN MUSLIM MINDANAO (ARMM)")
filter2
count2 = count(filter2)
count2

### Create a new table/merge the regionarea.csv table and the new table "count"
innerjoin = merge(x=regionarea, y=count, by="Region")
innerjoin
View(innerjoin)
#Create a new column for the area of barangay and the calculation
areaofbarangay = mutate(innerjoin, area_barangay = innerjoin$Area/innerjoin$n)
View(areaofbarangay)

### Simplification of table: areaofbarangay
filter3 = select(areaofbarangay, Region, area_barangay)
filter3

### Merge filter3 table with the population.csv table
innerjoin1 = merge(x=population, y=filter3, by="Region")
innerjoin1
View(innerjoin1)

### Create new column for calculation of populationdensity
populationdensity = mutate(innerjoin1, population_density = Population/area_barangay)
populationdensity
View(populationdensity)

### Sort the population, find the first or top 5 most dense barangay
sorted = arrange(populationdensity, desc(population_density))
View(sorted)
finalpopulationdensity = slice(sorted,1:5)
finalpopulationdensity
View(finalpopulationdensity)
top5populationdensitybarangay = write.csv(finalpopulationdensity, file = "top5populationdensitybarangay.csv")

topfivebarangay = select(finalpopulationdensity, Barangay, population_density)
topfivebarangay



## FOR CITY DENSITY:
### read the csv files
population <-read.csv("population.csv")
regionarea <-read.csv("regionarea.csv")

### load the dplyr package
library(dplyr)

### count the number of cityprovinces by region
by_city=group_by(population,Region)
nocity=summarise(by_city,n_distinct(CityProvince))

### merge two data frames by Region
merged <- merge(nocity,regionarea,by="Region")

### computed for the total area per region divided by number of cities
areapercity = mutate(merged,merged$Area/merged$`n_distinct(CityProvince)`)

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
