# Performance Review: The Significance of the NFL Combine

## STAT 306: Multivariate Sports Analytics

## Why the NFL Combine?
- The NFL Combine is one of the few benchmarks done consistently for past and present NFL Players
- Unique data across many years
- Relatively uncertain on the importance of the combine
- Existing research finds little to no relationship between combine and NFL performance
- Data used for analysis:
  - NFL Combine Data (Via Kaggle) from 2000-2018
  - NFL Pass-Defender Data (also Via Kaggle) from 2018
  - Challenges with data wrangling and fixes!

## Regression Analysis
- Started with full regression model (Adjusted R-squared = 0.8166)
- Used manual elimination to improve model (Adjusted R-squared = 0.823)
- Significant variables: Experience, position, incompletion rate, interception rate
- Height and combine vertical jump also significant at 10% level
- Concerns with regression:
  - Particularly Bad VIFs
  - Normality concern: Nonparametric multiple regression

## K-Means Clustering
- Sometimes multi-position athletes will strategically decide their “position” for the combine based on how they expect to perform
- Players may also be better fit for a different position based on their physical attributes
- What is k-means clustering?
- Our uses for K-Means Clustering:
  - Removing position and seeing what natural groupings emerge

## Our Findings
- Surprisingly good accuracy for classification of clusters!
- Could also help players decide what position to list themselves as when entering the NFL draft


### Sources:
- [Medium Article on K-Means Clustering](https://medium.com/@robertb909/k-means-clustering-a64f859a1074)
- [GeeksforGeeks Article on K-Means Clustering in R](https://www.geeksforgeeks.org/k-means-clustering-in-r-programming/#)
- [Rfit Package Documentation](https://cran.r-project.org/web/packages/Rfit/Rfit.pdf)
- [R-bloggers Article on Principal Component Analysis (PCA) in R](https://www.r-bloggers.com/2021/05/principal-component-analysis-pca-in-r/)
- [NFL BDB Data on Kaggle](https://www.kaggle.com/datasets/chipkajb/nfl-bdb-data)
- Research Articles in Google Drive
