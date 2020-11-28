#Library laden
library(shiny)
library(tidyverse)
library(e1071)


# Wir laden den Model einmal
model.svm <- readRDS('titanic.svm.rds')


#Hier gestalten wir die UI für unseren App
ui <- fluidPage(
  
  #Titel für App benennen
  titlePanel("Die Wahrscheinlichkeit, dass Sie vom Titanic Unfall überleben werden"),
  
  # Sidebar layout für Definition der INPUT und OUTPUT 
  sidebarLayout(
    
    
    sidebarPanel(
      
      
      sliderInput("age", "Alter:",
                  min = 0, max = 150,
                  value = ""),
      
      selectInput("sex", selected = NULL, "Geschlecht:",
                  c("weiblich" = 1,
                    "maennlich" = 0)),
      
      selectInput("pclass", selected = NULL, "Passagierklasse:",
                  c("erste Klasse" = 1,
                    "zweite Klasse" = 2,
                    "dritte Klasse" = 3)),
      
      
      
      actionButton("action", label = "Werden Sie überleben?")
    ),
    
    # Main panel für die OUTPUT
    
    mainPanel(
      
      tableOutput("value1")
      
    )
  )
)

# Server Logic definieren
server <- function(input, output, session) {
  
  
  observeEvent(input$action, {
    pclass <- as.numeric(input$pclass)
    sex <- as.numeric(input$sex)
    age <- input$age
    data <- data.frame(pclass,sex,age)
    result <- predict(model.svm, data, probability = TRUE)
    my_result <- data.frame(attr(result, "probabilities"))
    output$value1 <- renderTable(my_result)
  }
  )
  
  
}


# Shiny App yu erstellen
shinyApp(ui, server)

