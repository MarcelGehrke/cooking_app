server <- function(input, output, session) {
    
# Read data ---------------------------------------------------------------

    data <-
        readODS::read_ods("data/recipes_db.ods", sheet = "rezepte")
    
    id_s <- list(unique(data$rezept_id))
    ingredients <- list()
    
    for (i in seq_along(id_s)) {
        ingredients[[i]] <-
            readODS::read_ods("data/recipes_db.ods", sheet = id_s[[i]])
        
        ingredients
    }
    
    names(ingredients) <- as.character(id_s)


# Table all recipes -------------------------------------------------------

    output$recipes_table <- DT::renderDataTable({
        DT::datatable(data = data %>% select(-rezept_id, -url),
                      rownames = FALSE)
    }, server = FALSE)
    


# Define number of portions -----------------------------------------------
    
    
    output$text <- renderText({
        sel <- input$recipes_table_rows_selected
        
        if (!is.null(sel)) {
            paste("Mmh, es soll also",
                  data[sel, ]$Gericht,
                  "geben.")
        }
        
        else {
            paste("Bitte wähle ein Gericht aus.")
        }
    })
    

# Recipe website ----------------------------------------------------------

    output$recipe_website <- renderUI({
        if (!is.null(input$recipes_table_rows_selected)) {
            sel <- input$recipes_table_rows_selected
            tagList("Und so gehts:", a("Rezept Website", href = data[sel,]$url))
        }
    })
    
# Table selected recipe ---------------------------------------------------

    output$ingredients_table <- DT::renderDataTable({
        if (!is.null(input$recipes_table_rows_selected)) {
            sel <- input$recipes_table_rows_selected
            orig_portions <- data[sel,]$Portionen
            
            ingredients_table <-
                ingredients[[data[sel,]$rezept_id]] %>%
                select(-rezept_id) %>%
                mutate(menge = (menge / orig_portions) * input$number_portions)
            
            DT::datatable(data = ingredients_table,
                          rownames = FALSE)
        }
    }, server = FALSE)

# Add to shopping list ----------------------------------------------------

observeEvent(input$add_to_cart, {
    sendSweetAlert(
        session = session,
        title = "Auf der Liste!",
        text = "Die Zutaten wurden deiner Einkaufsliste hinzugefügt.",
        type = "success"
    )
    })
    

# Shopping List -----------------------------------------------------------

    shopping_list <- reactiveValues()
    
    observe({
        if (input$add_to_cart > 0) {
            val <-  input$add_to_cart[[1]]
            sel <- input$recipes_table_rows_selected
            
            shopping_list[[as.character(sel)]] <-
                ingredients[[data[sel,]$rezept_id]]
        }
    })
}



