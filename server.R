library(shiny)
library(ggplot2)
library(maps)
library(mapdata)
library(car) 
data_2014 = read.csv ("Data/2014.csv", header = TRUE)
data_2013 = read.csv ("Data/2013.csv", header = TRUE)
data_2014 = data.frame (data_2014)
data_2013 = data.frame (data_2013)
#data_nfl = data   
row.names(data_2014) <- data_2014$Team
row.names(data_2013) <- data_2013$Team

shinyServer(function(input, output) {
  
  fulldata <- reactive({
    switch(input$dataset,
           "2014" = data_2014,                    
           "2013" = data_2013,)
  })
  
  
  
  output$map <- renderPlot({
    
    metric <- switch(input$var, 
                    "Total Points" = fulldata()$Total.Points,
                    "Total Touchdowns" = fulldata()$Total.TD,
                    "Rushing Touchdowns" = fulldata()$Rushing.TD,
                    "Passing Touchdowns" = fulldata()$Passing.TD
                    )    
    
    map('state', fill = FALSE, col = "#cccccc",resolution=)
    symbols(fulldata()$Longitude, fulldata()$Latitude, 
            circles=((pi * metric^2)), 
            add=TRUE, inches=0.35, bg="#ff7a67", fg="#ffffff")
    #(pi * metric^2)
  })

  
  # a large table, reative to input$show_vars
  output$mytable1 <- renderDataTable({
    fulldata()[, input$show_vars, drop = FALSE]
  })
  
  
  output$heat <- renderPlot({
    
    metric2 <- switch(input$var, 
                     "Total Points" = fulldata()$Total.Points,
                     "Total Touchdowns" = fulldata()$Total.TD,
                     "Rushing Touchdowns" = fulldata()$Rushing.TD,
                     "Passing Touchdowns" = fulldata()$Passing.TD,
    ) 
    
    data_heat = fulldata() [, c(15, 4:12, 14, 18:23)]
    data_heat = data_heat [order(metric2),]
    data_heat = data.matrix (data_heat)
    red_colors <- c("#ffd3cd", "#ffc4bc", "#ffb5ab", "#ffa69a", 
                    "#ff9789", "#ff8978", "#ff7a67", "#ff6b56", "#ff5c45", "#ff4d34")
    data_heatmap = heatmap(data_heat, Rowv=NA, Colv=NA, 
                            col = red_colors, scale="column", margins=c(10,2))
    })
  
  output$plot <- renderPlot({
    
    metric3 <- switch(input$var2, 
                      "Total Touchdowns" = fulldata()$Total.TD,
                      "Rushing Touchdowns" = fulldata()$Rushing.TD,
                      "Passing Touchdowns" = fulldata()$Passing.TD,
                      "Kickoff Return Touchdowns" = fulldata()$Kickoff.Return,
                      "Punt Return Touchdowns" = fulldata()$Punt.Return,
                      "Interception Return Touchdowns" = fulldata()$Interception.Return,
                      "Fumble Return Touchdowns" = fulldata()$Fumble.Return,
                      "Blocked FG Return Touchdowns" = fulldata()$Blocked.FG.Return,
                      "Blocked P Return Touchdowns" = fulldata()$Punt.Return,
                      "FG Miss Return Touchdowns" = fulldata()$FG.Miss.Return,
                      "Safeties" = fulldata()$Safeties,
                      "Points After TD Rate" = fulldata()$Points.after.TD.Rate,
                      "FG Rate" = fulldata()$FG.Rate,
                      "Penalties Committed" = fulldata()$Pen.Commited,
                      "Penalties Received" = fulldata()$Pen.Received,
                      "Penalties Yard Differential" = fulldata()$Pen.Yard.Diff,
                      "Turnover Differential" = fulldata()$Turnover.Diff
    )
    
    metric2 <- switch(input$var, 
                      "Total Points" = fulldata()$Total.Points,
                      "Total Touchdowns" = fulldata()$Total.TD,
                      "Rushing Touchdowns" = fulldata()$Rushing.TD,
                      "Passing Touchdowns" = fulldata()$Passing.TD,
    ) 
    
    mod = scatterplot (metric3, metric2, xlab = "Selected Indicator 2", ylab = "Selected Indicator 1", col = c("#808080", "#ff7a67", "#000000"))
    
   
    
    
    #coef (mod)
    #p2 <- ggplot(data_nfl,aes(metric3, data_nfl$Total.Points))
    #p2+geom_point(aes(alpha=Safeties))+geom_smooth()+labs(x="Other Metric", y="Total Points")
  })
    
  
  output$cor <- renderTable({
    
    metric4 <- switch(input$var2, 
                      "Total Touchdowns" = fulldata()$Total.TD,
                      "Rushing Touchdowns" = fulldata()$Rushing.TD,
                      "Passing Touchdowns" = fulldata()$Passing.TD,
                      "Kickoff Return Touchdowns" = fulldata()$Kickoff.Return,
                      "Punt Return Touchdowns" = fulldata()$Punt.Return,
                      "Interception Return Touchdowns" = fulldata()$Interception.Return,
                      "Fumble Return Touchdowns" = fulldata()$Fumble.Return,
                      "Blocked FG Return Touchdowns" = fulldata()$Blocked.FG.Return,
                      "Blocked P Return Touchdowns" = fulldata()$Punt.Return,
                      "FG Miss Return Touchdowns" = fulldata()$FG.Miss.Return,
                      "Safeties" = fulldata()$Safeties,
                      "Points After TD Rate" = fulldata()$Points.after.TD.Rate,
                      "FG Rate" = fulldata()$FG.Rate,
                      "Penalties Committed" = fulldata()$Pen.Commited,
                      "Penalties Received" = fulldata()$Pen.Received,
                      "Penalties Yard Differential" = fulldata()$Pen.Yard.Diff,
                      "Turnover Differential" = fulldata()$Turnover.Diff
    )
    
    metric5 <- switch(input$var, 
                      "Total Points" = fulldata()$Total.Points,
                      "Total Touchdowns" = fulldata()$Total.TD,
                      "Rushing Touchdowns" = fulldata()$Rushing.TD,
                      "Passing Touchdowns" = fulldata()$Passing.TD,
    )
    
    
    
    #fulldata() = as.integer (fulldata()) 
    #d = fulldata()[c("Total.Points", "Total.TD")]
    #d <- d[,sapply(d,is.integer)|sapply(d,is.numeric), ] 
    #fulldata()
    #d = matrix (d)
    #d
    d = fulldata()[,sapply(fulldata(), is.integer)| sapply(fulldata(), is.numeric)]
    #d = fulldata()[,c(fulldata()$Total.Points, fulldata()$Total.TD)]
    d = d[,c(13, 2:4, 12, 16:21)]
    cor <- as.data.frame(round(cor(d), 6))
    cor <- cbind(Variables = rownames(cor), cor)
    cor
    #cor[, input$show_vars, drop = FALSE]
  })
  
})