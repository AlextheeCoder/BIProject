Business Intelligence Project
================
Alex Mwai Muthee
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

``` r
# Issue 3 Data Exploration & Visualization-----------------
### Scatter plot of latitude and longitude
ggplot(startup, aes(x = longitude, y = latitude)) +
  geom_point() +
  labs(x = "Longitude", y = "Latitude") +
  theme_bw()
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-1.png)<!-- -->

``` r
### Trend in funding rounds
ggplot(startup, aes(x = funding_rounds)) +
  geom_histogram(fill = "skyblue", color = "white", binwidth = 1) +
  ggtitle("Distribution of Funding Rounds") +
  xlab("Number of Funding Rounds") +
  ylab("Count")
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-2.png)<!-- -->

``` r
###Regional trends in startup funding 
startup %>% 
  group_by(state_code) %>% 
  summarize(avg_funding = mean(funding_total_usd))%>% 
  ggplot(aes(x=state_code, y=avg_funding)) +
  geom_bar(stat="identity", fill="skyblue", color="White") +
  ggtitle("Average Funding by State") +
  xlab("State") +
  ylab("Average Funding (in USD)")
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-3.png)<!-- -->

``` r
###Bar plot of category code
ggplot(startup, aes(y = category_code)) +
  geom_bar() +
  labs(y = "Category Code", x = "Count") +
  theme_bw()
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-4.png)<!-- -->

``` r
###Box plot of funding total by category
ggplot(startup, aes(y = category_code, x = funding_total_usd/1000000)) +
  geom_boxplot() +
  labs(y = "Category Code", x = "Funding Total (Millions of USD)") +
  theme_bw() +
  scale_x_continuous(limits = c(0, 300))
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-5.png)<!-- -->

``` r
###Bar plot of status by category
ggplot(startup, aes(y = category_code, fill = status)) +
  geom_bar() +
  labs(y = "Category Code", x = "Count") +
  theme_bw() +
  scale_fill_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"))
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-6.png)<!-- -->

``` r
###Regional trends in startup funding
startup %>%
  group_by(status) %>%
  summarize(avg_funding = mean(funding_total_usd)) %>%
  ggplot(aes(x = status, y = avg_funding)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "white") +
  ggtitle("Average Funding by Status") +
  xlab("Status") +
  ylab("Average Funding (in USD)")
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-7.png)<!-- -->

``` r
###Bar chart of count of companies by state:
startup_state <- startup %>%
  group_by(state_code) %>%
  summarise(count = n()) %>%
  arrange(desc(count))
ggplot(startup_state, aes(y = state_code, x = count, fill = state_code)) +
  geom_col() +
  labs(y = "State Code", x = "Count of Companies") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-8.png)<!-- -->

``` r
### select relevant numeric variables
startup_data_num <- select_if(startup, is.numeric)
### compute correlation matrix
corr_matrix <- cor(startup_data_num, use = "pairwise.complete.obs")

### plot correlation heat map
ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower", 
           lab_size = 3, ggtheme = ggplot2::theme_gray, 
           colors = c("#6D9EC1", "white", "#E46726"))
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-9.png)<!-- -->

``` r
# ----------------------------------Issue 4 & 5--------------------------------------------------------

### Check for missing values
missing_values <- sapply(startup, function(x) sum(is.na(x) | x == ""))

