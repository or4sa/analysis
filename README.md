# analysis
Analysis scripts and data transformation utilities


## Working with data from Stats SA (superweb)
You'll be able to access [SuperWeb](http://superweb.statssa.gov.za/webapi) after registering against your email address.
The data is accessed by selecting fields and adding them to a table, culminating in being able to download a csv file which one can then work with.
The csv files produced by Stats SA are not in any reasonable csv format, so you'll find a utility script in the `utils` folder which will convert a download from Stats SA (which is in long form) and produced a neatly labelled long form table with all the blanks filled in.

Here is how to run a cleanup on some raw data from Stats SA:
```
Rscript utils/stats_sa_cleanup.R data-samples/2018_household_water_RSA_Provinces.csv 
```
This uses the file in the `data-samples` folder and produces the following output:
```
  Usage of piped or tapwater Safe to drink
1                        Yes           Yes
2                        Yes           Yes
3                        Yes           Yes
4                        Yes           Yes
5                        Yes           Yes
6                        Yes           Yes
  Treatment of drinking water then Good in taste Water supply
1                                    Yes, always          Yes
2                                    Yes, always          Yes
3                                    Yes, always          Yes
4                                    Yes, always          Yes
5                                    Yes, always          Yes
6                                    Yes, always          Yes
  Water supply interruption Water meter     PROVINCES Person Weight
1                       Yes         Yes  Western Cape             0
2                       Yes         Yes  Eastern Cape             0
3                       Yes         Yes Northern Cape             0
4                       Yes         Yes    Free State             0
5                       Yes         Yes KwaZulu-Natal             0
6                       Yes         Yes    North West             0
Writing out to:  data-samples/2018_household_water_RSA_Provinces_cleaned.csv 

```
The output has been saved to the sample folder but with the suffix `_cleaned.csv`. One can now work with this data in the common long form and run some analyses on the data.

## Data analysis examples

### Household water dataset
After running the clean up on the household water data we can do some analysis. You'll find analysis scripts in the `examples` folder.

```
      PROVINCES UnsafeWater
1  Eastern Cape   1.7988696
2 KwaZulu-Natal   1.7894287
3    Mpumalanga   0.9963722
4  Western Cape   0.9653256
5       Gauteng   0.6098336
6    Free State   0.5143059
7    North West   0.5028480
8 Northern Cape   0.2747506
9       Limpopo   0.1951150
```
This table gives the percentage of unsafe drinking water per province as a percentage of the total population. You can see that EC and KZN are very close in almost making up half of the undrinkable water in the country.

If we interrogate the data to understand the localised impace within each province (i.e. if you lived there, what are your odds of not having drinkable water) - we get the following:
```
1  Eastern Cape   15.881519
2 Northern Cape   12.836752
3    Mpumalanga   12.656176
4    Free State   10.220807
5 KwaZulu-Natal    9.167602
6  Western Cape    8.340349
7    North West    7.360749
8       Gauteng    2.390036
9       Limpopo    1.915160
```
This is quite scary in that is suggests that almost 16% of people in the Eastern Cape don't have safe, drinkable water. We can see the difference between the two normalisations in the following chart.

![Sample output](https://github.com/or4sa/analysis/blob/master/examples/safe_unsafe_water.png)

Going through the example will also show you how to use `dplyr`, `reshape2`, `ggplot2` and theres one sneaky `magrittr` command hiding in there.