library(shiny)

shinyUI(fluidPage(
    titlePanel("Teacher Payment Calculator"),
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId = "numTeachers", label = "Number of Teachers", value = 1, min = 1),
            numericInput(inputId = "totalRevenue", label = "Total Revenue", value = 100),
            numericInput(inputId = "lessonLength", label = "Lesson Length (hours)", value = 1),
            numericInput(inputId = "hourlyRate", label = "Hourly Rate", value = 25),
            numericInput(inputId = "swingFraction", label = "Swing Society Share (%)",
                         value = .25, min = 0, max = 1)
        ),
        
        mainPanel(
            uiOutput("teacherInputs"),
            h4("Teacher payments"),
            tableOutput("payments"), 
            h4("Calculations"), 
            textOutput("total_lessons"),
            textOutput("profit_to_split"),
            textOutput("corvallis_swing_share"),
            textOutput("teacher_share")
        )
    )
))
