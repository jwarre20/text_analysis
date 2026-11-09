library(shiny)

ability_scores <- c(
  "Strength" = "strength",
  "Dexterity" = "dexterity",
  "Constitution" = "constitution",
  "Intelligence" = "intelligence",
  "Wisdom" = "wisdom",
  "Charisma" = "charisma"
)

score_costs <- c(
  "8" = 0,
  "9" = 1,
  "10" = 2,
  "11" = 3,
  "12" = 4,
  "13" = 5,
  "14" = 7,
  "15" = 9
)

score_choices <- names(score_costs)
default_scores <- c(15, 14, 13, 12, 10, 8)

field <- function(id, label, placeholder = "") {
  textInput(id, label, placeholder = placeholder)
}

ui <- fluidPage(
  tags$head(tags$style(HTML("
    body { background: #f4f1eb; color: #242323; }
    .container-fluid { max-width: 1180px; }
    .app-header { padding: 28px 0 18px; border-bottom: 1px solid #d8d0c3; margin-bottom: 22px; }
    .app-header h1 { margin: 0 0 6px; font-family: Georgia, serif; }
    .app-header p { color: #655d52; margin: 0; }
    .panel-card { background: #fff; border: 1px solid #e1dbd1; border-radius: 8px; padding: 20px; margin-bottom: 18px; }
    .section-title { font-family: Georgia, serif; margin: 4px 0 16px; }
    .points-total { font-weight: 700; font-size: 18px; }
    .sheet-label { color: #655d52; font-size: 12px; text-transform: uppercase; letter-spacing: .06em; margin: 12px 0 2px; }
    .sheet-value { white-space: pre-wrap; overflow-wrap: anywhere; }
    .ability-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 0 14px; }
    @media (max-width: 767px) { .ability-grid { grid-template-columns: 1fr; } }
  "))),
  div(
    class = "app-header",
    h1("Adventurer's Ledger"),
    p("Build a character for your next campaign.")
  ),
  sidebarLayout(
    sidebarPanel(
      width = 5,
      div(
        class = "panel-card",
        h3(class = "section-title", "Identity"),
        field("character_name", "Character name", "e.g. Rowan Ashford"),
        fluidRow(
          column(6, selectInput("character_class", "Class",
            choices = c("Barbarian", "Bard", "Cleric", "Druid", "Fighter",
              "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"),
            selected = "Fighter"
          )),
          column(6, selectInput("species", "Species",
            choices = c("Dragonborn", "Dwarf", "Elf", "Gnome", "Halfling",
              "Human", "Orc", "Tiefling", "Other"),
            selected = "Human"
          ))
        ),
        fluidRow(
          column(6, field("background", "Background", "e.g. Sage")),
          column(6, selectInput("alignment", "Alignment",
            choices = c("Unspecified", "Lawful Good", "Neutral Good", "Chaotic Good",
              "Lawful Neutral", "True Neutral", "Chaotic Neutral", "Lawful Evil",
              "Neutral Evil", "Chaotic Evil")
          ))
        ),
        numericInput("level", "Level", value = 1, min = 1, max = 20, step = 1)
      ),
      div(
        class = "panel-card",
        h3(class = "section-title", "Ability scores"),
        p("Assign scores from 8 to 15 using a 27-point buy."),
        div(class = "ability-grid",
          lapply(seq_along(ability_scores), function(i) {
            selectInput(
              ability_scores[[i]],
              names(ability_scores)[i],
              choices = score_choices,
              selected = as.character(default_scores[[i]])
            )
          })
        ),
        uiOutput("points_status")
      ),
      div(
        class = "panel-card",
        h3(class = "section-title", "Backstory & details"),
        textAreaInput("backstory", "Backstory", rows = 5,
          placeholder = "Where did they come from, and what brought them here?"),
        textAreaInput("personality", "Personality traits", rows = 2),
        textAreaInput("ideals", "Ideals", rows = 2),
        textAreaInput("bonds", "Bonds", rows = 2),
        textAreaInput("flaws", "Flaws", rows = 2),
        textAreaInput("notes", "Other notes", rows = 3)
      )
    ),
    mainPanel(
      width = 7,
      div(
        class = "panel-card",
        h3(class = "section-title", "Character sheet"),
        uiOutput("character_sheet"),
        uiOutput("download_ui")
      )
    )
  )
)

server <- function(input, output, session) {
  points_spent <- reactive({
    scores <- vapply(ability_scores, function(id) {
      score <- input[[id]]
      if (is.null(score)) NA_integer_ else as.integer(score)
    }, integer(1))

    if (anyNA(scores)) return(NA_integer_)
    sum(score_costs[as.character(scores)])
  })

  character_is_valid <- reactive({
    name <- trimws(input$character_name)
    points <- points_spent()
    nzchar(name) && !is.na(points) && points <= 27
  })

  output$points_status <- renderUI({
    points <- points_spent()
    if (is.na(points)) {
      return(div(class = "text-warning points-total", "Choose a score for each ability."))
    }

    remaining <- 27 - points
    if (remaining < 0) {
      div(class = "text-danger points-total", paste0(points, " / 27 points — ", abs(remaining), " over budget"))
    } else {
      div(class = "text-success points-total", paste0(points, " / 27 points — ", remaining, " remaining"))
    }
  })

  output$character_sheet <- renderUI({
    if (!character_is_valid()) {
      if (!nzchar(trimws(input$character_name))) {
        return(p("Enter a character name to see the sheet preview.", class = "text-muted"))
      }
      return(p("Spend no more than 27 points to preview this character.", class = "text-danger"))
    }

    score_rows <- lapply(ability_scores, function(id) {
      tags$li(paste0(names(ability_scores)[match(id, ability_scores)], ": ", input[[id]]))
    })

    section <- function(label, value) {
      if (is.null(value) || !nzchar(trimws(value))) return(NULL)
      tagList(
        div(class = "sheet-label", label),
        div(class = "sheet-value", value)
      )
    }

    tagList(
      h2(input$character_name),
      p(paste(input$species, input$character_class, paste("Level", input$level), sep = " · ")),
      section("Background", input$background),
      section("Alignment", input$alignment),
      div(class = "sheet-label", "Ability scores"),
      tags$ul(score_rows),
      section("Backstory", input$backstory),
      section("Personality traits", input$personality),
      section("Ideals", input$ideals),
      section("Bonds", input$bonds),
      section("Flaws", input$flaws),
      section("Other notes", input$notes)
    )
  })

  output$download_ui <- renderUI({
    if (character_is_valid()) {
      downloadButton("download_sheet", "Download character sheet")
    }
  })

  output$download_sheet <- downloadHandler(
    filename = function() {
      name <- gsub("[^A-Za-z0-9_-]+", "-", trimws(input$character_name))
      paste0(name, "-character.txt")
    },
    content = function(file) {
      validate(need(character_is_valid(), "Enter a name and spend no more than 27 points."))
      score_lines <- vapply(ability_scores, function(id) {
        paste0(names(ability_scores)[match(id, ability_scores)], ": ", input[[id]])
      }, character(1))
      optional_lines <- function(label, value) {
        if (is.null(value) || !nzchar(trimws(value))) return(character())
        c("", paste0(label, ":"), value)
      }
      lines <- c(
        input$character_name,
        paste(input$species, input$character_class, paste("Level", input$level), sep = " | "),
        if (nzchar(trimws(input$background))) paste0("Background: ", input$background),
        paste0("Alignment: ", input$alignment),
        "",
        "Ability scores:",
        score_lines,
        optional_lines("Backstory", input$backstory),
        optional_lines("Personality traits", input$personality),
        optional_lines("Ideals", input$ideals),
        optional_lines("Bonds", input$bonds),
        optional_lines("Flaws", input$flaws),
        optional_lines("Other notes", input$notes)
      )
      writeLines(lines, file, useBytes = TRUE)
    }
  )
}

shinyApp(ui = ui, server = server)
