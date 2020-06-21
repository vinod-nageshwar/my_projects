library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(treemap)

load(file = "./data/resturantdata.rda")

shinyServer(function(input, output, session) {

    categorydata <- reactive({
        resturantdata %>% filter(as.integer(MenuPrice) >= input$pricerange[1] & as.integer(MenuPrice) <=input$pricerange[2]) %>% group_by(MenuCategory) %>% summarise(Items = n())
    })
    
    itemcount <- reactive({
        resturantdata %>% filter(as.integer(MenuPrice) >= input$pricerange[1] & as.integer(MenuPrice) <=input$pricerange[2]) %>% summarise(Items = n())
    })
    
    itemdata <- reactive({
        resturantdata %>% filter(as.integer(MenuPrice) >= input$pricerange[1] & as.integer(MenuPrice) <=input$pricerange[2] & MenuCategory == input$category)%>% mutate(Name = paste(MenuItem, "- Rs.",MenuPrice), MenuPrice=as.numeric(MenuPrice)) %>% select (Name, MenuPrice)
    })
    
    loadCategory <- reactive({
        result <- resturantdata %>% filter(as.integer(MenuPrice) >= input$pricerange[1] & as.integer(MenuPrice) <=input$pricerange[2]) %>% select(MenuCategory) %>% distinct() %>% arrange(MenuCategory)
        choices = setNames(result$MenuCategory,result$MenuCategory)
    })
    
    observeEvent(input$pricerange, {
        updateSelectInput(session, "category","Menu Category:",  loadCategory())
    }) 
    
    output$items <- renderValueBox({
        valueBox(
            itemcount()$Items,
            paste("No of Menu Items Available for the selected Price (Rs.",input$pricerange[1]," - "," Rs.",input$pricerange[2],")"),
            icon = icon("credit-card"),
            color = "yellow"
        )
    })

    output$table <- renderTable({
        tbl <- categorydata()
        if(nrow(tbl) > 0)
        {
            names(tbl) <- NULL
            tbl
        }

    })

     output$distPlot <- renderPlot({
         if (nrow(itemdata())>0){
         treemap(itemdata(),
                 index="Name",
                 vSize="MenuPrice",
                 vColor="MenuPrice",
                 type="value",
                 inflate.labels=F,
                 title.legend="",
                 title=""
                            )
         }
     })
    
})
