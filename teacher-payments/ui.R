library(shiny)

shinyUI(fluidPage(
    titlePanel("Teacher Payment Calculator"),
    sidebarLayout(
        sidebarPanel(
            numericInput(inputId = "paypal", label = "PayPal Revenue", value = 100),
            numericInput(inputId = "square", label = "Square Revenue", value = 100),
            numericInput(inputId = "cash", label = "Cash Revenue", value = 100),
            numericInput(inputId = "venue", label = "Venue Cost", value = 100),
            numericInput(inputId = "other_expenses", label = "Other Expenses", value = 0),
            hr(style = "border-top: 1px solid #000000;"),
            numericInput(inputId = "numTeachers", label = "Number of Teachers", value = 4, min = 1),
            numericInput(inputId = "lessonLength", label = "Lesson Length (hours)", value = 1), 
            numericInput(inputId = "hourlyRate", label = "Hourly Teacher Rate", value = 25),
            numericInput(inputId = "swingFraction", label = "Swing Society Share (%)",
                         value = 25, min = 0, max = 100), 
            submitButton()
        ),
        mainPanel(
            h2("Revenue Calculation"),
            p("Revenue Calculation: (PayPal + Square + Cash) - (Venue Cost + Other Expenses) "),
            textOutput("revenue_calc"),
            h4(textOutput("revenue")),
            hr(),
            h3("Teacher Inputs"),
            uiOutput("teacherInputs"),
            #actionButton("add_teacher", label = "Add Teacher"),
            h2("Teacher payments"),
            tableOutput("payments"), 
            hr(),
            h2("Calculations"), 
            textOutput("total_lessons"),
            textOutput("profit_to_split"),
            textOutput("corvallis_swing_share"),
            textOutput("teacher_share")
        )
    )

))
