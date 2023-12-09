library(shiny)
library(shinyjs)
library(proxy)
library(rsconnect)
source("userrecommender.R")

#UI
ui <- ((fluidPage(  
  titlePanel("Anime Recommendation System"),
  sidebarLayout(
    sidebarPanel(width=5, position = c("left"),
      h3("Rate any 5 unique Anime from the Dropdown Boxes"),
      div(style="display:inline-block",
      selectizeInput(
        inputId = "anime_1", 
        label = "#1", 
        multiple = FALSE,
        choices = NULL,
        selected = NULL,
        width = '200px',
        options = list(placeholder= "Search"))),
      div(style="display:inline-block",
      selectizeInput(
        inputId = "anime_1_rating", 
        label = NULL, 
        multiple = FALSE,
        choices = NULL,
        selected = NULL,
        width = '100px',
        options = list(
          placeholder= "Rating"
        ))),
      hr(),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_2", 
            label = "#2", 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '200px',
            options = list(placeholder= "Search"))),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_2_rating", 
            label = NULL, 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '100px',
            options = list(
              placeholder= "Rating"
            ))),
      hr(),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_3", 
            label = "#3", 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '200px',
            options = list(placeholder= "Search"))),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_3_rating", 
            label = NULL, 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '100px',
            options = list(
              placeholder= "Rating"
            ))),
      hr(),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_4", 
            label = "#4", 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '200px',
            options = list(placeholder= "Search"))),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_4_rating", 
            label = NULL, 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '100px',
            options = list(
              placeholder= "Rating"
            ))),
      hr(),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_5", 
            label = "#5", 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '200px',
            options = list(placeholder= "Search"))),
      div(style="display:inline-block",
          selectizeInput(
            inputId = "anime_5_rating", 
            label = NULL, 
            multiple = FALSE,
            choices = NULL,
            selected = NULL,
            width = '100px',
            options = list(
              placeholder= "Rating"
            ))),
      hr(),
      h3("Click on an Algorithm Below to Get Ratings"),
      actionButton("returnIBCF", "IBCF"),
      actionButton("returnUBCF", "UBCF"),
      actionButton("returnALS", "ALS"),
      actionButton("returnSVD", "SVD"),
      actionButton("returnHybrid", "Hybrid"),
    ),
    mainPanel(width=7, position = c("right"),
             h3(textOutput("rec_text")),
             tableOutput("table"))
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
    "anime_1_rating", 
    choices = sort(rating_select$Rating),
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
    "anime_2_rating", 
    choices = sort(rating_select$Rating),
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
    "anime_3_rating", 
    choices = sort(rating_select$Rating),
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
    "anime_4_rating", 
    choices = sort(rating_select$Rating),
    selected = character(0), 
    server = TRUE)
  updateSelectizeInput(
    session, 
    "anime_5", 
    choices = sort(anime_df_sample$English.name),
    selected = character(0), 
    server = TRUE)
  updateSelectizeInput(
    session, 
    "anime_5_rating", 
    choices = sort(rating_select$Rating),
    selected = character(0), 
    server = TRUE)
  
  observeEvent(input$returnIBCF, {
    output$rec_text <- renderText("Recommendations Using IBCF:")
    output$table <- renderTable({
      get_ibcf_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5, 
                    input$anime_1_rating, input$anime_2_rating, input$anime_3_rating, input$anime_4_rating, input$anime_5_rating)
    })
  })
  
  observeEvent(input$returnUBCF, {
    output$rec_text <- renderText("Recommendations Using UBCF:")
    output$table <- renderTable({
      get_ubcf_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5, 
                    input$anime_1_rating, input$anime_2_rating, input$anime_3_rating, input$anime_4_rating, input$anime_5_rating)
    })
  })

  observeEvent(input$returnALS, {
    output$rec_text <- renderText("Recommendations Using ALS:")
    output$table <- renderTable({
      get_als_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5, 
                   input$anime_1_rating, input$anime_2_rating, input$anime_3_rating, input$anime_4_rating, input$anime_5_rating)
    })
  })
  
  observeEvent(input$returnSVD, {
    output$rec_text <- renderText("Recommendations Using SVD:")
    output$table <- renderTable({
      get_svd_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5, 
                   input$anime_1_rating, input$anime_2_rating, input$anime_3_rating, input$anime_4_rating, input$anime_5_rating)
    })
  })
  
  observeEvent(input$returnHybrid, {
    output$rec_text <- renderText("Recommendations Using Hybrid:")
    output$table <- renderTable({
      get_hybrid_recs(input$anime_1, input$anime_2,input$anime_3,input$anime_4,input$anime_5, 
                      input$anime_1_rating, input$anime_2_rating, input$anime_3_rating, input$anime_4_rating, input$anime_5_rating)
    })
  })
  
})

#get ratings from new users button?

# Run Shiny App
shinyApp(ui=ui,server=server)


# old code

#observeEvent(input$anime_1, {updateSelectizeInput(session,"anime_1", choices = anime_df$English.name, server = TRUE)})

#onclick("anime_1", {})
