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

default_scores <- setNames(c(15, 14, 13, 12, 10, 8), unname(ability_scores))

class_ability_priorities <- list(
  Barbarian = c("Strength", "Constitution", "Dexterity", "Wisdom", "Charisma", "Intelligence"),
  Bard = c("Charisma", "Dexterity", "Constitution", "Wisdom", "Intelligence", "Strength"),
  Cleric = c("Wisdom", "Constitution", "Dexterity", "Strength", "Charisma", "Intelligence"),
  Druid = c("Wisdom", "Constitution", "Dexterity", "Intelligence", "Charisma", "Strength"),
  Fighter = c("Strength", "Constitution", "Dexterity", "Wisdom", "Intelligence", "Charisma"),
  Monk = c("Dexterity", "Wisdom", "Constitution", "Strength", "Intelligence", "Charisma"),
  Paladin = c("Strength", "Charisma", "Constitution", "Wisdom", "Dexterity", "Intelligence"),
  Ranger = c("Dexterity", "Wisdom", "Constitution", "Strength", "Intelligence", "Charisma"),
  Rogue = c("Dexterity", "Constitution", "Wisdom", "Charisma", "Intelligence", "Strength"),
  Sorcerer = c("Charisma", "Constitution", "Dexterity", "Wisdom", "Intelligence", "Strength"),
  Warlock = c("Charisma", "Constitution", "Dexterity", "Wisdom", "Intelligence", "Strength"),
  Wizard = c("Intelligence", "Constitution", "Dexterity", "Wisdom", "Charisma", "Strength")
)

skill_abilities <- c(
  "Acrobatics" = "dexterity", "Animal Handling" = "wisdom", "Arcana" = "intelligence",
  "Athletics" = "strength", "Deception" = "charisma", "History" = "intelligence",
  "Insight" = "wisdom", "Intimidation" = "charisma", "Investigation" = "intelligence",
  "Medicine" = "wisdom", "Nature" = "intelligence", "Perception" = "wisdom",
  "Performance" = "charisma", "Persuasion" = "charisma", "Religion" = "intelligence",
  "Sleight of Hand" = "dexterity", "Stealth" = "dexterity", "Survival" = "wisdom"
)

armour_profiles <- list(
  "No armour" = list(base = 10L, dexterity = Inf, proficiency = "None"),
  "Mage Armour" = list(base = 13L, dexterity = Inf, proficiency = "None"),
  "Padded armour" = list(base = 11L, dexterity = Inf, proficiency = "Light"),
  "Leather armour" = list(base = 11L, dexterity = Inf, proficiency = "Light"),
  "Studded leather" = list(base = 12L, dexterity = Inf, proficiency = "Light"),
  "Hide armour" = list(base = 12L, dexterity = 2L, proficiency = "Medium"),
  "Chain shirt" = list(base = 13L, dexterity = 2L, proficiency = "Medium"),
  "Scale mail" = list(base = 14L, dexterity = 2L, proficiency = "Medium"),
  "Breastplate" = list(base = 14L, dexterity = 2L, proficiency = "Medium"),
  "Half plate" = list(base = 15L, dexterity = 2L, proficiency = "Medium"),
  "Ring mail" = list(base = 14L, dexterity = 0L, proficiency = "Heavy"),
  "Chain mail" = list(base = 16L, dexterity = 0L, proficiency = "Heavy"),
  "Splint armour" = list(base = 17L, dexterity = 0L, proficiency = "Heavy"),
  "Plate armour" = list(base = 18L, dexterity = 0L, proficiency = "Heavy")
)

weapon_profiles <- list(
  "Unarmed Strike" = list(damage = "1", type = "Bludgeoning", ability = "strength", category = "Simple"),
  "Club" = list(damage = "1d4", type = "Bludgeoning", ability = "strength", category = "Simple"),
  "Dagger" = list(damage = "1d4", type = "Piercing", ability = "finesse", category = "Simple"),
  "Greatclub" = list(damage = "1d8", type = "Bludgeoning", ability = "strength", category = "Simple"),
  "Handaxe" = list(damage = "1d6", type = "Slashing", ability = "strength", category = "Simple"),
  "Javelin" = list(damage = "1d6", type = "Piercing", ability = "strength", category = "Simple"),
  "Light Crossbow" = list(damage = "1d8", type = "Piercing", ability = "dexterity", category = "Simple"),
  "Light Hammer" = list(damage = "1d4", type = "Bludgeoning", ability = "strength", category = "Simple"),
  "Mace" = list(damage = "1d6", type = "Bludgeoning", ability = "strength", category = "Simple"),
  "Quarterstaff" = list(damage = "1d6", type = "Bludgeoning", ability = "strength", category = "Simple"),
  "Shortbow" = list(damage = "1d6", type = "Piercing", ability = "dexterity", category = "Simple"),
  "Sickle" = list(damage = "1d4", type = "Slashing", ability = "strength", category = "Simple"),
  "Spear" = list(damage = "1d6", type = "Piercing", ability = "strength", category = "Simple"),
  "Battleaxe" = list(damage = "1d8", type = "Slashing", ability = "strength", category = "Martial"),
  "Flail" = list(damage = "1d8", type = "Bludgeoning", ability = "strength", category = "Martial"),
  "Glaive" = list(damage = "1d10", type = "Slashing", ability = "strength", category = "Martial"),
  "Greataxe" = list(damage = "1d12", type = "Slashing", ability = "strength", category = "Martial"),
  "Greatsword" = list(damage = "2d6", type = "Slashing", ability = "strength", category = "Martial"),
  "Halberd" = list(damage = "1d10", type = "Slashing", ability = "strength", category = "Martial"),
  "Lance" = list(damage = "1d10", type = "Piercing", ability = "strength", category = "Martial"),
  "Longbow" = list(damage = "1d8", type = "Piercing", ability = "dexterity", category = "Martial"),
  "Longsword" = list(damage = "1d8", type = "Slashing", ability = "strength", category = "Martial"),
  "Maul" = list(damage = "2d6", type = "Bludgeoning", ability = "strength", category = "Martial"),
  "Morningstar" = list(damage = "1d8", type = "Piercing", ability = "strength", category = "Martial"),
  "Pike" = list(damage = "1d10", type = "Piercing", ability = "strength", category = "Martial"),
  "Rapier" = list(damage = "1d8", type = "Piercing", ability = "finesse", category = "Martial"),
  "Scimitar" = list(damage = "1d6", type = "Slashing", ability = "finesse", category = "Martial"),
  "Shortsword" = list(damage = "1d6", type = "Piercing", ability = "finesse", category = "Martial"),
  "Trident" = list(damage = "1d8", type = "Piercing", ability = "strength", category = "Martial"),
  "War Pick" = list(damage = "1d8", type = "Piercing", ability = "strength", category = "Martial"),
  "Warhammer" = list(damage = "1d8", type = "Bludgeoning", ability = "strength", category = "Martial"),
  "Whip" = list(damage = "1d4", type = "Slashing", ability = "finesse", category = "Martial"),
  "Hand Crossbow" = list(damage = "1d6", type = "Piercing", ability = "dexterity", category = "Martial"),
  "Heavy Crossbow" = list(damage = "1d10", type = "Piercing", ability = "dexterity", category = "Martial")
)

class_starting_weapons <- c(
  Barbarian = "Greataxe", Bard = "Rapier", Cleric = "Mace", Druid = "Quarterstaff",
  Fighter = "Longsword", Monk = "Quarterstaff", Paladin = "Longsword",
  Ranger = "Longbow", Rogue = "Rapier", Sorcerer = "Dagger",
  Warlock = "Dagger", Wizard = "Quarterstaff"
)

class_starting_armour <- c(
  Barbarian = "No armour", Bard = "Leather armour", Cleric = "Chain shirt",
  Druid = "Leather armour", Fighter = "Chain mail", Monk = "No armour",
  Paladin = "Chain mail", Ranger = "Leather armour", Rogue = "Leather armour",
  Sorcerer = "No armour", Warlock = "Leather armour", Wizard = "No armour"
)

weapon_properties <- c(
  "Unarmed Strike" = "Melee, 5 ft.",
  "Club" = "Light, 5 ft.",
  "Dagger" = "Finesse, Light, Thrown (20/60 ft.), 5 ft.",
  "Greatclub" = "Two-Handed, 5 ft.",
  "Handaxe" = "Light, Thrown (20/60 ft.), 5 ft.",
  "Javelin" = "Thrown (30/120 ft.), 5 ft.",
  "Light Crossbow" = "Ammunition (80/320 ft.), Loading, Two-Handed",
  "Light Hammer" = "Light, Thrown (20/60 ft.), 5 ft.",
  "Mace" = "5 ft.",
  "Quarterstaff" = "Versatile, 5 ft.",
  "Shortbow" = "Ammunition (80/320 ft.), Two-Handed",
  "Sickle" = "Light, 5 ft.",
  "Spear" = "Thrown (20/60 ft.), Versatile, 5 ft.",
  "Battleaxe" = "Versatile, 5 ft.",
  "Flail" = "5 ft.",
  "Glaive" = "Heavy, Reach, Two-Handed, 10 ft.",
  "Greataxe" = "Heavy, Two-Handed, 5 ft.",
  "Greatsword" = "Heavy, Two-Handed, 5 ft.",
  "Halberd" = "Heavy, Reach, Two-Handed, 10 ft.",
  "Lance" = "Reach, 10 ft.",
  "Longbow" = "Ammunition (150/600 ft.), Heavy, Two-Handed",
  "Longsword" = "Versatile, 5 ft.",
  "Maul" = "Heavy, Two-Handed, 5 ft.",
  "Morningstar" = "5 ft.",
  "Pike" = "Heavy, Reach, Two-Handed, 10 ft.",
  "Rapier" = "Finesse, 5 ft.",
  "Scimitar" = "Finesse, Light, 5 ft.",
  "Shortsword" = "Finesse, Light, 5 ft.",
  "Trident" = "Thrown (20/60 ft.), Versatile, 5 ft.",
  "War Pick" = "5 ft.",
  "Warhammer" = "Versatile, 5 ft.",
  "Whip" = "Finesse, Reach, 10 ft.",
  "Hand Crossbow" = "Ammunition (30/120 ft.), Light, Loading",
  "Heavy Crossbow" = "Ammunition (100/400 ft.), Heavy, Loading, Two-Handed"
)

weapon_proficiency_exceptions <- list(
  Bard = c("Hand Crossbow", "Longsword", "Rapier", "Shortsword"),
  Monk = "Shortsword",
  Rogue = c("Hand Crossbow", "Longsword", "Rapier", "Shortsword")
)

class_martial_weapon_proficiency <- c(
  Barbarian = TRUE, Bard = FALSE, Cleric = FALSE, Druid = FALSE,
  Fighter = TRUE, Monk = FALSE, Paladin = TRUE, Ranger = TRUE,
  Rogue = FALSE, Sorcerer = FALSE, Warlock = FALSE, Wizard = FALSE
)

class_limited_weapons <- list(
  Sorcerer = c("Dagger", "Dart", "Sling", "Quarterstaff", "Light Crossbow"),
  Wizard = c("Dagger", "Dart", "Sling", "Quarterstaff", "Light Crossbow")
)

ability_score_effects <- c(
  Strength = "Melee attacks and damage with Strength weapons, Athletics, and Strength saves.",
  Dexterity = "Initiative, many ranged and finesse attacks, AC in light or medium armour, Acrobatics, Sleight of Hand, Stealth, and Dexterity saves.",
  Constitution = "Hit points and Constitution saves. Concentration checks use Constitution when you take damage while maintaining a spell.",
  Intelligence = "Arcana, History, Investigation, Nature, Religion, and Intelligence saves. Wizards use it for their spells.",
  Wisdom = "Perception, Insight, Survival, Animal Handling, Medicine, and Wisdom saves. Clerics, Druids, and Rangers use it for their spells.",
  Charisma = "Persuasion, Deception, Intimidation, Performance, and Charisma saves. Bards, Paladins, Sorcerers, and Warlocks use it for their spells."
)

race_descriptions <- c(
  "Human" = "Ambitious and adaptable, humans make their mark in every corner of the world.",
  "Elf" = "Graceful and long-lived, elves carry the memory of ancient forests and lost ages.",
  "Dwarf" = "Stout and steadfast, dwarves are shaped by deep halls, old oaths, and hard-won craft.",
  "Halfling" = "Small, resourceful, and courageous, halflings find comfort and wonder wherever they roam.",
  "Gnome" = "Curious and inventive, gnomes meet the world's mysteries with bright ideas and bigger questions.",
  "Dragonborn" = "Proud descendants of dragons, dragonborn bear a striking presence and a storied legacy.",
  "Half-Elf" = "A blend of human ambition and elven heritage, at home in more than one world.",
  "Half-Orc" = "Marked by formidable strength and fierce resolve, forged between two worlds.",
  "Tiefling" = "Marked by an infernal heritage, tieflings navigate a world that often judges by appearances."
)

race_subraces <- list(
  Human = c("Human", "Variant Human"),
  Elf = c("High Elf", "Wood Elf", "Drow"),
  Dwarf = c("Hill Dwarf", "Mountain Dwarf"),
  Halfling = c("Lightfoot Halfling", "Stout Halfling"),
  Gnome = c("Forest Gnome", "Rock Gnome"),
  Dragonborn = "Dragonborn",
  `Half-Elf` = "Half-Elf",
  `Half-Orc` = "Half-Orc",
  Tiefling = "Tiefling"
)

race_subrace_rules <- list(
  Human = list(
    Human = list(bonuses = setNames(rep(1L, 6L), unname(ability_scores)),
      traits = c("Medium size", "30-foot walking speed", "Common and one language of your choice")),
    `Variant Human` = list(bonuses = integer(),
      traits = c("Medium size", "30-foot walking speed", "Common and one language of your choice",
        "One skill proficiency", "One feat of your choice"))
  ),
  Elf = list(
    `High Elf` = list(bonuses = c(dexterity = 2L, intelligence = 1L), speed = 30L,
      traits = c("Medium size", "Darkvision 60 ft.", "Common and Elvish",
        "Keen Senses: Perception proficiency",
        "Fey Ancestry", "Trance", "Elf Weapon Training", "One wizard cantrip")),
    `Wood Elf` = list(bonuses = c(dexterity = 2L, wisdom = 1L), speed = 35L,
      traits = c("Medium size", "Darkvision 60 ft.", "Common and Elvish",
        "Keen Senses: Perception proficiency",
        "Fey Ancestry", "Trance", "Elf Weapon Training", "Mask of the Wild")),
    Drow = list(bonuses = c(dexterity = 2L, charisma = 1L), speed = 30L,
      traits = c("Medium size", "Darkvision 120 ft.", "Common and Elvish",
        "Keen Senses: Perception proficiency",
        "Fey Ancestry", "Trance", "Drow Weapon Training", "Sunlight Sensitivity",
        "Drow Magic: Dancing Lights; Faerie Fire and Darkness at higher levels"))
  ),
  Dwarf = list(
    `Hill Dwarf` = list(bonuses = c(constitution = 2L, wisdom = 1L), speed = 25L,
      traits = c("Medium size", "Darkvision 60 ft.", "Common and Dwarvish",
        "Dwarven Resilience", "Dwarven speed is not reduced by heavy armour",
        "Dwarven Combat Training", "Tool Proficiency", "Stonecunning",
        "Dwarven Toughness: +1 maximum HP per level")),
    `Mountain Dwarf` = list(bonuses = c(constitution = 2L, strength = 2L), speed = 25L,
      traits = c("Medium size", "Darkvision 60 ft.", "Common and Dwarvish",
        "Dwarven Resilience", "Dwarven speed is not reduced by heavy armour",
        "Dwarven Combat Training", "Tool Proficiency", "Stonecunning",
        "Dwarven Armour Training: light and medium armour"))
  ),
  Halfling = list(
    `Lightfoot Halfling` = list(bonuses = c(dexterity = 2L, charisma = 1L), speed = 25L,
      traits = c("Small size", "Common and Halfling", "Lucky", "Brave",
        "Halfling Nimbleness", "Naturally Stealthy")),
    `Stout Halfling` = list(bonuses = c(dexterity = 2L, constitution = 1L), speed = 25L,
      traits = c("Small size", "Common and Halfling", "Lucky", "Brave",
        "Halfling Nimbleness",
        "Stout Resilience: advantage against poison and resistance to poison damage"))
  ),
  Gnome = list(
    `Forest Gnome` = list(bonuses = c(intelligence = 2L, dexterity = 1L), speed = 25L,
      traits = c("Small size", "Common and Gnomish", "Darkvision 60 ft.", "Gnome Cunning",
        "Natural Illusionist: Minor Illusion", "Speak with Small Beasts")),
    `Rock Gnome` = list(bonuses = c(intelligence = 2L, constitution = 1L), speed = 25L,
      traits = c("Small size", "Common and Gnomish", "Darkvision 60 ft.", "Gnome Cunning",
        "Artificer's Lore", "Tinker"))
  ),
  Dragonborn = list(
    Dragonborn = list(bonuses = c(strength = 2L, charisma = 1L), speed = 30L,
      traits = c("Medium size", "Common and Draconic", "Draconic Ancestry", "Breath Weapon",
        "Resistance to damage matching your Draconic Ancestry"))
  ),
  `Half-Elf` = list(
    `Half-Elf` = list(bonuses = c(charisma = 2L), speed = 30L,
      traits = c("Medium size", "Darkvision 60 ft.", "Fey Ancestry",
        "Skill Versatility: proficiency in two skills", "Common, Elvish and one language of your choice"))
  ),
  `Half-Orc` = list(
    `Half-Orc` = list(bonuses = c(strength = 2L, constitution = 1L), speed = 30L,
      traits = c("Medium size", "Common and Orc", "Darkvision 60 ft.",
        "Menacing: Intimidation proficiency",
        "Relentless Endurance", "Savage Attacks"))
  ),
  Tiefling = list(
    Tiefling = list(bonuses = c(intelligence = 1L, charisma = 2L), speed = 30L,
      traits = c("Medium size", "Common and Infernal", "Darkvision 60 ft.", "Hellish Resistance",
        "Infernal Legacy: Thaumaturgy; Hellish Rebuke and Darkness at higher levels",
        "Common and Infernal"))
  )
)

draconic_ancestry <- c(
  Black = "Acid", Blue = "Lightning", Brass = "Fire", Bronze = "Lightning",
  Copper = "Acid", Gold = "Fire", Green = "Poison", Red = "Fire",
  Silver = "Cold", White = "Cold"
)

race_language_choices <- c("Dwarvish", "Elvish", "Giant", "Gnomish", "Goblin",
  "Halfling", "Orc", "Sylvan", "Undercommon", "Abyssal", "Celestial",
  "Draconic", "Infernal", "Primordial", "Deep Speech", "Druidic",
  "Thieves' Cant")

phb_feats <- c(
  "Alert", "Athlete", "Actor", "Charger", "Crossbow Expert", "Defensive Duelist",
  "Dual Wielder", "Dungeon Delver", "Durable", "Elemental Adept", "Grappler",
  "Great Weapon Master", "Healer", "Heavily Armoured", "Heavy Armour Master",
  "Inspiring Leader", "Keen Mind", "Lightly Armoured", "Linguist", "Lucky",
  "Mage Slayer", "Magic Initiate", "Martial Adept", "Medium Armour Master",
  "Mobile", "Moderately Armoured", "Mounted Combatant", "Observant",
  "Polearm Master", "Resilient", "Ritual Caster", "Savage Attacker",
  "Sentinel", "Sharpshooter", "Shield Master", "Skilled", "Skulker",
  "Spell Sniper", "Tavern Brawler", "Tough", "War Caster", "Weapon Master"
)

class_descriptions <- c(
  "Barbarian" = "A fierce warrior who draws on raw strength and battle rage.",
  "Bard" = "A spellweaver and performer whose words and music shape the world.",
  "Cleric" = "A champion of divine power, devoted to a sacred calling.",
  "Druid" = "A guardian of the wild who channels the magic of nature.",
  "Fighter" = "A disciplined master of weapons, tactics, and the art of battle.",
  "Monk" = "A swift martial artist who hones body and spirit into one.",
  "Paladin" = "A sworn protector whose oath fuels courage and magic.",
  "Ranger" = "A skilled wanderer and hunter at home on the edges of civilisation.",
  "Rogue" = "A resourceful expert in stealth, precision, and cunning.",
  "Sorcerer" = "A natural spellcaster whose magic comes from within.",
  "Warlock" = "A wielder of strange magic granted through a powerful pact.",
  "Wizard" = "A learned mage who masters magic through study and practice."
)

