library(shiny)
library(semantic.dashboard)
library(shinyWidgets)
library(dplyr)
library(magrittr)


ui <- dashboardPage(
    dashboardHeader(
        title = span("Cooking App ", icon("utensils")),
        inverted = TRUE,
        color = "blue"
    ),
    dashboardSidebar(
        size = "thin",
        color = "blue",
        inverted = TRUE,
        
        sidebarMenu(
            menuItem(
                tabName = "recipes",
                text = "Rezepte",
                icon = icon("book")
            ),
            menuItem(
                tabName = "shopping_list",
                text = "Einkaufsliste",
                icon = icon("shopping cart")
            )
        )
    ),
    dashboardBody(tabItems(
        tabItem(tabName = "recipes",
                fluidRow(box(
                    color = "blue",
                    width = 12L,
                    DT::dataTableOutput("recipes_table")
                )),
                box(
                    color = "blue",
                    width = 6L,
                    shiny::textOutput("text"),
                    shiny::br(),
                    knobInput(
                        inputId = "number_portions",
                        label = "Wie viele Portionen dürfen es sein?",
                        value = 4,
                        min = 0,
                        max = 12,
                        displayPrevious = TRUE,
                        lineCap = "round",
                        fgColor = "#428BCA",
                        inputColor = "#428BCA"
                    ),
                    shiny::br(),
                    shiny::uiOutput("recipe_website")
                ),
                box(
                    color = "blue",
                    width = 6L,
                    DT::dataTableOutput("ingredients_table"),
                    shinyWidgets::useSweetAlert(),
                    actionBttn(
                        inputId = "add_to_cart",
                        label = "Ab auf die Einkaufsliste damit!",
                        style = "unite", 
                        color = "primary"
                        )
                    )
                ),
        tabItem(tabName = "shopping_list",
                h2("Test Menü 2"))
    ))
)