### Display the results in a dataframe
missing_values_df <- data.frame(Variable = names(missing_values), Missing_Values = missing_values)
knitr::kable(missing_values_df)
```

|                          | Variable                 | Missing_Values |
|:-------------------------|:-------------------------|---------------:|
| Unnamed..0               | Unnamed..0               |              0 |
| state_code               | state_code               |              0 |
| latitude                 | latitude                 |              0 |
| longitude                | longitude                |              0 |
| zip_code                 | zip_code                 |              0 |
| id                       | id                       |              0 |
| city                     | city                     |              0 |
| Unnamed..6               | Unnamed..6               |            493 |
| name                     | name                     |              0 |
| labels                   | labels                   |              0 |
| founded_at               | founded_at               |              0 |
| closed_at                | closed_at                |            588 |
| first_funding_at         | first_funding_at         |              0 |
| last_funding_at          | last_funding_at          |              0 |
| age_first_funding_year   | age_first_funding_year   |              0 |
| age_last_funding_year    | age_last_funding_year    |              0 |
| age_first_milestone_year | age_first_milestone_year |            152 |
| age_last_milestone_year  | age_last_milestone_year  |            152 |
| relationships            | relationships            |              0 |
| funding_rounds           | funding_rounds           |              0 |
| funding_total_usd        | funding_total_usd        |              0 |
| milestones               | milestones               |              0 |
| state_code.1             | state_code.1             |              1 |
| is_CA                    | is_CA                    |              0 |
| is_NY                    | is_NY                    |              0 |
| is_MA                    | is_MA                    |              0 |
| is_TX                    | is_TX                    |              0 |
| is_otherstate            | is_otherstate            |              0 |
| category_code            | category_code            |              0 |
| is_software              | is_software              |              0 |
| is_web                   | is_web                   |              0 |
| is_mobile                | is_mobile                |              0 |
| is_enterprise            | is_enterprise            |              0 |
| is_advertising           | is_advertising           |              0 |
| is_gamesvideo            | is_gamesvideo            |              0 |
| is_ecommerce             | is_ecommerce             |              0 |
| is_biotech               | is_biotech               |              0 |
| is_consulting            | is_consulting            |              0 |
| is_othercategory         | is_othercategory         |              0 |
| object_id                | object_id                |              0 |
| has_VC                   | has_VC                   |              0 |
| has_angel                | has_angel                |              0 |
| has_roundA               | has_roundA               |              0 |
| has_roundB               | has_roundB               |              0 |
| has_roundC               | has_roundC               |              0 |
| has_roundD               | has_roundD               |              0 |
| avg_participants         | avg_participants         |              0 |
| is_top500                | is_top500                |              0 |
| status                   | status                   |              0 |

``` r
### Dropping useless columns: Unnamed: 0, id, Unnamed: 6, state_code.1, object-id

startup <- subset(startup, select = -c(Unnamed..0,id, Unnamed..6,state_code.1,object_id, labels))
View(startup)


## Reformatting the dates
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     hour, isoweek, mday, minute, month, quarter, second, wday, week,
    ##     yday, year

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
parse_dates <- function(date_column) {
  parsed_dates <- mdy(date_column)
  formatted_dates <- format(parsed_dates, "%d/%m/%Y")
  return(formatted_dates)
}

### Executing the function parse_dates to the column "closed_at"
startup$closed_at <- parse_dates(startup$closed_at)

### Executing the function parse_dates to the column "founded_at"
startup$founded_at <- parse_dates(startup$founded_at)

### Executing the function parse_dates to the column "first_funding_at"
startup$first_funding_at <- parse_dates(startup$first_funding_at)

### Executing the function parse_dates to the column "last_funding_at"
startup$last_funding_at <- parse_dates(startup$last_funding_at)

startup$closed_at <- dmy(startup$closed_at)
startup$founded_at <- dmy(startup$founded_at)
startup$first_funding_at <- dmy(startup$first_funding_at)
startup$last_funding_at <- dmy(startup$last_funding_at)

### Dropping illogical lines (closed_date before founded_date):
illogical_lines <- subset(startup, closed_at < founded_at)
View(illogical_lines)

### New dataframe without these lines
startup <- subset(startup, is.na(closed_at) | closed_at >= founded_at)
View (startup)


## Replacing the "status" variable by a categorical variable
startup$status <- ifelse(startup$status == "acquired", 1, ifelse(startup$status == "closed", 0, startup$status))
View(startup)