class_rules <- list(
  Barbarian = list(saves = c("Strength", "Constitution"), hit_die = 12L, slots = 0L,
    features = c("Rage", "Unarmored Defense")),
  Bard = list(saves = c("Dexterity", "Charisma"), hit_die = 8L, slots = 2L,
    features = c("Bardic Inspiration", "Spellcasting")),
  Cleric = list(saves = c("Wisdom", "Charisma"), hit_die = 8L, slots = 2L,
    features = c("Spellcasting", "Divine Domain")),
  Druid = list(saves = c("Intelligence", "Wisdom"), hit_die = 8L, slots = 2L,
    features = c("Druidic", "Spellcasting")),
  Fighter = list(saves = c("Strength", "Constitution"), hit_die = 10L, slots = 0L,
    features = c("Fighting Style", "Second Wind")),
  Monk = list(saves = c("Strength", "Dexterity"), hit_die = 8L, slots = 0L,
    features = c("Unarmored Defense", "Martial Arts")),
  Paladin = list(saves = c("Wisdom", "Charisma"), hit_die = 10L, slots = 0L,
    features = c("Divine Sense", "Lay on Hands")),
  Ranger = list(saves = c("Strength", "Dexterity"), hit_die = 10L, slots = 0L,
    features = c("Favored Enemy", "Natural Explorer")),
  Rogue = list(saves = c("Dexterity", "Intelligence"), hit_die = 8L, slots = 0L,
    features = c("Expertise", "Sneak Attack", "Thieves' Cant")),
  Sorcerer = list(saves = c("Constitution", "Charisma"), hit_die = 6L, slots = 2L,
    features = c("Spellcasting", "Sorcerous Origin")),
  Warlock = list(saves = c("Wisdom", "Charisma"), hit_die = 8L, slots = 1L,
    features = c("Otherworldly Patron", "Pact Magic")),
  Wizard = list(saves = c("Intelligence", "Wisdom"), hit_die = 6L, slots = 2L,
    features = c("Spellcasting", "Arcane Recovery"))
)

background_descriptions <- c(
  "Acolyte" = "You served a temple or shrine and know its rites and community.",
  "Charlatan" = "You survived by deception, disguise, and reading your marks.",
  "Criminal" = "You have underworld contacts and experience outside the law.",
  "Entertainer" = "You earn your living by captivating audiences.",
  "Folk Hero" = "You are celebrated locally for defending ordinary people.",
  "Guild Artisan" = "You trained in a craft and belong to a professional guild.",
  "Hermit" = "You lived in seclusion and made a discovery during that time.",
  "Noble" = "You were raised among privilege, family histories, and social duties.",
  "Outlander" = "You grew up in the wilds and can travel and forage there.",
  "Sage" = "You spent years studying and researching.",
  "Sailor" = "You worked aboard a vessel and know life at sea.",
  "Soldier" = "You trained and served in a military organisation.",
  "Urchin" = "You grew up on the streets and learned to survive there."
)

background_rules <- list(
  Acolyte = list(skills = c("Insight", "Religion"), tool = "None",
    languages = "Two of your choice", feature = "Shelter of the Faithful",
    equipment = "Holy symbol, prayer book or prayer wheel, 5 sticks of incense, vestments, common clothes, and 15 GP."),
  Charlatan = list(skills = c("Deception", "Sleight of Hand"), tool = "Disguise Kit and Forgery Kit",
    languages = "None", feature = "False Identity",
    equipment = "Fine clothes, disguise kit, tools of your chosen con, and 15 GP."),
  Criminal = list(skills = c("Deception", "Stealth"), tool = "One gaming set and Thieves' Tools",
    languages = "None", feature = "Criminal Contact",
    equipment = "Crowbar, dark common clothes with a hood, and 15 GP."),
  Entertainer = list(skills = c("Acrobatics", "Performance"), tool = "Disguise Kit and one musical instrument",
    languages = "None", feature = "By Popular Demand",
    equipment = "Musical instrument, favour of an admirer, costume, and 15 GP."),
  `Folk Hero` = list(skills = c("Animal Handling", "Survival"), tool = "One artisan's tool and land vehicles",
    languages = "None", feature = "Rustic Hospitality",
    equipment = "One artisan's tool, shovel, iron pot, common clothes, and 10 GP."),
  `Guild Artisan` = list(skills = c("Insight", "Persuasion"), tool = "One artisan's tool",
    languages = "One of your choice", feature = "Guild Membership",
    equipment = "One artisan's tool, a letter of introduction, traveller's clothes, and 15 GP."),
  Hermit = list(skills = c("Medicine", "Religion"), tool = "Herbalism Kit",
    languages = "One of your choice", feature = "Discovery",
    equipment = "Scroll case with notes, winter blanket, common clothes, herbalism kit, and 5 GP."),
  Noble = list(skills = c("History", "Persuasion"), tool = "One gaming set",
    languages = "One of your choice", feature = "Position of Privilege",
    equipment = "Fine clothes, signet ring, scroll of pedigree, and 25 GP."),
  Outlander = list(skills = c("Athletics", "Survival"), tool = "One musical instrument",
    languages = "One of your choice", feature = "Wanderer",
    equipment = "Staff, hunting trap, trophy from an animal, traveller's clothes, and 10 GP."),
  Sage = list(skills = c("Arcana", "History"), tool = "None",
    languages = "Two of your choice", feature = "Researcher",
    equipment = "Bottle of ink, quill, small knife, letter from a dead colleague, common clothes, and 10 GP."),
  Sailor = list(skills = c("Athletics", "Perception"), tool = "Navigator's Tools and water vehicles",
    languages = "None", feature = "Ship's Passage",
    equipment = "Belaying pin (club), silk rope, lucky charm, common clothes, and 10 GP."),
  Soldier = list(skills = c("Athletics", "Intimidation"), tool = "One gaming set and land vehicles",
    languages = "None", feature = "Military Rank",
    equipment = "Insignia of rank, trophy from a fallen enemy, gaming set, common clothes, and 10 GP."),
  Urchin = list(skills = c("Sleight of Hand", "Stealth"), tool = "Disguise Kit and Thieves' Tools",
    languages = "None", feature = "City Secrets",
    equipment = "Small knife, map of your home city, pet mouse, token of your parents, common clothes, and 10 GP.")
)

background_choice_rules <- list(
  Acolyte = list(languages = 2L),
  Charlatan = list(con_tools = TRUE),
  Criminal = list(gaming_set = TRUE),
  Entertainer = list(instrument = TRUE),
  `Folk Hero` = list(artisan_tool = TRUE),
  `Guild Artisan` = list(artisan_tool = TRUE, languages = 1L),
  Hermit = list(languages = 1L),
  Noble = list(gaming_set = TRUE, languages = 1L),
  Outlander = list(instrument = TRUE, languages = 1L),
  Sage = list(languages = 2L),
  Soldier = list(gaming_set = TRUE)
)

artisan_tools <- c("Alchemist's Supplies", "Brewer's Supplies", "Calligrapher's Supplies",
  "Carpenter's Tools", "Cartographer's Tools", "Cobbler's Tools", "Cook's Utensils",
  "Glassblower's Tools", "Jeweller's Tools", "Leatherworker's Tools", "Mason's Tools",
  "Painter's Supplies", "Potter's Tools", "Smith's Tools", "Tinker's Tools",
  "Weaver's Tools", "Woodcarver's Tools")
gaming_sets <- c("Dice Set", "Dragonchess Set", "Playing Card Set", "Three-Dragon Ante Set")
musical_instruments <- c("Bagpipes", "Drum", "Dulcimer", "Flute", "Lute", "Lyre",
  "Horn", "Pan Flute", "Shawm", "Viol")

skill_choices <- list(
  Barbarian = c("Animal Handling", "Athletics", "Intimidation", "Nature", "Perception", "Survival"),
  Bard = c("Acrobatics", "Animal Handling", "Arcana", "Athletics", "Deception", "History",
    "Insight", "Intimidation", "Investigation", "Medicine", "Nature", "Perception",
    "Performance", "Persuasion", "Religion", "Sleight of Hand", "Stealth", "Survival"),
  Cleric = c("History", "Insight", "Medicine", "Persuasion", "Religion"),
  Druid = c("Arcana", "Animal Handling", "Insight", "Medicine", "Nature", "Perception",
    "Religion", "Survival"),
  Fighter = c("Acrobatics", "Animal Handling", "Athletics", "History", "Insight",
    "Intimidation", "Perception", "Survival"),
  Monk = c("Acrobatics", "Athletics", "History", "Insight", "Religion", "Stealth"),
  Paladin = c("Athletics", "Insight", "Intimidation", "Medicine", "Persuasion", "Religion"),
  Ranger = c("Animal Handling", "Athletics", "Insight", "Investigation", "Nature",
    "Perception", "Stealth", "Survival"),
  Rogue = c("Acrobatics", "Athletics", "Deception", "Insight", "Intimidation",
    "Investigation", "Perception", "Persuasion", "Sleight of Hand", "Stealth"),
  Sorcerer = c("Arcana", "Deception", "Insight", "Intimidation", "Persuasion", "Religion"),
  Warlock = c("Arcana", "Deception", "History", "Intimidation", "Investigation",
    "Nature", "Religion"),
  Wizard = c("Arcana", "History", "Insight", "Investigation", "Medicine", "Religion")
)

skill_counts <- c(
  Barbarian = 2L, Bard = 3L, Cleric = 2L, Druid = 2L, Fighter = 2L, Monk = 2L,
  Paladin = 2L, Ranger = 3L, Rogue = 4L, Sorcerer = 2L, Warlock = 2L, Wizard = 2L
)

skill_descriptions <- c(
  "Acrobatics" = "Keep your balance, tumble, or perform agile physical manoeuvres.",
  "Animal Handling" = "Calm, guide, or intuit the intentions of animals.",
  "Arcana" = "Recall knowledge about magic, spells, and otherworldly forces.",
  "Athletics" = "Climb, jump, swim, or overcome obstacles through physical force.",
  "Deception" = "Mislead others through disguise, lies, or a convincing feint.",
  "History" = "Recall important events, people, places, and old traditions.",
  "Insight" = "Notice clues in someone's behavior and judge their intentions.",
  "Intimidation" = "Influence someone through threats or a show of force.",
  "Investigation" = "Search carefully for clues and draw conclusions from them.",
  "Medicine" = "Assess injuries, illness, and the practical needs of the wounded.",
  "Nature" = "Recall facts about plants, animals, weather, and natural cycles.",
  "Perception" = "Notice details using sight, hearing, smell, or other senses.",
  "Performance" = "Entertain an audience with music, acting, or another art.",
  "Persuasion" = "Influence others with tact, honesty, or compelling arguments.",
  "Religion" = "Recall knowledge about deities, rites, symbols, and faiths.",
  "Sleight of Hand" = "Use nimble fingers for tricks, concealment, or delicate tasks.",
  "Stealth" = "Move quietly and avoid being noticed.",
  "Survival" = "Follow tracks, navigate the wild, and find food or shelter."
)

spell_cantrips <- list(
  Bard = c("Dancing Lights", "Light", "Mage Hand", "Message", "Minor Illusion",
    "Prestidigitation", "Vicious Mockery"),
  Cleric = c("Guidance", "Light", "Sacred Flame", "Spare the Dying", "Thaumaturgy"),
  Druid = c("Druidcraft", "Guidance", "Produce Flame", "Shillelagh", "Thorn Whip"),
  Paladin = character(),
  Ranger = character(),
  Sorcerer = c("Fire Bolt", "Mage Hand", "Minor Illusion", "Prestidigitation",
    "Ray of Frost", "Shocking Grasp"),
  Warlock = c("Chill Touch", "Eldritch Blast", "Mage Hand", "Minor Illusion",
    "Prestidigitation", "True Strike"),
  Wizard = c("Fire Bolt", "Light", "Mage Hand", "Message", "Minor Illusion",
    "Prestidigitation", "Ray of Frost")
)

spell_choices <- list(
  Bard = c("Charm Person", "Dissonant Whispers", "Faerie Fire", "Healing Word",
    "Sleep", "Thunderwave"),
  Cleric = c("Bless", "Command", "Cure Wounds", "Guiding Bolt", "Healing Word",
    "Sanctuary", "Shield of Faith"),
  Druid = c("Animal Friendship", "Entangle", "Faerie Fire", "Goodberry",
    "Healing Word", "Thunderwave"),
  Paladin = c("Bless", "Command", "Cure Wounds", "Divine Favor", "Heroism",
    "Searing Smite", "Shield of Faith"),
  Ranger = c("Ensnaring Strike", "Fog Cloud", "Goodberry", "Hunter's Mark",
    "Longstrider", "Speak with Animals"),
  Sorcerer = c("Burning Hands", "Charm Person", "Chromatic Orb", "Mage Armor",
    "Magic Missile", "Shield"),
  Warlock = c("Armor of Agathys", "Arms of Hadar", "Charm Person", "Hex",
    "Protection from Evil and Good", "Witch Bolt"),
  Wizard = c("Burning Hands", "Charm Person", "Detect Magic", "Find Familiar",
    "Mage Armor", "Magic Missile", "Shield", "Sleep", "Thunderwave")
)

spell_descriptions <- c(
  "Dancing Lights" = "Create up to four small lights that glow and move at a distance.",
  "Light" = "Make one object shine with bright light and a surrounding glow.",
  "Mage Hand" = "Create a spectral hand that manipulates light objects at a distance.",
  "Message" = "Whisper a short message to a creature and receive a quiet reply.",
  "Minor Illusion" = "Create a brief sound or a small image to distract or entertain.",
  "Prestidigitation" = "Perform a small magical trick such as cleaning, warming, or marking.",
  "Vicious Mockery" = "Deliver a magically cutting insult that unsettles a foe.",
  "Guidance" = "A creature receives a brief touch of magical guidance for a task.",
  "Sacred Flame" = "Call down radiant fire upon a creature you can see.",
  "Spare the Dying" = "Stabilize a creature that is at the brink of death.",
  "Thaumaturgy" = "Create a brief, dramatic sign of supernatural power.",
  "Druidcraft" = "Create a tiny nature-themed effect or sense local natural changes.",
  "Produce Flame" = "Summon a small flame that can light an area or be hurled.",
  "Shillelagh" = "Imbue a wooden weapon with nature magic for a short time.",
  "Thorn Whip" = "A thorny vine lashes out and can pull a creature closer.",
  "Fire Bolt" = "Hurl a mote of fire at a creature or object.",
  "Ray of Frost" = "Send a chilling beam toward a creature.",
  "Shocking Grasp" = "Deliver a crackling touch of lightning to a nearby foe.",
  "Chill Touch" = "Reach with a ghostly hand that deals necrotic chill.",
  "Eldritch Blast" = "Fire a beam of crackling magical force at a target.",
  "True Strike" = "Focus on a target to guide your next attack with magic.",
  "Charm Person" = "Magically make a humanoid regard you as a friendly acquaintance.",
  "Dissonant Whispers" = "Fill a creature's mind with a discordant, unsettling melody.",
  "Faerie Fire" = "Outline creatures and objects in light, making them easier to see.",
  "Healing Word" = "Restore a small amount of vitality to a creature at a distance.",
  "Sleep" = "Send nearby creatures into a magical slumber.",
  "Thunderwave" = "Release a burst of thunderous force around you.",
  "Bless" = "Bolster allies with a small bonus to attacks and saving throws.",
  "Command" = "Give a creature a brief, one-word command it must resist.",
  "Cure Wounds" = "Restore vitality to a creature you touch.",
  "Guiding Bolt" = "Launch radiant energy that helps reveal the target to an ally.",
  "Sanctuary" = "Ward a creature so attackers must resist before targeting it.",
  "Shield of Faith" = "Surround a creature with a brief protective ward.",
  "Animal Friendship" = "Convince a beast that you mean it no harm.",
  "Entangle" = "Cause plants in an area to grasp at creatures.",
  "Goodberry" = "Create berries that provide nourishment and a little healing.",
  "Divine Favor" = "Let your weapon strikes carry a short-lived radiant force.",
  "Heroism" = "Steady a creature against fear and grant temporary resilience.",
  "Searing Smite" = "Let your next weapon hit flare with searing fire.",
  "Ensnaring Strike" = "Cause your next hit to summon grasping vines around its target.",
  "Fog Cloud" = "Fill an area with thick fog that obscures sight.",
  "Hunter's Mark" = "Mark a creature, making it easier to track and harm.",
  "Longstrider" = "Magically increase a creature's travel speed for a time.",
  "Speak with Animals" = "Understand and communicate with beasts.",
  "Burning Hands" = "Send a short cone of flame from your hands.",
  "Chromatic Orb" = "Hurl a sphere of elemental energy at a target.",
  "Mage Armor" = "Surround a willing creature with protective magical force.",
  "Magic Missile" = "Create darts of force that strike their targets reliably.",
  "Shield" = "Raise a brief magical barrier against incoming attacks.",
  "Armor of Agathys" = "Gain temporary protection that chills creatures who strike you.",
  "Arms of Hadar" = "Shadowy tendrils lash out at creatures near you.",
  "Hex" = "Curse a creature and hinder one of its abilities.",
  "Protection from Evil and Good" = "Ward a creature against certain supernatural beings.",
  "Witch Bolt" = "Link yourself to a nearby creature with a crackling arc of energy.",
  "Detect Magic" = "Sense the presence of magic nearby.",
  "Find Familiar" = "Summon a spirit in the form of a small animal companion."
)

