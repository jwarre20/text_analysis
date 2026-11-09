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
    :root {
      color-scheme: dark;
      --night: #111318;
      --surface: #1b1e25;
      --surface-raised: #222630;
      --border: #343946;
      --text: #eee9dc;
      --muted: #aaa394;
      --gold: #d7b56d;
      --gold-bright: #f0d18a;
    }
    body {
      background-color: var(--night);
      background-image: radial-gradient(ellipse at 50% -20%, #34302a 0, transparent 55%);
      color: var(--text);
      font-family: 'Segoe UI', sans-serif;
    }
    .container-fluid { max-width: 1180px; }
    .app-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 30px 0 22px;
      border-bottom: 1px solid var(--border);
      margin-bottom: 24px;
    }
    .app-header h1 {
      margin: 0 0 7px;
      color: var(--gold-bright);
      font-family: Georgia, serif;
      font-size: 36px;
      letter-spacing: .02em;
    }
    .app-header p { color: var(--muted); margin: 0; }
    .header-kicker {
      color: var(--gold);
      font-size: 11px;
      font-weight: 700;
      letter-spacing: .2em;
      text-transform: uppercase;
      margin-bottom: 7px;
    }
    .crest { color: var(--gold); opacity: .9; width: 82px; height: 82px; flex: 0 0 auto; margin-left: 20px; }
    .panel-card {
      background: linear-gradient(145deg, #1d2027, #191c22);
      border: 1px solid var(--border);
      border-radius: 10px;
      box-shadow: 0 10px 28px rgba(0, 0, 0, .16);
      padding: 20px;
      margin-bottom: 18px;
    }
    .section-title {
      color: var(--gold-bright);
      font-family: Georgia, serif;
      margin: 4px 0 16px;
      padding-bottom: 10px;
      border-bottom: 1px solid #34312b;
    }
    .control-label { color: #d7d0c2; }
    .help-block, .text-muted { color: var(--muted); }
    .form-control {
      background-color: #14171c;
      border-color: #3a3f49;
      color: var(--text);
      border-radius: 6px;
      box-shadow: none;
    }
    .form-control:focus {
      background-color: #171a20;
      border-color: var(--gold);
      color: #fff9eb;
      box-shadow: 0 0 0 2px rgba(215, 181, 109, .14);
    }
    .form-control::placeholder { color: #77766f; }
    select.form-control option { background: #1b1e25; color: var(--text); }
    .input-group-addon {
      background: var(--surface-raised);
      border-color: #3a3f49;
      color: var(--gold);
    }
    .points-total { font-weight: 700; font-size: 16px; margin-top: 12px; }
    .text-success { color: #94c9a1; }
    .text-warning { color: var(--gold-bright); }
    .text-danger { color: #f08a82; }
    .sheet-label {
      color: var(--gold);
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: .12em;
      margin: 14px 0 3px;
    }
    .sheet-value { white-space: pre-wrap; overflow-wrap: anywhere; color: #e4dfd4; }
    #character_sheet h2 { color: var(--gold-bright); font-family: Georgia, serif; }
    #character_sheet ul { padding-left: 20px; color: #e4dfd4; }
    #character_sheet li { padding: 2px 0; }
    .btn-default, .btn-primary {
      background: #4a3b24;
      border-color: #806539;
      color: #fff0cc;
      border-radius: 6px;
    }
    .btn-default:hover, .btn-default:focus, .btn-primary:hover, .btn-primary:focus {
      background: #624d2e;
      border-color: var(--gold);
      color: #fff8e8;
    }
    .ability-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 0 14px; }
    @media (max-width: 767px) {
      .ability-grid { grid-template-columns: 1fr; }
      .app-header h1 { font-size: 29px; }
      .crest { width: 62px; height: 62px; }
      .panel-card { padding: 16px; }
    }
  "))),
  div(
    class = "app-header",
    div(
      div(class = "header-kicker", "Character chronicles"),
      h1("Adventurer's Ledger"),
      p("Build a character for your next campaign.")
    ),
    tags$svg(
      class = "crest",
      viewBox = "0 0 100 100",
      `aria-hidden` = "true",
      tags$path(
        d = "M50 5 L87 20 L83 58 C79 76 65 88 50 96 C35 88 21 76 17 58 L13 20 Z",
        fill = "none", stroke = "currentColor", `stroke-width` = "2"
      ),
      tags$path(
        d = "M50 16 L77 27 L74 56 C71 69 61 78 50 85 C39 78 29 69 26 56 L23 27 Z",
        fill = "none", stroke = "currentColor", `stroke-width` = "1", opacity = ".55"
      ),
      tags$path(
        d = "M50 25 L55 43 L72 47 L57 56 L59 73 L50 63 L41 73 L43 56 L28 47 L45 43 Z",
        fill = "currentColor", opacity = ".9"
      ),
      tags$circle(cx = "50", cy = "49", r = "4", fill = "#1b1e25")
    )
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