distinct_categories <- unique(startup$category_code)
print(distinct_categories)
```

    ##  [1] "music"            "enterprise"       "web"              "software"        
    ##  [5] "games_video"      "network_hosting"  "finance"          "mobile"          
    ##  [9] "education"        "public_relations" "security"         "other"           
    ## [13] "photo_video"      "hardware"         "ecommerce"        "advertising"     
    ## [17] "travel"           "fashion"          "analytics"        "consulting"      
    ## [21] "biotech"          "cleantech"        "search"           "semiconductor"   
    ## [25] "social"           "medical"          "automotive"       "messaging"       
    ## [29] "manufacturing"    "hospitality"      "news"             "transportation"  
    ## [33] "sports"           "real_estate"      "health"

``` r
startup$state <- ifelse(startup$is_CA == 1, "California", 
                        ifelse(startup$is_MA == 1, "Massachusetts",
                               ifelse(startup$is_NY == 1, "New York",
                                      ifelse(startup$is_TX == 1, "Texas",
                                             ifelse(startup$is_otherstate == 1, "Other states", "Unknow")))))

## Create a frequency table of the different states in the startup$state column
state_counts <- table(startup$state)
df_pie <- data.frame(State = names(state_counts), Count = as.numeric(state_counts))

df_pie <- df_pie %>%
  mutate(Percentage = round(100 * Count / sum(Count), 1))


## Diagram creation to visualize the distribution of startups across different states
pie_chart <- ggplot(data = df_pie, aes(x = "", y = Count, fill = State)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste(State, "\n", Percentage, "%")), position = position_stack(vjust = 0.5), color = "white", size = 3) +  
  labs(fill = "State", title = "State origin of the selected startups") +  
  scale_fill_discrete(name = "State") +
  theme_void() +
  theme(legend.position = "right", plot.title = element_text(hjust = 0.5))  

print(pie_chart)
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-10.png)<!-- -->

``` r
## % of startups in each industry
startup$industry <- ifelse(startup$is_web == 1, "Web", 
                           ifelse(startup$is_advertising == 1, "Advertising",
                                  ifelse(startup$is_mobile == 1, "Mobile",
                                         ifelse(startup$is_enterprise == 1, "Enterprise",
                                                ifelse(startup$is_gamesvideo == 1, "Video Games",
                                                       ifelse(startup$is_ecommerce == 1, "Ecommerce",
                                                              ifelse(startup$is_biotech == 1, "Biotech",
                                                                     ifelse(startup$is_consulting == 1, "Consulting",
                                                                            ifelse(startup$is_othercategory == 1, "Other Category",
                                                                                   ifelse(startup$is_software == 1, "Software", "Unknown"))))))))))

industry_counts <- table(startup$industry)
df_pie <- data.frame(Industry = names(industry_counts), Count = as.numeric(industry_counts))

df_pie <- df_pie %>%
  mutate(Percentage = round(100 * Count / sum(Count), 1))

## Diagram creation for % of startups in each industry
pie_chart <- ggplot(data = df_pie, aes(x = "", y = Count, fill = Industry)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste(Industry, "\n", Percentage, "%")), position = position_stack(vjust = 0.5), color = "white", size = 3) +  
  labs(fill = "Industry", title = "Industries overview among the selected startups") +  
  scale_fill_discrete(name = "Industry") +
  theme_void() +
  theme(legend.position = "right", plot.title = element_text(hjust = 0.5))  

print(pie_chart)
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-11.png)<!-- -->

``` r
startup$status_text <- ifelse(startup$status == 1, "Acquired", "Not acquired")

## Number of acquired/non-acquired startups
status_counts <- table(startup$status_text)

df_bar <- data.frame(Status = names(status_counts), Count = as.numeric(status_counts))

## Diagram creation for Number of acquired/non-acquired startups
bar_chart <- ggplot(data = df_bar, aes(x = Status, y = Count, fill = Status)) +
  geom_bar(stat = "identity") +
  labs(x = "Status", y = "Number of startups", title = "Number of acquired VS non-acquired startups") +
  scale_fill_manual(values = c("Acquired" = "blue", "Non-Acquired" = "red"),
                    labels = c("Acquired", "Non-Acquired")) +  
  geom_text(aes(label = Count), position = position_stack(vjust = 0.5), color = "black", size = 3, vjust = -0.5) +  
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  

print(bar_chart)
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-12.png)<!-- -->

