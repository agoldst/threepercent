# Exploring Three Percent's Translation Data

Some elementary explorations of the data collected in the University of Rochester's [Three Percent Translation Database](). This is a listing of literary translations published in the United States in the last five years.

By kind permission of Chad Post I am including my aggregate data file publicly here. But please note that this is not an authoritative source for the data. The data here may be out of date. The authoritative source remains the spreadsheets available at [www.rochester.edu/College/translation/threepercent/index.php?s=database](http://www.rochester.edu/College/translation/threepercent/index.php?s=database). My warm thanks to Chad and everyone who has worked on compiling this data.

## Data files

all_titles.csv: the main data. One row for each book. Derived from the Three Percent spreadsheets.

who-pop/: country populations, from the [WHO](http://apps.who.int/gho/data/node.main.107).

unesco-book/: book production data, from [UNESCO](http://stats.uis.unesco.org/unesco/ReportFolders/ReportFolders.aspx) (Culture: Table 21).

log.txt: tracks modifications to the datafiles.

country_authority.csv: tabulates country names used in all_titles.csv against country names used in the WHO and UNESCO data. Manually put together with the help of the find-missing.pl script; the intermediate files are the three with "countries" in their names.

## Script

analysis.R: R script that tabulates counts and munges data.

other files: cruft.

