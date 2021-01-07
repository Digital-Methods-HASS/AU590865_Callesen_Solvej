#Title: Females in Danish Higher Education 1920-2014
#Author: Solvej Byriel Callesen

#Before I begin, it is necessary to download the data used in this project.
##The data comes from p. 24 of https://www.dst.dk/Site/Dst/Udgivelser/GetPubFile.aspx?id=22699&sid=kvind
###It is found by clicking on the titles for the graphs “Kvinders andel af de fuldførte gymnasiale, erhvervsfaglige og videregående uddannelser. 1921-2014” and “Kvinders andel af de fuldførte uddannelser til lærer, jurist, læge og præst. 1921-2014”
###These datasets are downloaded as "S24f2" and "S24f3". I rename them "dataset_kvindersuddannelse_1920-idag" and "datset_specifikkeuddannelser". 

#Then I set up my Rstudio.
#I create 4 folders in my directory:
dir.create("data") #For my raw data
dir.create("data_output") #For my edited data
dir.create("scripts")#For my scripts
dir.create("fig_output")#For my figures

#I also open up the preinstalled packages that I need. 
library(tidyverse)
library(janitor)

#I manually move the excel files I will be working with to the folder called "data".

#My Rstudio is now ready for me to begin.

#Before I can work with my files I need to clean them a bit in OpenRefine.
#I load the first file "dataset_kvindersuddannelse_1920-idag" to my OpenRefine.
#In this process I uncheck "Store blank rows", I ignore the first row, and I use "Load at most" to only see the first 13 rows as the last rows contain notes rather than data.
#Then I "create project"

#I only need rows 1,11,12 and 13, so I flag those rows, and use "Facet by flag" to only see the rows I need.
#Row 1 contains the years, whilst rows 11-13 contain data for higher education. 
#I also need to rename the rows as Rstudio will probably have a hard time reading the special danish characters.
#I rename them "men_overall", "women_overall" and "share_women_overall". I also call the nameless row with years "year".

#I now have to export the document as a csv files since I need the spreadsheet to be long, rather than wide before I can clean the rest. 
#I manually move the csv file from "overførsler" to "data_output"

#The following code is used to load the file into my Environment:
wide_overall<-read.csv("data_output/dataset_kvindersuddannelse_1920-idag-xlsx.csv")

#I now have a dataframe in my Global Environment called "wide_overall" ie. a wide spreadsheet with the overall numbers

#Now I need to transpose the spreadsheet to make long. This will make it easier to clean in OpenRefine.
long_overall<-t(wide_overall)

#I make the first row the column headers by using the janitor package.
overall_named<-janitor::row_to_names(long_overall,row_number = (1))

#The dataframe "overall_named" contains a spreadsheet with one observation per row, and one variable per column.
##However, "overall_named" is still not clean, so I have to load it back into OpenRefine.
#First i write the dataframe into a csv file on my computer. 
write.csv(overall_named,"data_output/overall_named")

#I open a new window in OpenRefine and load the long spreadsheet. 
#I can go straight to "create project" this time as I have no blank rows. 

#I start out with the weird extra column containing row names. I use "Edit columns" and "Remove this column". 

#Then I clean the year column. It contains 2 years in the format "1920-21". Since the hyphen will make the column a text column, I decide to delete everything except the first year. 
#To delete the second year and the hyphen I use "Edit cells" and "Transform". 
#Then I use the following code: value.split("-")[0]
#Now I have one year per row. This will alter the results a bit, but otherwise I find it impossible to create a decent ggplot. 

#All of the observations are considered text, so column for column I use "Edit cells", "Common transforms", "To number". 
#Now all of my observations are numbers except the first row which is what will later become the column name. 

#I also have some NA's which are represented as . in this data. 
#I change the . to NA by using "Facet", "Text Facet" and then choosing ".", "Edit", I replace . with NA and click "apply".
#I have to change the NA's column by column so I do this for "men", "women" and "share_women". 

#Lastly I notice that one year is misspelled. It is called "188" instead of "1988".
##I change this by using "Facet", "Text facet", clicking "188", changing the number, and clicking "apply".

#I export the OpenRefine spreadsheet to csv and manually move to "data_output".
#Then I reload the document into Rstudio:
numerical_overall<-read.csv("data_output/overall_named.csv")

#I just want to check that the columns are in fact numerical:
year<-numerical_overall[,1] #This makes year a value I can check
class(year) #This checks the class of this value
year<-as.numeric(year) #This code should make the value numerical rather than integer
class(year) #This checks that the as.numeric code worked.

men_overall<-numerical_overall[,2]
class(men_overall) #men_overall is numeric

women_overall<-numerical_overall[,3]
class(women_overall) #women_overall is numeric

share_women_overall<-numerical_overall[,4]
class(share_women_overall) #share_women_overall is also numeric

#I have now cleaned the first spreadsheet, but I have another one.
#Since the second spreadsheet contains 4 individual spreads on one page there are a few things that are different.

