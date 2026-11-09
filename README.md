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

The character builder includes identity and background fields, a 27-point ability-score buy, a live sheet preview, and a plain-text download.