``` r
## scatter plot that visually explores the relationship between the number of funding rounds and the total funding received (in USD) by startups
scatter_plot_log <- ggplot(startup, aes(x = funding_rounds, y = log(funding_total_usd))) +
  geom_point() +
  labs(x = "Number of Funding Rounds", y = "Log of Total Funding in USD", 
       title = "Scatter Plot: Funding vs. Funding Rounds") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

## Displaying the scatter plot with logarithmic transformation for better understanding
print(scatter_plot_log)
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-13.png)<!-- -->

``` r
categories <- c("is_software", "is_web", "is_advertising", "is_mobile", "is_enterprise", "is_gamesvideo", "is_ecommerce", "is_consulting", "is_biotech", "is_othercategory")

## Vectors initialization 
count_vector_acquired <- numeric(length(categories))
count_vector_non_acquired <- numeric(length(categories))

## Loop accross all industries
for (i in seq_along(categories)) {
  category <- categories[i]
  count_vector_acquired[i] <- sum(startup[[category]] == 1 & startup$status == 1)
  count_vector_non_acquired[i] <- sum(startup[[category]] == 1 & startup$status == 0)
}

## Dataframe with the results
acquisitions_by_industry <- data.frame(Category = categories, Acquired = count_vector_acquired, Non_acquired = count_vector_non_acquired)
print(acquisitions_by_industry)
```

    ##            Category Acquired Non_acquired
    ## 1       is_software      101           52
    ## 2            is_web       93           51
    ## 3    is_advertising       44           16
    ## 4         is_mobile       52           27
    ## 5     is_enterprise       56           17
    ## 6     is_gamesvideo       31           21
    ## 7      is_ecommerce       11           13
    ## 8     is_consulting        2            1
    ## 9        is_biotech       22           12
    ## 10 is_othercategory      184          114

``` r
## Restructing
results_melted <- melt(acquisitions_by_industry, id.vars = "Category")

