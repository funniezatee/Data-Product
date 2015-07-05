library(shiny)
library(ggplot2)
library(plyr)
library(ggmap)


#load data
data = read.csv("accidents2014.csv", header = TRUE)

#replace factor data
data$Sex.of.Casualty <- gsub("1", "Male", data$Sex.of.Casualty) 
data$Sex.of.Casualty <- gsub("2", "Female", data$Sex.of.Casualty) 
data$Road.Surface <- gsub("1", "Dry", data$Road.Surface)
data$Road.Surface <- gsub("2", "Wet/Damp", data$Road.Surface)
data$Road.Surface <- gsub("3", "Snow", data$Road.Surface)
data$Road.Surface <- gsub("4", "Frost/Ice", data$Road.Surface)
data$Road.Surface <- gsub("5", "Flood (0ver 3cm)", data$Road.Surface)
data$Lighting.Conditions <- gsub("1", "Daylight: street lights present", data$Lighting.Conditions)
data$Lighting.Conditions <- gsub("2", "Daylight: no street lighting", data$Lighting.Conditions)
data$Lighting.Conditions <- gsub("3", "Daylight: street lighting unknown", data$Lighting.Conditions)
data$Lighting.Conditions <- gsub("4", "Darkness: street lights present and lit", data$Lighting.Conditions)
data$Lighting.Conditions <- gsub("5", "Darkness: street lights present but unlit", data$Lighting.Conditions)
data$Lighting.Conditions <- gsub("6", "Darkness: no street lighting", data$Lighting.Conditions)
data$Lighting.Conditions <- gsub("7", "Darkness: street lighting unknown", data$Lighting.Conditions)
data$Weather.Conditions <- gsub("1", "Fine without high winds", data$Weather.Conditions)
data$Weather.Conditions <- gsub("2", "Raining without high winds", data$Weather.Conditions)
data$Weather.Conditions <- gsub("3", "Snowing without high winds", data$Weather.Conditions)
data$Weather.Conditions <- gsub("4", "Fine with high winds", data$Weather.Conditions)
data$Weather.Conditions <- gsub("5", "Raining with high winds", data$Weather.Conditions)
data$Weather.Conditions <- gsub("6", "Snowing with high winds", data$Weather.Conditions)
data$Weather.Conditions <- gsub("7", "Fog or mist - if hazard", data$Weather.Conditions)
data$Weather.Conditions <- gsub("8", "Other", data$Weather.Conditions)
data$Weather.Conditions <- gsub("9", "Unknown", data$Weather.Conditions)
data$Casualty.Class <- gsub("1", "Driver or rider", data$Casualty.Class)
data$Casualty.Class <- gsub("2", "Vehicle or pillion passenger", data$Casualty.Class)
data$Casualty.Class <- gsub("3", "Pedestrian", data$Casualty.Class)
data$Casualty.Severity <- gsub("1", "Fatal", data$Casualty.Severity)
data$Casualty.Severity <- gsub("2", "Serious", data$Casualty.Severity)
data$Casualty.Severity <- gsub("3", "Slight", data$Casualty.Severity)

index <- with(data, Type.of.Vehicle>21 )
data[index, 'Type.of.Vehicle'] <- "others"

data$Type.of.Vehicle <- gsub("1", "Pedal cycle", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("2", "M/cycle < Fifty cc", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("3", "M/cycle > Fifty cc and < hundred twenty five cc", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("4", "M/cycle > hundred twenty five cc and < five hundred cc", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("5", "M/cycle > five hundred cc", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("8", "Taxi/Private hire car", data$Type.of.Vehicle )

data$Type.of.Vehicle <- gsub("9", "Car", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("10", "Minibus (Eight - sixteen passenger seats)", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("11", "Bus or coach (seventeen or more passenger seats)", data$Type.of.Vehicle )

data$Type.of.Vehicle <- gsub("14", "Other motor vehicle", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("15", "Other non-motor vehicle", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("16", "Ridden horse", data$Type.of.Vehicle )

data$Type.of.Vehicle <- gsub("17", "Agricultural vehicle (includes diggers etc.)", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("18", "Tram / Light rail", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("19", "Goods vehicle 3.5 tonnes mgw and under", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("20", "Goods vehicle over 3.5 tonnes and under 7.5 tonnes mgw", data$Type.of.Vehicle )
data$Type.of.Vehicle <- gsub("21", "Goods vehicle 7.5 tonnes mgw and over", data$Type.of.Vehicle )


#set proper type formats
data[,1] <- as.character(data[,1])
data[,6] <- as.Date(data[,6], "%d/%m/%Y")
data[,7] <- sprintf("%04d", data[,7])
data[,7] <- substr(strptime(data[,7], '%H%M'), 11,19)
data[,8] <- as.factor(data[,8])
data[,9] <- as.factor(data[,9])
data[,10] <- as.factor(data[,10])
data[,11] <- as.factor(data[,11])
data[,12] <- as.factor(data[,12])
data[,13] <- as.factor(data[,13])
data[,14] <- as.factor(data[,14])
data[,16] <- as.factor(data[,16])

str(data)




shinyServer(function(input, output) {
  output$result = renderPrint({
      input$sex
  })
  output$result2 = renderPrint({
    input$daterange
  })
  output$result3 = renderPrint({
    input$map
  })
  output$zoom <- renderText({ 
    "Zoom level (takes a while to load):"
  })
  
  output$plot1 <- renderPlot(function() {
   
    if(input$sex=="Gender Histogram"){
        
        print(qplot(Sex.of.Casualty, data=data, geom = "bar"))
    } else {
        ggplot(data, aes(x=Age.of.Casualty)) + 
        geom_histogram(aes(y=..density..), colour="black", fill="blue") 
    }
  })
  
  
  output$plot2 <- renderPlot(function() {
   
    casualtyPerDate <- ddply(data, .(Accident.Date), summarise, total=sum(Number.of.Casualties))
    casualtyPerDate$total=as.numeric(casualtyPerDate$total)
    
    casualtyPerDate <- subset(casualtyPerDate, Accident.Date > input$daterange[1] & Accident.Date < input$daterange[2])
    
    
    if(input$date=="Bar Plot") {
    
        print(qplot(Accident.Date, data=data, geom = "bar"))
     
    } else if(input$date=="Point Plot") {  
      
        print(ggplot() + geom_point(casualtyPerDate, mapping=aes(x=Accident.Date, y=total), color='red'))
        
      }
    })
    
  
  output$plot3 <- renderPlot(function() {
      xaxis <- "Accident.Date"
      ggplot() + 
      geom_point(data, mapping=aes_string(x=xaxis, y=input$variable2, shape=input$variable3, color=input$variable3, size=input$variable4)) 
  
    
  })
  
  #load converted coordinates latitude and longtitude
  converted <- read.table("converted.txt", header=FALSE, sep = ',')
  converted <- as.data.frame(converted)
  converted <- rename(converted, c("V1"="lat", "V2"="lon"))
  
    output$plot4 <- renderPlot(function() {
      
        uk <- get_map("Leeds,United Kingdom", zoom=input$map)  
        p <- ggmap(uk)  
        p <- p + geom_point(data=converted, aes(x=lon, y=lat),  color="red", size=0.9, alpha=0.6)  
        p  
       
  })
  
})