
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

# country name uniformity
# function for outputting raw lists
writeCountryNames <- function(threepct,who,unesco) {
  writeLines(levels(threepct$Country),con="threepct_countries.txt")
  writeLines(as.character(who$Country),con="who_countries.txt")
  writeLines(as.character(unesco$Country),con="who_countries.txt")
}

# manually join these to make country_authority.csv

# authority table
# country.auth <- read.csv("country_authority.csv")


# analytic questions:
# does a country's language predict its translation count?

# visualizations

# summary data
# per country
tx.per.country <- table(tx$Country,tx$Year)

# per language
tx.per.lg <- table(tx$Language,tx$Year)


