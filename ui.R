# ui.R
library(shiny)
library (googleVis)
shinyUI
(
  fluidPage
  (
    theme = "bootstrap_paper.css",
    h3("Conor Reid"),
    h4 ("Visualisation of NFL Scoring Trends in 2013, 2014"),
    
    sidebarLayout
    (
      sidebarPanel
      (
        p("This app aims to visualize data pertaining to the 
                 scoring records of each NFL team in the 2013 and 2014 Season."),
        
        br(),
        
        selectInput("dataset", "Choose a season to visualize", choices = 
                      c("2014", "2013")),
        
        
        conditionalPanel(condition = "input.conditionedPanels == 1 | input.conditionedPanels == 2",
        selectInput
        ("var", label = "Choose an overall team performance indictor to filter results by (Selected Indicator 1):", 
                    choices = list("Total Points",
                                    "Total Touchdowns", 
                                   "Rushing Touchdowns","Passing Touchdowns")
                    ,selected = "Total Points")),
              
        br(),
        
      
      conditionalPanel(condition = "input.conditionedPanels == 2",
      selectInput
      ("var2", label = "Choose a second indicator, which to generate the scatter plot (Selected Indicator 2):", 
       choices = list("Total Touchdowns", 
                      "Rushing Touchdowns","Passing Touchdowns", 
                      "Kickoff Return Touchdowns",
                      "Punt Return Touchdowns", "Interception Return Touchdowns",
                      "Fumble Return Touchdowns",
                      "Blocked FG Return Touchdowns",
                      "Blocked P Return Touchdowns",
                      "FG Miss Return Touchdowns",
                      "Safeties",
                      "Points After TD Rate",
                      "FG Rate",
                      "Penalties Committed",
                      "Penalties Received",
                      "Penalties Yard Differential",
                      "Turnover Differential"
                      )
       ,selected = "Total Touchdowns")),
      
      
      conditionalPanel(condition = "input.conditionedPanels == 3",
          checkboxGroupInput
                           ("show_vars",
                         "Chose Inputs:",
                         c("Team" = "Team",
                           "Total Points" = "Total.Points",
                           "Total Touchdowns" = "Total.TD",
                           "Rushing Touchdowns" = "Rushing.TD",
                           "Passing Touchdowns" = "Passing.TD",
                           "Kickoff Return Touchdowns" = "Kickoff.Return",
                           "Punt Return Touchdowns" = "Punt.Return", 
                           "Interception Return Touchdowns" = "Interception.Return",
                           "Fumble Return Touchdowns" = "Fumble.Return",
                           "Blocked FG Return Touchdowns" = "Blocked.FG.Return",
                           "Blocked P Return Touchdowns" = "Blocked.P.Return",
                           "FG Miss Return Touchdowns" = "FG.Miss.Return",
                           "Safeties" = "Safeties",
                           "Points After TD Rate" = "Points.after.TD.Rate",
                           "FG Rate" = "FG.Rate",
                           "Penalties Committed" = "Pen.Commited",
                           "Penalties Received" = "Pen.Received",
                           "Penalties Yard Differential" = "Pen.Yard.Diff",
                           "Turnover Differential" = "Turnover.Diff"
                           
                           ), 
                         selected = c("Team"))
                      )
      ),
      mainPanel
      (
        tabsetPanel(
          tabPanel (h4 ("Mapping"),
                    h4 ("Geomap"),
                    p("Below, team performance can be seen by the selected metric above in geographcal context. The size of the bubble indictes a higher score in the given statistic. Note that not every state is represented in the NFL, and some are home to more than one team."),
                    plotOutput("map"),
                    br(),
                    h4 ("Heat Map"),
                    p ("Below, a heat map of all available variables is shown. This map will automatically sort by
                       whatever performance statistic is chosen above. How their performance in the otehr metrics can then
                       be evaluated."),
                    plotOutput("heat"),
                    br(),
                    br(), value = 1),
          tabPanel (h4 ("Plotting"),
                    h4("Scatter Plot"),
                    p("The scatter plot graphs both statistics chosen above, and includes trend lines in addition to data points to better characterize the trend. Further, 
                      a box plot bar is shown below each axis title, indicating where the mean, quartiles and outliers lie. "),
                    plotOutput ("plot"),
                    br(),
                    textOutput ("stat"),
                    br(),
                    br(),
                    h4("Corrolations"),
                    p("Below, a table containing each variable and its corrolation value in realtion to each other variable is shown. A corrolation value furthest from 
                      zero indicates a high corrolation. Close to 1 indicates a strongly negitive realtionship, close to -1 a strongly positive relationship."),
                    p("It was orgianlly intented to have this table controlled by the variable selection module on the side
                      panel, however this was not possible in the time allotted."),
                    tableOutput ("cor"),
                    value = 2),
          tabPanel(h4 ("Tables"), 
                  h4 ("Data Table"), 
                  p("Below, an interactive datatable is included allowing the interrogation of the raw dataset that
                  is used in the construction of this app. One can join any of the available columns of the data 
                    to the displayed table, and sort by any of those columns. Specific teams can also be selected and relevent stats queryed."), 
                   dataTableOutput('mytable1'), value = 3),
          id = "conditionedPanels"
          
        )
      
      )
      
    )
  )
  )