#I open a new window in OpenRefine and load "dataset_specifikkeuddannelser" into it. 
#As before i uncheck "Store blank rows", ignore the first row and ""Load at most" 17 rows. 
#Because I need all of these lines I use "Facet", "Text facet" on the first column to rename the future columns.
#I rename the rows one by one with the "edit button
##I name them the english version of their original name with the profession 
###for instance "men_teacher", "women_teacher", "share_overall_teacher" and so on with the last part being a different profession for each spreadsheet (lawyer,doctor and priest)
#I then flag rows 1,3,4,5,7,8,9,11,12,13,15,16,17. These are the rows I need.
#I facet out the flagged rows by using the "All" column, "Facet" and "Facet by flag".
##I only choose the "true" rows.
#Then I export the file to csv, move it from "overførsler" to "data_output" and read it into Rstudio
specific_studies<-read.csv("data_output/dataset_specifikkeuddannelser-xlsx.csv")

#I have to make this spreadsheet long rather than wide as well:
long_specific<-t(specific_studies)

#I also make the first row the column headers with janitor:
named_specific<-janitor::row_to_names(long_specific,row_number = (1))

#Then I save the file on my computer:
write.csv(named_specific,"data_output/named_specific")

#I load the second spreadsheet into a new window of OpenRefine.
##I can go straight to "Create project" because there are no blank rows.

#I use "Edit column", "Remove column" to remove the weird rownames given by Rstudio.
#For the year column I use "Edit cells", "Transform" and the code: value.split("-")[0]

#Most columns have either a . or an - somewhere so I need to change these into something Rstudio can read.
##I believe the . to be NA's since the years with . always includes all 3 columns from the spreadsheet
##I think - is, however, 0 since the hyphen are always only in the "women" and "share_women" columns.
###The publication in which the datasets were found confirm this interpretation.
#I edit the NA's and 0's with "Facet", "Text facet". Here I choose . or -, edit them in the text box and click apply.
##I do this for every of the 13 columns. 

#Then I use "Edit cells", "Common transforms", "To number" on all 13 columns.

#Then I export to csv, move the file to "data_output" and read it back into Rstudio:
numerical_specific<-read.csv("data_output/named_specific.csv")

#Again I want to check that all the columns are numerical. I do this the same way as last time.
men_teacher<-numerical_specific[,2]
class(men_teacher) #This column is numeric.
women_teacher<-numerical_specific[,3]
class(women_teacher)#This column is numeric.
share_women_teacher<-numerical_specific[,4]
class(share_women_teacher)#This column is numeric.
men_lawyer<-numerical_specific[,5]
class(men_lawyer)#This column is numeric.
women_lawyer<-numerical_specific[,6]
class(women_lawyer)#This column is numeric.
share_women_lawyer<-numerical_specific[,7]
class(women_lawyer)#This column is numeric.
men_doctor<-numerical_specific[,8]
class(men_doctor)#This column is numeric.
women_doctor<-numerical_specific[,9]
class(women_doctor)#This column is numeric.
share_women_doctor<-numerical_specific[,10]
class(share_women_doctor)#This column is numeric.
men_priest<-numerical_specific[,11]
class(men_priest)#This column is numeric.
women_priest<-numerical_specific[,12]
class(women_priest)#This column is numeric.
share_women_priest<-numerical_specific[,13]
class(share_women_priest)#This column is numeric.

#I need to select every column with a share of women as well as one year column.
##This is for the first ggplot
share_women<-select(numerical_overall,year,share_women_overall)
share_women_specific<-select(numerical_specific,share_women_teacher,share_women_lawyer,share_women_doctor,share_women_priest)

#Then I need to combine the two dataframes with the share of women
share_women_year<-cbind(share_women,share_women_specific)

#Then I can try to create the ggplot.
##First I need to change the layout of the dataframe
graph_share<-share_women_year %>% 
  gather(key = "Study",value = "Share_of_women",-year)

#I will just check that the "Share_of_women" column is still numeric
Share_of_women<-graph_share[,3]
class(Share_of_women) #It is still numeric

#I need "Study" to be a value I can use in a plot
Study<-graph_share[,2]

#Now I should be able to create a ggplot with lines.
graph_share %>% 
  ggplot(aes(x=year,y=Share_of_women))+
  geom_line(aes(color=Study))

#I now have a nice looking graph with the years on the x axis and the percentages of women on the y axis. 
##The lines show the percentages in the different years for the different studies.
###The line called "share_women_overall" is my reference line.

#I also want to create a graph which shows the numbers of women who study rather than the percentages.
##With this graph it will be easier to see how large a part of all women who graduated from higher education graduated from the different studies.

#Like last time I have to select specific columns. This time it is "year" and "women".
number_overall<-select(numerical_overall,year,women_overall)
number_specific<-select(numerical_specific,women_teacher,women_lawyer,women_doctor,women_priest)

#I also need to combine these two dataframes. 
number_women_year<-cbind(number_overall,number_specific)

#Now I can try to create the second ggplot.
##I need to change the layout of the spreadsheet in the dataframe.
graph_number<-number_women_year %>% 
  gather(key = "Studies",value = "Number_of_women",-year)

#Again I will just check if "Number_of_women" is numerical.
Number_of_women<-graph_number[,3]
class(Number_of_women) #It is indeed numeric

#I also need "Studies" to be a value:
Studies<-graph_number[,2]

#Now I can create my second ggplot, which is also with lines.
graph_number %>% 
  ggplot(aes(x=year,y=Number_of_women))+
  geom_line(aes(color=Studies))

#Now I have my second graph with years on the x axis and number of women on the y axis.
##This time it is possible to see how many of the women who studied at the university, studied to become teacher, lawyers, doctors and priest.
