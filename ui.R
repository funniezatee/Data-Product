library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Traffic Accident data - UK Leeds 2014"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    
    radioButtons("sex", "1. View some plots:", c("Gender Histogram", "Casualty Age Distribution")),
    radioButtons("date",  "2. Casualty count by time period. Select 'Bar Plot' for overall figures in the year. Select 'point plot' to account for specific date range.", c("Bar Plot", "Point Plot")),
    dateRangeInput("daterange", "Plot Points Date range:",
                   start = "2014-01-02",
                   end   = "2015-01-01"),
    
    h5(strong("3. View combinations of variables together:")),
    h5(strong("X-Axis: Time Period 2014")),
    selectInput("variable2", "Y-Axis:",
                c("Number.of.Vehicles" = "Number.of.Vehicles",
                  "Number.of.Casualties" = "Number.of.Casualties",
                  "Road.Surface" = "Road.Surface",
                  "Lighting.Conditions" = "Lighting.Conditions",
                  "Weather.Conditions" = "Weather.Conditions",
                  "Casualty.Severity" = "Casualty.Severity",
                  "Sex.of.Casualty" = "Sex.of.Casualty",
                  "Age.of.Casualty" = "Age.of.Casualty",
                  "Type.of.Vehicle" = "Type.of.Vehicle")),
    selectInput("variable3", "Variable 3 (shape):",
                c("Number.of.Vehicles" = "Number.of.Vehicles",
                  "Number.of.Casualties" = "Number.of.Casualties",
                  "Road.Surface" = "Road.Surface",
                  "Lighting.Conditions" = "Lighting.Conditions",
                  "Weather.Conditions" = "Weather.Conditions",
                  "Casualty.Severity" = "Casualty.Severity",
                  "Sex.of.Casualty" = "Sex.of.Casualty",
                  "Age.of.Casualty" = "Age.of.Casualty",
                  "Type.of.Vehicle" = "Type.of.Vehicle"), selected='Sex.of.Casualty'),
    selectInput("variable4", "Variable 4 (size):",
                c("Number.of.Vehicles" = "Number.of.Vehicles",
                  "Number.of.Casualties" = "Number.of.Casualties",
                  "Road.Surface" = "Road.Surface",
                  "Lighting.Conditions" = "Lighting.Conditions",
                  "Weather.Conditions" = "Weather.Conditions",
                  "Casualty.Severity" = "Casualty.Severity",
                  "Sex.of.Casualty" = "Sex.of.Casualty",
                  "Age.of.Casualty" = "Age.of.Casualty",
                  "Type.of.Vehicle" = "Type.of.Vehicle")),
    
    h5(strong("4. View accidents in a map:")),
    sliderInput("map", "Zoom level:", min=6, max=14, value=12)
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
        tabPanel("Graphs",
            br(),
            helpText("1. Type of plot selected:"),
            verbatimTextOutput("result"),
            plotOutput("plot1"),
            
            helpText("2. Date range selected for plot points:"),
            verbatimTextOutput("result2"),
            plotOutput("plot2"),
            
            helpText("3. Variables selected for combination mega plot:"),
            plotOutput("plot3"),
            
            helpText("4. Accident Map of Leeds, UK."),
            textOutput("zoom"),
            verbatimTextOutput("result3"),
            plotOutput("plot4"),
            
            p(h6("Data Source: http://data.gov.uk/dataset/road-traffic-accidents"))
        ),
        tabPanel("Instructions",
            br(),
            p("This work is thanks to data collected from the UK government dataset website (see below). It describes the traffic accident data in UK
              , Leeds in the year 2014."),
            
            p("In section 1:"),
            p("You get to observe the accident bias based on gender. You can also choose to view a plot based
              on Age distribution."),
            
            p("In section 2:"),
            p("We get to observe the casualty count based on the 2014 time period.
              This we can see with the bar plot. For more details, you can use the Point plot
              to visualize. You can even adjust by date range. This applies to the point plot only."),
            
            p("In section 3:"),
            p("You get to play with a number of variables in this combination plot. The x-axis variable is fixed at date.
              You get to adjust the y-axis, shape, and size variables."),
            
            p("In section 4:"),
            p("You can view the accident locations on the map. Each red dot represents an accident occurence.
              Play with the zoom to visualize from different perspectives."),
            br(),
            strong(tags$a(href="http://rpubs.com/funniezatee/91091", "View R Presentation")),
            br(),
            br(),
            br(),
            p(h6("Data Source: http://data.gov.uk/dataset/road-traffic-accidents")),
            p(h6("Additional tools for coordinates conversion: http://ww2.scenic-tours.co.uk/serve.php?t=WoNlbJvoVlhuJL5405objaa8jVO8atNuwZV"))
        )         
    )
    
  )
))