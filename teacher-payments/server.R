library(shiny)

shinyServer(function(input, output) {
    
    
    output$revenue_calc <- renderText({
        paste("(",input$paypal,"+",input$square,"+",input$cash,") - (",
              input$other_expenses,"+", input$venue,")")
    })
    output$revenue <- renderText({
        revenue <- (input$paypal + input$square + input$cash) - (input$other_expenses + input$venue)
        paste("Total revenue = ", revenue )
    })
    
    output$teacherInputs <- renderUI({
        num_teachers <- input$numTeachers
        teacher_inputs <- lapply(1:num_teachers, function(i) {
            teacher_input <- list(
                textInput(inputId = paste0("teacher_", i), label = paste("Teacher", i, "Name"),
                          value = "name"),
                numericInput(inputId = paste0("lessons_", i), label = paste("Number of Lessons Taught", i), value = 1)
            )
            div(teacher_input, style = "display: flex; align-items: center;")
        })
        tagList(teacher_inputs)
    })
    
    output$total_lessons <- renderText({
        teacher_payments <- sapply(1:input$numTeachers, function(i) {
            input[[paste0("lessons_", i)]]
        })
        paste("Number of lessons (weeks):", sum(teacher_payments)/2)
    })
 
    
    output$profit_to_split <- renderText({
        teacher_payments <- sapply(1:input$numTeachers, function(i) {
            input[[paste0("lessons_", i)]] * input$hourlyRate * input$lessonLength
        })
        total_teacher_payment <- sum(teacher_payments)
        
        total_revenue <- (input$paypal + input$square + input$cash) - (input$other_expenses + input$venue)
        remaining_profit <- max(0,(total_revenue - total_teacher_payment))
        
        paste("Remaining profit: Revenue - teacher base rate = ",
              total_revenue, "-", total_teacher_payment, "=", remaining_profit, sep = "\n")
    })   
       
    output$corvallis_swing_share <- renderText({
        teacher_payments <- sapply(1:input$numTeachers, function(i) {
            input[[paste0("lessons_", i)]] * input$hourlyRate * input$lessonLength
        })
        total_teacher_payment <- sum(teacher_payments)
        total_revenue <- (input$paypal + input$square + input$cash) - (input$other_expenses + input$venue)
        remaining_profit <- total_revenue - total_teacher_payment
        if (remaining_profit > 0)  {
            corvallis_share <- remaining_profit*0.01*input$swingFraction
        }
        else{
            corvallis_share <- remaining_profit
        }
        
        paste("Corvallis Swing Dance Society Share: = Remaining profit * Share = ", 
              remaining_profit, "*", input$swingFraction, "=", corvallis_share)
    })
    
    output$teacher_share <- renderText({
        teacher_payments <- sapply(1:input$numTeachers, function(i) {
            input[[paste0("lessons_", i)]] * input$hourlyRate * input$lessonLength
        })
        total_teacher_payment <- sum(teacher_payments)
        total_revenue <- (input$paypal + input$square + input$cash) - (input$other_expenses + input$venue)
        remaining_profit <- max(0,(total_revenue - total_teacher_payment))
        teacher_share <- remaining_profit*(1 - 0.01*input$swingFraction)
        
        paste("Overall teacher share to be split based on classes taught:", teacher_share)
    })
    
    
    
    output$payments <- renderTable({
        total_lessons <- sum(sapply(1:input$numTeachers, function(i) {
            input[[paste0("lessons_", i)]]
        }))

        total_revenue <- (input$paypal + input$square + input$cash) - (input$other_expenses + input$venue)
        lesson_length <- input$lessonLength
        hourly_rate <- input$hourlyRate
        swing_fraction <- 0.01 * input$swingFraction
        
        wage_cost <- total_lessons * lesson_length * hourly_rate
        remaining_split <- total_revenue - wage_cost 
        teacher_split <- remaining_split * (1 - swing_fraction)
        
        
        teacher_data <- data.frame(
            Teacher = character(input$numTeachers),
            Payment = numeric(input$numTeachers),
            Share = numeric(input$numTeachers),
            Total = numeric(input$numTeachers)
        )
        
        for (i in 1:input$numTeachers) {
            teacher_name <- input[[paste0("teacher_", i)]]
            lessons <- input[[paste0("lessons_", i)]]
            payment <- hourly_rate * lesson_length * lessons
            
            if (wage_cost < total_revenue) {
                proportion <- lessons / total_lessons
                
                teacher_share <- proportion * teacher_split
                share <- round(teacher_share, 2)
                
                payment_with_share <- payment + teacher_share
                
                total_payment <- round(payment_with_share, 2)
            } else {
                share <- 0
                total_payment <- round(payment, 2)
            }
            
            teacher_data$Teacher[i] <- teacher_name
            teacher_data$Payment[i] <- round(payment, 2)
            teacher_data$Share[i] <- share
            teacher_data$Total[i] <- total_payment
        }
        
        teacher_data
    })
    
    
})
