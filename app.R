library(shiny)
library(shinyjs)
library(proxy)
library(recommenderlab)
library(reshape2)
source("userrecommender.R")
load("anime_eval_schemes.rda")
load("ibcf_models.rda")
load("ubcf_models.rda")
load("als_models.rda")
load("svd_models.rda")
load("prediction_models.rda")

#UI
ui <- ((fluidPage(  
  titlePanel("Anime Recommendation System"),
  sidebarLayout(
    sidebarPanel(
      h3("Choose 1-5 Anime that you would rate higher than an 8/10"),
      selectizeInput(
        inputId = "anime_1", 
        label = "#1", 
        multiple = FALSE,
        choices = NULL,
        selected = NULL,
        options = list(
          placeholder= "Type to search"
        )),
      selectizeInput(
        inputId = "anime_2", 
        label = "#2", 
        multiple = FALSE,
        choices = NULL,
        selected = NULL,
        options = list(
          placeholder= "Type to search"
        )),
      selectizeInput(
        inputId = "anime_3", 
        label = "#3", 
        multiple = FALSE,
        choices = NULL,
        selected = NULL,
        options = list(
          placeholder= "Type to search"
        )),
      selectizeInput(
        inputId = "anime_4", 
        label = "#4", 
        multiple = FALSE,
        choices = NULL,
        selected = NULL,
        options = list(
          placeholder= "Type to search"
        )),
      selectizeInput(
        inputId = "anime_5", 
        label = "#5", 
        multiple = FALSE,
        choices = NULL,
        selected = NULL,
        options = list(
          placeholder= "Type to search"
        )),
      actionButton("returnIBCF", "Get Recommendations using IBCF"),
      actionButton("returnUBCF", "Get Recommendations using UBCF"),
      actionButton("returnALS", "Get Recommendations using ALS"),
      actionButton("returnSVD", "Get Recommendations using SVD"),
      actionButton("returnHybrid", "Get Recommendations using Hybrid"),
      hr()
    ),
    mainPanel(
      column(4,
             h3(textOutput("rec_text")),
             tableOutput("table"))
    )
  )
)))

#Server
server <- (function(input, output, session) {
  
  updateSelectizeInput(
    session, 
    "anime_1", 
    choices = sort(anime_df_sample$English.name),
    selected = character(0), 
    server = TRUE)
  updateSelectizeInput(
    session, 
    "anime_2", 
    choices = sort(anime_df_sample$English.name),
    selected = character(0), 
    server = TRUE)
  updateSelectizeInput(
    session, 
    "anime_3", 
    choices = sort(anime_df_sample$English.name),
    selected = character(0), 
    server = TRUE)
  updateSelectizeInput(
    session, 
    "anime_4", 
    choices = sort(anime_df_sample$English.name),
    selected = character(0), 
    server = TRUE)
  updateSelectizeInput(
    session, 
    "anime_5", 
    choices = sort(anime_df_sample$English.name),
    selected = character(0), 
    server = TRUE)
  
  observeEvent(input$returnIBCF, {
    output$rec_text <- renderText("Recommendations Using IBCF:")
    output$table <- renderTable({
      get_ibcf_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5)
    })
  })
  
  observeEvent(input$returnUBCF, {
    output$rec_text <- renderText("Recommendations Using UBCF:")
    output$table <- renderTable({
      get_ubcf_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5)
    })
  })

  observeEvent(input$returnALS, {
    output$rec_text <- renderText("Recommendations Using ALS:")
    output$table <- renderTable({
      get_als_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5)
    })
  })
  
  observeEvent(input$returnSVD, {
    output$rec_text <- renderText("Recommendations Using SVD:")
    output$table <- renderTable({
      get_svd_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5)
    })
  })
  
  observeEvent(input$returnHybrid, {
    output$rec_text <- renderText("Recommendations Using Hybrid:")
    output$table <- renderTable({
      get_hybrid_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5)
    })
  })
  
})

#get ratings from new users button?

# Run Shiny App
shinyApp(ui=ui,server=server)


# old code

#observeEvent(input$anime_1, {updateSelectizeInput(session,"anime_1", choices = anime_df$English.name, server = TRUE)})

#onclick("anime_1", {})