spell_mechanics <- c(
  "Dancing Lights" = "No roll. Range 120 ft.; create up to four lights for up to 1 minute (concentration).",
  "Light" = "No roll. Touch one object; it sheds light for 1 hour.",
  "Mage Hand" = "No roll. Range 30 ft.; move or manipulate a light object with a spectral hand for 1 minute.",
  "Message" = "No roll. Range 120 ft.; send a short whispered message and receive a quiet reply.",
  "Minor Illusion" = "No roll. Range 30 ft.; make a small image or sound that lasts up to 1 minute.",
  "Prestidigitation" = "No roll. Range 10 ft.; create a minor magical effect, such as a harmless sensory effect or cleaning an object.",
  "Vicious Mockery" = "Wisdom save (DC {dc}); 1d4 psychic damage on a failure and disadvantage on the target's next attack roll.",
  "Guidance" = "No attack roll. Touch a creature; it adds 1d4 to one ability check before the spell ends (concentration, up to 1 minute).",
  "Sacred Flame" = "Dexterity save (DC {dc}); 1d8 radiant damage on a failure. Range 60 ft.",
  "Spare the Dying" = "No roll. Touch a creature with 0 HP to stabilize it.",
  "Thaumaturgy" = "No roll. Range 30 ft.; create a brief supernatural sign or sensory effect.",
  "Druidcraft" = "No roll. Range 30 ft.; create a minor nature effect or predict local weather.",
  "Produce Flame" = "Ranged spell attack ({attack}); 1d8 fire damage on a hit. Range 30 ft.; the flame can also provide light.",
  "Shillelagh" = "For 1 minute, your club or quarterstaff uses your spellcasting ability for attack and damage rolls, deals 1d8 damage, and counts as magical.",
  "Thorn Whip" = "Melee spell attack ({attack}); 1d6 piercing damage on a hit, and pull a Large or smaller target up to 10 ft. Range 30 ft.",
  "Fire Bolt" = "Ranged spell attack ({attack}); 1d10 fire damage on a hit. Range 120 ft.",
  "Ray of Frost" = "Ranged spell attack ({attack}); 1d8 cold damage on a hit and reduce the target's Speed by 10 ft. Range 60 ft.",
  "Shocking Grasp" = "Melee spell attack ({attack}); 1d8 lightning damage on a hit. The target cannot take reactions until its next turn.",
  "Chill Touch" = "Ranged spell attack ({attack}); 1d8 necrotic damage on a hit, and the target cannot regain HP until your next turn. Undead also have disadvantage on attacks against you. Range 120 ft.",
  "Eldritch Blast" = "Ranged spell attack ({attack}); 1d10 force damage on a hit. Range 120 ft.",
  "True Strike" = "Choose a creature within 30 ft.; you gain advantage on your first attack against it on your next turn (concentration, up to 1 round).",
  "Charm Person" = "Wisdom save (DC {dc}); on a failure, a Humanoid is Friendly and Charmed for up to 1 hour. The effect ends early if you or your allies damage it; it has advantage on the save if you are fighting it.",
  "Dissonant Whispers" = "Wisdom save (DC {dc}); on a failure, take 3d6 psychic damage and use your reaction to move away. No damage on a success.",
  "Faerie Fire" = "Dexterity save (DC {dc}); creatures in a 20-ft. cube are outlined, granting advantage on attacks against them (concentration, up to 1 minute).",
  "Healing Word" = "No roll. Range 60 ft.; a creature regains 1d4 + {modifier} HP.",
  "Sleep" = "Range 90 ft. Roll 5d8; creatures in a 20-ft. radius fall unconscious in ascending current-HP order until the total is used. The effect lasts 1 minute and ends early for a creature that takes damage or is woken.",
  "Thunderwave" = "Constitution save (DC {dc}); 2d8 thunder damage and push 10 ft. on a failure; half damage on a success. 15-ft. cube.",
  "Bless" = "No roll. Up to 3 creatures add 1d4 to attack rolls and saving throws (concentration, up to 1 minute).",
  "Command" = "Wisdom save (DC {dc}); on a failure, a creature follows a one-word command on its next turn.",
  "Cure Wounds" = "No roll. Touch a creature; it regains 1d8 + {modifier} HP.",
  "Guiding Bolt" = "Ranged spell attack ({attack}); 4d6 radiant damage on a hit. The next attack against the target has advantage. Range 120 ft.",
  "Sanctuary" = "Wisdom save (DC {dc}) required for a creature to target the warded creature with an attack or harmful spell. No concentration; up to 1 minute.",
  "Shield of Faith" = "No roll. A creature gains +2 AC (concentration, up to 10 minutes).",
  "Animal Friendship" = "Wisdom save (DC {dc}); on a failure, a Beast is Charmed for 24 hours. Range 30 ft.",
  "Entangle" = "Strength save (DC {dc}) or become Restrained by plants; the area is difficult terrain (concentration, up to 1 minute).",
  "Goodberry" = "No roll. Create 10 berries; each restores 1 HP and provides nourishment. They lose potency after 24 hours.",
  "Divine Favor" = "For up to 1 minute (concentration), your weapon hits deal an extra 1d4 radiant damage.",
  "Heroism" = "No roll. A creature is immune to Frightened and gains temporary HP equal to your spellcasting modifier at the start of each turn (concentration, up to 1 minute).",
  "Searing Smite" = "Your next melee weapon hit deals an extra 1d6 fire damage and ignites the target. At the start of each turn it makes a Constitution save (DC {dc}); on a failure it takes 1d6 fire damage, and on a success the spell ends. A creature can use an action to extinguish the flames (concentration, up to 1 minute).",
  "Ensnaring Strike" = "Your next weapon hit deals an extra 1d6 piercing damage; a Large or smaller target makes a Strength save (DC {dc}) or is restrained and takes 1d6 piercing damage at the start of each turn. It can use an action to make a Strength check to escape (concentration, up to 1 minute).",
  "Fog Cloud" = "No roll. Create a heavily obscured 20-ft. Sphere (concentration, up to 1 hour).",
  "Hunter's Mark" = "No roll. Mark a creature; your weapon hits against it deal an extra 1d6 damage, and you have advantage on checks to find it (concentration, up to 1 hour).",
  "Longstrider" = "No roll. A creature's Speed increases by 10 ft. for 1 hour.",
  "Speak with Animals" = "No roll. Understand and communicate with Beasts for 10 minutes.",
  "Burning Hands" = "Dexterity save (DC {dc}); 3d6 Fire damage in a 15-ft. Cone on a failure, half on a success.",
  "Chromatic Orb" = "Ranged spell attack ({attack}); 3d8 damage of a chosen type on a hit. Range 90 ft.",
  "Mage Armor" = "No roll. A willing creature's base AC becomes 13 + its Dexterity modifier for 8 hours.",
  "Magic Missile" = "No attack roll or save; three darts automatically hit for 1d4 + 1 Force damage each. Range 120 ft.",
  "Shield" = "Reaction, no roll. Gain +5 AC until the start of your next turn, including against the triggering attack; Magic Missile deals no damage to you.",
  "Armor of Agathys" = "No roll. Gain 5 temporary HP; while any remain, a creature that hits you with a melee attack takes 5 Cold damage. Lasts 1 hour.",
  "Arms of Hadar" = "Strength save (DC {dc}); creatures within 10 ft. take 2d6 necrotic damage and cannot take reactions until their next turn on a failed save. No damage on a success.",
  "Hex" = "No roll. Your hits deal an extra 1d6 Necrotic damage to the cursed target, which has disadvantage on checks with one chosen ability (concentration, up to 1 hour).",
  "Protection from Evil and Good" = "No roll. One creature is warded against Aberrations, Celestials, Elementals, Fey, Fiends, and Undead (concentration, up to 10 minutes).",
  "Witch Bolt" = "Ranged spell attack ({attack}); 1d12 lightning damage on a hit. Range 30 ft.; on later turns, use an action to deal 1d12 lightning damage while the target remains within range and in sight (concentration, up to 1 minute).",
  "Detect Magic" = "No roll. Sense magic within 30 ft. and, with an action, see an aura around it (concentration, up to 10 minutes).",
  "Find Familiar" = "No attack roll. Summon a spirit in an animal form to serve as a familiar; it acts independently and shares a telepathic link with you."
)

spellcasting_classes <- setdiff(names(spell_choices), c("Paladin", "Ranger"))
spellcasting_abilities <- c(
  Bard = "charisma",
  Cleric = "wisdom",
  Druid = "wisdom",
  Paladin = "charisma",
  Ranger = "wisdom",
  Sorcerer = "charisma",
  Warlock = "charisma",
  Wizard = "intelligence"
)

spellcasting_stats <- function(class, scores) {
  ability <- unname(spellcasting_abilities[[class]])
  modifier <- floor((scores[[ability]] - 10) / 2)
  list(
    ability = names(ability_scores)[match(ability, ability_scores)],
    modifier = modifier,
    attack = 2L + modifier,
    save_dc = 10L + modifier
  )
}

ability_modifier <- function(score) {
  floor((score - 10) / 2)
}

proficiency_bonus <- function(level = 1L) {
  2L + floor((level - 1L) / 4L)
}

species_skill_proficiencies <- function(species, selected_species_skill = character()) {
  if (identical(species, "Elf")) {
    "Perception"
  } else if (species %in% c("Human", "Half-Elf")) {
    selected_species_skill
  } else {
    character()
  }
}

class_skill_proficiencies <- function(class, background, selected_skills,
                                      species = NULL,
                                      selected_species_skill = character()) {
  unique(c(background_rules[[background]]$skills,
    species_skill_proficiencies(species, selected_species_skill),
    selected_skills))
}

skill_bonus <- function(skill, scores, class, background, selected_skills,
                        expertise = character(), species = NULL,
                        selected_species_skill = character()) {
  ability <- unname(skill_abilities[[skill]])
  bonus <- ability_modifier(scores[[ability]])
  if (skill %in% class_skill_proficiencies(class, background, selected_skills,
      species, selected_species_skill)) {
    bonus <- bonus + proficiency_bonus()
    if (skill %in% expertise) bonus <- bonus + proficiency_bonus()
  }
  bonus
}

saving_throw_bonus <- function(ability, scores, class) {
  bonus <- ability_modifier(scores[[unname(ability_scores[[ability]])]])
  if (ability %in% class_rules[[class]]$saves) bonus <- bonus + proficiency_bonus()
  bonus
}

armour_class <- function(class, scores, armour, shield = FALSE) {
  dexterity <- ability_modifier(scores[["dexterity"]])
  if (identical(armour, "No armour") && identical(class, "Barbarian")) {
    base <- 10 + dexterity + ability_modifier(scores[["constitution"]])
  } else if (identical(armour, "No armour") && identical(class, "Monk")) {
    base <- 10 + dexterity +
      if (isTRUE(shield)) 0L else ability_modifier(scores[["wisdom"]])
  } else {
    profile <- armour_profiles[[armour]]
    dexterity_bonus <- if (identical(profile$proficiency, "Heavy")) {
      0L
    } else {
      min(dexterity, profile$dexterity)
    }
    base <- profile$base + dexterity_bonus
  }
  as.integer(base + if (isTRUE(shield)) 2L else 0L)
}

weapon_attack_record <- function(weapon, scores, class) {
  profile <- weapon_profiles[[weapon]]
  if (is.null(profile)) return(NULL)
  ability <- profile$ability
  if (identical(ability, "finesse")) {
    ability <- if (scores[["dexterity"]] > scores[["strength"]]) "dexterity" else "strength"
  }
  attack_modifier <- ability_modifier(scores[[ability]])
  limited <- class_limited_weapons[[class]]
  proficient <- if (!is.null(limited)) {
    weapon %in% limited
  } else {
    profile$category == "Simple" ||
      isTRUE(class_martial_weapon_proficiency[[class]]) ||
      weapon %in% weapon_proficiency_exceptions[[class]]
  }
  list(
    name = weapon,
    bonus = attack_modifier + if (proficient) proficiency_bonus() else 0L,
    damage = paste0(profile$damage, " ",
      if (attack_modifier >= 0) "+" else "", attack_modifier, " ", profile$type),
    ability = paste0(toupper(substr(ability, 1L, 1L)), substring(ability, 2L)),
    proficient = proficient,
    properties = unname(weapon_properties[[weapon]])
  )
}

spell_prepared_limit <- function(class, scores) {
  if (!class %in% c("Cleric", "Druid", "Wizard")) {
    return(0L)
  }
  stats <- spellcasting_stats(class, scores)
  switch(
    class,
    Cleric = max(1L, stats$modifier + 1L),
    Druid = max(1L, stats$modifier + 1L),
    Wizard = max(1L, stats$modifier + 1L),
    0L
  )
}

spell_range <- function(spell) {
  mechanics <- unname(spell_mechanics[[spell]])
  match <- regexec("Range ([^.;]+)", mechanics, perl = TRUE)
  result <- regmatches(mechanics, match)[[1]]
  if (length(result) > 1L) result[[2]] else if (grepl("Touch", mechanics, fixed = TRUE)) {
    "Touch"
  } else {
    "See effect"
  }
}

spell_duration <- function(spell) {
  mechanics <- unname(spell_mechanics[[spell]])
  match <- regexec("(concentration, up to [^).]+|up to [0-9]+ (rounds?|minutes?|hours?|days?)|for [0-9]+ (rounds?|minutes?|hours?|days?)|Lasts [^.;]+)", mechanics, ignore.case = TRUE, perl = TRUE)
  result <- regmatches(mechanics, match)[[1]]
  if (length(result) > 1L) result[[2]] else "See spell description"
}

spell_components <- function(spell) {
  "Check spell description"
}

class_armour_training <- list(
  Barbarian = c("Light", "Medium", "Shield"),
  Bard = "Light",
  Cleric = c("Light", "Medium", "Shield"),
  Druid = c("Light", "Medium", "Shield"),
  Fighter = c("Light", "Medium", "Heavy", "Shield"),
  Monk = character(),
  Paladin = c("Light", "Medium", "Heavy", "Shield"),
  Ranger = c("Light", "Medium", "Shield"),
  Rogue = "Light",
  Sorcerer = character(),
  Warlock = "Light",
  Wizard = character()
)

default_character_gear <- function(class, background, species, scores, subrace = NULL) {
  hp <- level_one_hit_points(class, scores, species, subrace)
  list(
    armour = unname(class_starting_armour[[class]]),
    shield = class %in% c("Cleric", "Fighter", "Paladin"),
    weapons = unname(class_starting_weapons[[class]]),
    inventory = "",
    cp = 0L, sp = 0L, ep = 0L, gp = 0L, pp = 0L,
    spell_slots_remaining = class_rules[[class]]$slots,
    current_hp = hp, temporary_hp = 0L,
    death_successes = 0L, death_failures = 0L
  )
}

normalise_character_gear <- function(gear, class, background, species, scores,
                                     subrace = NULL) {
  defaults <- default_character_gear(class, background, species, scores, subrace)
  if (!is.list(gear)) return(defaults)
  if (is.null(gear$armour)) gear$armour <- defaults$armour
  if (!is.character(gear$armour) || length(gear$armour) != 1L ||
      is.na(gear$armour) || !gear$armour %in% names(armour_profiles)) {
    stop("The saved armour choice is invalid.", call. = FALSE)
  }
  if (is.null(gear$inventory)) gear$inventory <- defaults$inventory
  if (!is.character(gear$inventory) || length(gear$inventory) != 1L ||
      is.na(gear$inventory)) {
    stop("The saved inventory must be text.", call. = FALSE)
  }
  if (is.null(gear$weapons)) {
    gear$weapons <- defaults$weapons
  } else {
    gear$weapons <- unlist(gear$weapons, use.names = FALSE)
  }
  if (length(gear$weapons) > 3L || anyNA(gear$weapons) ||
      any(!gear$weapons %in% names(weapon_profiles))) {
    stop("The save file contains invalid equipped weapons.", call. = FALSE)
  }
  gear$weapons <- unique(gear$weapons)
  if (is.null(gear$shield)) gear$shield <- defaults$shield
  if (!is.logical(gear$shield) || length(gear$shield) != 1L || is.na(gear$shield)) {
    stop("The saved shield choice is invalid.", call. = FALSE)
  }
  integer_fields <- c("cp", "sp", "ep", "gp", "pp", "current_hp",
    "temporary_hp", "spell_slots_remaining", "death_successes", "death_failures")
  for (field in integer_fields) {
    value <- gear[[field]]
    if (is.null(value)) value <- defaults[[field]]
    if (!is.numeric(value) || length(value) != 1L || !is.finite(value) ||
        value != as.integer(value) || value < 0 ||
        (field == "spell_slots_remaining" &&
          value > class_rules[[class]]$slots) ||
        (field %in% c("death_successes", "death_failures") && value > 3L)) {
      stop(paste("The saved", field, "value is invalid."), call. = FALSE)
    }
    gear[[field]] <- as.integer(value)
  }
  gear$armour <- as.character(gear$armour)
  gear$inventory <- as.character(gear$inventory)
  gear
}

spell_mechanics_for <- function(spell, class, scores) {
  stats <- spellcasting_stats(class, scores)
  mechanics <- unname(spell_mechanics[[spell]])
  mechanics <- gsub("\\{attack\\}", paste0(if (stats$attack >= 0) "+" else "",
    stats$attack), mechanics)
  mechanics <- gsub("\\{dc\\}", stats$save_dc, mechanics)
  gsub("\\{modifier\\}", paste0(if (stats$modifier >= 0) "+" else "",
    stats$modifier), mechanics)
}

equipment_options <- c(
  "Trailwarden's Pack" = "A weatherproof cloak, bedroll, flint, waterskin, trail rations, rope, and a hooded lantern.",
  "Rookhaven Guard Kit" = "A sturdy travelling coat, shield, whetstone, waterskin, trail rations, and a simple field-repair kit.",
  "Wayfarer's Satchel" = "A light cloak, journal, charcoal sticks, bandages, waterskin, trail rations, and a small tool roll."
)

valid_alignments <- c(
  "Unspecified", "Lawful Good", "Neutral Good", "Chaotic Good",
  "Lawful Neutral", "True Neutral", "Chaotic Neutral", "Lawful Evil",
  "Neutral Evil", "Chaotic Evil"
)

generate_character_name <- function() {
  first_names <- c(
    "Aelar", "Bryn", "Cairn", "Dara", "Eira", "Fen", "Galen", "Ilyra",
    "Kellan", "Liora", "Mira", "Neris", "Orin", "Rowan", "Sable", "Tamsin"
  )
  family_names <- c(
    "Ashford", "Blackthorn", "Briarwood", "Dawnmere", "Emberfall", "Frostvale",
    "Holloway", "Ironwood", "Mossglenn", "Nightbrook", "Pineward", "Rook",
    "Stormwell", "Thorne", "Vale", "Wilder"
  )
  paste(sample(first_names, 1), sample(family_names, 1))
}

format_background <- function(choice) {
  if (is.null(choice) || !choice %in% names(background_descriptions)) return("")
  paste0(choice, ":\n", unname(background_descriptions[[choice]]))
}

apply_ability_increases <- function(scores, increases) {
  result <- scores
  if (length(increases)) {
    for (ability in names(increases)) {
      result[[unname(ability_scores[[ability]])]] <-
        result[[unname(ability_scores[[ability]])]] + increases[[ability]]
    }
  }
  result
}

default_subrace <- function(race) {
  subraces <- race_subraces[[race]]
  if (is.null(subraces)) return(NULL)
  unname(subraces[[1L]])
}

default_race_choices <- function(race, subrace) {
  switch(
    race,
    Human = if (identical(subrace, "Variant Human")) {
      list(ability_names = c("Strength", "Dexterity"),
        ability_bonuses = c(strength = 1L, dexterity = 1L),
        skill = "Perception", feat = "Alert")
    } else {
      list(language = "Dwarvish")
    },
    Elf = if (identical(subrace, "High Elf")) list(cantrip = "Mage Hand") else list(),
    Dwarf = list(tool = "Smith's Tools"),
    Dragonborn = list(draconic_ancestry = "Red"),
    `Half-Elf` = list(ability_names = c("Strength", "Dexterity"),
      ability_bonuses = c(strength = 1L, dexterity = 1L),
      skills = c("Perception", "Insight")),
    list()
  )
}

racial_ability_bonuses <- function(race, subrace, choices = list()) {
  bonuses <- race_subrace_rules[[race]][[subrace]]$bonuses
  if (is.null(bonuses)) bonuses <- integer()
  bonuses <- c(bonuses, choices$ability_bonuses)
  result <- setNames(integer(length(ability_scores)), unname(ability_scores))
  if (length(bonuses)) {
    for (ability in names(bonuses)) {
      if (ability %in% names(result)) result[[ability]] <- result[[ability]] + bonuses[[ability]]
    }
  }
  result
}

race_trait_summary <- function(race, subrace, choices = list()) {
  traits <- race_subrace_rules[[race]][[subrace]]$traits
  if (identical(race, "Dragonborn") && !is.null(choices$draconic_ancestry)) {
    traits <- c(traits, paste0(choices$draconic_ancestry, " ancestry: ",
      draconic_ancestry[[choices$draconic_ancestry]], " damage"))
  }
  if (identical(subrace, "Variant Human")) {
    traits <- c(traits, paste0("Feat:", choices$feat))
  }
  if (identical(race, "Half-Elf")) {
    traits <- c(traits,
      paste0("Skill Versatility: ", paste(choices$skills, collapse = " and ")))
  }
  if (identical(race, "Human") && identical(subrace, "Human") &&
      !is.null(choices$language)) {
    traits <- c(traits, paste("Additional language:", choices$language))
  }
  if (identical(race, "Dwarf") && !is.null(choices$tool)) {
    traits <- c(traits, paste("Tool Proficiency:", choices$tool))
  }
  if (identical(subrace, "High Elf") && !is.null(choices$cantrip)) {
    traits <- c(traits, paste("High Elf Cantrip:", choices$cantrip))
  }
  bonuses <- racial_ability_bonuses(race, subrace, choices)
  racial_bonuses <- bonuses[bonuses > 0L]
  if (length(racial_bonuses)) {
    traits <- c(traits, paste0("Ability Score Increase: ",
      paste(paste0("+", racial_bonuses, " ",
        names(racial_bonuses)), collapse = ", ")))
  }
  unique(traits)
}

race_walking_speed <- function(race, subrace) {
  speed <- race_subrace_rules[[race]][[subrace]]$speed
  if (is.null(speed)) 30L else as.integer(speed)
}

race_size <- function(race, subrace) {
  traits <- race_subrace_rules[[race]][[subrace]]$traits
  size_trait <- grep("^(Small|Medium) size", traits, value = TRUE)
  if (length(size_trait)) sub(" size$", "", size_trait[[1L]]) else "Medium"
}

normalise_race_choices <- function(race, subrace, choices, allow_defaults = FALSE) {
  fail <- function(message) stop(message, call. = FALSE)
  if (!is.list(choices)) fail("The save file contains invalid race choices.")
  defaults <- if (allow_defaults) default_race_choices(race, subrace) else list()
  value <- function(name) {
    selected <- choices[[name]]
    if (is.null(selected)) selected <- defaults[[name]]
    if (is.null(selected)) return(character())
    unlist(selected, use.names = FALSE)
  }
  result <- list()
  if (identical(race, "Human") && identical(subrace, "Variant Human")) {
    abilities <- as.character(value("ability_names"))
    skill <- as.character(value("skill"))
    feat <- as.character(value("feat"))
    if (length(abilities) != 2L || anyDuplicated(abilities) ||
        any(!abilities %in% names(ability_scores)) ||
        length(skill) != 1L || !skill %in% names(skill_abilities) ||
        length(feat) != 1L || !feat %in% phb_feats) {
      fail("The save file contains invalid Variant Human choices.")
    }
    result$ability_names <- abilities
    result$ability_bonuses <- setNames(rep(1L, 2L),
      unname(ability_scores[abilities]))
    result$skill <- skill
    result$feat <- feat
  } else if (identical(race, "Human")) {
    language <- as.character(value("language"))
    if (length(language) != 1L || !language %in% race_language_choices) {
      fail("The save file contains an invalid Human language choice.")
    }
    result$language <- language
  } else if (identical(race, "Dwarf")) {
    tool <- as.character(value("tool"))
    if (length(tool) != 1L ||
        !tool %in% c("Smith's Tools", "Brewer's Supplies", "Mason's Tools")) {
      fail("The save file contains an invalid Dwarven tool choice.")
    }
    result$tool <- tool
  } else if (identical(race, "Elf") && identical(subrace, "High Elf")) {
    cantrip <- as.character(value("cantrip"))
    if (length(cantrip) != 1L || !cantrip %in% spell_cantrips$Wizard) {
      fail("The save file contains an invalid High Elf cantrip.")
    }
    result$cantrip <- cantrip
  } else if (identical(race, "Dragonborn")) {
    ancestry <- as.character(value("draconic_ancestry"))
    if (length(ancestry) != 1L || !ancestry %in% names(draconic_ancestry)) {
      fail("The save file contains an invalid Draconic Ancestry choice.")
    }
    result$draconic_ancestry <- ancestry
  } else if (identical(race, "Half-Elf")) {
    abilities <- as.character(value("ability_names"))
    skills <- as.character(value("skills"))
    if (length(abilities) != 2L || anyDuplicated(abilities) ||
        any(!abilities %in% setdiff(names(ability_scores), "Charisma")) ||
        length(skills) != 2L || anyDuplicated(skills) ||
        any(!skills %in% names(skill_abilities))) {
      fail("The save file contains invalid Half-Elf choices.")
    }
    result$ability_names <- abilities
    result$ability_bonuses <- setNames(rep(1L, 2L),
      unname(ability_scores[abilities]))
    result$skills <- skills
  }
  result
}

