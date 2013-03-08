
# read in translations data, fill in NA for blank fields
tx <- read.csv("all_titles.csv",na.strings="")

# force ISBN as string
tx$ISBN <- as.character(tx$ISBN)

# norm countries by pop / languages by num of speakers?

# analytic questions:
# does a country's language predict its translation count?

# visualizations
