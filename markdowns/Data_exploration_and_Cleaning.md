Business Intelligence Project
================
Alex MWai Muthee
27/11/2023

- [Student Details](#student-details)
- [Setup Chunk](#setup-chunk)
- [Understanding the Dataset (Exploratory Data Analysis
  (EDA))](#understanding-the-dataset-exploratory-data-analysis-eda)
  - [Loading the Dataset](#loading-the-dataset)
    - [Source:](#source)
    - [Reference:](#reference)

# Student Details

|                                              |                  |
|----------------------------------------------|------------------|
| **Student ID Number**                        | 131123           |
| **Student Name**                             | Alex Mwai Muthee |
| **BBIT 4.2 Group**                           | B                |
| **BI Project Group Name/ID (if applicable)** | …                |

# Setup Chunk

**Note:** the following KnitR options have been set as the global
defaults: <BR>
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

# Understanding the Dataset (Exploratory Data Analysis (EDA))

## Loading the Dataset

startup = read.csv(“data/startupdata.csv”)

### Source:

The dataset that was used can be downloaded here:
<https://www.kaggle.com/datasets/manishkc06/startup-success-prediction>

### Reference:

\*\<Cite the dataset here using APA\>  
KC, M. (2018). Startup Success Prediction \[Data set\]. Kaggle.
Retrieved from
<https://www.kaggle.com/datasets/manishkc06/startup-success-prediction>

``` r
library(readr)
##Other required libraries
library(data.table)
library(ggplot2)
library(ggridges)
library(grid)
library(gridExtra)
library(GGally)
```

    ## Registered S3 method overwritten by 'GGally':
    ##   method from   
    ##   +.gg   ggplot2

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following object is masked from 'package:gridExtra':
    ## 
    ##     combine

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     between, first, last

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(ggplot2)
library(tidyr)
library(reshape2)
```

    ## 
    ## Attaching package: 'reshape2'

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     smiths

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     dcast, melt

``` r
library(cluster)
library(class)
library(caret)
```

    ## Loading required package: lattice

``` r
library(rpart)
library(plumber)
library(randomForest)
```

    ## randomForest 4.7-1.1

    ## Type rfNews() to see new features/changes/bug fixes.

    ## 
    ## Attaching package: 'randomForest'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     combine

    ## The following object is masked from 'package:gridExtra':
    ## 
    ##     combine

    ## The following object is masked from 'package:ggplot2':
    ## 
    ##     margin

``` r
library(ggcorrplot)

# Provide the executable R code inside the various code chunks as guided by the lab work.
startup = read.csv("../data/startupdata.csv")

##View the data

View(startup)
names(startup)
```

    ##  [1] "Unnamed..0"               "state_code"              
    ##  [3] "latitude"                 "longitude"               
    ##  [5] "zip_code"                 "id"                      
    ##  [7] "city"                     "Unnamed..6"              
    ##  [9] "name"                     "labels"                  
    ## [11] "founded_at"               "closed_at"               
    ## [13] "first_funding_at"         "last_funding_at"         
    ## [15] "age_first_funding_year"   "age_last_funding_year"   
    ## [17] "age_first_milestone_year" "age_last_milestone_year" 
    ## [19] "relationships"            "funding_rounds"          
    ## [21] "funding_total_usd"        "milestones"              
    ## [23] "state_code.1"             "is_CA"                   
    ## [25] "is_NY"                    "is_MA"                   
    ## [27] "is_TX"                    "is_otherstate"           
    ## [29] "category_code"            "is_software"             
    ## [31] "is_web"                   "is_mobile"               
    ## [33] "is_enterprise"            "is_advertising"          
    ## [35] "is_gamesvideo"            "is_ecommerce"            
    ## [37] "is_biotech"               "is_consulting"           
    ## [39] "is_othercategory"         "object_id"               
    ## [41] "has_VC"                   "has_angel"               
    ## [43] "has_roundA"               "has_roundB"              
    ## [45] "has_roundC"               "has_roundD"              
    ## [47] "avg_participants"         "is_top500"               
    ## [49] "status"

``` r
head(startup)
```

    ##   Unnamed..0 state_code latitude  longitude zip_code      id          city
    ## 1       1005         CA 42.35888  -71.05682    92101  c:6669     San Diego
    ## 2        204         CA 37.23892 -121.97372    95032 c:16283     Los Gatos
    ## 3       1001         CA 32.90105 -117.19266    92121 c:65620     San Diego
    ## 4        738         CA 37.32031 -122.05004    95014 c:42668     Cupertino
    ## 5       1002         CA 37.77928 -122.41924    94105 c:65806 San Francisco
    ## 6        379         CA 37.40691 -122.09037    94043 c:22898 Mountain View
    ##               Unnamed..6              name labels founded_at closed_at
    ## 1                              Bandsintown      1   1/1/2007          
    ## 2                                TriCipher      1   1/1/2000          
    ## 3     San Diego CA 92121             Plixi      1  3/18/2009          
    ## 4     Cupertino CA 95014 Solidcore Systems      1   1/1/2002          
    ## 5 San Francisco CA 94105    Inhale Digital      0   8/1/2010 10/1/2012
    ## 6 Mountain View CA 94043  Matisse Networks      0   1/1/2002 2/15/2009
    ##   first_funding_at last_funding_at age_first_funding_year age_last_funding_year
    ## 1         4/1/2009        1/1/2010                 2.2493                3.0027
    ## 2        2/14/2005      12/28/2009                 5.1260                9.9973
    ## 3        3/30/2010       3/30/2010                 1.0329                1.0329
    ## 4        2/17/2005       4/25/2007                 3.1315                5.3151
    ## 5         8/1/2010        4/1/2012                 0.0000                1.6685
    ## 6        7/18/2006       7/18/2006                 4.5452                4.5452
    ##   age_first_milestone_year age_last_milestone_year relationships funding_rounds
    ## 1                   4.6685                  6.7041             3              3
    ## 2                   7.0055                  7.0055             9              4
    ## 3                   1.4575                  2.2055             5              1
    ## 4                   6.0027                  6.0027             5              3
    ## 5                   0.0384                  0.0384             2              2
    ## 6                   5.0027                  5.0027             3              1
    ##   funding_total_usd milestones state_code.1 is_CA is_NY is_MA is_TX
    ## 1            375000          3           CA     1     0     0     0
    ## 2          40100000          1           CA     1     0     0     0
    ## 3           2600000          2           CA     1     0     0     0
    ## 4          40000000          1           CA     1     0     0     0
    ## 5           1300000          1           CA     1     0     0     0
    ## 6           7500000          1           CA     1     0     0     0
    ##   is_otherstate   category_code is_software is_web is_mobile is_enterprise
    ## 1             0           music           0      0         0             0
    ## 2             0      enterprise           0      0         0             1
    ## 3             0             web           0      1         0             0
    ## 4             0        software           1      0         0             0
    ## 5             0     games_video           0      0         0             0
    ## 6             0 network_hosting           0      0         0             0
    ##   is_advertising is_gamesvideo is_ecommerce is_biotech is_consulting
    ## 1              0             0            0          0             0
    ## 2              0             0            0          0             0
    ## 3              0             0            0          0             0
    ## 4              0             0            0          0             0
    ## 5              0             1            0          0             0
    ## 6              0             0            0          0             0
    ##   is_othercategory object_id has_VC has_angel has_roundA has_roundB has_roundC
    ## 1                1    c:6669      0         1          0          0          0
    ## 2                0   c:16283      1         0          0          1          1
    ## 3                0   c:65620      0         0          1          0          0
    ## 4                0   c:42668      0         0          0          1          1
    ## 5                0   c:65806      1         1          0          0          0
    ## 6                1   c:22898      0         0          0          1          0
    ##   has_roundD avg_participants is_top500   status
    ## 1          0           1.0000         0 acquired
    ## 2          1           4.7500         1 acquired
    ## 3          0           4.0000         1 acquired
    ## 4          1           3.3333         1 acquired
    ## 5          0           1.0000         1   closed
    ## 6          0           3.0000         1   closed

``` r
class(startup)
```

    ## [1] "data.frame"

``` r
summary(startup)
```

    ##    Unnamed..0      state_code           latitude       longitude      
    ##  Min.   :   1.0   Length:923         Min.   :25.75   Min.   :-122.76  
    ##  1st Qu.: 283.5   Class :character   1st Qu.:37.39   1st Qu.:-122.20  
    ##  Median : 577.0   Mode  :character   Median :37.78   Median :-118.37  
    ##  Mean   : 572.3                      Mean   :38.52   Mean   :-103.54  
    ##  3rd Qu.: 866.5                      3rd Qu.:40.73   3rd Qu.: -77.21  
    ##  Max.   :1153.0                      Max.   :59.34   Max.   :  18.06  
    ##                                                                       
    ##    zip_code              id                city            Unnamed..6       
    ##  Length:923         Length:923         Length:923         Length:923        
    ##  Class :character   Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##                                                                             
    ##      name               labels        founded_at         closed_at        
    ##  Length:923         Min.   :0.0000   Length:923         Length:923        
    ##  Class :character   1st Qu.:0.0000   Class :character   Class :character  
    ##  Mode  :character   Median :1.0000   Mode  :character   Mode  :character  
    ##                     Mean   :0.6468                                        
    ##                     3rd Qu.:1.0000                                        
    ##                     Max.   :1.0000                                        
    ##                                                                           
    ##  first_funding_at   last_funding_at    age_first_funding_year
    ##  Length:923         Length:923         Min.   :-9.0466       
    ##  Class :character   Class :character   1st Qu.: 0.5767       
    ##  Mode  :character   Mode  :character   Median : 1.4466       
    ##                                        Mean   : 2.2356       
    ##                                        3rd Qu.: 3.5753       
    ##                                        Max.   :21.8959       
    ##                                                              
    ##  age_last_funding_year age_first_milestone_year age_last_milestone_year
    ##  Min.   :-9.047        Min.   :-14.170          Min.   :-7.005         
    ##  1st Qu.: 1.670        1st Qu.:  1.000          1st Qu.: 2.411         
    ##  Median : 3.529        Median :  2.521          Median : 4.477         
    ##  Mean   : 3.931        Mean   :  3.055          Mean   : 4.754         
    ##  3rd Qu.: 5.560        3rd Qu.:  4.686          3rd Qu.: 6.753         
    ##  Max.   :21.896        Max.   : 24.685          Max.   :24.685         
    ##                        NA's   :152              NA's   :152            
    ##  relationships    funding_rounds   funding_total_usd     milestones   
    ##  Min.   : 0.000   Min.   : 1.000   Min.   :1.100e+04   Min.   :0.000  
    ##  1st Qu.: 3.000   1st Qu.: 1.000   1st Qu.:2.725e+06   1st Qu.:1.000  
    ##  Median : 5.000   Median : 2.000   Median :1.000e+07   Median :2.000  
    ##  Mean   : 7.711   Mean   : 2.311   Mean   :2.542e+07   Mean   :1.842  
    ##  3rd Qu.:10.000   3rd Qu.: 3.000   3rd Qu.:2.472e+07   3rd Qu.:3.000  
    ##  Max.   :63.000   Max.   :10.000   Max.   :5.700e+09   Max.   :8.000  
    ##                                                                       
    ##  state_code.1           is_CA            is_NY            is_MA        
    ##  Length:923         Min.   :0.0000   Min.   :0.0000   Min.   :0.00000  
    ##  Class :character   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.00000  
    ##  Mode  :character   Median :1.0000   Median :0.0000   Median :0.00000  
    ##                     Mean   :0.5276   Mean   :0.1148   Mean   :0.08992  
    ##                     3rd Qu.:1.0000   3rd Qu.:0.0000   3rd Qu.:0.00000  
    ##                     Max.   :1.0000   Max.   :1.0000   Max.   :1.00000  
    ##                                                                        
    ##      is_TX        is_otherstate   category_code       is_software    
    ##  Min.   :0.0000   Min.   :0.000   Length:923         Min.   :0.0000  
    ##  1st Qu.:0.0000   1st Qu.:0.000   Class :character   1st Qu.:0.0000  
    ##  Median :0.0000   Median :0.000   Mode  :character   Median :0.0000  
    ##  Mean   :0.0455   Mean   :0.221                      Mean   :0.1658  
    ##  3rd Qu.:0.0000   3rd Qu.:0.000                      3rd Qu.:0.0000  
    ##  Max.   :1.0000   Max.   :1.000                      Max.   :1.0000  
    ##                                                                      
    ##      is_web        is_mobile       is_enterprise     is_advertising   
    ##  Min.   :0.000   Min.   :0.00000   Min.   :0.00000   Min.   :0.00000  
    ##  1st Qu.:0.000   1st Qu.:0.00000   1st Qu.:0.00000   1st Qu.:0.00000  
    ##  Median :0.000   Median :0.00000   Median :0.00000   Median :0.00000  
    ##  Mean   :0.156   Mean   :0.08559   Mean   :0.07909   Mean   :0.06717  
    ##  3rd Qu.:0.000   3rd Qu.:0.00000   3rd Qu.:0.00000   3rd Qu.:0.00000  
    ##  Max.   :1.000   Max.   :1.00000   Max.   :1.00000   Max.   :1.00000  
    ##                                                                       
    ##  is_gamesvideo      is_ecommerce       is_biotech      is_consulting    
    ##  Min.   :0.00000   Min.   :0.00000   Min.   :0.00000   Min.   :0.00000  
    ##  1st Qu.:0.00000   1st Qu.:0.00000   1st Qu.:0.00000   1st Qu.:0.00000  
    ##  Median :0.00000   Median :0.00000   Median :0.00000   Median :0.00000  
    ##  Mean   :0.05634   Mean   :0.02709   Mean   :0.03684   Mean   :0.00325  
    ##  3rd Qu.:0.00000   3rd Qu.:0.00000   3rd Qu.:0.00000   3rd Qu.:0.00000  
    ##  Max.   :1.00000   Max.   :1.00000   Max.   :1.00000   Max.   :1.00000  
    ##                                                                         
    ##  is_othercategory  object_id             has_VC         has_angel     
    ##  Min.   :0.0000   Length:923         Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.0000   Class :character   1st Qu.:0.0000   1st Qu.:0.0000  
    ##  Median :0.0000   Mode  :character   Median :0.0000   Median :0.0000  
    ##  Mean   :0.3229                      Mean   :0.3261   Mean   :0.2546  
    ##  3rd Qu.:1.0000                      3rd Qu.:1.0000   3rd Qu.:1.0000  
    ##  Max.   :1.0000                      Max.   :1.0000   Max.   :1.0000  
    ##                                                                       
    ##    has_roundA       has_roundB       has_roundC       has_roundD     
    ##  Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.00000  
    ##  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.00000  
    ##  Median :1.0000   Median :0.0000   Median :0.0000   Median :0.00000  
    ##  Mean   :0.5081   Mean   :0.3922   Mean   :0.2329   Mean   :0.09967  
    ##  3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:0.0000   3rd Qu.:0.00000  
    ##  Max.   :1.0000   Max.   :1.0000   Max.   :1.0000   Max.   :1.00000  
    ##                                                                      
    ##  avg_participants   is_top500         status         
    ##  Min.   : 1.000   Min.   :0.0000   Length:923        
    ##  1st Qu.: 1.500   1st Qu.:1.0000   Class :character  
    ##  Median : 2.500   Median :1.0000   Mode  :character  
    ##  Mean   : 2.839   Mean   :0.8093                     
    ##  3rd Qu.: 3.800   3rd Qu.:1.0000                     
    ##  Max.   :16.000   Max.   :1.0000                     
    ## 

``` r
str(startup)
```

    ## 'data.frame':    923 obs. of  49 variables:
    ##  $ Unnamed..0              : int  1005 204 1001 738 1002 379 195 875 16 846 ...
    ##  $ state_code              : chr  "CA" "CA" "CA" "CA" ...
    ##  $ latitude                : num  42.4 37.2 32.9 37.3 37.8 ...
    ##  $ longitude               : num  -71.1 -122 -117.2 -122.1 -122.4 ...
    ##  $ zip_code                : chr  "92101" "95032" "92121" "95014" ...
    ##  $ id                      : chr  "c:6669" "c:16283" "c:65620" "c:42668" ...
    ##  $ city                    : chr  "San Diego" "Los Gatos" "San Diego" "Cupertino" ...
    ##  $ Unnamed..6              : chr  "" "" "San Diego CA 92121" "Cupertino CA 95014" ...
    ##  $ name                    : chr  "Bandsintown" "TriCipher" "Plixi" "Solidcore Systems" ...
    ##  $ labels                  : int  1 1 1 1 0 0 1 1 1 1 ...
    ##  $ founded_at              : chr  "1/1/2007" "1/1/2000" "3/18/2009" "1/1/2002" ...
    ##  $ closed_at               : chr  "" "" "" "" ...
    ##  $ first_funding_at        : chr  "4/1/2009" "2/14/2005" "3/30/2010" "2/17/2005" ...
    ##  $ last_funding_at         : chr  "1/1/2010" "12/28/2009" "3/30/2010" "4/25/2007" ...
    ##  $ age_first_funding_year  : num  2.25 5.13 1.03 3.13 0 ...
    ##  $ age_last_funding_year   : num  3 10 1.03 5.32 1.67 ...
    ##  $ age_first_milestone_year: num  4.6685 7.0055 1.4575 6.0027 0.0384 ...
    ##  $ age_last_milestone_year : num  6.7041 7.0055 2.2055 6.0027 0.0384 ...
    ##  $ relationships           : int  3 9 5 5 2 3 6 25 13 14 ...
    ##  $ funding_rounds          : int  3 4 1 3 2 1 3 3 3 3 ...
    ##  $ funding_total_usd       : num  375000 40100000 2600000 40000000 1300000 7500000 26000000 34100000 9650000 5750000 ...
    ##  $ milestones              : int  3 1 2 1 1 1 2 3 4 4 ...
    ##  $ state_code.1            : chr  "CA" "CA" "CA" "CA" ...
    ##  $ is_CA                   : int  1 1 1 1 1 1 1 1 0 1 ...
    ##  $ is_NY                   : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_MA                   : int  0 0 0 0 0 0 0 0 1 0 ...
    ##  $ is_TX                   : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_otherstate           : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ category_code           : chr  "music" "enterprise" "web" "software" ...
    ##  $ is_software             : int  0 0 0 1 0 0 1 0 0 0 ...
    ##  $ is_web                  : int  0 0 1 0 0 0 0 0 0 1 ...
    ##  $ is_mobile               : int  0 0 0 0 0 0 0 0 1 0 ...
    ##  $ is_enterprise           : int  0 1 0 0 0 0 0 0 0 0 ...
    ##  $ is_advertising          : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_gamesvideo           : int  0 0 0 0 1 0 0 0 0 0 ...
    ##  $ is_ecommerce            : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_biotech              : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_consulting           : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_othercategory        : int  1 0 0 0 0 1 0 1 0 0 ...
    ##  $ object_id               : chr  "c:6669" "c:16283" "c:65620" "c:42668" ...
    ##  $ has_VC                  : int  0 1 0 0 1 0 1 0 1 1 ...
    ##  $ has_angel               : int  1 0 0 0 1 0 0 0 0 1 ...
    ##  $ has_roundA              : int  0 0 1 0 0 0 1 1 1 1 ...
    ##  $ has_roundB              : int  0 1 0 1 0 1 1 1 0 0 ...
    ##  $ has_roundC              : int  0 1 0 1 0 0 0 0 0 0 ...
    ##  $ has_roundD              : int  0 1 0 1 0 0 0 1 1 0 ...
    ##  $ avg_participants        : num  1 4.75 4 3.33 1 ...
    ##  $ is_top500               : int  0 1 1 1 1 1 1 1 1 1 ...
    ##  $ status                  : chr  "acquired" "acquired" "acquired" "acquired" ...

``` r
table(startup$state_code)
```

    ## 
    ##  AR  AZ  CA  CO  CT  DC  FL  GA  ID  IL  IN  KY  MA  MD  ME  MI  MN  MO  NC  NH 
    ##   1   2 488  19   4   4   6  11   1  18   2   2  83   7   2   3   5   2   7   2 
    ##  NJ  NM  NV  NY  OH  OR  PA  RI  TN  TX  UT  VA  WA  WI  WV 
    ##   7   1   2 106   6   7  17   3   3  42   3  13  42   1   1

``` r
table(startup$category_code)
```

    ## 
    ##      advertising        analytics       automotive          biotech 
    ##               62               19                2               34 
    ##        cleantech       consulting        ecommerce        education 
    ##               23                3               25                4 
    ##       enterprise          fashion          finance      games_video 
    ##               73                8                6               52 
    ##         hardware           health      hospitality    manufacturing 
    ##               27                3                1                2 
    ##          medical        messaging           mobile            music 
    ##                7               11               79                6 
    ##  network_hosting             news            other      photo_video 
    ##               34                8               11                7 
    ## public_relations      real_estate           search         security 
    ##               25                3               12               19 
    ##    semiconductor           social         software           sports 
    ##               35               14              153                1 
    ##   transportation           travel              web 
    ##                2                8              144

``` r
table(startup$status)
```

    ## 
    ## acquired   closed 
    ##      597      326

``` r
table(startup$state_code, startup$status)
```

    ##     
    ##      acquired closed
    ##   AR        0      1
    ##   AZ        1      1
    ##   CA      332    156
    ##   CO       14      5
    ##   CT        0      4
    ##   DC        2      2
    ##   FL        2      4
    ##   GA        6      5
    ##   ID        0      1
    ##   IL        9      9
    ##   IN        1      1
    ##   KY        1      1
    ##   MA       64     19
    ##   MD        5      2
    ##   ME        1      1
    ##   MI        0      3
    ##   MN        3      2
    ##   MO        1      1
    ##   NC        2      5
    ##   NH        1      1
    ##   NJ        3      4
    ##   NM        0      1
    ##   NV        1      1
    ##   NY       77     29
    ##   OH        0      6
    ##   OR        6      1
    ##   PA        6     11
    ##   RI        2      1
    ##   TN        2      1
    ##   TX       23     19
    ##   UT        1      2
    ##   VA        7      6
    ##   WA       24     18
    ##   WI        0      1
    ##   WV        0      1

``` r
## Descriptive statistics
### Mean
mean(startup$funding_total_usd, na.rm = TRUE)
```

    ## [1] 25419749

``` r
### Median
median(startup$funding_total_usd, na.rm = TRUE)
```

    ## [1] 1e+07

``` r
### Range
range(startup$funding_total_usd, na.rm = TRUE)
```

    ## [1] 1.1e+04 5.7e+09

``` r
### Quartiles
quantile(startup$funding_total_usd, na.rm = TRUE)
```

    ##         0%        25%        50%        75%       100% 
    ##      11000    2725000   10000000   24725000 5700000000

``` r
### Variance
var(startup$funding_total_usd, na.rm = TRUE)
```

    ## [1] 3.596119e+16

``` r
### Standard Deviation
sd(startup$funding_total_usd, na.rm = TRUE)
```

    ## [1] 189634364

``` r
### Correlation
cor(startup$age_first_funding_year, startup$funding_total_usd, use = "complete.obs")
```

    ## [1] 0.04634968
