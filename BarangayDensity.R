library(dplyr)
population = read.csv("population.csv")
population
View(population)

regionarea = read.csv("regionarea.csv")
regionarea
View(regionarea)


#Group the table by region and count the number of barangay
library(pastecs)
by_region = group_by(population, Region)
count = count(by_region, vars = "Barangay")
View(count)

#This is to countercheck the number of barangay in by_region
filter2 = filter(population, Region == "AUTONOMOUS REGION IN MUSLIM MINDANAO (ARMM)")
filter2
count2 = count(filter2)
count2

#Create a new table/merge the regionarea.csv table and the new table "count"
innerjoin = merge(x=regionarea, y=count, by="Region")
innerjoin
View(innerjoin)
#Create a new column for the area of barangay and the calculation
areaofbarangay = mutate(innerjoin, area_barangay = innerjoin$Area/innerjoin$n)
View(areaofbarangay)

#Simplification of table: areaofbarangay
filter3 = select(areaofbarangay, Region, area_barangay)
filter3

#Merge filter3 table with the population.csv table
innerjoin1 = merge(x=population, y=filter3, by="Region")
innerjoin1
View(innerjoin1)
#Create new column for calculation of populationdensity
populationdensity = mutate(innerjoin1, population_density = Population/area_barangay)
populationdensity
View(populationdensity)

#Sort the population, find the first or top 5 most dense barangay
sorted = arrange(populationdensity, desc(population_density))
View(sorted)
finalpopulationdensity = slice(sorted,1:5)
finalpopulationdensity
View(finalpopulationdensity)
top5populationdensitybarangay = write.csv(finalpopulationdensity, file = "top5populationdensitybarangay.csv")

topfivebarangay = select(finalpopulationdensity, Barangay, population_density)
topfivebarangay

