# greek-election-data

To extract the data from the last Greek election (September 2015) from ekloges.ypes.gr run the following Ruby scripts: `static_data.rb` and `results.rb`. They will overwrite the files in the data folder. You can then import the CSV files into a database to query the data. I have already wrote some basic SQL queries in `queries.sql`.

Note that for some reason, the results from ετεροδημότες is included at the district level (εκλ. περιφέρεια) but not at the municipality level (δήμος). As I extract results from each municipal unit the vote results from ετεροδημότες are not counted in...