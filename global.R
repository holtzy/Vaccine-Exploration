# Load libraries
library(shinydashboard)
library(highcharter)
data("vaccines")
library(ggplot2)
library(dplyr)
library("viridis")
library(leaflet)
library(hrbrthemes)
library(rgdal)

# rename dataset
data <- vaccines


# ---------- #
# MAP OBJECT PREPARATION
# Load shape file of US state + merge with vaccines values
# ---------- #

# Note: US states data found here. And saved in the DATA folder.
# https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html

# Load map at spdf format:
data_spdf <- readOGR( dsn="DATA/" , layer="cb_2016_us_state_20m")
