library(tidyverse)
library(shiny)
library(shinydashboard)

load(file = "./data/resturantdata.rda")

category <- distinct(resturantdata, MenuCategory)

choices = setNames(category$MenuCategory,category$MenuCategory)

minPrice <- min(as.integer(resturantdata$MenuPrice))
maxPrice <- max(as.integer(resturantdata$MenuPrice))

ui <- dashboardPage(
    dashboardHeader(title = "Resturant Dashboard"),
    dashboardSidebar(
        sliderInput("pricerange",
                    "Price:",
                    min = minPrice,
                    max = maxPrice,
                    value = c(minPrice,maxPrice)),
        selectInput("category", "Menu Category:",  choices)
    ),
    dashboardBody
    (
        fluidRow
        (
            column
            (
                width=12,
                height=300,
                box(
                    width=3,
                    title = "CATEGORY", status = "primary", solidHeader = TRUE,
                    collapsible = TRUE,
                    tableOutput("table")
                    ),
                infoBoxOutput("items"),
                box(
                    width=8,
                    title = "MENU ITEMS", status = "primary", solidHeader = TRUE,
                    collapsible = TRUE,
                    plotOutput("distPlot")
                )
            ),
        )
    )
)