default_background_choices <- function(background) {
  rules <- background_choice_rules[[background]]
  if (is.null(rules)) return(list())
  choices <- list()
  if (!is.null(rules$languages)) {
    choices$languages <- head(race_language_choices, rules$languages)
  }
  if (!is.null(rules$artisan_tool)) choices$artisan_tool <- artisan_tools[[1L]]
  if (!is.null(rules$gaming_set)) choices$gaming_set <- gaming_sets[[1L]]
  if (!is.null(rules$instrument)) choices$instrument <- musical_instruments[[1L]]
  if (!is.null(rules$con_tools)) choices$con_tools <- "Forgery Kit"
  choices
}

normalise_background_choices <- function(background, choices, allow_defaults = FALSE) {
  fail <- function(message) stop(message, call. = FALSE)
  if (!is.list(choices)) fail("The save file contains invalid background choices.")
  defaults <- if (allow_defaults) default_background_choices(background) else list()
  value <- function(name) {
    selected <- choices[[name]]
    if (is.null(selected)) selected <- defaults[[name]]
    unlist(selected, use.names = FALSE)
  }
  rules <- background_choice_rules[[background]]
  if (is.null(rules)) return(list())
  result <- list()
  if (!is.null(rules$languages)) {
    languages <- as.character(value("languages"))
    if (length(languages) != rules$languages || anyDuplicated(languages) ||
        any(!languages %in% race_language_choices)) {
      fail("The save file contains invalid background language choices.")
    }
    result$languages <- languages
  }
  if (!is.null(rules$artisan_tool)) {
    tool <- as.character(value("artisan_tool"))
    if (length(tool) != 1L || !tool %in% artisan_tools) {
      fail("The save file contains an invalid artisan's tool choice.")
    }
    result$artisan_tool <- tool
  }
  if (!is.null(rules$gaming_set)) {
    gaming_set <- as.character(value("gaming_set"))
    if (length(gaming_set) != 1L || !gaming_set %in% gaming_sets) {
      fail("The save file contains an invalid gaming set choice.")
    }
    result$gaming_set <- gaming_set
  }
  if (!is.null(rules$instrument)) {
    instrument <- as.character(value("instrument"))
    if (length(instrument) != 1L || !instrument %in% musical_instruments) {
      fail("The save file contains an invalid musical instrument choice.")
    }
    result$instrument <- instrument
  }
  if (!is.null(rules$con_tools)) {
    con_tools <- as.character(value("con_tools"))
    if (length(con_tools) != 1L || !nzchar(trimws(con_tools))) {
      fail("Enter the tool used for your Charlatan's chosen con.")
    }
    result$con_tools <- trimws(con_tools)
  }
  result
}

background_tool_summary <- function(background, choices = list()) {
  selected <- unlist(choices[c("artisan_tool", "gaming_set", "instrument",
    "con_tools")], use.names = FALSE)
  parts <- c(background_rules[[background]]$tool, selected[nzchar(selected)])
  paste(unique(parts[nzchar(parts)]), collapse = "; ")
}

level_one_hit_points <- function(class, scores, species, subrace = NULL) {
  class_rules[[class]]$hit_die +
    floor((scores[["constitution"]] - 10) / 2) +
    if (identical(species, "Dwarf") && identical(subrace, "Hill Dwarf")) 1L else 0L
}

spell_selection_limits <- function(class, scores) {
  ability_modifier <- function(score_name) {
    floor((scores[[score_name]] - 10) / 2)
  }
  switch(
    class,
    Bard = list(cantrips = 2L, spells = 4L, spell_label = "known spells"),
    Cleric = list(cantrips = 3L, spells = max(1L, ability_modifier("wisdom") + 1L),
      spell_label = "prepared spells"),
    Druid = list(cantrips = 2L, spells = max(1L, ability_modifier("wisdom") + 1L),
      spell_label = "prepared spells"),
    Paladin = list(cantrips = 0L, spells = 0L, spell_label = "prepared spells"),
    Ranger = list(cantrips = 0L, spells = 0L, spell_label = "known spells"),
    Sorcerer = list(cantrips = 4L, spells = 2L, spell_label = "known spells"),
    Warlock = list(cantrips = 2L, spells = 2L, spell_label = "known spells"),
    Wizard = list(cantrips = 3L, spells = 6L, spell_label = "spellbook spells"),
    list(cantrips = 0L, spells = 0L, spell_label = "spells")
  )
}

character_payload <- function(species, class, background, scores, ability_increases,
                              details, skills, expertise, species_skill,
                              cantrips, spells,
                              prepared_spells, equipment, gear, subrace = NULL,
                              race_choices = list(), background_choices = list()) {
  list(
    schema_version = 7,
    species = species,
    subrace = subrace,
    race_choices = race_choices,
    background_choices = background_choices,
    class = class,
    background_choice = background,
    ability_scores = as.list(scores),
    ability_increases = as.list(ability_increases),
    details = details,
    skills = as.list(skills),
    expertise = as.list(expertise),
    species_skill = as.list(species_skill),
    cantrips = as.list(cantrips),
    spells = as.list(spells),
    prepared_spells = as.list(prepared_spells),
    equipment = equipment,
    gear = gear
  )
}

character_sheet_lines <- function(species, class, background, scores,
                                  ability_increases, details, skills, expertise,
                                  species_skill, cantrips, spells, prepared_spells,
                                  equipment, gear, subrace = NULL,
                                  race_choices = list(),
                                  background_choices = list()) {
  if (is.null(subrace)) subrace <- default_subrace(species)
  final <- scores + racial_ability_bonuses(species, subrace, race_choices)
  score_lines <- vapply(seq_along(ability_scores), function(i) {
    id <- unname(ability_scores[[i]])
    modifier <- ability_modifier(final[[id]])
    paste0(names(ability_scores)[i], ": ", final[[id]], " (",
      if (modifier >= 0) "+" else "", modifier, ")")
  }, character(1))
  background_info <- background_rules[[background]]
  class_info <- class_rules[[class]]
  racial_traits <- race_trait_summary(species, subrace, race_choices)
  proficient_skills <- class_skill_proficiencies(class, background, skills,
    species, species_skill)
  saving_lines <- vapply(names(ability_scores), function(ability) {
    bonus <- saving_throw_bonus(ability, final, class)
    paste0(ability, ": ", if (bonus >= 0) "+" else "", bonus)
  }, character(1))
  attacks <- lapply(unique(c(gear$weapons, "Unarmed Strike")), function(weapon) {
    attack <- weapon_attack_record(weapon, final, class)
    paste0(attack$name, " — ", if (attack$bonus >= 0) "+" else "",
      attack$bonus, " to hit; ", attack$damage,
      "; ", if (attack$proficient) "proficient" else "not proficient",
      "; ", attack$properties)
  })
  spell_line <- function(spell) {
    paste0(spell, " — Range: ", spell_range(spell),
      "; Duration: ", spell_duration(spell),
      "; Components: ", spell_components(spell),
      if (spell %in% prepared_spells) "; Prepared" else "")
  }
  max_hp <- level_one_hit_points(class, final, species, subrace)
  spell_stats <- if (class %in% spellcasting_classes) {
    stats <- spellcasting_stats(class, final)
    c(
      paste0("Spellcasting ability: ", stats$ability),
      paste0("Spell attack bonus: ", if (stats$attack >= 0) "+" else "", stats$attack),
      paste0("Spell save DC: ", stats$save_dc)
    )
  } else {
    character()
  }
  skill_lines <- vapply(proficient_skills, function(skill) {
    bonus <- skill_bonus(skill, final, class, background, skills, expertise,
      species, species_skill)
    paste0(skill, " (", skill_abilities[[skill]], ")",
      if (skill %in% expertise) " · Expertise" else "", ": ",
      if (bonus >= 0) "+" else "", bonus)
  }, character(1))
  detail_lines <- vapply(c("pronouns", "age", "height", "eyes", "hair",
    "appearance", "personality", "ideals", "bonds", "flaws", "backstory",
    "languages", "notes"), function(field) {
    value <- details[[field]]
    if (is.null(value) || !nzchar(trimws(value))) return("")
    paste0(paste0(toupper(substr(field, 1L, 1L)), substring(field, 2L)), ": ", value)
  }, character(1))
  c(
    details$character_name,
    paste(species, subrace, class, "Level 1", sep = " | "),
    paste0("Alignment: ", details$alignment),
    paste0("Background: ", background),
    paste0("Background feature: ", background_info$feature),
    "",
    "Ability scores and modifiers:",
    score_lines,
    paste0("Proficiency bonus: +", proficiency_bonus()),
    paste0("Initiative: ", if (ability_modifier(final[["dexterity"]]) >= 0) "+" else "",
      ability_modifier(final[["dexterity"]])),
    paste0("Size: ", race_size(species, subrace)),
    paste0("Walking speed: ", race_walking_speed(species, subrace), " ft."),
    paste0("Passive Perception: ", 10L + skill_bonus("Perception", final, class,
      background, skills, expertise, species, species_skill)),
    "",
    "Saving throws:",
    saving_lines,
    "",
    "Proficient skills:",
    skill_lines,
    paste0("Background tool proficiencies: ",
      background_tool_summary(background, background_choices)),
    paste0("Background languages: ", if (length(background_choices$languages)) {
      paste(background_choices$languages, collapse = ", ")
    } else {
      background_info$languages
    }),
    if (length(species_skill)) paste0("Racial skill proficiency: ", species_skill),
    paste0("Racial traits: ", paste(racial_traits, collapse = "; ")),
    "",
    "Level 1 class features:",
    paste0("- ", class_info$features),
    paste0("Saving throw proficiencies: ", paste(class_info$saves, collapse = ", ")),
    paste0("Hit points: ", gear$current_hp, "/", max_hp,
      if (gear$temporary_hp > 0) paste0(" + ", gear$temporary_hp, " temporary") else ""),
    paste0("Armour class: ", armour_class(class, final, gear$armour, gear$shield),
      " (", gear$armour, if (gear$shield) ", shield" else "", ")"),
    paste0("Armour training: ",
      if (armour_profiles[[gear$armour]]$proficiency == "None" ||
          armour_profiles[[gear$armour]]$proficiency %in% class_armour_training[[class]]) {
        "proficient"
      } else {
        paste("not proficient with", tolower(armour_profiles[[gear$armour]]$proficiency), "armour")
      }),
    if (gear$shield && !"Shield" %in% class_armour_training[[class]]) {
      "Not proficient with shields."
    },
    paste0("Death saves: ", gear$death_successes, " successes, ",
      gear$death_failures, " failures"),
    "",
    "Attacks:",
    paste0("- ", unlist(attacks, use.names = FALSE)),
    "",
    "Spellcasting:",
    spell_stats,
    paste0("Spell slots: ", if (class_info$slots == 0L) {
      "None"
    } else if (identical(class, "Warlock")) {
      paste(gear$spell_slots_remaining, "/", class_info$slots, "Pact Magic slot")
    } else {
      paste(gear$spell_slots_remaining, "/", class_info$slots,
        "1st-level slots")
    }),
    paste0("Background equipment: ", background_info$equipment),
    "",
    "Campaign equipment:",
    paste0(equipment, ":"),
    unname(equipment_options[[equipment]]),
    "Inventory:",
    gear$inventory,
    paste0("Coins: ", gear$cp, " CP · ", gear$sp, " SP · ", gear$ep, " EP · ",
      gear$gp, " GP · ", gear$pp, " PP"),
    "",
    "Cantrips:",
    if (length(cantrips)) {
      paste0("- ", vapply(cantrips, spell_line, character(1)))
    } else {
      "None"
    },
    "",
    if (!class %in% spellcasting_classes) {
      "Spells:"
    } else if (identical(class, "Wizard")) {
      "Spellbook (marked spells are prepared):"
    } else if (class %in% c("Bard", "Sorcerer", "Warlock")) {
      "Known level-1 spells:"
    } else {
      "Prepared level-1 spells:"
    },
    if (length(spells)) paste0("- ", vapply(spells, spell_line, character(1))) else "None",
    "",
    "Identity and backstory:",
    if (length(detail_lines[nzchar(detail_lines)])) detail_lines[nzchar(detail_lines)] else "No additional details."
  )
}

validate_character_payload <- function(payload) {
  fail <- function(message) stop(message, call. = FALSE)
  is_text <- function(value) is.character(value) && length(value) == 1 && !is.na(value)

  if (!is.list(payload) || !is.numeric(payload$schema_version) ||
      length(payload$schema_version) != 1L ||
      is.na(payload$schema_version) ||
      !payload$schema_version %in% c(1, 2, 3, 4, 5, 6, 7)) {
    fail("This is not a supported character save file.")
  }
  version <- as.integer(payload$schema_version)
  race <- payload$species
  if (version <= 5L && identical(race, "Orc")) race <- "Half-Orc"
  if (!is_text(race) || !race %in% names(race_descriptions)) {
    fail("The save file contains a race that is not available in the 2014 Player's Handbook.")
  }
  if (!is_text(payload$class) || !payload$class %in% names(class_descriptions)) {
    fail("The save file contains an unknown class.")
  }
  background <- payload$background_choice
  if (version <= 3L) {
    legacy_backgrounds <- c(
      "Rookhaven Local" = "Soldier", "Blackwood Scout" = "Outlander",
      "Caravan Guard" = "Soldier", "Village Healer" = "Hermit",
      "Wandering Scholar" = "Sage", "Disgraced Veteran" = "Soldier",
      "Temple Acolyte" = "Acolyte", "Hedge Mage" = "Sage",
      "Bounty Hunter" = "Criminal", "Runaway Apprentice" = "Sage",
      "Far-Traveled Sailor" = "Sailor", "Heir to a Fallen House" = "Noble"
    )
    old_origin <- payload$backstory_choice
    background <- if (is_text(old_origin) && old_origin %in% names(legacy_backgrounds)) {
      unname(legacy_backgrounds[[old_origin]])
    } else {
      "Outlander"
    }
  }
  legacy_background_map <- c(
    Artisan = "Guild Artisan", Farmer = "Folk Hero", Guard = "Soldier",
    Guide = "Outlander", Merchant = "Guild Artisan", Scribe = "Sage",
    Wayfarer = "Outlander"
  )
  if (is_text(background) && background %in% names(legacy_background_map)) {
    background <- unname(legacy_background_map[[background]])
  }
  if (!is_text(background) || !background %in% names(background_rules)) {
    fail("The save file contains an unknown background.")
  }
  background_choices <- normalise_background_choices(background,
    if (version >= 7L) payload$background_choices else list(),
    allow_defaults = version <= 6L)
  subrace <- if (version >= 6L) payload$subrace else default_subrace(race)
  if (!is_text(subrace) || !subrace %in% race_subraces[[race]]) {
    fail("The save file contains an invalid race or subrace.")
  }
  race_choices <- normalise_race_choices(race, subrace,
    if (version >= 6L) payload$race_choices else list(),
    allow_defaults = version <= 5L)
  if (!is.list(payload$ability_scores) ||
      !all(unname(ability_scores) %in% names(payload$ability_scores))) {
    fail("The save file is missing ability scores.")
  }
  scores <- vapply(unname(ability_scores), function(id) {
    score <- payload$ability_scores[[id]]
    if (!is.numeric(score) || length(score) != 1 || !is.finite(score) ||
        score != as.integer(score) || score < 8 || score > 15) {
      fail(paste("The saved", id, "score must be a whole number from 8 to 15."))
    }
    as.integer(score)
  }, integer(1))
  names(scores) <- unname(ability_scores)
  points <- sum(score_costs[as.character(scores)])
  if (points > 27) fail("The saved ability scores exceed the 27-point budget.")

  ability_increases <- integer()
  final_scores <- scores + racial_ability_bonuses(race, subrace, race_choices)
  if (any(final_scores > 20L)) fail("The saved racial ability increases exceed the maximum score.")

  if (!is.list(payload$details)) fail("The save file is missing character details.")
  details <- payload$details
  detail_defaults <- c(
    character_name = "", alignment = "Unspecified", appearance = "",
    personality = "", ideals = "", bonds = "", flaws = "", backstory = "",
    languages = "", notes = "", pronouns = "", age = "", height = "",
    eyes = "", hair = ""
  )
  text_fields <- names(detail_defaults)
  details_result <- as.list(detail_defaults)
  for (field_name in text_fields) {
    value <- details[[field_name]]
    if (is.null(value)) value <- detail_defaults[[field_name]]
    if (!is_text(value)) fail(paste("The saved", field_name, "must be text."))
    details_result[[field_name]] <- value
  }
  if (!nzchar(trimws(details_result$character_name))) {
    fail("The save file must include a character name.")
  }
  if (!details_result$alignment %in% valid_alignments) {
    fail("The save file contains an unknown alignment.")
  }
  details <- details_result

  skills <- unlist(payload$skills, use.names = FALSE)
  species_skill <- if (identical(subrace, "Variant Human")) race_choices$skill else
    if (identical(race, "Half-Elf")) race_choices$skills else character()
  saved_species_skill <- unlist(payload$species_skill, use.names = FALSE)
  if (is.null(saved_species_skill)) saved_species_skill <- character()
  if (version >= 6L &&
      !setequal(as.character(saved_species_skill), as.character(species_skill))) {
    fail("The saved racial skill proficiencies do not match the selected race.")
  }
  automatic_skills <- unique(c(background_rules[[background]]$skills,
    species_skill_proficiencies(race, species_skill)))
  if (version <= 5L) {
    valid_old_skills <- skills[skills %in% skill_choices[[payload$class]]]
    skills <- unique(setdiff(valid_old_skills, automatic_skills))
    skills <- c(skills, setdiff(skill_choices[[payload$class]],
      c(automatic_skills, skills)))
    skills <- head(skills, skill_counts[[payload$class]])
  }
  if (length(skills) != skill_counts[[payload$class]] ||
      anyNA(skills) || anyDuplicated(skills) ||
      any(!skills %in% setdiff(skill_choices[[payload$class]], automatic_skills))) {
    fail("The save file contains invalid class skill selections.")
  }
  expertise <- unlist(payload$expertise, use.names = FALSE)
  if (is.null(expertise)) expertise <- character()
  if (version <= 5L && identical(payload$class, "Rogue")) {
    expertise <- head(unique(c(expertise[
      expertise %in% c(automatic_skills, skills)
    ], automatic_skills, skills)), 2L)
  }
  proficient_skills <- unique(c(automatic_skills, skills))
  if ((identical(payload$class, "Rogue") && length(expertise) != 2L) ||
      (!identical(payload$class, "Rogue") && length(expertise) != 0L) ||
      anyNA(expertise) || anyDuplicated(expertise) ||
      any(!expertise %in% proficient_skills)) {
    fail("The save file contains invalid Expertise choices.")
  }

  cantrips <- unlist(payload$cantrips, use.names = FALSE)
  spells <- unlist(payload$spells, use.names = FALSE)
  if (version <= 5L) {
    limits <- spell_selection_limits(payload$class, final_scores)
    cantrips <- head(unique(c(cantrips, spell_cantrips[[payload$class]])),
      limits$cantrips)
    spells <- head(unique(c(spells, spell_choices[[payload$class]])),
      limits$spells)
  } else {
    limits <- spell_selection_limits(payload$class, final_scores)
  }
  class_cantrips <- spell_cantrips[[payload$class]]
  class_spells <- spell_choices[[payload$class]]
  if (is.null(class_cantrips)) class_cantrips <- character()
  if (is.null(class_spells)) class_spells <- character()
  if (length(cantrips) != limits$cantrips || anyNA(cantrips) ||
      anyDuplicated(cantrips) ||
      any(!cantrips %in% class_cantrips)) {
    fail("The save file contains invalid cantrip selections.")
  }
  if (length(spells) != limits$spells ||
      anyNA(spells) || anyDuplicated(spells) || any(!spells %in% class_spells)) {
    fail("The save file contains invalid spell selections.")
  }

  equipment <- payload$equipment
  if (is.null(equipment) && version <= 2L) {
    equipment <- names(equipment_options)[[1]]
  }
  if (!is_text(equipment) || !equipment %in% names(equipment_options)) {
    fail("The save file contains an unknown equipment pack.")
  }
  prepared_spells <- unlist(payload$prepared_spells, use.names = FALSE)
  if (version <= 5L) {
    if (identical(payload$class, "Wizard")) {
      prepared_spells <- head(spells, spell_prepared_limit(payload$class, final_scores))
    } else if (payload$class %in% c("Cleric", "Druid")) {
      prepared_spells <- spells
    } else if (payload$class %in% c("Paladin", "Ranger")) {
      prepared_spells <- character()
    }
  }
  if (is.null(prepared_spells)) prepared_spells <- character()
  prepared_limit <- spell_prepared_limit(payload$class, final_scores)
  if (length(prepared_spells) > prepared_limit || anyNA(prepared_spells) ||
      anyDuplicated(prepared_spells) || any(!prepared_spells %in% spells) ||
      (!identical(payload$class, "Wizard") && length(prepared_spells) > 0L &&
        !payload$class %in% c("Cleric", "Druid", "Paladin", "Ranger"))) {
    fail("The save file contains invalid prepared spells.")
  }
  if (identical(payload$class, "Wizard") &&
      length(prepared_spells) != min(prepared_limit, length(spells))) {
    fail("A Wizard save must contain the selected number of prepared spells.")
  }
  if (payload$class %in% c("Cleric", "Druid")) {
    prepared_spells <- spells
  }
  gear_data <- payload$gear
  if (version <= 5L && is.list(gear_data) &&
      is.numeric(gear_data$spell_slots_remaining) &&
      length(gear_data$spell_slots_remaining) == 1L &&
      is.finite(gear_data$spell_slots_remaining)) {
    gear_data$spell_slots_remaining <- min(
      gear_data$spell_slots_remaining, class_rules[[payload$class]]$slots)
  }
  gear <- normalise_character_gear(gear_data, payload$class, background,
    race, final_scores, subrace)

  list(
    species = race,
    subrace = subrace,
    race_choices = race_choices,
    class = payload$class,
    background_choice = background,
    background_choices = background_choices,
    ability_scores = scores,
    ability_increases = ability_increases,
    details = details,
    skills = skills,
    expertise = expertise,
    species_skill = species_skill,
    cantrips = cantrips,
    spells = spells,
    prepared_spells = prepared_spells,
    equipment = equipment,
    gear = gear
  )
}

