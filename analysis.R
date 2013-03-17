
# read in translations data, fill in NA for blank fields
tx <- read.csv("all_titles.csv",na.strings="")

# force ISBN as string
tx$ISBN <- as.character(tx$ISBN)

# normalizations

# populations: WHO
pop <- read.csv("who-pop/data-text.csv",as.is=TRUE)

# populations (in thousands) in 2010
total.pop <- subset(pop,subset=(Indicator=="Population (in thousands) total" & Year==2010),select=c(Country,Numeric))
names(total.pop) <- c("Country","Population")

# book production: UNESCO

# unesco.fill.missing: utility function
# initialize a data column from 1999 data and then
# attempt to supply missing values iteratively
# going backwards in time
# df: original imported unesco data table
# col: type of column we're operating on
# return value: a copy of df with col and col.year columns
# col has the values filled in,
# col.year indicates what year the value is from
unesco.fill.missing <- function(df,col="Literature") {
  # name of column to hold what year we've gotten data from
  year.col <- paste(col,".year",sep="")
  filled.col <- paste(col,".filled",sep="")
  result <- df
  # initialize to all NA's
  result[[filled.col]] <- NA
  for(i in 4:0) {
    # what's still missing?
    missing <- is.na(result[[filled.col]])
    result[[year.col]][missing] <- 1995 + i
    # because the raw UNESCO data has five identical "Literature"
    # columns (similarly for all other categories),
    # the data column is called e.g. "Literature.3" for 1998
    # but just "Literature" for 1995
    data.col <- ifelse(i > 0,paste(col,".",i,sep=""),col)
    
    result[[filled.col]][missing] <- df[[data.col]][missing]
  }
  # but now we've accidentally filled in 1995 for the totally
  # missing rows, too
  missing <- is.na(result[[filled.col]])
  result[[year.col]][missing] <- NA
  
  # try to get the data types right, R
  result[[filled.col]] <- as.numeric(as.character(result[[filled.col]]))
  result
}

unesco.prod <- read.csv("unesco-book/book-prod.csv",skip=1,header=TRUE,as.is=TRUE,na.strings="...",comment.char="#")

lit.prod <- subset(unesco.fill.missing(unesco.prod,col="Literature"),
                   select=c(Country,Literature.filled,Literature.year))
 
book.prod <- subset(unesco.fill.missing(unesco.prod,col="Total"),
                     select=c(Country,Total.filled,Total.year))

# country name uniformity
# function for outputting raw lists
writeCountryNames <- function(threepct,who,unesco) {
  writeLines(levels(threepct$Country),con="threepct_countries.txt")
  writeLines(as.character(who$Country),con="who_countries.txt")
  writeLines(as.character(unesco$Country),con="unesco_countries.txt")
}

# I manually collated the outputs of this f'n to make country_authority.csv 
# authority table for country names
country.auth <- read.csv("country_authority.csv",as.is=TRUE)

# joined data
# create a "hash" of country populations keyed to three percent country names
# first we merge the population df with the country-names authority list
country.pop.df <- subset(
  merge(total.pop,country.auth,by.x="Country",by.y="WHO"),
  select=c(three.percent,Population))

# then we assign the pop. data to a vector and the country names to the vector names 
country.pop <- as.numeric(country.pop.df$Population)
names(country.pop) <- country.pop.df$three.percent
  
# same process with lit production
country.lit.prod.df <- subset(
  merge(lit.prod,country.auth,by.x="Country",by.y="UNESCO"),
  select=c(three.percent,Literature.filled))

country.lit.prod <- country.lit.prod.df$Literature.filled
names(country.lit.prod) <- country.lit.prod.df$three.percent

# and with total book production
country.book.prod.df <- subset(
  merge(book.prod,country.auth,by.x="Country",by.y="UNESCO"),
  select=c(three.percent,Total.filled))

country.book.prod <- country.book.prod.df$Total.filled
names(country.book.prod) <- country.book.prod.df$three.percent

# summary data
# per country
country.table <- table(tx$Country,tx$Year)
countries.df <- as.data.frame(country.table)
names(countries.df) <- c("Country","Year","Freq")
countries.df$per.capita <- NA
countries.df$per.lit <- NA
countries.df$per.book <- NA

for(i in seq_along(countries.df$Country)) {
  countries.df$per.capita[i] <-
    countries.df$Freq[i] / country.pop[as.character(countries.df$Country[i])]

  countries.df$per.lit[i] <-
    countries.df$Freq[i] / country.lit.prod[as.character(countries.df$Country[i])]
  
  countries.df$per.book[i] <-
    countries.df$Freq[i] / country.book.prod[as.character(countries.df$Country[i])] 
}

# List top numbers for a given year
# by category as specified by "per"
# choices: per.lit, per.book, per.capita
top.in.year <- function(df,year,n=10,per="per.lit") {
  rows <- subset(df,subset=(Year==year))
  rows[order(rows[[per]],decreasing=TRUE)[1:n],]
}

# per language
# TODO language per capita counts
languages.table <- table(tx$Language,tx$Year)





# analytic questions:
# does a country's language predict its translation count?

# visualizations