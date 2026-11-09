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

The app opens with the Beneath the Blackwood campaign introduction, followed by name, ancestry, class, 2024 background, ability-score, alignment, class-skill, spell, and equipment pages. Backgrounds grant their ability increases, skills, tool proficiency, Origin feat, and a summary of starting gear; ability-score increases can be allocated using either 2024 method. The character overview summarizes species traits and level-1 class features, saving throws, hit points, proficiencies, and spells. Spell cards show concise roll and effect guidance, including attack bonuses, save DCs, damage, and other outcomes where relevant; these are play aids, not full spell text. Characters start at level 1. Players can download a text sheet or save/load a JSON character file; returning players can open the separate load page from the introduction. Older save files are migrated to a matching 2024 background. Downloaded JSON saves remain on the player's device; party submissions are stored in the DM's private Sheet after the Google integration is configured. Species options that require a subchoice (such as a lineage) are described but not collected yet, and class-specific starting equipment is not modeled separately from the campaign equipment kits.

## Configure party saving and player email

The final character page can save the full character to a private Google Sheet and email a text sheet to the player's supplied address. This requires a one-time Google Apps Script setup:

1. Create a Google Sheet in the DM's account. Keep it private; the app creates a `Characters` tab for submissions.
2. From the sheet, open **Extensions > Apps Script** and replace the editor contents with [`Code.gs`](./Code.gs).
3. In Apps Script **Project Settings > Script Properties**, add:
   - `SPREADSHEET_ID`: the ID from the Google Sheet URL.
   - `SAVE_TOKEN`: a unique secret of at least 32 characters. Do not put this value in source code or commit it.
4. In Apps Script, deploy a **Web app**, choose **Execute as me**, and set access to **Anyone** so the Shiny server can call it. The shared secret in the request protects the endpoint; keep the Sheet private. Complete Google's authorization prompts for Sheets and email.
5. In the shinyapps.io dashboard for `adventurers-ledger`, add these application environment variables:
   - `CHARACTER_SAVE_ENDPOINT`: the deployed Apps Script Web app URL ending in `/exec`.
   - `CHARACTER_SAVE_TOKEN`: the same secret used for the Apps Script `SAVE_TOKEN` property.
6. Redeploy the Shiny app. Test a submission with an email address you control, verify the row in the private `Characters` tab and the email, then share only the Sheet with the DM account(s) that should see submissions.

The DM account that owns the Apps Script sends the email. Each submission is stored in the private Sheet, including the character selections and the player's email address, until the DM deletes it. A retry of the same submission does not create duplicate rows.