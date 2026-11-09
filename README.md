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

The app opens with the Beneath the Blackwood campaign introduction, followed by name, race and subrace, class, 2014 background, ability-score, alignment, class-skill, spell, equipment, and identity pages. The race page collects variable racial choices and shows a live summary of the selected race's traits and ability score increases. The ability-score sliders use a 27-point buy and class-based suggestions; 2014 racial increases are applied separately from the purchased scores. Backgrounds grant their 2014 skills, tool proficiencies, languages, feature, and starting-equipment summary; selectable background tools and languages are collected on the background page.

The printable character sheet includes ability modifiers, proficiency bonus, initiative, passive Perception, saving throws, proficient skills (including Rogue Expertise), hit points, armour class, weapon attacks, spellcasting values, spell preparation, inventory, coins, and character notes. Armour, shields, weapons, current HP, spell slots, death saves, inventory, and currency can be edited. The app supplies suggested level-1 armour and weapons by class; check class starting equipment and proficiency with your table. Spell entries include the range and duration available in the app's reference data; consult the full spell description for components and rules details. Spell summaries are play aids, not full spell text.

Characters start at level 1 using the 2014 Player's Handbook race, subrace, background, and class assumptions. On the final page, players can save the character overview as a PDF using the browser's print dialog (choose **Save as PDF**), download a text sheet, or save/load a JSON character file. These files are saved locally by the player; the app does not email characters or store a central roster. Returning players can open the separate load page from the introduction. Existing version 1–6 save files are migrated to the current format; 2024-only backgrounds are mapped to the closest 2014 PHB background, and saved Orc characters are mapped to Half-Orc. Characters do not progress beyond level 1.