## Diagram creation
acquisitions_diagram <- ggplot(results_melted, aes(x = Category, y = value, fill = variable)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(x = "Industry", y = "Number of startups",
       title = "Number of Acquired and Non Acquired Startups by Industry",
       fill = "Status") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Acquired", "Non Acquired")) +
  scale_x_discrete(labels = c("Software", "Web", "Advertising", "Mobile", "Enterprise", "Games/Video", "E-commerce", "Consulting", "Biotech", "Other")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

print(acquisitions_diagram)
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-14.png)<!-- -->

``` r
selected_vars <- startup[, c("age_first_funding_year", "age_last_funding_year", "milestones", "funding_total_usd","funding_rounds")]
scaled_data <- scale(selected_vars)



## Hierarchical clustering
dist_matrix <- dist(scaled_data)
hclust_model <- hclust(dist_matrix, method = "ward.D2")

## Assessing the silhouette scores for models with 2 to 10 clusters
num_clusters <- 2:10
sil_widths <- numeric(length(num_clusters))

## Loop on the different numbers of clusters
for (k in num_clusters) {
  cluster_assignments <- cutree(hclust_model, k)
  
  # Calculate silhouette matrix
  sil <- silhouette(cluster_assignments, dist = dist_matrix)
  
  # Extract silhouette widths from the sil matrix
  sil_widths[k - 1] <- mean(sil[, "sil_width"])
}

## Optimal number of clusters
optimal_clusters <- which.max(sil_widths) + 1
cat("Optimal number of clusters:", optimal_clusters, "\n")
```

    ## Optimal number of clusters: 2

``` r
## Plot silhouette scores
plot(num_clusters, sil_widths, type = "b", pch = 19, xlab = "Number of Clusters", ylab = "Average Silhouette Width", main = "Silhouette Scores for Different Numbers of Clusters")
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-15.png)<!-- -->

``` r
## Imputing for missing data (closedt_at)
### This is to solve some of the errors I was facing during the training.
startup$closed_at <- as.Date(startup$closed_at)
median_date <- median(startup$closed_at, na.rm = TRUE)
startup$closed_at[is.na(startup$closed_at)] <- median_date


missing_count <- colSums(is.na(startup))
startup_missing <- as.data.frame(missing_count); startup_missing
```

    ##                          missing_count
    ## state_code                           0
    ## latitude                             0
    ## longitude                            0
    ## zip_code                             0
    ## city                                 0
    ## name                                 0
    ## founded_at                           0
    ## closed_at                            0
    ## first_funding_at                     0
    ## last_funding_at                      0
    ## age_first_funding_year               0
    ## age_last_funding_year                0
    ## age_first_milestone_year           151
    ## age_last_milestone_year            151
    ## relationships                        0
    ## funding_rounds                       0
    ## funding_total_usd                    0
    ## milestones                           0
    ## is_CA                                0
    ## is_NY                                0
    ## is_MA                                0
    ## is_TX                                0
    ## is_otherstate                        0
    ## category_code                        0
    ## is_software                          0
    ## is_web                               0
    ## is_mobile                            0
    ## is_enterprise                        0
    ## is_advertising                       0
    ## is_gamesvideo                        0
    ## is_ecommerce                         0
    ## is_biotech                           0
    ## is_consulting                        0
    ## is_othercategory                     0
    ## has_VC                               0
    ## has_angel                            0
    ## has_roundA                           0
    ## has_roundB                           0
    ## has_roundC                           0
    ## has_roundD                           0
    ## avg_participants                     0
    ## is_top500                            0
    ## status                               0
    ## state                                0
    ## industry                             0
    ## status_text                          0

``` r
startup$age_first_milestone_year <- ifelse(is.na(startup$age_first_milestone_year),median(startup$age_first_milestone_year,na.rm = T),startup$age_first_milestone_year)
startup$age_last_milestone_year <- ifelse(is.na(startup$age_last_milestone_year),median(startup$age_last_milestone_year,na.rm = T),startup$age_last_milestone_year)


missing_count_2 <- colSums(is.na(startup))
startup_missing_2 <- as.data.frame(missing_count_2); startup_missing_2
```

    ##                          missing_count_2
    ## state_code                             0
    ## latitude                               0
    ## longitude                              0
    ## zip_code                               0
    ## city                                   0
    ## name                                   0
    ## founded_at                             0
    ## closed_at                              0
    ## first_funding_at                       0
    ## last_funding_at                        0
    ## age_first_funding_year                 0
    ## age_last_funding_year                  0
    ## age_first_milestone_year               0
    ## age_last_milestone_year                0
    ## relationships                          0
    ## funding_rounds                         0
    ## funding_total_usd                      0
    ## milestones                             0
    ## is_CA                                  0
    ## is_NY                                  0
    ## is_MA                                  0
    ## is_TX                                  0
    ## is_otherstate                          0
    ## category_code                          0
    ## is_software                            0
    ## is_web                                 0
    ## is_mobile                              0
    ## is_enterprise                          0
    ## is_advertising                         0
    ## is_gamesvideo                          0
    ## is_ecommerce                           0
    ## is_biotech                             0
    ## is_consulting                          0
    ## is_othercategory                       0
    ## has_VC                                 0
    ## has_angel                              0
    ## has_roundA                             0
    ## has_roundB                             0
    ## has_roundC                             0
    ## has_roundD                             0
    ## avg_participants                       0
    ## is_top500                              0
    ## status                                 0
    ## state                                  0
    ## industry                               0
    ## status_text                            0

``` r
# Removing not required data sets from the environment
rm(startup_missing, startup_missing_2, missing_count, missing_count_2)




# ------------------------------Training and Modelling--------------------------------------------------------------


## Defining  the features and the target variable
features <- c("funding_total_usd", "funding_rounds", "milestones", "category_code", "state", "industry", "status")
dataset <- startup[, features]

## Convert categorical variables to factors
for (col in c("category_code", "state", "industry", "status")) {
  dataset[, col] <- as.factor(dataset[, col])
}

set.seed(7) 
train_indices <- sample(1:nrow(dataset), 0.7 * nrow(dataset))
train_data <- dataset[train_indices, ]
test_data <- dataset[-train_indices, ]


tree_model <- rpart(status ~ ., data = train_data, method = "class")

predictions_tree <- predict(tree_model, newdata = train_data, type = "class")

confusion_matrix_tree <- table(Predicted = predictions_tree, Actual = train_data$status)
print(confusion_matrix_tree)
```

    ##          Actual
    ## Predicted   0   1
    ##         0 124  33
    ##         1  97 390

``` r
accuracy_tree <- sum(diag(confusion_matrix_tree)) / sum(confusion_matrix_tree)
print(paste("Accuracy of Decision Tree model:", accuracy_tree))
```

    ## [1] "Accuracy of Decision Tree model: 0.798136645962733"

``` r
#-----------------------------------------------Clustering(unsupervised)--------------------------------------------
## Select features for clustering
df_cluster <- startup

cluster_features <- scale(df_cluster[, c("funding_total_usd", "milestones", "funding_rounds")])

set.seed(7)
wss <- sapply(1:10, function(k){kmeans(cluster_features, k, nstart = 20)$tot.withinss})
plot(1:10, wss, type = "b", xlab = "Number of Clusters", ylab = "Total Within Sum of Squares")
```

![](Startup_prediction_files/figure-gfm/Dataset%20Loader-16.png)<!-- -->

``` r
optimal_k <- 3 
kmeans_result <- kmeans(cluster_features, optimal_k, nstart = 20)
df_cluster$cluster <- kmeans_result$cluster



predicted_status_per_cluster <- aggregate(status ~ cluster, data = df_cluster, FUN = function(x) {
  names(which.max(table(x)))
})
names(predicted_status_per_cluster) <- c("cluster", "predicted_status")
df_cluster$predicted_status <- predicted_status_per_cluster[df_cluster$cluster, "predicted_status"]
confusion_matrix_kmeans <- table(Predicted = df_cluster$predicted_status, Actual = df_cluster$status)
accuracy_kmeans <- sum(diag(confusion_matrix_kmeans)) / sum(confusion_matrix_kmeans)
print(paste("Accuracy of K-Means Clustering:", accuracy_kmeans))
```

    ## [1] "Accuracy of K-Means Clustering: 0.678260869565217"

``` r
#------------------------------------------------Random Forest------------------------------------


df_rf <- startup

## Define features
features <- c("funding_total_usd", "funding_rounds", "milestones", "category_code", "state", "industry")
dataset2 <- df_rf[, c(features, "status")]

## Convert categorical variables to factors
for (col in c("category_code", "state", "industry", "status")) {
  dataset2[, col] <- as.factor(dataset2[, col])
}

set.seed(7)
train_indices <- sample(1:nrow(dataset2), 0.7 * nrow(dataset2))
train_data <- dataset2[train_indices, ]
test_data <- dataset2[-train_indices, ]
rf_model <- randomForest(x = train_data[, features], 
                         y = train_data$status,
                         ntree = 100)


prediction_rf <- predict(rf_model, newdata = test_data)
confusion_matrix_rf <- table(Predicted = prediction_rf, Actual = test_data$status)
print(confusion_matrix_rf)
```

    ##          Actual
    ## Predicted   0   1
    ##         0  46  20
    ##         1  57 153

``` r
accuracy_rf <- sum(diag(confusion_matrix_rf)) / sum(confusion_matrix_rf)
print(paste("Accuracy of Random Forest model:", accuracy_rf))
```

    ## [1] "Accuracy of Random Forest model: 0.721014492753623"

``` r
# ------------------------------------Ensambles---------------------------------------

predictions_tree <- predict(tree_model, newdata = test_data, type = "class")
predictions_rf <- predict(rf_model, newdata = test_data)

## Combine the predictions (Majority Voting)
combined_predictions <- data.frame(predictions_tree, predictions_rf)

## Determine the final predictions based on majority voting
final_predictions <- apply(combined_predictions, 1, function(x) {
  names(which.max(table(x)))
})
confusion_matrix_ensemble <- table(Predicted = final_predictions, Actual = test_data$status)
accuracy_ensemble <- sum(diag(confusion_matrix_ensemble)) / sum(confusion_matrix_ensemble)
print(paste("Accuracy of Ensemble model:", accuracy_ensemble))
```

    ## [1] "Accuracy of Ensemble model: 0.677536231884058"

``` r
## The decision trees model is still the most accurate, so i think that is the best for predictions
```
