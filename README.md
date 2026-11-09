# Adventurer's Ledger

A small R Shiny app for creating and exporting fantasy tabletop RPG characters.

## Run locally

1. Install R and the `shiny` package:

   ```r
   install.packages("shiny")
   ```

2. From this directory, start the app:

   ```r
   shiny::runApp()
   ```

The app opens with the Beneath the Blackwood campaign introduction, followed by name, ancestry, class, 2024 background, ability-score, alignment, class-skill, spell, and equipment pages. Backgrounds grant their ability increases, skills, tool proficiency, Origin feat, and a summary of starting gear; ability-score increases can be allocated using either 2024 method. The character overview summarizes species traits and level-1 class features, saving throws, hit points, proficiencies, and spells. Spell cards show concise roll and effect guidance, including attack bonuses, save DCs, damage, and other outcomes where relevant; these are play aids, not full spell text. Characters start at level 1. Players can save the character overview as a PDF using the browser's print dialog (choose **Save as PDF**), download a text sheet, or save/load a JSON character file. Returning players can open the separate load page from the introduction. Older save files are migrated to a matching 2024 background. These downloads stay on the player's device; emailing a PDF to the player and DM is also available after the optional email service is configured. Species options that require a subchoice (such as a lineage) are described but not collected yet, and class-specific starting equipment is not modeled separately from the campaign equipment kits.

## Optional: Configure PDF email

Players can save a PDF directly from the final page without configuring any service: click **Save PDF to your device**, then choose **Save as PDF** in the browser's print dialog. This saves the character overview locally and does not send it to the DM.

To also email a PDF copy to both the player and the DM, configure the optional Google Apps Script integration. It does not use a Google Sheet or keep a persistent character roster:

1. In the DM's Google account, create a standalone Apps Script project at [script.google.com](https://script.google.com/).
2. Replace the editor contents with [`Code.gs`](./Code.gs) and save.
3. In **Project Settings > Script Properties**, add:
   - `DM_EMAIL`: the address that should receive every character PDF.
   - `SAVE_TOKEN`: a unique secret of at least 32 characters. Do not put this value in source code or commit it.
4. Deploy as a **Web app**, choose **Execute as me**, and set access to **Anyone** so the Shiny server can call it. Complete Google's authorization prompts for Docs, Drive, and email. The script creates a temporary Google Doc to produce the PDF and moves it to Drive trash after sending.
5. Open an R console. In VS Code, the R extension's **Create R Terminal** command should start one. If the terminal still shows a PowerShell prompt (`PS ...>`), start R there by entering:

   ```powershell
   & "C:\Program Files\R\R-4.6.2\bin\R.exe"
   ```

   Wait until you see the R prompt (`>`), then enter the following R commands there—not at the PowerShell prompt. No RStudio project or special project setup is required. Set the working directory to the folder containing this app's `app.R` file; for this repository, run:

   ```r
   setwd("C:/Users/joshu/.vscode/Text_analysis/text_analysis")
   ```

   If your app folder is somewhere else, use that folder's path instead. Confirm `file.exists("app.R")` returns `TRUE`, then run the code below in the same R console. It prompts for the endpoint and token locally; do not paste the token into chat or save it in the project:

   ```r
   local({
     endpoint <- readline("Apps Script Web app URL ending in /exec: ")
     token <- readline("Shared SAVE_TOKEN: ")
     if (!nzchar(endpoint) || !nzchar(token)) {
       stop("Both the endpoint and shared token are required.")
     }
     Sys.setenv(
       CHARACTER_SAVE_ENDPOINT = endpoint,
       CHARACTER_SAVE_TOKEN = token
     )
     on.exit(Sys.unsetenv(c("CHARACTER_SAVE_ENDPOINT", "CHARACTER_SAVE_TOKEN")))

     rsconnect::deployApp(
       appDir = getwd(),
       appName = "adventurers-ledger",
       envVars = c("CHARACTER_SAVE_ENDPOINT", "CHARACTER_SAVE_TOKEN"),
       upload = FALSE
     )
   })
   ```

   `envVars` lists the names of variables already set in the local R session; `rsconnect` sends their values to the app's shinyapps.io configuration. The token is visible while typed into the R console, so avoid screen-sharing during entry. This updates the app's settings without uploading a new bundle. To deploy code changes as well, omit `upload = FALSE`.
6. Test with an email address you control and verify that both you and the player receive the PDF.

The DM account that owns the Apps Script sends both emails. No Google Sheet or long-term character copy is kept by the integration. A temporary document is moved to the owner's Drive trash after PDF generation, and duplicate submissions are suppressed for up to six hours.