ui <- fluidPage(
  lang = "en-AU",
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
    .stats-page { max-width: 1000px; margin: 0 auto; padding: 48px 0 70px; }
    .stats-intro { color: #d3cec2; line-height: 1.65; text-align: center; margin: 0 auto 25px; max-width: 680px; }
    .stats-panel { max-width: 900px; margin: 0 auto; }
    .stats-guidance { max-width: 900px; margin: 0 auto 20px; text-align: center; }
    .ability-guidance-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px; text-align: left; margin: 18px 0; }
    .ability-guidance-card { background: #171a20; border: 1px solid var(--border); border-radius: 7px; padding: 12px 14px; }
    .ability-guidance-heading { display: flex; justify-content: space-between; align-items: baseline; gap: 10px; color: var(--gold-bright); font-family: Georgia, serif; }
    .ability-guidance-card p { color: #d3cec2; line-height: 1.5; margin: 8px 0; }
    .ability-suggestion { color: var(--gold); font: 13px 'Segoe UI', sans-serif; }
    .stats-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px 34px; }
    .stats-grid .form-group { margin-bottom: 20px; }
    .stats-grid .control-label { color: #e6d5aa; font-family: Georgia, serif; font-size: 16px; }
    .stats-grid .irs { width: 100%; }
    .stats-grid .irs--shiny .irs-line { background: #373b44; border-color: #373b44; }
    .stats-grid .irs--shiny .irs-bar { background: linear-gradient(90deg, #6e5632, #d7b56d); border-color: #c5a15b; }
    .stats-grid .irs--shiny .irs-handle { background: #f0d18a; border: 2px solid #fff0c8; box-shadow: 0 0 10px rgba(215, 181, 109, .35); }
    .stats-grid .irs--shiny .irs-single { background: #72562f; color: #fff4d8; }
    .stats-grid .irs--shiny .irs-single:before { border-top-color: #72562f; }
    .stats-grid .irs--shiny .irs-grid-text { color: #aaa394; }
    .stats-panel .selectize-input {
      background: #14171c !important;
      background-image: none !important;
      border-color: #3a3f49 !important;
      box-shadow: none !important;
      color: var(--text) !important;
    }
    .stats-panel .selectize-input.focus {
      border-color: var(--gold) !important;
      box-shadow: 0 0 0 2px rgba(215, 181, 109, .14) !important;
    }
    .stats-panel .selectize-input input { color: var(--text) !important; }
    .stats-panel .selectize-dropdown {
      background: #1b1e25;
      border-color: #3a3f49;
      color: var(--text);
    }
    .stats-panel .selectize-dropdown .option { color: var(--text); }
    .stats-panel .selectize-dropdown .active {
      background: #34302a;
      color: var(--gold-bright);
    }
    .stats-panel select.form-control {
      background-color: #14171c;
      border-color: #3a3f49;
      color: var(--text);
    }
    .stats-actions { display: flex; justify-content: center; align-items: center; gap: 16px; margin-top: 22px; }
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
    .intro-page { max-width: 900px; margin: 0 auto; padding: 38px 0 60px; }
    .intro-art {
      display: block;
      width: 100%;
      height: 210px;
      border: 1px solid #343946;
      border-radius: 10px 10px 0 0;
      background: #10151b;
    }
    .intro-copy {
      background: linear-gradient(145deg, #1d2027, #191c22);
      border: 1px solid var(--border);
      border-top: 0;
      border-radius: 0 0 10px 10px;
      box-shadow: 0 16px 40px rgba(0, 0, 0, .24);
      padding: 30px clamp(20px, 5vw, 52px);
      text-align: center;
    }
    .intro-title {
      color: var(--gold-bright);
      font: 42px/1.1 Georgia, serif;
      letter-spacing: .02em;
      margin: 0 0 8px;
      text-align: center;
    }
    .intro-eyebrow {
      color: var(--gold);
      font-size: 11px;
      font-weight: 700;
      letter-spacing: .2em;
      margin: 0 0 25px;
      text-align: center;
      text-transform: uppercase;
    }
    .intro-copy h2 {
      color: var(--gold-bright);
      font: 24px Georgia, serif;
      margin: 30px 0 14px;
    }
    .intro-copy p, .intro-copy li { color: #d3cec2; line-height: 1.75; }
    .intro-copy .opening { color: #e7dfce; font-family: Georgia, serif; font-size: 16px; }
    .intro-copy .closing { color: var(--gold-bright); font-family: Georgia, serif; }
    .rumor-list { list-style: none; padding-left: 0; }
    .rumor-list li::marker { color: var(--gold); }
    .journey-action { margin-top: 28px; text-align: center; }
    .journey-actions { display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 12px; }
    .begin-button {
      background: linear-gradient(180deg, #9b7741, #72562f);
      border: 1px solid var(--gold-bright);
      border-radius: 6px;
      box-shadow: 0 4px 18px rgba(215, 181, 109, .16);
      color: #fff7e6;
      font-family: Georgia, serif;
      font-size: 17px;
      letter-spacing: .03em;
      padding: 12px 27px;
      transition: background .15s ease, transform .15s ease;
    }
    .begin-button:hover, .begin-button:focus {
      background: linear-gradient(180deg, #b18b4d, #846537);
      border-color: #ffe4a8;
      color: #fff;
      transform: translateY(-1px);
    }
    .race-page { max-width: 1000px; margin: 0 auto; padding: 48px 0 70px; }
    .race-heading { color: var(--gold-bright); font: 42px/1.1 Georgia, serif; text-align: center; margin: 0 0 10px; }
    .race-subheading { color: #e4dfd4; font: 24px Georgia, serif; text-align: center; margin: 0 0 8px; }
    .race-heading.selection-page-title { font-size: 56px; text-align: center; }
    .race-subheading.selection-page-subtitle { font-size: 30px; text-align: center; }
    .race-prompt { color: var(--muted); text-align: center; margin: 0 0 16px; }
    .race-options { width: 100%; max-width: 860px; margin: 16px auto 0; }
    .race-options .shiny-input-radiogroup,
    .race-options .shiny-input-container,
    .race-options .shiny-options-group { width: 100%; }
    .race-options .shiny-options-group {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 18px;
    }
    .race-options .radio {
      flex: 0 0 calc((100% - 36px) / 3);
      margin: 0 !important;
    }
    .race-options .radio label {
      position: relative;
      display: flex;
      align-items: flex-start;
      width: 100%;
      min-height: 112px;
      gap: 10px;
      padding: 18px;
      background: linear-gradient(145deg, #1d2027, #191c22);
      border: 1px solid var(--border);
      border-radius: 9px;
      color: var(--text);
      cursor: pointer;
      white-space: normal;
      transition: border-color .15s ease, background .15s ease;
    }
    .background-options .radio label {
      height: 142px;
      min-height: 142px;
      align-items: center;
    }
    .race-options .radio label:hover,
    .race-options .radio label:focus-within {
      background: #252831;
      border-color: var(--gold);
    }
    .race-options .radio input {
      position: absolute;
      top: 17px;
      left: 17px;
      margin: 0;
      accent-color: var(--gold);
    }
    .race-options .radio label > span { flex: 1; min-width: 0; }
    .race-name { display: block; color: var(--gold-bright); font: 21px Georgia, serif; text-align: center; }
    .race-blurb { display: block; color: #d3cec2; font: 14px/1.6 'Segoe UI', sans-serif; margin-top: 9px; text-align: center; }
    .multi-options .shiny-options-group {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 14px;
    }
    .multi-options .checkbox { margin: 0 !important; }
    .multi-options .checkbox label {
      display: flex;
      align-items: flex-start;
      width: 100%;
      min-height: 100px;
      gap: 10px;
      padding: 16px;
      background: linear-gradient(145deg, #1d2027, #191c22);
      border: 1px solid var(--border);
      border-radius: 9px;
      color: var(--text);
      white-space: normal;
    }
    .multi-options .checkbox label:hover,
    .multi-options .checkbox label:focus-within { border-color: var(--gold); background: #252831; }
    .multi-options .checkbox input { flex: 0 0 auto; margin: 5px 0 0; accent-color: var(--gold); }
    .multi-options .checkbox label > span { flex: 1; min-width: 0; }
    .selection-choice {
      position: relative;
      display: flex;
      align-items: center;
      gap: 12px;
      min-height: 28px;
    }
    .selection-choice[title]:hover::after,
    .selection-choice[title]:focus::after,
    .multi-options .checkbox label:focus-within .selection-choice[title]::after {
      content: attr(title);
      position: absolute;
      z-index: 20;
      left: 0;
      bottom: calc(100% + 10px);
      width: min(280px, 75vw);
      padding: 10px 12px;
      border: 1px solid var(--gold);
      border-radius: 7px;
      background: #111318;
      box-shadow: 0 8px 20px rgba(0, 0, 0, .45);
      color: var(--text);
      font: 13px/1.5 'Segoe UI', sans-serif;
      white-space: normal;
      pointer-events: none;
    }
    .selection-icon { width: 23px; height: 23px; flex: 0 0 23px; color: var(--gold); }
    .spell-choice { min-width: 0; }
    .spell-description {
      color: var(--muted);
      font: 13px/1.5 'Segoe UI', sans-serif;
      margin: 8px 0 0 35px;
    }
    .spell-mechanics {
      border-top: 1px solid #343946;
      color: #e4dfd4;
      font: 13px/1.55 'Segoe UI', sans-serif;
      margin: 9px 0 0 35px;
      padding-top: 8px;
    }
    .spell-options .shiny-options-group { grid-auto-rows: 1fr; }
    .spell-options .checkbox { height: 100%; }
    .spell-options .checkbox label { height: 100%; min-height: 230px; }
    .spellcasting-summary {
      background: #1b1e25;
      border: 1px solid var(--border);
      border-radius: 8px;
      color: #e6d5aa;
      line-height: 1.6;
      margin: 18px auto;
      max-width: 860px;
      padding: 12px 16px;
      text-align: center;
    }
    .spell-group-title {
      max-width: 900px;
      margin: 28px auto 18px;
      color: var(--gold-bright);
      font: 24px Georgia, serif;
      text-align: center;
    }
    .details-page, .overview-page { max-width: 900px; margin: 0 auto; padding: 44px 0 70px; }
    .details-panel { max-width: 760px; margin: 28px auto 0; }
    .name-panel { max-width: 760px; text-align: center; }
    .name-panel .shiny-input-container { width: 100%; max-width: 420px; margin: 0 auto 15px; }
    .name-panel .control-label { display: block; text-align: center; }
    .name-panel .form-control { text-align: center; }
    .name-actions { display: flex; justify-content: center; gap: 12px; flex-wrap: wrap; }
    .overview-panel { max-width: 820px; margin: 24px auto; }
    .overview-page { text-align: center; }
    .overview-page > .race-heading, .overview-page > .race-subheading { text-align: center; }
    .overview-name { color: var(--gold-bright); font: 38px Georgia, serif; text-align: center; margin: 0 0 8px; }
    .overview-subtitle { color: var(--muted); text-align: center; margin-bottom: 24px; }
    .overview-section { border-top: 1px solid var(--border); padding: 15px 0; }
    .overview-section h3 { color: var(--gold); font: 19px Georgia, serif; margin: 0 0 8px; }
    .overview-section p, .overview-section li {
      color: #e4dfd4;
      line-height: 1.65;
      white-space: pre-wrap;
    }
    .overview-section ul { list-style: none; padding-left: 0; margin-bottom: 0; }
    .overview-section li { text-align: center; }
    .sheet-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 0 24px;
      text-align: left;
    }
    .sheet-grid .overview-section { min-width: 0; }
    .sheet-grid .overview-section h3 { text-align: left; }
    .sheet-grid .overview-section p,
    .sheet-grid .overview-section li { text-align: left; overflow-wrap: anywhere; }
    .sheet-grid .overview-section ul { padding-left: 18px; list-style: disc; }
    .sheet-grid .sheet-full-width { grid-column: 1 / -1; }
    .gear-panel { text-align: left; }
    .gear-panel .spell-group-title { margin-top: 24px; }
    .coin-grid { grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 0 12px; }
    .identity-panel { text-align: left; }
    @media print {
      @page { margin: 16mm; }
      body * { visibility: hidden !important; }
      #character_sheet, #character_sheet * { visibility: visible !important; }
      #character_sheet {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        color: #171717 !important;
        font-family: Arial, sans-serif;
      }
      #character_sheet .overview-name,
      #character_sheet .overview-subtitle,
      #character_sheet .overview-section h3,
      #character_sheet .overview-section p,
      #character_sheet .overview-section li {
        color: #171717 !important;
      }
      #character_sheet .overview-section {
        border-color: #b8b8b8;
        break-inside: avoid;
      }
      #character_sheet .sheet-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 0 8mm;
      }
      #character_sheet .overview-section h3 { color: #522f11 !important; }
      #character_sheet .overview-section { padding: 3mm 0; }
      #character_sheet .overview-name { font-size: 28pt; }
    }
    .party-save-panel { text-align: center; }
    .party-save-panel .form-group { max-width: 420px; margin: 0 auto 15px; }
    .overview-actions { display: flex; justify-content: center; flex-wrap: wrap; gap: 12px; margin-top: 20px; }
    .race-actions { display: flex; justify-content: center; align-items: center; gap: 16px; margin-top: 28px; }
    .race-back { background: transparent; border-color: var(--border); color: var(--muted); }
    .race-back:hover, .race-back:focus { background: #252831; border-color: #656b76; color: var(--text); }
    @media (max-width: 767px) {
      .sheet-grid { grid-template-columns: 1fr; }
      .sheet-grid .sheet-full-width { grid-column: auto; }
      .coin-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
      .app-header h1 { font-size: 29px; }
      .crest { width: 62px; height: 62px; }
      .panel-card { padding: 16px; }
      .intro-page { padding-top: 18px; }
      .intro-art { height: 145px; }
      .intro-title { font-size: 34px; }
      .intro-copy { padding: 24px 20px; }
      .race-page { padding-top: 28px; }
      .race-heading { font-size: 34px; }
      .race-heading.selection-page-title { font-size: 46px; }
      .race-subheading.selection-page-subtitle { font-size: 25px; }
      .spell-group-title { font-size: 21px; }
      .race-options .shiny-options-group { gap: 12px; }
      .race-options .radio { flex-basis: calc((100% - 12px) / 2); }
      .race-options .radio label { min-height: 0; padding: 16px; }
      .multi-options .shiny-options-group { grid-template-columns: 1fr; gap: 10px; }
      .multi-options .checkbox label { min-height: 0; padding: 14px; }
      .spell-options .checkbox label { min-height: 230px; }
      .stats-page { padding-top: 28px; }
      .stats-grid { grid-template-columns: 1fr; gap: 0; }
      .ability-guidance-grid { grid-template-columns: 1fr; }
      .stats-panel { padding: 18px 16px; }
      .details-page, .overview-page { padding-top: 28px; }
      .overview-name { font-size: 32px; }
    }
    @media (max-width: 480px) {
      .race-options .radio { flex-basis: 100%; }
    }
  "))),
  uiOutput("app_screen")
)

introduction_ui <- function() {
  div(
    class = "intro-page",
    tags$svg(
      class = "intro-art",
      viewBox = "0 0 1200 300",
      preserveAspectRatio = "xMidYMid slice",
      role = "img",
      `aria-label` = "Moonlit pine forest beneath a stormy sky",
      tags$defs(
        tags$linearGradient(
          id = "blackwood-sky", x1 = "0", y1 = "0", x2 = "0", y2 = "1",
          tags$stop(offset = "0%", `stop-color` = "#171b28"),
          tags$stop(offset = "100%", `stop-color` = "#526073")
        ),
        tags$linearGradient(
          id = "blackwood-ground", x1 = "0", y1 = "0", x2 = "0", y2 = "1",
          tags$stop(offset = "0%", `stop-color` = "#26352e"),
          tags$stop(offset = "100%", `stop-color` = "#101815")
        )
      ),
      tags$rect(width = "1200", height = "300", fill = "url(#blackwood-sky)"),
      tags$circle(cx = "890", cy = "72", r = "31", fill = "#ead9ae", opacity = ".85"),
      tags$path(
        d = "M0 152 Q180 115 340 151 T680 142 T1000 135 T1200 155 L1200 300 L0 300 Z",
        fill = "#303b43", opacity = ".8"
      ),
      tags$path(d = "M0 199 Q190 169 390 194 T770 181 T1200 195 L1200 300 L0 300 Z",
        fill = "url(#blackwood-ground)"),
      tags$path(d = "M0 267 L0 103 L28 162 L53 91 L77 160 L101 113 L119 181 L148 130 L175 185 L196 98 L221 172 L248 120 L275 188 L300 103 L330 183 L353 138 L376 206 L405 117 L431 178 L454 97 L483 186 L506 132 L530 205 L554 91 L585 185 L612 119 L638 199 L663 102 L693 182 L719 127 L746 205 L772 104 L800 181 L826 119 L851 196 L879 92 L907 177 L932 134 L958 207 L984 105 L1012 177 L1039 123 L1065 200 L1091 96 L1120 178 L1146 130 L1174 197 L1200 110 L1200 300 L0 300 Z",
        fill = "#121916"),
      tags$path(d = "M0 287 L0 164 L17 203 L33 153 L51 214 L69 176 L86 232 L103 160 L124 222 L142 183 L162 239 L180 149 L199 215 L219 178 L238 245 L258 165 L277 221 L296 181 L315 244 L337 152 L357 218 L378 179 L399 248 L419 164 L440 222 L460 183 L480 251 L501 151 L522 220 L543 179 L563 247 L583 164 L603 219 L624 182 L645 246 L666 153 L688 221 L708 177 L730 247 L750 164 L772 222 L793 180 L813 246 L835 151 L855 220 L876 181 L897 247 L917 164 L938 219 L959 179 L980 247 L1000 152 L1021 220 L1042 181 L1063 247 L1084 160 L1105 219 L1125 179 L1146 247 L1167 155 L1184 211 L1200 174 L1200 300 L0 300 Z",
        fill = "#0c110f")
    ),
    div(
      class = "intro-copy",
      h1(class = "intro-title", "Beneath the Blackwood"),
      div(class = "intro-eyebrow", "A tale from the edge of the wild"),
      p(class = "opening",
        em("Thunder rolls across the night sky."),
        br(),
        em("Rain falls endlessly through the towering pines of the Blackwood.")
      ),
      p("For generations, the forest has stood as a silent border between civilisation and the unknown. Traders travel its roads. Hunters stalk its shadows. Children grow up hearing stories of the things that dwell beneath its ancient canopy."),
      p(em("Most dismiss those stories as superstition."), br(), em("They are wrong.")),
      p("Recent weeks have brought unsettling rumours:"),
      tags$ul(
        class = "rumor-list",
        tags$li("Caravans have vanished without a trace."),
        tags$li("Livestock have been found mutilated in the night."),
        tags$li("Strange howls echo through the forest after sunset."),
        tags$li("Entire stretches of woodland have fallen silent.")
      ),
      p("The town of Rookhaven sits at the edge of the Blackwood, relying on its roads for trade and survival. Fear is beginning to spread among its people."),
      p("Some believe a monster stalks the woods.", br(), "Others believe something far older has awakened."),
      p(class = "closing", "One thing is certain.", br(), "The Blackwood is changing.", br(), "And soon, so will you."),
      h2("Before You Begin"),
      p("In this adventure you will create a hero who has answered a call for help from the town of Rookhaven."),
      p("Whatever your reason, fate has brought you to the Blackwood."),
      p(class = "closing",
        "The choices you make will determine whether you become one of its legends...",
        br(),
        "Or one more name lost among the trees."
      ),
      div(class = "journey-action journey-actions",
        actionButton(
          "begin_journey", "Enter the Blackwood", class = "btn-primary begin-button"
        ),
        actionButton(
          "open_load_character", "Load a saved character", class = "btn-default race-back"
        )
      )
    )
  )
}

choice_selection_ui <- function(title, subtitle, prompt, input_id, descriptions,
                                error_id, back_id, back_label, continue_id,
                                selected = NULL, options_class = "race-options",
                                extra_ui = NULL) {
  div(
    class = "race-page",
    h1(class = "race-heading", title),
    h2(class = "race-subheading", subtitle),
    if (nzchar(prompt)) p(class = "race-prompt", prompt),
    div(
      class = options_class,
      radioButtons(
        input_id,
        label = NULL,
        choiceNames = lapply(names(descriptions), function(choice) {
          tags$span(
            tags$span(class = "race-name", choice),
            tags$span(class = "race-blurb", unname(descriptions[[choice]]))
          )
        }),
        choiceValues = names(descriptions),
        selected = selected
      )
    ),
    extra_ui,
    uiOutput(error_id),
    div(
      class = "race-actions",
      actionButton(back_id, back_label, class = "btn-default race-back"),
      actionButton(continue_id, "Continue", class = "btn-primary begin-button")
    )
  )
}

race_option_inputs_ui <- function(race, subrace, choices = list()) {
  if (is.null(race) || !race %in% names(race_subraces)) return(NULL)
  ability_choices <- setNames(names(ability_scores), names(ability_scores))
  tagList(
    selectInput("selected_subrace", "Race / subrace",
      choices = race_subraces[[race]], selected = subrace),
    if (identical(race, "Human") && identical(subrace, "Variant Human")) {
      tagList(
        selectInput("variant_abilities", "Increase two different abilities by +1",
          choices = ability_choices, selected = choices$ability_names, multiple = TRUE),
        selectInput("variant_skill", "Variant Human skill proficiency",
          choices = names(skill_abilities), selected = choices$skill),
        p(class = "text-muted", "Choose a feat whose prerequisites your character meets."),
        selectInput("variant_feat", "Variant Human feat",
          choices = phb_feats, selected = choices$feat)
      )
    },
    if (identical(race, "Human") && identical(subrace, "Human")) {
      selectInput("human_language", "Human additional language",
        choices = race_language_choices, selected = choices$language)
    },
    if (identical(race, "Dwarf")) {
      selectInput("dwarf_tool", "Dwarven tool proficiency",
        choices = c("Smith's Tools", "Brewer's Supplies", "Mason's Tools"),
        selected = choices$tool)
    },
    if (identical(race, "Elf") && identical(subrace, "High Elf")) {
      selectInput("high_elf_cantrip", "High Elf wizard cantrip",
        choices = spell_cantrips$Wizard, selected = choices$cantrip)
    },
    if (identical(race, "Dragonborn")) {
      selectInput("draconic_ancestry", "Draconic ancestry",
        choices = names(draconic_ancestry), selected = choices$draconic_ancestry)
    },
    if (identical(race, "Half-Elf")) {
      tagList(
        selectInput("half_elf_abilities", "Increase two other abilities by +1",
          choices = setdiff(names(ability_scores), "Charisma"),
          selected = choices$ability_names, multiple = TRUE),
        selectInput("half_elf_skills", "Half-Elf skill proficiencies",
          choices = names(skill_abilities), selected = choices$skills, multiple = TRUE)
      )
    }
  )
}

race_selection_ui <- function(selected = NULL, subrace = NULL, choices = list()) {
  if (is.null(selected) || !selected %in% names(race_descriptions)) {
    selected <- names(race_descriptions)[[1L]]
  }
  if (is.null(subrace) || !subrace %in% race_subraces[[selected]]) {
    subrace <- default_subrace(selected)
  }
  div(
    class = "race-page",
    h1(class = "race-heading selection-page-title", "The Path Begins...."),
    h2(class = "race-subheading selection-page-subtitle", "Who are you?"),
    p(class = "race-prompt", "Choose your race and subrace. Their traits and ability score increases are summarised as you make your choices."),
    div(class = "race-options",
      radioButtons("selected_race", label = NULL,
        choiceNames = lapply(names(race_descriptions), function(race) {
          tags$span(tags$span(class = "race-name", race),
            tags$span(class = "race-blurb", unname(race_descriptions[[race]])))
        }),
        choiceValues = names(race_descriptions), selected = selected)
    ),
    uiOutput("race_options_ui"),
    div(class = "panel-card", h3(class = "spell-group-title", "Your racial benefits"),
      uiOutput("race_benefits")),
    uiOutput("race_error"),
    div(class = "race-actions",
      actionButton("back_to_name", "Back to Name", class = "btn-default race-back"),
      actionButton("confirm_race", "Continue", class = "btn-primary begin-button"))
  )
}

background_choice_inputs_ui <- function(background, choices = list()) {
  rules <- background_choice_rules[[background]]
  if (is.null(rules)) return(NULL)
  tagList(
    if (!is.null(rules$languages)) {
      selectInput("background_languages", paste("Choose", rules$languages, "language(s)"),
        choices = race_language_choices, selected = choices$languages,
        multiple = rules$languages > 1L)
    },
    if (!is.null(rules$artisan_tool)) {
      selectInput("background_artisan_tool", "Choose an artisan's tool",
        choices = artisan_tools, selected = choices$artisan_tool)
    },
    if (!is.null(rules$gaming_set)) {
      selectInput("background_gaming_set", "Choose a gaming set",
        choices = gaming_sets, selected = choices$gaming_set)
    },
    if (!is.null(rules$instrument)) {
      selectInput("background_instrument", "Choose a musical instrument",
        choices = musical_instruments, selected = choices$instrument)
    },
    if (!is.null(rules$con_tools)) {
      textInput("background_con_tools", "Tools of your chosen con",
        value = choices$con_tools)
    }
  )
}

class_selection_ui <- function(selected = NULL) {
  choice_selection_ui(
    "Your Story Takes Shape....",
    "What is your calling?",
    "Choose the skills and path you'll bring to the Blackwood.",
    "selected_class",
    class_descriptions,
    "class_error",
    "back_to_race",
    "Back to Race",
    "confirm_class",
    selected
  )
}

background_selection_ui <- function(selected = NULL) {
  choice_selection_ui(
    "A Life Before the Blackwood....",
    "Choose your background",
    "Your background grants two skill proficiencies, tool proficiencies, equipment, and a background feature.",
    "selected_background",
    background_descriptions,
    "background_error",
    "back_to_class",
    "Back to Class",
    "confirm_background",
    selected,
    options_class = "race-options background-options",
    extra_ui = uiOutput("background_options_ui")
  )
}

suggested_ability_scores <- function(class) {
  priorities <- class_ability_priorities[[class]]
  if (is.null(priorities)) return(default_scores)
  scores <- setNames(integer(length(ability_scores)), unname(ability_scores))
  scores[unname(ability_scores[priorities])] <- c(15L, 14L, 13L, 12L, 10L, 8L)
  scores
}

stats_selection_ui <- function(selected_scores, background, species, subrace, race_choices, class) {
  suggested <- suggested_ability_scores(class)
  div(
    class = "stats-page",
    h1(class = "race-heading", "The Measure of Your Legend...."),
    h2(class = "race-subheading", "Set your ability scores"),
    p(class = "stats-intro",
      "Shape your strengths with the sliders. Each score costs points from your 27-point budget; scores range from 8 to 15. Use the class suggestions as a starting point, or make your own build."
    ),
    div(
      class = "panel-card stats-guidance",
      h3(class = "spell-group-title", paste(class, "suggested scores")),
      p(class = "text-muted",
        paste0(
          "For a typical ", class, ", prioritize ",
          paste(head(class_ability_priorities[[class]], 3L), collapse = ", "),
          ". These are flexible suggestions, not rules. Your ",
          paste(species, subrace), " provides the racial ability score increases shown below."
        )
      ),
      div(class = "ability-guidance-grid",
        lapply(seq_along(ability_scores), function(i) {
          ability <- names(ability_scores)[i]
          score_id <- unname(ability_scores[[i]])
          rank <- match(ability, class_ability_priorities[[class]])
          div(
            class = "ability-guidance-card",
            div(
              class = "ability-guidance-heading",
              strong(ability),
              span(class = "ability-suggestion", paste0(suggested[[score_id]], " suggested"))
            ),
            p(unname(ability_score_effects[[ability]])),
            span(class = "text-muted", paste("Priority", rank, "of 6 for", class))
          )
        })
      ),
      if (identical(class, "Fighter")) {
        p(class = "text-muted",
          "Prefer ranged or finesse weapons? Try Dexterity as your top score instead of Strength."
        )
      },
      actionButton("apply_suggested_scores", "Use Suggested Scores",
        class = "btn-default")
    ),
    div(
      class = "panel-card stats-panel",
      div(class = "stats-grid",
        lapply(seq_along(ability_scores), function(i) {
          score_id <- unname(ability_scores[[i]])
          sliderInput(
            score_id,
            names(ability_scores)[i],
            min = 8,
            max = 15,
            value = selected_scores[[score_id]],
            step = 1,
            ticks = TRUE,
            width = "100%"
          )
        })
      ),
      h3(class = "spell-group-title", "Racial ability score increases"),
      p(class = "stats-intro", paste(
        "Your", subrace, "racial ability score increases are applied automatically."
      )),
      uiOutput("final_score_preview"),
      uiOutput("points_status"),
      uiOutput("stats_error"),
      div(
        class = "stats-actions",
        actionButton("back_to_background", "Back to Background", class = "btn-default race-back"),
        actionButton("confirm_stats", "Continue", class = "btn-primary begin-button")
      )
    )
  )
}

load_character_ui <- function() {
  div(
    class = "details-page",
    h1(class = "race-heading", "Returning to the Blackwood...."),
    h2(class = "race-subheading", "Load a saved character"),
    p(class = "race-prompt", "Choose a character JSON file saved from this app."),
    div(
      class = "panel-card details-panel",
      fileInput("load_character_file", "Choose saved character", accept = ".json"),
      uiOutput("load_character_status"),
      div(class = "race-actions",
        actionButton("back_to_intro", "Back", class = "btn-default race-back")
      )
    )
  )
}

character_name_ui <- function(details = list()) {
  div(
    class = "details-page",
    h1(class = "race-heading", "A Name for the Chronicle...."),
    h2(class = "race-subheading", "What shall they be called?"),
    p(class = "race-prompt", "Every legend begins with a name."),
    div(
      class = "panel-card details-panel name-panel",
      textInput(
        "character_name", "Character name",
        value = detail_value(details, "character_name"),
        placeholder = "e.g. Rowan Ashford"
      ),
      actionButton("generate_name", "Generate a name", class = "btn-default race-back"),
      uiOutput("name_error"),
      div(
        class = "name-actions",
        actionButton("back_to_intro", "Back", class = "btn-default race-back"),
        actionButton("confirm_name", "Continue", class = "btn-primary begin-button")
      )
    )
  )
}

alignment_selection_ui <- function(selected = NULL) {
  choice_selection_ui(
    "The Compass Within....",
    "Choose an alignment",
    "",
    "selected_alignment",
    setNames(valid_alignments, valid_alignments),
    "alignment_error",
    "back_to_stats",
    "Back to Ability Scores",
    "confirm_alignment",
    selected
  )
}

selection_description <- function(choice, descriptions, icon_type,
                                   show_description = FALSE, mechanics = NULL) {
  description <- unname(descriptions[[choice]])
  if (show_description) {
    return(tags$div(
      class = "spell-choice",
      tags$span(
        class = "selection-choice",
        `aria-label` = paste(choice, description, sep = ". "),
        selection_icon(icon_type),
        choice
      ),
      p(class = "spell-description", description),
      if (!is.null(mechanics)) p(class = "spell-mechanics", strong("Roll & effect: "), mechanics)
    ))
  }
  tags$span(
    class = "selection-choice",
    title = description,
    `aria-label` = paste(choice, description, sep = ". "),
    selection_icon(icon_type),
    choice
  )
}

selection_icon <- function(type) {
  if (identical(type, "spell")) {
    tags$svg(
      class = "selection-icon",
      viewBox = "0 0 24 24",
      `aria-hidden` = "true",
      tags$path(d = "M5 19L16.5 7.5M14 5l5 5M4 20l5-1-4-4zM17 3l4 4",
        fill = "none", stroke = "currentColor", `stroke-width` = "1.7",
        `stroke-linecap` = "round", `stroke-linejoin` = "round")
    )
  } else {
    tags$svg(
      class = "selection-icon",
      viewBox = "0 0 24 24",
      `aria-hidden` = "true",
      tags$path(d = "M12 3l2.2 5.2L20 10l-4.3 3.4L16.8 19 12 16l-4.8 3 1.1-5.6L4 10l5.8-1.8z",
        fill = "none", stroke = "currentColor", `stroke-width` = "1.5",
        `stroke-linejoin` = "round"),
      tags$circle(cx = "12", cy = "11", r = "2", fill = "currentColor")
    )
  }
}

skills_selection_ui <- function(class, background, species,
                                selected = character(),
                                selected_species_skill = character()) {
  count <- skill_counts[[class]]
  background_skills <- background_rules[[background]]$skills
  species_skills <- species_skill_proficiencies(species, selected_species_skill)
  automatic_skills <- unique(c(background_skills, species_skills))
  available_skills <- setdiff(skill_choices[[class]], automatic_skills)
  div(
    class = "race-page",
    h1(class = "race-heading selection-page-title", "Skills of the Trade...."),
    h2(class = "race-subheading selection-page-subtitle",
      paste("Choose", count, "class skills")),
    p(class = "race-prompt",
      paste("Choose", count, "skills from the options available to your", class,
        "under the 2014 rules. Your background grants",
        paste(background_skills, collapse = " and "),
        if (identical(species, "Human") && length(species_skills)) {
          paste0(" and your Variant Human race grants ", paste(species_skills, collapse = " and "))
        } else if (identical(species, "Half-Elf")) {
          paste0(" and your Half-Elf race grants ", paste(species_skills, collapse = " and "))
        } else if (length(species_skills)) {
          paste0(" and your Elf race grants ", paste(species_skills, collapse = " and "))
        } else {
          ""
        },
        ".")
    ),
    div(
      class = "race-options multi-options skill-options",
      checkboxGroupInput(
        "selected_skills",
        label = NULL,
        choiceNames = lapply(available_skills, function(skill) {
          selection_description(skill, skill_descriptions, "skill")
        }),
        choiceValues = available_skills,
        selected = selected
      )
    ),
    uiOutput("rogue_expertise_ui"),
    uiOutput("skills_error"),
    div(
      class = "race-actions",
      actionButton("back_to_alignment", "Back to Alignment", class = "btn-default race-back"),
      actionButton("confirm_skills", "Continue", class = "btn-primary begin-button")
    )
  )
}

spell_selection_ui <- function(class, selected_cantrips = character(),
                               selected_spells = character(), limits,
                               scores = default_scores) {
  cantrip_choices <- spell_cantrips[[class]]
  class_spells <- spell_choices[[class]]
  stats <- if (class %in% spellcasting_classes) spellcasting_stats(class, scores) else NULL
  div(
    class = "race-page",
    h1(class = "race-heading selection-page-title", "Whispers of Power...."),
    h2(class = "race-subheading selection-page-subtitle", "Choose your starting spells"),
    if (class %in% spellcasting_classes) {
      p(class = "race-prompt",
      "Choose from the 2014 Player's Handbook spell options available to your class."
      )
    } else {
      p(class = "race-prompt",
        paste(class, "does not have spellcasting at level 1. Continue to choose your equipment.")
      )
    },
    if (identical(class, "Wizard")) {
      p(class = "race-prompt",
        "Choose your spellbook entries, then mark the spells you have prepared for today."
      )
    },
    if (!is.null(stats)) {
      div(
        class = "spellcasting-summary",
        strong("Your level-1 spellcasting numbers: "),
        paste0(stats$ability, " modifier ",
          if (stats$modifier >= 0) "+" else "", stats$modifier,
          " · spell attack ",
          if (stats$attack >= 0) "+" else "", stats$attack,
          " · spell save DC ", stats$save_dc,
          " · proficiency +2"),
        br(),
        span("Use the attack bonus for spell attacks and the save DC when a spell calls for a saving throw.")
      )
    },
    if (limits$cantrips > 0L) {
      tagList(
        h3(class = "spell-group-title", paste("Cantrips — choose", limits$cantrips)),
        div(
          class = "race-options multi-options spell-options",
          checkboxGroupInput(
            "selected_cantrips",
            label = NULL,
            choiceNames = lapply(cantrip_choices, function(spell) {
              selection_description(spell, spell_descriptions, "spell",
                show_description = TRUE,
                mechanics = spell_mechanics_for(spell, class, scores))
            }),
            choiceValues = cantrip_choices,
            selected = selected_cantrips
          )
        )
      )
    },
    if (limits$spells > 0L) {
      tagList(
        h3(class = "spell-group-title",
          if (identical(class, "Wizard")) {
            paste("Add", limits$spells, "level-1 spells to your spellbook")
          } else {
            paste("Level 1 — choose", limits$spells, limits$spell_label)
          }),
        div(
          class = "race-options multi-options spell-options",
          checkboxGroupInput(
            "selected_spells",
            label = NULL,
            choiceNames = lapply(class_spells, function(spell) {
              selection_description(spell, spell_descriptions, "spell",
                show_description = TRUE,
                mechanics = spell_mechanics_for(spell, class, scores))
            }),
            choiceValues = class_spells,
            selected = selected_spells
          )
        )
      )
    },
    uiOutput("wizard_prepared_ui"),
    uiOutput("spells_error"),
    div(
      class = "race-actions",
      actionButton("back_to_skills", "Back to Skills", class = "btn-default race-back"),
      actionButton("confirm_spells", "Continue", class = "btn-primary begin-button")
    )
  )
}

equipment_selection_ui <- function(selected = NULL, gear, class) {
  if (is.null(selected) || !selected %in% names(equipment_options)) {
    selected <- names(equipment_options)[[1]]
  }
  weapon_choices <- c("— none —" = "", names(weapon_profiles))
  div(
    class = "race-page",
    h1(class = "race-heading selection-page-title", "Ready for the Road...."),
    h2(class = "race-subheading selection-page-subtitle", "Choose your equipment"),
    p(class = "race-prompt",
      "Select a campaign pack, then record your worn armour, shield, attacks, inventory, and coins. The initial gear is a level-1 suggestion; check it against your table's choices."),
    div(
      class = "race-options",
      radioButtons(
        "selected_equipment",
        label = NULL,
        choiceNames = lapply(names(equipment_options), function(choice) {
          tags$span(
            tags$span(class = "race-name", choice),
            tags$span(class = "race-blurb", unname(equipment_options[[choice]]))
          )
        }),
        choiceValues = names(equipment_options),
        selected = selected
      )
    ),
    uiOutput("equipment_error"),
    div(class = "panel-card details-panel gear-panel",
      h3(class = "spell-group-title", "Worn gear and attacks"),
      selectInput("equipped_armour", "Armour", names(armour_profiles),
        selected = gear$armour),
      checkboxInput("equipped_shield", "Wearing a shield (+2 AC)", gear$shield),
      p(class = "text-muted",
        "Armour training: check whether your class is proficient with your selected armour and shield. Unfamiliar armour can impose penalties under your table's rules."),
      selectInput("equipped_weapons", "Weapons carried (up to three)",
        choices = weapon_choices, selected = gear$weapons, multiple = TRUE),
      textAreaInput("inventory", "Inventory and carried gear",
        value = gear$inventory, rows = 5, width = "100%"),
      h3(class = "spell-group-title", "Coins and hit points"),
      div(class = "stats-grid coin-grid",
        numericInput("coin_cp", "Copper (CP)", gear$cp, min = 0, step = 1),
        numericInput("coin_sp", "Silver (SP)", gear$sp, min = 0, step = 1),
        numericInput("coin_ep", "Electrum (EP)", gear$ep, min = 0, step = 1),
        numericInput("coin_gp", "Gold (GP)", gear$gp, min = 0, step = 1),
        numericInput("coin_pp", "Platinum (PP)", gear$pp, min = 0, step = 1)
      ),
      div(class = "stats-grid",
        numericInput("spell_slots_remaining", "Spell slots remaining",
          gear$spell_slots_remaining, min = 0,
          max = class_rules[[class]]$slots, step = 1),
        numericInput("current_hp", "Current HP", gear$current_hp, min = 0, step = 1),
        numericInput("temporary_hp", "Temporary HP", gear$temporary_hp, min = 0, step = 1),
        numericInput("death_successes", "Death save successes", gear$death_successes, min = 0, max = 3, step = 1),
        numericInput("death_failures", "Death save failures", gear$death_failures, min = 0, max = 3, step = 1)
      )
    ),
    div(
      class = "race-actions",
      actionButton("back_to_spells", "Back to Spells", class = "btn-default race-back"),
      actionButton("confirm_equipment", "Continue", class = "btn-primary begin-button")
    )
  )
}

character_identity_ui <- function(details) {
  div(
    class = "details-page",
    h1(class = "race-heading", "Beyond the Numbers...."),
    h2(class = "race-subheading", "Give your character a life"),
    p(class = "race-prompt",
      "Record the details that help you bring this adventurer to the table. These are optional and can be edited in your save file."),
    div(class = "panel-card details-panel identity-panel",
      textInput("pronouns", "Pronouns", detail_value(details, "pronouns")),
      textInput("age", "Age", detail_value(details, "age")),
      textInput("height", "Height", detail_value(details, "height")),
      textInput("eyes", "Eye colour", detail_value(details, "eyes")),
      textInput("hair", "Hair", detail_value(details, "hair")),
      textAreaInput("appearance", "Appearance", detail_value(details, "appearance"), rows = 2),
      textAreaInput("personality", "Personality", detail_value(details, "personality"), rows = 2),
      textAreaInput("ideals", "Ideals", detail_value(details, "ideals"), rows = 2),
      textAreaInput("bonds", "Bonds", detail_value(details, "bonds"), rows = 2),
      textAreaInput("flaws", "Flaws", detail_value(details, "flaws"), rows = 2),
      textAreaInput("backstory", "Backstory", detail_value(details, "backstory"), rows = 4),
      textInput("languages", "Languages", detail_value(details, "languages"),
        placeholder = "e.g. Common, Elvish"),
      textAreaInput("notes", "Other notes", detail_value(details, "notes"), rows = 3),
      div(class = "race-actions",
        actionButton("back_to_equipment", "Back to Equipment", class = "btn-default race-back"),
        actionButton("confirm_identity", "View Character Sheet", class = "btn-primary begin-button")
      )
    )
  )
}

detail_value <- function(details, name, default = "") {
  value <- details[[name]]
  if (is.null(value)) default else value
}

value_or <- function(value, default) {
  if (is.null(value)) default else value
}

character_overview_ui <- function() {
  div(
    class = "overview-page",
    h1(class = "race-heading", "Your Chronicle"),
    h2(class = "race-subheading", "The hero you bring to the Blackwood"),
    uiOutput("load_character_status"),
    div(class = "panel-card overview-panel", uiOutput("character_sheet")),
    uiOutput("download_ui"),
    div(
      class = "overview-actions",
      actionButton("back_to_identity", "Back to Details", class = "btn-default race-back")
    )
  )
}

server <- function(input, output, session) {
  current_screen <- reactiveVal("intro")
  chosen_species <- reactiveVal(NULL)
  chosen_subrace <- reactiveVal(NULL)
  chosen_race_choices <- reactiveVal(list())
  chosen_class <- reactiveVal(NULL)
  chosen_background <- reactiveVal(NULL)
  chosen_background_choices <- reactiveVal(list())
  chosen_scores <- reactiveVal(default_scores)
  chosen_ability_increases <- reactiveVal(NULL)
  chosen_skills <- reactiveVal(character())
  chosen_expertise <- reactiveVal(character())
  chosen_species_skill <- reactiveVal(character())
  chosen_cantrips <- reactiveVal(character())
  chosen_spells <- reactiveVal(character())
  chosen_prepared_spells <- reactiveVal(character())
  chosen_equipment <- reactiveVal(names(equipment_options)[[1]])
  character_gear <- reactiveVal(NULL)
  saved_details <- reactiveVal(list())
  load_message <- reactiveVal(NULL)

  current_detail <- function(name, default = "") {
    value_or(input[[name]], detail_value(saved_details(), name, default))
  }

  collect_details <- function() {
    fields <- c("character_name", "alignment", "pronouns", "age", "height",
      "eyes", "hair", "appearance", "personality", "ideals", "bonds", "flaws",
      "backstory", "languages", "notes")
    defaults <- list(alignment = "Unspecified")
    values <- lapply(fields, function(field) {
      current_detail(field, value_or(defaults[[field]], ""))
    })
    names(values) <- fields
    values
  }

  current_gear <- function() {
    gear <- character_gear()
    if (is.null(gear) && !is.null(chosen_class()) && !is.null(chosen_background()) &&
        !is.null(chosen_species())) {
      gear <- default_character_gear(chosen_class(), chosen_background(),
        chosen_species(), final_scores(), chosen_subrace())
    }
    gear
  }

  mage_armour_available <- function() {
    "Mage Armor" %in% chosen_spells() &&
      (!identical(chosen_class(), "Wizard") ||
        "Mage Armor" %in% chosen_prepared_spells())
  }

  collect_gear <- function() {
    gear <- current_gear()
    values <- list(
      armour = value_or(input$equipped_armour, gear$armour),
      shield = value_or(input$equipped_shield, gear$shield),
      weapons = value_or(input$equipped_weapons, gear$weapons),
      inventory = value_or(input$inventory, gear$inventory)
    )
    values$weapons <- values$weapons[nzchar(values$weapons)]
    for (field in c("cp", "sp", "ep", "gp", "pp")) {
      values[[field]] <- value_or(input[[paste0("coin_", field)]], gear[[field]])
    }
    values$current_hp <- value_or(input$current_hp, gear$current_hp)
    values$temporary_hp <- value_or(input$temporary_hp, gear$temporary_hp)
    values$spell_slots_remaining <- value_or(input$spell_slots_remaining,
      gear$spell_slots_remaining)
    values$death_successes <- value_or(input$death_successes, gear$death_successes)
    values$death_failures <- value_or(input$death_failures, gear$death_failures)
    values
  }

  update_saved_details <- function() {
    details <- collect_details()
    saved_details(details)
    details
  }

  output$app_screen <- renderUI({
    switch(
      current_screen(),
      intro = introduction_ui(),
      load = load_character_ui(),
      race = race_selection_ui(chosen_species(), chosen_subrace(),
        chosen_race_choices()),
      class = class_selection_ui(chosen_class()),
      background = background_selection_ui(chosen_background()),
      stats = stats_selection_ui(chosen_scores(), chosen_background(),
        chosen_species(), chosen_subrace(), chosen_race_choices(), chosen_class()),
      name = character_name_ui(saved_details()),
      alignment = alignment_selection_ui(detail_value(saved_details(), "alignment", "Unspecified")),
      skills = skills_selection_ui(chosen_class(), chosen_background(),
        chosen_species(), chosen_skills(), chosen_species_skill()),
      spells = spell_selection_ui(
        chosen_class(), chosen_cantrips(), chosen_spells(),
        spell_selection_limits(chosen_class(), final_scores()),
        final_scores()
      ),
      equipment = equipment_selection_ui(chosen_equipment(), current_gear(),
        chosen_class()),
      identity = character_identity_ui(saved_details()),
      summary = character_overview_ui()
    )
  })

  current_race_choices <- function(race, subrace) {
    choices <- if (identical(race, chosen_species()) &&
        identical(subrace, chosen_subrace())) chosen_race_choices() else list()
    if (identical(race, "Human") && identical(subrace, "Variant Human")) {
      choices$ability_names <- value_or(input$variant_abilities, choices$ability_names)
      choices$skill <- value_or(input$variant_skill, choices$skill)
      choices$feat <- value_or(input$variant_feat, choices$feat)
      if (length(choices$ability_names) == 2L &&
          all(choices$ability_names %in% names(ability_scores))) {
        choices$ability_bonuses <- setNames(rep(1L, 2L),
          unname(ability_scores[choices$ability_names]))
      }
    } else if (identical(race, "Human") && identical(subrace, "Human")) {
      choices$language <- value_or(input$human_language, choices$language)
    } else if (identical(race, "Dwarf")) {
      choices$tool <- value_or(input$dwarf_tool, choices$tool)
    } else if (identical(race, "Elf") && identical(subrace, "High Elf")) {
      choices$cantrip <- value_or(input$high_elf_cantrip, choices$cantrip)
    } else if (identical(race, "Dragonborn")) {
      choices$draconic_ancestry <- value_or(input$draconic_ancestry,
        choices$draconic_ancestry)
    } else if (identical(race, "Half-Elf")) {
      choices$ability_names <- value_or(input$half_elf_abilities, choices$ability_names)
      choices$skills <- value_or(input$half_elf_skills, choices$skills)
      if (length(choices$ability_names) == 2L &&
          all(choices$ability_names %in% setdiff(names(ability_scores), "Charisma"))) {
        choices$ability_bonuses <- setNames(rep(1L, 2L),
          unname(ability_scores[choices$ability_names]))
      }
    }
    choices
  }

  current_background_choices <- function(background) {
    choices <- if (identical(background, chosen_background())) {
      chosen_background_choices()
    } else {
      list()
    }
    defaults <- default_background_choices(background)
    fields <- c(
      languages = "background_languages",
      artisan_tool = "background_artisan_tool",
      gaming_set = "background_gaming_set",
      instrument = "background_instrument",
      con_tools = "background_con_tools"
    )
    for (field in names(fields)) {
      selected <- value_or(input[[fields[[field]]]], choices[[field]])
      if (is.null(selected)) selected <- defaults[[field]]
      if (!is.null(selected)) choices[[field]] <- selected
    }
    language_count <- background_choice_rules[[background]]$languages
    if (!is.null(language_count) &&
        (length(choices$languages) != language_count ||
          anyDuplicated(choices$languages))) {
      choices$languages <- defaults$languages
    }
    choices
  }

  output$background_options_ui <- renderUI({
    background <- value_or(input$selected_background, chosen_background())
    if (is.null(background) || !background %in% names(background_rules)) return(NULL)
    background_choice_inputs_ui(background,
      current_background_choices(background))
  })

  output$race_options_ui <- renderUI({
    race <- value_or(input$selected_race, chosen_species())
    if (is.null(race) || !race %in% names(race_subraces)) return(NULL)
    subrace <- value_or(input$selected_subrace, chosen_subrace())
    if (is.null(subrace) || !subrace %in% race_subraces[[race]]) {
      subrace <- default_subrace(race)
    }
    race_option_inputs_ui(race, subrace,
      current_race_choices(race, subrace))
  })

  output$race_benefits <- renderUI({
    race <- value_or(input$selected_race, chosen_species())
    if (is.null(race) || !race %in% names(race_subraces)) return(NULL)
    subrace <- value_or(input$selected_subrace, chosen_subrace())
    if (is.null(subrace) || !subrace %in% race_subraces[[race]]) {
      subrace <- default_subrace(race)
    }
    choices <- current_race_choices(race, subrace)
    traits <- race_trait_summary(race, subrace, choices)
    tagList(
      p(class = "text-muted", paste(race, "—", subrace,
        "·", race_size(race, subrace), "·", race_walking_speed(race, subrace), "ft. speed")),
      tags$ul(lapply(traits, tags$li))
    )
  })

  output$wizard_prepared_ui <- renderUI({
    if (!identical(chosen_class(), "Wizard") || current_screen() != "spells") return(NULL)
    selected_spells <- value_or(input$selected_spells, chosen_spells())
    selected_spells <- intersect(selected_spells, spell_choices$Wizard)
    if (!length(selected_spells)) {
      return(p(class = "race-prompt", "Choose spellbook spells to mark today's prepared spells."))
    }
    limit <- min(spell_prepared_limit("Wizard", final_scores()), length(selected_spells))
    selected_prepared <- value_or(input$wizard_prepared_spells, chosen_prepared_spells())
    selected_prepared <- intersect(selected_prepared, selected_spells)
    if (!length(selected_prepared)) selected_prepared <- head(selected_spells, limit)
    tagList(
      h3(class = "spell-group-title", paste("Prepare", limit, "spells for today")),
      checkboxGroupInput(
        "wizard_prepared_spells",
        label = NULL,
        choices = selected_spells,
        selected = selected_prepared
      )
    )
  })

  output$load_character_status <- renderUI({
    message <- load_message()
    if (is.null(message)) return(NULL)
    class <- if (startsWith(message, "Character loaded.")) "text-success" else "text-warning"
    div(class = class, message)
  })

  observeEvent(input$load_character_file, {
    load_message(NULL)
    tryCatch({
      file <- input$load_character_file
      if (is.null(file) || !file.exists(file$datapath)) {
        stop("The selected save file could not be read.", call. = FALSE)
      }
      payload <- jsonlite::fromJSON(file$datapath, simplifyVector = FALSE)
      character <- validate_character_payload(payload)
      chosen_species(character$species)
      chosen_subrace(character$subrace)
      chosen_race_choices(character$race_choices)
      chosen_class(character$class)
      chosen_background(character$background_choice)
      chosen_background_choices(character$background_choices)
      chosen_scores(character$ability_scores)
      chosen_ability_increases(integer())
      chosen_skills(character$skills)
      chosen_expertise(character$expertise)
      chosen_species_skill(character$species_skill)
      chosen_cantrips(character$cantrips)
      chosen_spells(character$spells)
      chosen_prepared_spells(character$prepared_spells)
      chosen_equipment(character$equipment)
      character_gear(character$gear)
      saved_details(character$details)
      current_screen("summary")
      load_message("Character loaded. You can review it or go back to make changes.")
    }, error = function(error) {
      load_message(paste("Could not load character:", conditionMessage(error)))
    })
  })

  observeEvent(input$begin_journey, {
    current_screen("name")
  })

  observeEvent(input$open_load_character, {
    load_message(NULL)
    current_screen("load")
  })

  observeEvent(input$back_to_intro, {
    current_screen("intro")
  })

  observeEvent(input$back_to_name, {
    current_screen("name")
  })

  output$race_error <- renderUI({
    if (current_screen() == "race" &&
        !is.null(input$confirm_race) && input$confirm_race > 0) {
      race <- input$selected_race
      subrace <- input$selected_subrace
      valid <- !is.null(race) && race %in% names(race_subraces) &&
        !is.null(subrace) && subrace %in% race_subraces[[race]]
      if (!valid) {
        return(div(class = "text-warning text-center",
          "Complete the required race and subrace choices before continuing."))
      }
      result <- tryCatch(
        normalise_race_choices(race, subrace,
          current_race_choices(race, subrace)),
        error = function(error) error
      )
      if (inherits(result, "error")) {
        return(div(class = "text-warning text-center",
          conditionMessage(result)))
      }
    }
    NULL
  })

  observeEvent(input$confirm_race, {
    race <- input$selected_race
    subrace <- input$selected_subrace
    if (is.null(race) || !race %in% names(race_subraces) ||
        is.null(subrace) || !subrace %in% race_subraces[[race]]) return()
    choices <- tryCatch(
      normalise_race_choices(race, subrace,
        current_race_choices(race, subrace)),
      error = function(error) NULL
    )
    if (is.null(choices)) return()
    chosen_species(race)
    chosen_subrace(subrace)
    chosen_race_choices(choices)
    chosen_species_skill(if (identical(subrace, "Variant Human")) {
      choices$skill
    } else if (identical(race, "Half-Elf")) {
      choices$skills
    } else {
      character()
    })
    current_screen("class")
  })

  observeEvent(input$back_to_race, {
    current_screen("race")
  })

  output$class_error <- renderUI({
    if (current_screen() == "class" &&
        !is.null(input$confirm_class) && input$confirm_class > 0 &&
        (is.null(input$selected_class) || !nzchar(input$selected_class))) {
      div(class = "text-warning text-center", "Choose a class before continuing.")
    }
  })

  observeEvent(input$confirm_class, {
    if (is.null(input$selected_class) || !nzchar(input$selected_class)) return()
    if (!identical(chosen_class(), input$selected_class)) {
      chosen_scores(suggested_ability_scores(input$selected_class))
      chosen_skills(character())
      chosen_expertise(character())
      chosen_cantrips(character())
      chosen_spells(character())
      chosen_prepared_spells(character())
    }
    chosen_class(input$selected_class)
    current_screen("background")
  })

  observeEvent(input$back_to_class, {
    current_screen("class")
  })

  output$background_error <- renderUI({
    if (current_screen() == "background" &&
        !is.null(input$confirm_background) && input$confirm_background > 0) {
      background <- input$selected_background
      if (is.null(background) || !background %in% names(background_rules)) {
        return(div(class = "text-warning text-center",
          "Choose a background before continuing."))
      }
      result <- tryCatch(
        normalise_background_choices(background,
          current_background_choices(background)),
        error = function(error) error
      )
      if (inherits(result, "error")) {
        return(div(class = "text-warning text-center",
          conditionMessage(result)))
      }
    }
    NULL
  })

  observeEvent(input$confirm_background, {
    if (is.null(input$selected_background) ||
        !input$selected_background %in% names(background_rules)) return()
    choices <- tryCatch(
      normalise_background_choices(input$selected_background,
        current_background_choices(input$selected_background)),
      error = function(error) NULL
    )
    if (is.null(choices)) return()
    chosen_background(input$selected_background)
    chosen_background_choices(choices)
    chosen_ability_increases(integer())
    chosen_skills(character())
    chosen_expertise(character())
    character_gear(default_character_gear(chosen_class(), input$selected_background,
      chosen_species(), final_scores(), chosen_subrace()))
    current_screen("stats")
  })

  observeEvent(input$back_to_background, {
    current_screen("background")
  })

  score_values <- reactive({
    scores <- vapply(unname(ability_scores), function(score_id) {
      score <- input[[score_id]]
      as.integer(if (is.null(score)) chosen_scores()[[score_id]] else score)
    }, integer(1))
    names(scores) <- unname(ability_scores)
    scores
  })

  observeEvent(input$apply_suggested_scores, {
    scores <- suggested_ability_scores(chosen_class())
    chosen_scores(scores)
    for (score_id in unname(ability_scores)) {
      updateSliderInput(session, score_id, value = scores[[score_id]])
    }
  })

  final_scores <- reactive({
    scores <- chosen_scores()
    if (is.null(chosen_species()) || is.null(chosen_subrace())) return(scores)
    bonuses <- racial_ability_bonuses(chosen_species(), chosen_subrace(),
      chosen_race_choices())
    scores + bonuses
  })

  points_spent <- reactive({
    scores <- score_values()
    if (anyNA(scores)) return(NA_integer_)
    sum(score_costs[as.character(scores)])
  })

  output$final_score_preview <- renderUI({
    scores <- score_values()
    bonuses <- racial_ability_bonuses(chosen_species(), chosen_subrace(),
      chosen_race_choices())
    final <- scores + bonuses
    div(
      class = "points-total text-center",
      paste("Scores after racial increases:",
        paste(paste(names(ability_scores), final[unname(ability_scores)]),
          collapse = " · ")
      )
    )
  })

  character_is_valid <- reactive({
    name <- trimws(current_detail("character_name"))
    points <- points_spent()
    nzchar(name) && !is.na(points) && points <= 27
  })

  output$points_status <- renderUI({
    if (current_screen() != "stats") return(NULL)
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

  output$stats_error <- renderUI({
    if (current_screen() == "stats" &&
        !is.null(input$confirm_stats) && input$confirm_stats > 0) {
      points <- points_spent()
      if (is.na(points)) {
        return(div(class = "text-warning text-center", "Set a score for every ability."))
      }
      if (points > 27) {
        return(div(class = "text-danger text-center", "Reduce your scores to fit the 27-point budget."))
      }
    }
  })

  observeEvent(input$confirm_stats, {
    points <- points_spent()
    if (is.na(points) || points > 27) return()
    chosen_scores(score_values())
    chosen_ability_increases(integer())
    character_gear(default_character_gear(chosen_class(), chosen_background(),
      chosen_species(), final_scores(), chosen_subrace()))
    current_screen("alignment")
  })

  observeEvent(input$back_to_stats, {
    details <- collect_details()
    details$alignment <- value_or(input$selected_alignment, details$alignment)
    saved_details(details)
    current_screen("stats")
  })

  output$name_error <- renderUI({
    if (current_screen() == "name" &&
        !is.null(input$confirm_name) && input$confirm_name > 0 &&
        !nzchar(trimws(current_detail("character_name")))) {
      div(class = "text-warning text-center", "Enter a character name to continue.")
    }
  })

  observeEvent(input$confirm_name, {
    details <- collect_details()
    if (!nzchar(trimws(details$character_name))) return()
    saved_details(details)
    current_screen("race")
  })

  observeEvent(input$generate_name, {
    updateTextInput(session, "character_name", value = generate_character_name())
  })

  output$alignment_error <- renderUI({
    if (current_screen() == "alignment" &&
        !is.null(input$confirm_alignment) && input$confirm_alignment > 0 &&
        (is.null(input$selected_alignment) ||
          !input$selected_alignment %in% valid_alignments)) {
      div(class = "text-warning text-center", "Choose an alignment before continuing.")
    }
  })

  observeEvent(input$confirm_alignment, {
    if (is.null(input$selected_alignment) ||
        !input$selected_alignment %in% valid_alignments) return()
    details <- collect_details()
    details$alignment <- input$selected_alignment
    saved_details(details)
    current_screen("skills")
  })

  observeEvent(input$back_to_alignment, {
    current_screen("alignment")
  })

  output$skills_error <- renderUI({
    automatic_skills <- unique(c(background_rules[[chosen_background()]]$skills,
      species_skill_proficiencies(chosen_species(), chosen_species_skill())))
    available_skills <- setdiff(skill_choices[[chosen_class()]],
      automatic_skills)
    if (current_screen() == "skills" &&
        !is.null(input$confirm_skills) && input$confirm_skills > 0 &&
        (length(input$selected_skills) != skill_counts[[chosen_class()]] ||
          any(!input$selected_skills %in% available_skills) ||
          (identical(chosen_class(), "Rogue") &&
            length(value_or(input$rogue_expertise, character())) != 2L))) {
      div(class = "text-warning text-center",
        if (identical(chosen_class(), "Rogue")) {
          "Choose the required class skills and exactly two proficient skills for Expertise."
        } else {
          paste("Choose exactly", skill_counts[[chosen_class()]], "class skills.")
        }
      )
    }
  })

  output$rogue_expertise_ui <- renderUI({
    if (!identical(chosen_class(), "Rogue") || current_screen() != "skills") return(NULL)
    proficient <- unique(c(background_rules[[chosen_background()]]$skills,
      species_skill_proficiencies(chosen_species(), chosen_species_skill()),
      value_or(input$selected_skills, chosen_skills())))
    selected <- intersect(value_or(input$rogue_expertise, chosen_expertise()), proficient)
    if (!length(selected)) selected <- head(proficient, 2L)
    tagList(
      h3(class = "spell-group-title", "Choose two skills for Expertise"),
      p(class = "race-prompt",
        "Your proficiency bonus is doubled for these two skills."),
      checkboxGroupInput("rogue_expertise", label = NULL, choices = proficient,
        selected = selected)
    )
  })

  observeEvent(input$confirm_skills, {
    skills <- value_or(input$selected_skills, character())
    fixed_skills <- unique(c(background_rules[[chosen_background()]]$skills,
      species_skill_proficiencies(chosen_species(), chosen_species_skill())))
    available_skills <- setdiff(skill_choices[[chosen_class()]], fixed_skills)
    if (length(skills) != skill_counts[[chosen_class()]] ||
        any(!skills %in% available_skills)) return()
    species_skill <- chosen_species_skill()
    automatic_skills <- unique(c(background_rules[[chosen_background()]]$skills,
      species_skill_proficiencies(chosen_species(), species_skill)))
    expertise <- character()
    if (identical(chosen_class(), "Rogue")) {
      expertise <- value_or(input$rogue_expertise, head(unique(c(
        automatic_skills, skills
      )), 2L))
      if (length(expertise) != 2L || anyDuplicated(expertise) ||
          any(!expertise %in% c(automatic_skills, skills))) return()
    }
    chosen_skills(skills)
    chosen_expertise(expertise)
    chosen_species_skill(species_skill)
    current_screen("spells")
  })

  observeEvent(input$back_to_skills, {
    current_screen("skills")
  })

  output$spells_error <- renderUI({
    if (current_screen() == "spells" &&
        !is.null(input$confirm_spells) && input$confirm_spells > 0) {
      limits <- spell_selection_limits(chosen_class(), final_scores())
      cantrips <- value_or(input$selected_cantrips, character())
      spells <- value_or(input$selected_spells, character())
      if (limits$cantrips == 0L) cantrips <- character()
      if (limits$spells == 0L) spells <- character()
      if (length(cantrips) != limits$cantrips) {
        return(div(class = "text-warning text-center",
          paste("Choose exactly", limits$cantrips, "cantrips.")
        ))
      }
      if (length(spells) != limits$spells) {
        return(div(class = "text-warning text-center",
          paste("Choose exactly", limits$spells, limits$spell_label, ".")
        ))
      }
      if (identical(chosen_class(), "Wizard")) {
        prepared <- intersect(value_or(input$wizard_prepared_spells, character()), spells)
        expected <- min(spell_prepared_limit("Wizard", final_scores()), length(spells))
        if (length(prepared) != expected) {
          return(div(class = "text-warning text-center",
            paste("Prepare exactly", expected, "spells for today.")
          ))
        }
      }
    }
  })

  observeEvent(input$confirm_spells, {
    limits <- spell_selection_limits(chosen_class(), final_scores())
    cantrips <- value_or(input$selected_cantrips, character())
    spells <- value_or(input$selected_spells, character())
    if (limits$cantrips == 0L) cantrips <- character()
    if (limits$spells == 0L) spells <- character()
    valid_cantrips <- spell_cantrips[[chosen_class()]]
    valid_spells <- spell_choices[[chosen_class()]]
    if (is.null(valid_cantrips)) valid_cantrips <- character()
    if (is.null(valid_spells)) valid_spells <- character()
    if (length(cantrips) != limits$cantrips ||
        any(!cantrips %in% valid_cantrips) ||
        length(spells) != limits$spells ||
        any(!spells %in% valid_spells)) return()
    prepared <- character()
    if (identical(chosen_class(), "Wizard")) {
      prepared <- value_or(input$wizard_prepared_spells,
        head(spells, min(spell_prepared_limit("Wizard", final_scores()),
          length(spells))))
      expected <- min(spell_prepared_limit("Wizard", final_scores()),
        length(spells))
      if (length(prepared) != expected || anyDuplicated(prepared) ||
          any(!prepared %in% spells)) return()
    }
    chosen_cantrips(cantrips)
    chosen_spells(spells)
    if (identical(chosen_class(), "Wizard")) {
      chosen_prepared_spells(prepared)
    } else if (chosen_class() %in% c("Cleric", "Druid", "Paladin", "Ranger")) {
      chosen_prepared_spells(spells)
    } else {
      chosen_prepared_spells(character())
    }
    current_screen("equipment")
  })

  observeEvent(input$back_to_spells, {
    if (!is.null(chosen_class()) && !is.null(chosen_background())) {
      character_gear(collect_gear())
      if (!is.null(input$selected_equipment) &&
          input$selected_equipment %in% names(equipment_options)) {
        chosen_equipment(input$selected_equipment)
      }
    }
    current_screen("spells")
  })

  output$equipment_error <- renderUI({
    if (current_screen() != "equipment" || is.null(input$confirm_equipment) ||
        input$confirm_equipment == 0) return(NULL)
    gear <- collect_gear()
    if (is.null(input$selected_equipment) ||
        !input$selected_equipment %in% names(equipment_options)) {
      return(div(class = "text-warning text-center", "Choose an equipment pack before continuing."))
    }
    if (length(gear$weapons) > 3L ||
        any(!gear$weapons %in% names(weapon_profiles))) {
      return(div(class = "text-warning text-center", "Choose no more than three valid weapons."))
    }
    numeric_fields <- c("cp", "sp", "ep", "gp", "pp", "current_hp",
      "temporary_hp", "spell_slots_remaining", "death_successes", "death_failures")
    invalid <- vapply(numeric_fields, function(field) {
      value <- gear[[field]]
      is.null(value) || length(value) != 1L || !is.numeric(value) ||
        !is.finite(value) ||
        value < 0 || value != as.integer(value) ||
        (field %in% c("death_successes", "death_failures") && value > 3L) ||
        (field == "spell_slots_remaining" &&
          value > class_rules[[chosen_class()]]$slots)
    }, logical(1))
    if (any(invalid)) {
      return(div(class = "text-warning text-center",
        "Coins, hit points, and spell slots must be whole numbers; death saves must be 0–3 and spell slots cannot exceed your class maximum."))
    }
    if (identical(gear$armour, "Mage Armour") &&
        !mage_armour_available()) {
      return(div(class = "text-warning text-center",
        "Mage Armour requires Mage Armor to be available (and prepared for a Wizard)."))
    }
    NULL
  })

  observeEvent(input$confirm_equipment, {
    gear <- collect_gear()
    numeric_fields <- c("cp", "sp", "ep", "gp", "pp", "current_hp",
      "temporary_hp", "spell_slots_remaining", "death_successes", "death_failures")
    invalid <- vapply(numeric_fields, function(field) {
      value <- gear[[field]]
      is.null(value) || length(value) != 1L || !is.numeric(value) ||
        !is.finite(value) || value < 0 || value != as.integer(value) ||
        (field %in% c("death_successes", "death_failures") && value > 3L) ||
        (field == "spell_slots_remaining" &&
          value > class_rules[[chosen_class()]]$slots)
    }, logical(1))
    if (is.null(input$selected_equipment) ||
        !input$selected_equipment %in% names(equipment_options) ||
        length(gear$weapons) > 3L ||
        any(!gear$weapons %in% names(weapon_profiles)) || any(invalid) ||
        (identical(gear$armour, "Mage Armour") &&
          !mage_armour_available())) return()
    chosen_equipment(input$selected_equipment)
    character_gear(normalise_character_gear(gear, chosen_class(),
      chosen_background(), chosen_species(), final_scores(), chosen_subrace()))
    current_screen("identity")
  })

  observeEvent(input$back_to_equipment, {
    update_saved_details()
    current_screen("equipment")
  })

  observeEvent(input$back_to_identity, {
    current_screen("identity")
  })

  observeEvent(input$confirm_identity, {
    update_saved_details()
    current_screen("summary")
  })

  output$character_sheet <- renderUI({
    if (!character_is_valid()) {
      name <- trimws(current_detail("character_name"))
      if (!nzchar(name)) {
        return(p("Enter a character name to see the sheet preview.", class = "text-muted"))
      }
      return(p("Spend no more than 27 points to preview this character.", class = "text-danger"))
    }

    details <- collect_details()
    gear <- current_gear()
    scores <- final_scores()
    proficient_skills <- class_skill_proficiencies(
      chosen_class(), chosen_background(), chosen_skills(), chosen_species(),
      chosen_species_skill()
    )
    section <- function(label, value, full_width = FALSE) {
      value <- unlist(value, use.names = FALSE)
      value <- value[!is.na(value) & nzchar(trimws(value))]
      if (!length(value)) return(NULL)
      tagList(
        div(
          class = paste("overview-section", if (full_width) "sheet-full-width"),
          h3(paste0(label, ":")),
          if (length(value) == 1L) p(value) else tags$ul(lapply(value, tags$li))
        )
      )
    }
    signed <- function(value) paste0(if (value >= 0) "+" else "", value)
    max_hp <- level_one_hit_points(chosen_class(), scores, chosen_species(),
      chosen_subrace())
    spell_text <- function(spell) {
      prepared_label <- if (spell %in% chosen_prepared_spells()) " · Prepared" else ""
      paste0(spell, " — Range: ", spell_range(spell),
        " · Duration: ", spell_duration(spell),
        " · Components: ", spell_components(spell), prepared_label)
    }
    saving_lines <- vapply(names(ability_scores), function(ability) {
      paste0(ability, " ", signed(saving_throw_bonus(ability, scores, chosen_class())),
        if (ability %in% class_rules[[chosen_class()]]$saves) " · proficient" else "")
    }, character(1))
    skill_lines <- vapply(proficient_skills, function(skill) {
      paste0(skill, " (", skill_abilities[[skill]], ") ",
        signed(skill_bonus(skill, scores, chosen_class(), chosen_background(),
          chosen_skills(), chosen_expertise(), chosen_species(),
          chosen_species_skill())),
        if (skill %in% chosen_expertise()) " · Expertise" else "")
    }, character(1))
    attacks <- lapply(unique(c(gear$weapons, "Unarmed Strike")), function(weapon) {
      attack <- weapon_attack_record(weapon, scores, chosen_class())
      paste0(attack$name, " — ", signed(attack$bonus), " to hit · ",
        attack$damage, " · ", attack$properties,
        if (attack$proficient) "" else " · not proficient")
    })
    identity_lines <- vapply(c("pronouns", "age", "height", "eyes", "hair",
      "appearance", "personality", "ideals", "bonds", "flaws", "backstory",
      "languages", "notes"), function(field) {
      value <- details[[field]]
      if (is.null(value) || !nzchar(trimws(value))) return("")
      label <- paste0(toupper(substr(field, 1L, 1L)), substring(field, 2L))
      paste0(label, ": ", value)
    }, character(1))
    armour_category <- armour_profiles[[gear$armour]]$proficiency
    armour_training <- class_armour_training[[chosen_class()]]
    armour_warning <- if (armour_category != "None" &&
        !armour_category %in% armour_training) {
      paste("Not proficient with", tolower(armour_category), "armour.")
    } else {
      character()
    }
    shield_warning <- if (isTRUE(gear$shield) && !"Shield" %in% armour_training) {
      "Not proficient with shields."
    } else {
      character()
    }
    spell_stats <- if (chosen_class() %in% spellcasting_classes) {
      stats <- spellcasting_stats(chosen_class(), scores)
      c(
        paste0("Spellcasting ability: ", stats$ability,
          " (", signed(stats$modifier), ")"),
        paste0("Spell attack: ", signed(stats$attack)),
        paste0("Spell save DC: ", stats$save_dc)
      )
    } else {
      character()
    }
    tagList(
      div(class = "overview-name", details$character_name),
      p(class = "overview-subtitle", paste(
        chosen_species(), chosen_subrace(), chosen_class(), "Level 1",
        sep = " · "
      )),
      div(class = "sheet-grid",
        section("Alignment", details$alignment),
        section("Background", format_background(chosen_background())),
        section("Ability Scores & Modifiers", lapply(seq_along(ability_scores), function(i) {
          ability <- names(ability_scores)[[i]]
          id <- unname(ability_scores[[i]])
          paste0(ability, " ", scores[[id]], " (", signed(ability_modifier(scores[[id]])), ")")
        })),
        section("Combat Stats", c(
          paste0("Armour Class: ", armour_class(chosen_class(), scores,
            gear$armour, gear$shield)),
          paste0("Hit Points: ", gear$current_hp, "/", max_hp),
          if (gear$temporary_hp > 0) paste0("Temporary HP: ", gear$temporary_hp),
          paste0("Initiative: ", signed(ability_modifier(scores[["dexterity"]]))),
          paste0("Size: ", race_size(chosen_species(), chosen_subrace())),
          paste0("Speed: ", race_walking_speed(chosen_species(), chosen_subrace()), " ft."),
          paste0("Proficiency Bonus: +", proficiency_bonus()),
          paste0("Passive Perception: ", 10L + skill_bonus("Perception", scores,
            chosen_class(), chosen_background(), chosen_skills(),
            chosen_expertise(), chosen_species(), chosen_species_skill())),
          paste0("Death Saves: ", gear$death_successes, " successes · ",
            gear$death_failures, " failures")
        )),
        section("Saving Throws", saving_lines),
        section("Skills", skill_lines),
        section("Weapon Attacks", unlist(attacks), full_width = TRUE),
        section("Armour & Training", c(
          paste("Worn:", gear$armour),
          if (armour_category == "None" ||
              armour_category %in% armour_training) {
            paste("Class training:", if (armour_category == "None") {
              "not applicable"
            } else {
              paste("proficient with", tolower(armour_category), "armour")
            })
          } else {
            armour_warning
          },
          if (gear$shield) "Shield equipped (+2 AC)",
          if (gear$shield && "Shield" %in% armour_training) {
            "Proficient with shields."
          },
          shield_warning
        )),
        section("Class Features", class_rules[[chosen_class()]]$features),
        section("Race Traits", race_trait_summary(chosen_species(),
          chosen_subrace(), chosen_race_choices())),
        section("Background Benefits", c(
          paste0("Skills: ", paste(background_rules[[chosen_background()]]$skills,
            collapse = ", ")),
          if (length(chosen_species_skill())) {
            paste0("Racial skill proficiency: ", chosen_species_skill())
          },
          paste0("Tool proficiencies: ",
            background_tool_summary(chosen_background(), chosen_background_choices())),
          paste0("Languages: ", if (length(chosen_background_choices()$languages)) {
            paste(chosen_background_choices()$languages, collapse = ", ")
          } else {
            background_rules[[chosen_background()]]$languages
          }),
          paste0("Background feature: ", background_rules[[chosen_background()]]$feature)
        )),
        section("Background Equipment",
          background_rules[[chosen_background()]]$equipment,
          full_width = TRUE),
        section("Spellcasting", c(
          spell_stats,
          if (class_rules[[chosen_class()]]$slots == 0L) "Spell slots: None"
          else if (identical(chosen_class(), "Warlock")) {
            paste0("Pact Magic slots: ", gear$spell_slots_remaining, "/",
              class_rules[[chosen_class()]]$slots)
          } else {
            paste0("First-level spell slots: ", gear$spell_slots_remaining, "/",
              class_rules[[chosen_class()]]$slots)
          }
        )),
        section("Cantrips", if (length(chosen_cantrips())) {
          vapply(chosen_cantrips(), spell_text, character(1))
        } else {
          "None"
        }, full_width = TRUE),
        section(if (!chosen_class() %in% spellcasting_classes) {
          "Spells"
        } else if (identical(chosen_class(), "Wizard")) {
          "Spellbook"
        } else if (chosen_class() %in% c("Bard", "Sorcerer", "Warlock")) {
          "Known Spells"
        } else {
          "Prepared Spells"
        },
          if (length(chosen_spells())) {
            vapply(chosen_spells(), spell_text, character(1))
          } else {
            "None"
          }, full_width = TRUE),
        section("Campaign Pack", c(chosen_equipment(),
          unname(equipment_options[[chosen_equipment()]]))),
        section("Inventory", gear$inventory, full_width = TRUE),
        section("Currency", paste(gear$cp, "CP ·", gear$sp, "SP ·",
          gear$ep, "EP ·", gear$gp, "GP ·", gear$pp, "PP")),
        section("Character Details", c(
          identity_lines[nzchar(identity_lines)]
        ), full_width = TRUE)
      )
    )
  })

  output$download_ui <- renderUI({
    if (character_is_valid()) {
      tagList(
        tags$button(
          type = "button",
          class = "btn btn-primary",
          onclick = "window.print()",
          "Save PDF to your device"
        ),
        downloadButton("download_sheet", "Download character sheet"),
        downloadButton("download_save", "Save character for later")
      )
    }
  })

  output$download_save <- downloadHandler(
    filename = function() {
      name <- gsub("[^A-Za-z0-9_-]+", "-", trimws(current_detail("character_name")))
      paste0(name, "-blackwood-character.json")
    },
    content = function(file) {
      validate(need(character_is_valid(), "Enter a name and spend no more than 27 points."))
      details <- collect_details()
      payload <- character_payload(
        chosen_species(),
        chosen_class(),
        chosen_background(),
        chosen_scores(),
        chosen_ability_increases(),
        details,
        chosen_skills(),
        chosen_expertise(),
        chosen_species_skill(),
        chosen_cantrips(),
        chosen_spells(),
        chosen_prepared_spells(),
        chosen_equipment(),
        current_gear(),
        chosen_subrace(),
        chosen_race_choices(),
        chosen_background_choices()
      )
      jsonlite::write_json(payload, file, auto_unbox = TRUE, pretty = TRUE)
    }
  )

  output$download_sheet <- downloadHandler(
    filename = function() {
      name <- gsub("[^A-Za-z0-9_-]+", "-", trimws(current_detail("character_name")))
      paste0(name, "-character.txt")
    },
    content = function(file) {
      validate(need(character_is_valid(), "Enter a name and spend no more than 27 points."))
      details <- collect_details()
      lines <- character_sheet_lines(
        chosen_species(), chosen_class(), chosen_background(), chosen_scores(),
        chosen_ability_increases(), details, chosen_skills(), chosen_expertise(),
        chosen_species_skill(), chosen_cantrips(),
        chosen_spells(), chosen_prepared_spells(), chosen_equipment(), current_gear(),
        chosen_subrace(), chosen_race_choices(), chosen_background_choices()
      )
      writeLines(lines, file, useBytes = TRUE)
    }
  )
}

shinyApp(ui = ui, server = server)
