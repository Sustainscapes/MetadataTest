Tests for metadata
================

## Prepare data for test

We will use some common R datasets just to test how dataspice works

``` r
# Create new folder for test data
dir.create("FakeData")
```

    ## Warning in dir.create("FakeData"): 'FakeData' already exists

``` r
#Call datasets from r
data("iris")
data("mtcars")

write.csv(iris, "FakeData/iris.csv", row.names = F)
write.csv(mtcars, "FakeData/mtcars.csv", row.names = F)
```

## Scripts

**TestsDataSpice.R:** Here we will go through the dataspice template to
see how we can start
