
# read in translations data, fill in NA for blank fields
tx <- read.csv("all_titles.csv",na.strings="")

# force ISBN as string
tx$ISBN <- as.character(tx$ISBN)

# normalizations

# populations: WHO
pop <- read.csv("who-pop/data-text.csv")

# populations (in thousands) in 2010
total.pop <- subset(pop,subset=(Indicator=="Population (in thousands) total" & Year==2010),select=c(Country,Numeric))

# book production: UNESCO

book.prod <- read.csv("unesco-book/book-prod.csv",skip=1,header=TRUE,na.strings="...",comment.char="#")

lit.prod <- subset(book.prod,select=c(Country,Literature.4))

lit.prod$prod.year <- 1999 # by default
names(lit.prod) <- c("Country","Literature","prod.year")

# attempt to supply missing values
# this will generate some warnings about NA's
# first from 1998
missing.lits <- is.na(lit.prod$Literature)
lit.prod$prod.year[missing.lits] <- 1998
lit.prod$Literature[missing.lits] <- book.prod$Literature.3[missing.lits]

# then from 1997
missing.lits <- is.na(lit.prod$Literature)
lit.prod$prod.year[missing.lits] <- 1997
lit.prod$Literature[missing.lits] <- book.prod$Literature.2[missing.lits]

# then from 1996
missing.lits <- is.na(lit.prod$Literature)
lit.prod$prod.year[missing.lits] <- 1996
lit.prod$Literature[missing.lits] <- book.prod$Literature.1[missing.lits]

# fix typing issue, make sure lit production number is typed as a number
lit.prod$Literature <- as.numeric(as.character(lit.prod$Literature))

# country name uniformity
# function for outputting raw lists
writeCountryNames <- function(threepct,who,unesco) {
  writeLines(levels(threepct$Country),con="threepct_countries.txt")
  writeLines(as.character(who$Country),con="who_countries.txt")
  writeLines(as.character(unesco$Country),con="unesco_countries.txt")
}

# I manually joined the output of this f'n to make country_authority.csv 
# authority table for country names
country.auth <- read.csv("country_authority.csv")

# joined data
# create a "hash" of country populations keyed to three percent country names
# first we merge the population df with the country-names authority list
names(total.pop) <- c("WHO","Population")
country.pop.df <- subset(
  merge(total.pop,country.auth),
  select=c(three.percent,Population))

# then we assign the pop. data to a vector and the country names to the vector names 
country.pop <- as.numeric(country.pop.df$Population)
names(country.pop) <- country.pop.df$three.percent
  
# same process with lit production
names(lit.prod) <- c("UNESCO","Literature","prod.year")
country.lit.prod.df <- subset(
  merge(lit.prod,country.auth),
  select=c(three.percent,Literature))

country.lit.prod <- country.lit.prod.df$Literature
names(country.lit.prod) <- country.lit.prod.df$three.percent

# summary data
# per country
country.table <- table(tx$Country,tx$Year)
countries.df <- as.data.frame(country.table)
names(countries.df) <- c("Country","Year","Freq")
countries.df$per.capita <- NA
countries.df$per.book <- NA

for(i in seq_along(countries.df$Country)) {
  countries.df$per.capita[i] <-
    countries.df$Freq[i] / country.pop[as.character(countries.df$Country[i])]

  countries.df$per.book[i] <-
    countries.df$Freq[i] / country.lit.prod[as.character(countries.df$Country[i])]
}


# per language
# TODO language per capita counts
languages.table <- table(tx$Language,tx$Year)





# analytic questions:
# does a country's language predict its translation count?

# visualizations