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

race_descriptions <- c(
  "Human" = "Ambitious and adaptable, humans make their mark in every corner of the world.",
  "Elf" = "Graceful and long-lived, elves carry the memory of ancient forests and lost ages.",
  "Dwarf" = "Stout and steadfast, dwarves are shaped by deep halls, old oaths, and hard-won craft.",
  "Halfling" = "Small, resourceful, and courageous, halflings find comfort and wonder wherever they roam.",
  "Gnome" = "Curious and inventive, gnomes meet the world's mysteries with bright ideas and bigger questions.",
  "Dragonborn" = "Proud descendants of dragons, dragonborn bear a striking presence and a storied legacy.",
  "Orc" = "Resilient and formidable, orcs forge their own place through strength, kinship, and resolve.",
  "Tiefling" = "Marked by an infernal heritage, tieflings navigate a world that often judges by appearances."
)

species_traits <- list(
  Human = "Resourceful: gain Heroic Inspiration after a Long Rest; Skillful: gain one skill proficiency; Versatile: gain one Origin feat.",
  Elf = "Darkvision 60 ft.; Fey Ancestry grants advantage against Charmed; Keen Senses grants Perception proficiency; choose a Drow, High Elf, or Wood Elf lineage.",
  Dwarf = "Darkvision 120 ft.; Dwarven Resilience grants poison resistance and save advantage; Dwarven Toughness adds 1 HP per level; Stonecunning grants tremorsense briefly.",
  Halfling = "Brave grants advantage against Frightened; Halfling Nimbleness lets you move through larger creatures; Luck lets you reroll a 1 on a d20 Test; Naturally Stealthy helps you hide.",
  Gnome = "Darkvision 60 ft.; Gnomish Cunning grants advantage on Intelligence, Wisdom, and Charisma saves; choose Forest or Rock Gnome lineage.",
  Dragonborn = "Choose a Draconic Ancestry to determine damage resistance and Breath Weapon damage; Darkvision 60 ft.; gain limited Flight at level 5.",
  Orc = "Adrenaline Rush lets you Dash and gain temporary HP; Darkvision 120 ft.; Relentless Endurance can keep you standing once per Long Rest.",
  Tiefling = "Darkvision 60 ft.; choose Abyssal, Chthonic, or Infernal Legacy, which grants resistance and lineage magic."
)

class_descriptions <- c(
  "Barbarian" = "A fierce warrior who draws on raw strength and battle rage.",
  "Bard" = "A spellweaver and performer whose words and music shape the world.",
  "Cleric" = "A champion of divine power, devoted to a sacred calling.",
  "Druid" = "A guardian of the wild who channels the magic of nature.",
  "Fighter" = "A disciplined master of weapons, tactics, and the art of battle.",
  "Monk" = "A swift martial artist who hones body and spirit into one.",
  "Paladin" = "A sworn protector whose oath fuels courage and magic.",
  "Ranger" = "A skilled wanderer and hunter at home on the edges of civilization.",
  "Rogue" = "A resourceful expert in stealth, precision, and cunning.",
  "Sorcerer" = "A natural spellcaster whose magic comes from within.",
  "Warlock" = "A wielder of strange magic granted through a powerful pact.",
  "Wizard" = "A learned mage who masters magic through study and practice."
)

class_rules <- list(
  Barbarian = list(saves = c("Strength", "Constitution"), hit_die = 12L, slots = 0L,
    features = c("Rage", "Unarmored Defense", "Weapon Mastery")),
  Bard = list(saves = c("Dexterity", "Charisma"), hit_die = 8L, slots = 2L,
    features = c("Bardic Inspiration", "Spellcasting")),
  Cleric = list(saves = c("Wisdom", "Charisma"), hit_die = 8L, slots = 2L,
    features = c("Spellcasting", "Divine Order")),
  Druid = list(saves = c("Intelligence", "Wisdom"), hit_die = 8L, slots = 2L,
    features = c("Spellcasting", "Druidic", "Primal Order")),
  Fighter = list(saves = c("Strength", "Constitution"), hit_die = 10L, slots = 0L,
    features = c("Fighting Style", "Second Wind", "Weapon Mastery")),
  Monk = list(saves = c("Strength", "Dexterity"), hit_die = 8L, slots = 0L,
    features = c("Martial Arts", "Unarmored Defense", "Weapon Mastery")),
  Paladin = list(saves = c("Wisdom", "Charisma"), hit_die = 10L, slots = 2L,
    features = c("Lay on Hands", "Spellcasting", "Weapon Mastery")),
  Ranger = list(saves = c("Strength", "Dexterity"), hit_die = 10L, slots = 2L,
    features = c("Favored Enemy", "Spellcasting", "Weapon Mastery")),
  Rogue = list(saves = c("Dexterity", "Intelligence"), hit_die = 8L, slots = 0L,
    features = c("Expertise", "Sneak Attack", "Thieves' Cant", "Weapon Mastery")),
  Sorcerer = list(saves = c("Constitution", "Charisma"), hit_die = 6L, slots = 2L,
    features = c("Spellcasting", "Innate Sorcery")),
  Warlock = list(saves = c("Wisdom", "Charisma"), hit_die = 8L, slots = 1L,
    features = c("Eldritch Invocations", "Pact Magic")),
  Wizard = list(saves = c("Intelligence", "Wisdom"), hit_die = 6L, slots = 2L,
    features = c("Spellcasting", "Ritual Adept", "Arcane Recovery"))
)

background_descriptions <- c(
  "Acolyte" = "You served a temple and learned its rites, traditions, and sacred duties.",
  "Artisan" = "You trained in a craft and know the discipline of making useful things.",
  "Charlatan" = "You learned to read people and survive through quick talk and misdirection.",
  "Criminal" = "You built a life outside the law, relying on stealth and underworld contacts.",
  "Entertainer" = "You earned a living by captivating crowds with a practiced performance.",
  "Farmer" = "You worked the land, endured hard seasons, and learned to care for animals.",
  "Guard" = "You kept watch over a settlement and learned to recognize danger.",
  "Guide" = "You led travelers through wild places and learned to move unseen.",
  "Hermit" = "You lived apart from society, tending to simple needs and quiet study.",
  "Merchant" = "You traded goods, judged a bargain, and learned the value of a good route.",
  "Noble" = "You were raised among privilege, family histories, and social expectations.",
  "Sage" = "You devoted years to books, research, and the pursuit of knowledge.",
  "Sailor" = "You worked aboard a vessel and learned to trust your balance and crew.",
  "Scribe" = "You copied, organized, or preserved written records and correspondence.",
  "Soldier" = "You trained for battle and served as part of a military force.",
  "Wayfarer" = "You traveled from place to place, relying on your instincts and adaptability."
)

background_rules <- list(
  Acolyte = list(abilities = c("Intelligence", "Wisdom", "Charisma"),
    skills = c("Insight", "Religion"), tool = "Calligrapher's Supplies",
    feat = "Magic Initiate (Cleric)", equipment = "Calligrapher's Supplies, a book of prayers, and 8 GP."),
  Artisan = list(abilities = c("Strength", "Dexterity", "Intelligence"),
    skills = c("Investigation", "Persuasion"), tool = "One Artisan's Tool of your choice",
    feat = "Crafter", equipment = "Artisan's Tools of your choice and 32 GP."),
  Charlatan = list(abilities = c("Dexterity", "Constitution", "Charisma"),
    skills = c("Deception", "Sleight of Hand"), tool = "Forgery Kit",
    feat = "Skilled", equipment = "Forgery Kit, fine clothes, and 15 GP."),
  Criminal = list(abilities = c("Dexterity", "Constitution", "Intelligence"),
    skills = c("Sleight of Hand", "Stealth"), tool = "Thieves' Tools",
    feat = "Alert", equipment = "Thieves' Tools, 2 Daggers, and 16 GP."),
  Entertainer = list(abilities = c("Strength", "Dexterity", "Charisma"),
    skills = c("Acrobatics", "Performance"), tool = "One Musical Instrument of your choice",
    feat = "Musician", equipment = "Musical Instrument of your choice, 2 Costumes, and 11 GP."),
  Farmer = list(abilities = c("Strength", "Constitution", "Wisdom"),
    skills = c("Animal Handling", "Nature"), tool = "Carpenter's Tools",
    feat = "Tough", equipment = "Carpenter's Tools, a shovel, an iron pot, and 30 GP."),
  Guard = list(abilities = c("Strength", "Intelligence", "Wisdom"),
    skills = c("Athletics", "Perception"), tool = "Gaming Set",
    feat = "Alert", equipment = "Spear, a Gaming Set, uniform, and 12 GP."),
  Guide = list(abilities = c("Dexterity", "Constitution", "Wisdom"),
    skills = c("Stealth", "Survival"), tool = "Cartographer's Tools",
    feat = "Magic Initiate (Druid)", equipment = "Cartographer's Tools, bedroll, and 3 GP."),
  Hermit = list(abilities = c("Constitution", "Wisdom", "Charisma"),
    skills = c("Medicine", "Religion"), tool = "Herbalism Kit",
    feat = "Healer", equipment = "Herbalism Kit, a book, and 16 GP."),
  Merchant = list(abilities = c("Constitution", "Intelligence", "Charisma"),
    skills = c("Animal Handling", "Persuasion"), tool = "Navigator's Tools",
    feat = "Lucky", equipment = "Navigator's Tools, 2 Pouches, and 22 GP."),
  Noble = list(abilities = c("Strength", "Intelligence", "Charisma"),
    skills = c("History", "Persuasion"), tool = "Gaming Set",
    feat = "Skilled", equipment = "Fine Clothes, a Gaming Set, perfume, and 29 GP."),
  Sage = list(abilities = c("Constitution", "Intelligence", "Wisdom"),
    skills = c("Arcana", "History"), tool = "Calligrapher's Supplies",
    feat = "Magic Initiate (Wizard)", equipment = "Calligrapher's Supplies, a book, and 8 GP."),
  Sailor = list(abilities = c("Strength", "Dexterity", "Wisdom"),
    skills = c("Acrobatics", "Perception"), tool = "Navigator's Tools",
    feat = "Tavern Brawler", equipment = "Navigator's Tools, rope, and 20 GP."),
  Scribe = list(abilities = c("Dexterity", "Intelligence", "Wisdom"),
    skills = c("Investigation", "Perception"), tool = "Calligrapher's Supplies",
    feat = "Skilled", equipment = "Calligrapher's Supplies, a book, and 23 GP."),
  Soldier = list(abilities = c("Strength", "Dexterity", "Constitution"),
    skills = c("Athletics", "Intimidation"), tool = "Gaming Set",
    feat = "Savage Attacker", equipment = "Gaming Set, Healer's Kit, uniform, and 14 GP."),
  Wayfarer = list(abilities = c("Dexterity", "Wisdom", "Charisma"),
    skills = c("Insight", "Stealth"), tool = "Thieves' Tools",
    feat = "Lucky", equipment = "Thieves' Tools, 2 Pouches, and 16 GP.")
)

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
  "Acrobatics" = "Keep your balance, tumble, or perform agile physical maneuvers.",
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
  "Vicious Mockery" = "Wisdom save (DC {dc}); 1d6 psychic damage on a failure, and the target has disadvantage on its next attack roll.",
  "Guidance" = "No attack roll. Touch a creature; it adds 1d4 to one ability check before the spell ends (concentration, up to 1 minute).",
  "Sacred Flame" = "Dexterity save (DC {dc}); 1d8 radiant damage on a failure. Range 60 ft.",
  "Spare the Dying" = "No roll. Touch a creature with 0 HP to stabilize it.",
  "Thaumaturgy" = "No roll. Range 30 ft.; create a brief supernatural sign or sensory effect.",
  "Druidcraft" = "No roll. Range 30 ft.; create a minor nature effect or predict local weather.",
  "Produce Flame" = "Ranged spell attack ({attack}); 1d8 fire damage on a hit. Range 30 ft.; the flame can also provide light.",
  "Shillelagh" = "No separate attack roll. For 1 minute, use your spellcasting ability for attacks with the enchanted club or quarterstaff; its damage die becomes a d8.",
  "Thorn Whip" = "Melee spell attack ({attack}); 1d6 piercing damage on a hit, and pull a Large or smaller target up to 10 ft. Range 30 ft.",
  "Fire Bolt" = "Ranged spell attack ({attack}); 1d10 fire damage on a hit. Range 120 ft.",
  "Ray of Frost" = "Ranged spell attack ({attack}); 1d8 cold damage on a hit and reduce the target's Speed by 10 ft. Range 60 ft.",
  "Shocking Grasp" = "Melee spell attack ({attack}); 1d8 lightning damage on a hit. The target cannot take reactions until its next turn.",
  "Chill Touch" = "Melee spell attack ({attack}); 1d10 Necrotic damage on a hit, and the target cannot regain HP until the end of your next turn. Touch range.",
  "Eldritch Blast" = "Ranged spell attack ({attack}); 1d10 force damage on a hit. Range 120 ft.",
  "True Strike" = "Make a weapon attack using your spellcasting ability for the attack and damage rolls. On a hit, choose the weapon's normal damage type or Radiant; no extra damage die at level 1.",
  "Charm Person" = "Wisdom save (DC {dc}); on a failure, a Humanoid is Friendly and Charmed for up to 1 hour. The effect ends early if you or your allies damage it; it has advantage on the save if you are fighting it.",
  "Dissonant Whispers" = "Wisdom save (DC {dc}); 3d6 psychic damage on a failure, and the target uses its Reaction to move away. Half damage on a success.",
  "Faerie Fire" = "Dexterity save (DC {dc}); creatures in a 20-ft. cube are outlined, granting advantage on attacks against them (concentration, up to 1 minute).",
  "Healing Word" = "No roll. Range 60 ft.; a creature regains 2d4 {modifier} HP.",
  "Sleep" = "Wisdom save (DC {dc}); on a failure, a creature in the 5-ft. Sphere becomes Unconscious for up to 1 minute. It repeats the save at the end of each turn; damage or being shaken awake also ends the effect.",
  "Thunderwave" = "Constitution save (DC {dc}); 2d8 thunder damage and push 10 ft. on a failure; half damage on a success. 15-ft. cube.",
  "Bless" = "No roll. Up to 3 creatures add 1d4 to attack rolls and saving throws (concentration, up to 1 minute).",
  "Command" = "Wisdom save (DC {dc}); on a failure, a creature follows a one-word command on its next turn.",
  "Cure Wounds" = "No roll. Touch a creature; it regains 2d8 {modifier} HP.",
  "Guiding Bolt" = "Ranged spell attack ({attack}); 4d6 radiant damage on a hit. The next attack against the target has advantage. Range 120 ft.",
  "Sanctuary" = "Wisdom save (DC {dc}) required for a creature to target the warded creature with an attack or harmful spell. No concentration; up to 1 minute.",
  "Shield of Faith" = "No roll. A creature gains +2 AC (concentration, up to 10 minutes).",
  "Animal Friendship" = "Wisdom save (DC {dc}); on a failure, a Beast is Charmed for 24 hours. Range 30 ft.",
  "Entangle" = "Strength save (DC {dc}) or become Restrained by plants; the area is difficult terrain (concentration, up to 1 minute).",
  "Goodberry" = "No roll. Create 10 berries; each restores 1 HP and provides nourishment. They lose potency after 24 hours.",
  "Divine Favor" = "No roll. For up to 1 minute (concentration), your weapon hits deal an extra 1d4 Radiant damage.",
  "Heroism" = "No roll. A creature is immune to Frightened and gains temporary HP equal to your spellcasting modifier at the start of each turn (concentration, up to 1 minute).",
  "Searing Smite" = "After a melee hit, deal an extra 1d6 Fire damage. The target then makes a Constitution save (DC {dc}) at the end of each turn; on a failure, it takes 1d6 Fire damage, and on a success the burning ends (concentration, up to 1 minute).",
  "Ensnaring Strike" = "After you hit with a weapon, the target makes a Strength save (DC {dc}) or becomes Restrained by vines; it can repeat the save to escape (concentration, up to 1 minute).",
  "Fog Cloud" = "No roll. Create a heavily obscured 20-ft. Sphere (concentration, up to 1 hour).",
  "Hunter's Mark" = "No roll. Mark a creature; your weapon hits against it deal an extra 1d6 Force damage, and you have advantage on checks to find it (concentration, up to 1 hour).",
  "Longstrider" = "No roll. A creature's Speed increases by 10 ft. for 1 hour.",
  "Speak with Animals" = "No roll. Understand and communicate with Beasts for 10 minutes.",
  "Burning Hands" = "Dexterity save (DC {dc}); 3d6 Fire damage in a 15-ft. Cone on a failure, half on a success.",
  "Chromatic Orb" = "Ranged spell attack ({attack}); 3d8 damage of a chosen type on a hit. Range 90 ft.",
  "Mage Armor" = "No roll. A willing creature's base AC becomes 13 + its Dexterity modifier for 8 hours.",
  "Magic Missile" = "No attack roll or save; three darts automatically hit for 1d4 + 1 Force damage each. Range 120 ft.",
  "Shield" = "Reaction, no roll. Gain +5 AC until the start of your next turn, including against the triggering attack; Magic Missile deals no damage to you.",
  "Armor of Agathys" = "No roll. Gain 5 temporary HP; while any remain, a creature that hits you with a melee attack takes 5 Cold damage. Lasts 1 hour.",
  "Arms of Hadar" = "Strength save (DC {dc}); 2d6 Necrotic damage on a failure and the target cannot take reactions until its next turn. 10-ft. Emanation.",
  "Hex" = "No roll. Your hits deal an extra 1d6 Necrotic damage to the cursed target, which has disadvantage on checks with one chosen ability (concentration, up to 1 hour).",
  "Protection from Evil and Good" = "No roll. One creature is warded against Aberrations, Celestials, Elementals, Fey, Fiends, and Undead (concentration, up to 10 minutes).",
  "Witch Bolt" = "Ranged spell attack ({attack}); 1d12 Lightning damage on a hit. Range 60 ft.; the link can deal 1d12 more damage on later turns while maintained.",
  "Detect Magic" = "No roll. Sense magic within 30 ft. and, with an action, see an aura around it (concentration, up to 10 minutes).",
  "Find Familiar" = "No attack roll. Summon a spirit in an animal form to serve as a familiar; it acts independently and shares a telepathic link with you."
)

spellcasting_classes <- names(spell_choices)
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
  "Rookhaven Guard Kit" = "A sturdy traveling coat, shield, whetstone, waterskin, trail rations, and a simple field-repair kit.",
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

default_ability_increases <- function(background, scores) {
  eligible <- background_rules[[background]]$abilities
  ordered <- eligible[order(scores[ability_scores[eligible]], decreasing = TRUE)]
  setNames(c(2L, 1L), ordered[1:2])
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

level_one_hit_points <- function(class, scores, species) {
  class_rules[[class]]$hit_die +
    floor((scores[["constitution"]] - 10) / 2) +
    if (identical(species, "Dwarf")) 1L else 0L
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
    Paladin = list(cantrips = 0L, spells = max(1L, ability_modifier("charisma")),
      spell_label = "prepared spells"),
    Ranger = list(cantrips = 0L, spells = max(1L, ability_modifier("wisdom")),
      spell_label = "prepared spells"),
    Sorcerer = list(cantrips = 4L, spells = 2L, spell_label = "known spells"),
    Warlock = list(cantrips = 2L, spells = 2L, spell_label = "known spells"),
    Wizard = list(cantrips = 3L, spells = 6L, spell_label = "spellbook spells"),
    list(cantrips = 0L, spells = 0L, spell_label = "spells")
  )
}

character_payload <- function(species, class, background, scores, ability_increases,
                              details, skills, cantrips, spells, equipment) {
  list(
    schema_version = 4,
    species = species,
    class = class,
    background_choice = background,
    ability_scores = as.list(scores),
    ability_increases = as.list(ability_increases),
    details = details,
    skills = as.list(skills),
    cantrips = as.list(cantrips),
    spells = as.list(spells),
    equipment = equipment
  )
}

character_sheet_lines <- function(species, class, background, scores,
                                  ability_increases, details, skills,
                                  cantrips, spells, equipment) {
  final <- apply_ability_increases(scores, ability_increases)
  score_lines <- vapply(seq_along(ability_scores), function(i) {
    id <- unname(ability_scores[[i]])
    paste0(names(ability_scores)[i], ": ", final[[id]])
  }, character(1))
  background_info <- background_rules[[background]]
  class_info <- class_rules[[class]]
  increase_lines <- paste0(names(ability_increases), " +", ability_increases)
  c(
    details$character_name,
    paste(species, class, "Level 1", sep = " | "),
    paste0("Alignment: ", details$alignment),
    paste0("Background: ", background),
    paste0("Origin feat: ", background_info$feat),
    paste0("Background ability increases: ", paste(increase_lines, collapse = ", ")),
    "",
    "Ability scores:",
    score_lines,
    "",
    "Skill proficiencies:",
    paste0("- ", c(background_info$skills, skills)),
    paste0("Tool proficiency: ", background_info$tool),
    paste0("Species traits: ", species_traits[[species]]),
    "",
    "Level 1 class features:",
    paste0("- ", class_info$features),
    paste0("Saving throw proficiencies: ", paste(class_info$saves, collapse = ", ")),
    paste0("Hit points: ", level_one_hit_points(class, final, species)),
    paste0("Level 1 spell slots: ", if (class_info$slots == 0L) {
      "None"
    } else if (identical(class, "Warlock")) {
      "1 Pact Magic slot"
    } else {
      paste(class_info$slots, "1st-level spell slots")
    }),
    paste0("Background equipment: ", background_info$equipment),
    "",
    "Campaign equipment:",
    paste0(equipment, ":"),
    unname(equipment_options[[equipment]]),
    "",
    "Cantrips:",
    if (length(cantrips)) paste0("- ", cantrips) else "None",
    "",
    if (identical(class, "Wizard")) "Spellbook:" else "Level 1 spells:",
    if (length(spells)) paste0("- ", spells) else "None"
  )
}

validate_character_payload <- function(payload) {
  fail <- function(message) stop(message, call. = FALSE)
  is_text <- function(value) is.character(value) && length(value) == 1 && !is.na(value)

  if (!is.list(payload) || !is.numeric(payload$schema_version) ||
      length(payload$schema_version) != 1L ||
      is.na(payload$schema_version) ||
      !payload$schema_version %in% c(1, 2, 3, 4)) {
    fail("This is not a supported character save file.")
  }
  version <- as.integer(payload$schema_version)
  if (!is_text(payload$species) || !payload$species %in% names(race_descriptions)) {
    fail("The save file contains an unknown ancestry.")
  }
  if (!is_text(payload$class) || !payload$class %in% names(class_descriptions)) {
    fail("The save file contains an unknown class.")
  }
  background <- payload$background_choice
  if (version <= 3L) {
    legacy_backgrounds <- c(
      "Rookhaven Local" = "Guard", "Blackwood Scout" = "Guide",
      "Caravan Guard" = "Soldier", "Village Healer" = "Hermit",
      "Wandering Scholar" = "Sage", "Disgraced Veteran" = "Soldier",
      "Temple Acolyte" = "Acolyte", "Hedge Mage" = "Sage",
      "Bounty Hunter" = "Criminal", "Runaway Apprentice" = "Scribe",
      "Far-Traveled Sailor" = "Sailor", "Heir to a Fallen House" = "Noble"
    )
    old_origin <- payload$backstory_choice
    background <- if (is_text(old_origin) && old_origin %in% names(legacy_backgrounds)) {
      unname(legacy_backgrounds[[old_origin]])
    } else {
      "Wayfarer"
    }
  }
  if (!is_text(background) || !background %in% names(background_rules)) {
    fail("The save file contains an unknown background.")
  }
  if (!is.list(payload$ability_scores) ||
      !all(unname(ability_scores) %in% names(payload$ability_scores))) {
    fail("The save file is missing ability scores.")
  }
  scores <- vapply(unname(ability_scores), function(id) {
    score <- payload$ability_scores[[id]]
    if (!is.numeric(score) || length(score) != 1 || is.na(score) ||
        score != as.integer(score) || score < 8 || score > 15) {
      fail(paste("The saved", id, "score must be a whole number from 8 to 15."))
    }
    as.integer(score)
  }, integer(1))
  names(scores) <- unname(ability_scores)
  points <- sum(score_costs[as.character(scores)])
  if (points > 27) fail("The saved ability scores exceed the 27-point budget.")

  ability_increases <- payload$ability_increases
  if (version <= 3L || is.null(ability_increases)) {
    ability_increases <- default_ability_increases(background, scores)
  } else {
    ability_increases <- unlist(ability_increases, use.names = TRUE)
    if (!is.numeric(ability_increases) || anyNA(ability_increases) ||
        any(!names(ability_increases) %in% background_rules[[background]]$abilities) ||
        anyDuplicated(names(ability_increases)) ||
        !((length(ability_increases) == 2L &&
          identical(sort(as.integer(ability_increases)), c(1L, 2L))) ||
          (length(ability_increases) == 3L && all(ability_increases == 1L)))) {
      fail("The saved background ability increases are invalid.")
    }
    ability_increases <- as.integer(ability_increases)
    names(ability_increases) <- names(unlist(payload$ability_increases, use.names = TRUE))
  }
  final_scores <- apply_ability_increases(scores, ability_increases)
  if (any(final_scores > 20L)) fail("The saved ability increases exceed the maximum score.")

  if (!is.list(payload$details)) fail("The save file is missing character details.")
  details <- payload$details
  text_fields <- c("character_name", "alignment")
  for (field_name in text_fields) {
    value <- details[[field_name]]
    if (!is_text(value)) fail(paste("The saved", field_name, "must be text."))
  }
  if (!nzchar(trimws(details$character_name))) {
    fail("The save file must include a character name.")
  }
  if (!details$alignment %in% valid_alignments) {
    fail("The save file contains an unknown alignment.")
  }
  details <- list(
    character_name = details$character_name,
    alignment = details$alignment
  )

  skills <- unlist(payload$skills, use.names = FALSE)
  if (version <= 3L) {
    valid_old_skills <- skills[skills %in% skill_choices[[payload$class]]]
    skills <- unique(setdiff(valid_old_skills, background_rules[[background]]$skills))
    skills <- c(skills, setdiff(skill_choices[[payload$class]],
      c(background_rules[[background]]$skills, skills)))
    skills <- head(skills, skill_counts[[payload$class]])
  }
  if (length(skills) != skill_counts[[payload$class]] ||
      anyNA(skills) || anyDuplicated(skills) ||
      any(!skills %in% setdiff(skill_choices[[payload$class]], background_rules[[background]]$skills))) {
    fail("The save file contains invalid class skill selections.")
  }

  cantrips <- unlist(payload$cantrips, use.names = FALSE)
  spells <- unlist(payload$spells, use.names = FALSE)
  if (version <= 3L) {
    limits <- spell_selection_limits(payload$class, final_scores)
    cantrips <- head(spell_cantrips[[payload$class]], limits$cantrips)
    spells <- head(spell_choices[[payload$class]], limits$spells)
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

  list(
    species = payload$species,
    class = payload$class,
    background_choice = background,
    ability_scores = scores,
    ability_increases = ability_increases,
    details = details,
    skills = skills,
    cantrips = cantrips,
    spells = spells,
    equipment = equipment
  )
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
    .stats-page { max-width: 1000px; margin: 0 auto; padding: 48px 0 70px; }
    .stats-intro { color: #d3cec2; line-height: 1.65; text-align: center; margin: 0 auto 25px; max-width: 680px; }
    .stats-panel { max-width: 900px; margin: 0 auto; }
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
    .race-prompt { color: var(--muted); text-align: center; margin: 0 0 16px; }
    .race-options { width: 100%; max-width: 860px; margin: 16px auto 0; }
    .race-options .shiny-input-radiogroup,
    .race-options .shiny-input-container,
    .race-options .shiny-options-group { width: 100%; }
    .race-options .shiny-options-group {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 18px;
    }
    .race-options .radio { margin: 0 !important; }
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
    .spell-options .checkbox label { min-height: 120px; }
    .spell-group-title {
      max-width: 900px;
      margin: 28px auto 18px;
      color: var(--gold-bright);
      font: 20px Georgia, serif;
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
    }
    .party-save-panel { text-align: center; }
    .party-save-panel .form-group { max-width: 420px; margin: 0 auto 15px; }
    .overview-actions { display: flex; justify-content: center; flex-wrap: wrap; gap: 12px; margin-top: 20px; }
    .race-actions { display: flex; justify-content: center; align-items: center; gap: 16px; margin-top: 28px; }
    .race-back { background: transparent; border-color: var(--border); color: var(--muted); }
    .race-back:hover, .race-back:focus { background: #252831; border-color: #656b76; color: var(--text); }
    @media (max-width: 767px) {
      .app-header h1 { font-size: 29px; }
      .crest { width: 62px; height: 62px; }
      .panel-card { padding: 16px; }
      .intro-page { padding-top: 18px; }
      .intro-art { height: 145px; }
      .intro-title { font-size: 34px; }
      .intro-copy { padding: 24px 20px; }
      .race-page { padding-top: 28px; }
      .race-heading { font-size: 34px; }
      .race-options .shiny-options-group { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
      .race-options .radio label { min-height: 0; padding: 16px; }
      .multi-options .shiny-options-group { grid-template-columns: 1fr; gap: 10px; }
      .multi-options .checkbox label { min-height: 0; padding: 14px; }
      .spell-options .checkbox label { min-height: 0; }
      .stats-page { padding-top: 28px; }
      .stats-grid { grid-template-columns: 1fr; gap: 0; }
      .stats-panel { padding: 18px 16px; }
      .details-page, .overview-page { padding-top: 28px; }
      .overview-name { font-size: 32px; }
    }
    @media (max-width: 480px) {
      .race-options .shiny-options-group { grid-template-columns: 1fr; }
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
      p("For generations, the forest has stood as a silent border between civilization and the unknown. Traders travel its roads. Hunters stalk its shadows. Children grow up hearing stories of the things that dwell beneath its ancient canopy."),
      p(em("Most dismiss those stories as superstition."), br(), em("Most are wrong.")),
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
                                selected = NULL, options_class = "race-options") {
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
    uiOutput(error_id),
    div(
      class = "race-actions",
      actionButton(back_id, back_label, class = "btn-default race-back"),
      actionButton(continue_id, "Continue", class = "btn-primary begin-button")
    )
  )
}

race_selection_ui <- function(selected = NULL) {
  choice_selection_ui(
    "The Path Begins....",
    "Who are you?",
    "Choose your ancestry. Each path has a story of its own.",
    "selected_race",
    race_descriptions,
    "race_error",
    "back_to_name",
    "Back to Name",
    "confirm_race",
    selected
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
    "Back to Ancestry",
    "confirm_class",
    selected
  )
}

background_selection_ui <- function(selected = NULL) {
  ui <- choice_selection_ui(
    "A Life Before the Blackwood....",
    "Choose your background",
    "Your background grants ability increases, skills, a tool proficiency, and an Origin feat.",
    "selected_background",
    background_descriptions,
    "background_error",
    "back_to_class",
    "Back to Class",
    "confirm_background",
    selected,
    options_class = "race-options background-options"
  )
}

stats_selection_ui <- function(selected_scores, background, increases) {
  div(
    class = "stats-page",
    h1(class = "race-heading", "The Measure of Your Legend...."),
    h2(class = "race-subheading", "Set your ability scores"),
    p(class = "stats-intro",
      "Shape your strengths with the sliders. Each score costs points from your 27-point budget; scores range from 8 to 15."
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
      h3(class = "spell-group-title", "Background ability increases"),
      p(class = "stats-intro", paste(
        background, "allows increases to",
        paste(background_rules[[background]]$abilities, collapse = ", "),
        ". Choose +2 to one and +1 to another, or +1 to each of three."
      )),
      selectInput(
        "background_bonus_mode",
        "Choose an increase method",
        choices = c("+2 to one and +1 to another" = "two_one",
          "+1 to three different abilities" = "three_one"),
        selected = if (length(increases) == 3L) "three_one" else "two_one"
      ),
      uiOutput("background_boost_inputs"),
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

skills_selection_ui <- function(class, background, selected = character()) {
  count <- skill_counts[[class]]
  background_skills <- background_rules[[background]]$skills
  available_skills <- setdiff(skill_choices[[class]], background_skills)
  div(
    class = "race-page",
    h1(class = "race-heading", "Skills of the Trade...."),
    h2(class = "race-subheading", paste("Choose", count, "class skills")),
    p(class = "race-prompt",
      paste("Choose", count, "skills from the options available to your", class,
        "under the 2024 rules. Your background already grants",
        paste(background_skills, collapse = " and "), ".")
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
    h1(class = "race-heading", "Whispers of Power...."),
    h2(class = "race-subheading", "Choose your starting spells"),
    if (class %in% spellcasting_classes) {
      p(class = "race-prompt",
        "These are curated level-1 suggestions for the 2024 rules. Spell choices depend on class and ability scores; your table can adjust them."
      )
    } else {
      p(class = "race-prompt",
        paste(class, "does not have spellcasting at level 1. Continue to choose your equipment.")
      )
    },
    if (identical(class, "Wizard")) {
      p(class = "race-prompt",
        "Wizard selections are recorded in the spellbook; daily prepared spells are not tracked here."
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
    uiOutput("spells_error"),
    div(
      class = "race-actions",
      actionButton("back_to_skills", "Back to Skills", class = "btn-default race-back"),
      actionButton("confirm_spells", "Continue", class = "btn-primary begin-button")
    )
  )
}

equipment_selection_ui <- function(selected = NULL) {
  choice_selection_ui(
    "Ready for the Road....",
    "Choose your equipment",
    "Select a preset pack for the journey from Rookhaven into the Blackwood.",
    "selected_equipment",
    equipment_options,
    "equipment_error",
    "back_to_spells",
    "Back to Spells",
    "confirm_equipment",
    selected
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
      class = "panel-card party-save-panel",
      h3(class = "section-title", "Email a Copy to Your Party"),
      p("Email a PDF copy of this character sheet to yourself and the DM. This is optional; use Save PDF above to keep a copy on your device."),
      tags$div(
        class = "form-group",
        tags$label(`for` = "player_email", "Your email address"),
        tags$input(
          id = "player_email",
          name = "player_email",
          type = "email",
          class = "form-control shiny-input-text",
          autocomplete = "email",
          placeholder = "you@example.com",
          required = "required"
        )
      ),
      p(class = "text-muted",
        "Your email is used only to send the PDF. Character details are emailed to you and the DM; the app does not save a roster."
      ),
      actionButton("submit_character", "Email PDF to Me & the DM",
        class = "btn-primary begin-button"),
      uiOutput("party_save_setup"),
      uiOutput("party_save_status")
    ),
    div(
      class = "overview-actions",
      actionButton("back_to_equipment", "Back to Equipment", class = "btn-default race-back")
    )
  )
}

server <- function(input, output, session) {
  current_screen <- reactiveVal("intro")
  chosen_species <- reactiveVal(NULL)
  chosen_class <- reactiveVal(NULL)
  chosen_background <- reactiveVal(NULL)
  chosen_scores <- reactiveVal(default_scores)
  chosen_ability_increases <- reactiveVal(NULL)
  chosen_skills <- reactiveVal(character())
  chosen_cantrips <- reactiveVal(character())
  chosen_spells <- reactiveVal(character())
  chosen_equipment <- reactiveVal(names(equipment_options)[[1]])
  saved_details <- reactiveVal(list())
  load_message <- reactiveVal(NULL)
  party_save_status <- reactiveVal(NULL)
  party_save_pending <- reactiveVal(FALSE)
  party_submission_id <- reactiveVal(NULL)
  save_endpoint <- trimws(Sys.getenv("CHARACTER_SAVE_ENDPOINT"))
  save_token <- Sys.getenv("CHARACTER_SAVE_TOKEN")

  current_detail <- function(name, default = "") {
    value_or(input[[name]], detail_value(saved_details(), name, default))
  }

  collect_details <- function() {
    list(
      character_name = current_detail("character_name"),
      alignment = current_detail("alignment", "Unspecified")
    )
  }

  output$app_screen <- renderUI({
    switch(
      current_screen(),
      intro = introduction_ui(),
      load = load_character_ui(),
      race = race_selection_ui(chosen_species()),
      class = class_selection_ui(chosen_class()),
      background = background_selection_ui(chosen_background()),
      stats = stats_selection_ui(chosen_scores(), chosen_background(),
        value_or(chosen_ability_increases(),
          default_ability_increases(chosen_background(), chosen_scores()))),
      name = character_name_ui(saved_details()),
      alignment = alignment_selection_ui(detail_value(saved_details(), "alignment", "Unspecified")),
      skills = skills_selection_ui(chosen_class(), chosen_background(), chosen_skills()),
      spells = spell_selection_ui(
        chosen_class(), chosen_cantrips(), chosen_spells(),
        spell_selection_limits(chosen_class(), final_scores()),
        final_scores()
      ),
      equipment = equipment_selection_ui(chosen_equipment()),
      summary = character_overview_ui()
    )
  })

  output$load_character_status <- renderUI({
    message <- load_message()
    if (is.null(message)) return(NULL)
    class <- if (startsWith(message, "Character loaded.")) "text-success" else "text-warning"
    div(class = class, message)
  })

  output$party_save_setup <- renderUI({
    if (nzchar(save_endpoint) && nzchar(save_token)) return(NULL)
    div(class = "text-warning",
      "PDF email isn't connected yet. The DM must configure the email service endpoint."
    )
  })

  output$party_save_status <- renderUI({
    status <- party_save_status()
    if (is.null(status)) return(NULL)
    div(class = if (isTRUE(status$ok)) "text-success" else "text-danger",
      status$message)
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
      chosen_class(character$class)
      chosen_background(character$background_choice)
      chosen_scores(character$ability_scores)
      chosen_ability_increases(character$ability_increases)
      chosen_skills(character$skills)
      chosen_cantrips(character$cantrips)
      chosen_spells(character$spells)
      chosen_equipment(character$equipment)
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
        !is.null(input$confirm_race) && input$confirm_race > 0 &&
        (is.null(input$selected_race) || !nzchar(input$selected_race))) {
      div(class = "text-warning text-center", "Choose an ancestry before continuing.")
    }
  })

  observeEvent(input$confirm_race, {
    if (is.null(input$selected_race) || !nzchar(input$selected_race)) return()
    chosen_species(input$selected_race)
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
      chosen_skills(character())
      chosen_cantrips(character())
      chosen_spells(character())
    }
    chosen_class(input$selected_class)
    current_screen("background")
  })

  observeEvent(input$back_to_class, {
    current_screen("class")
  })

  output$background_error <- renderUI({
    if (current_screen() == "background" &&
        !is.null(input$confirm_background) && input$confirm_background > 0 &&
        (is.null(input$selected_background) ||
          !input$selected_background %in% names(background_rules))) {
      div(class = "text-warning text-center", "Choose a background before continuing.")
    }
  })

  observeEvent(input$confirm_background, {
    if (is.null(input$selected_background) ||
        !input$selected_background %in% names(background_rules)) return()
    chosen_background(input$selected_background)
    chosen_ability_increases(default_ability_increases(
      input$selected_background, chosen_scores()
    ))
    chosen_skills(character())
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

  collect_ability_increases <- function() {
    allowed <- background_rules[[chosen_background()]]$abilities
    mode <- value_or(input$background_bonus_mode,
      if (length(chosen_ability_increases()) == 3L) "three_one" else "two_one")
    if (identical(mode, "two_one")) {
      scores <- c(input$background_boost_two, input$background_boost_one)
      if (anyNA(scores) || any(!scores %in% allowed) || anyDuplicated(scores)) return(NULL)
      return(setNames(c(2L, 1L), scores))
    }
    if (identical(mode, "three_one")) {
      scores <- c(input$background_boost_three_1, input$background_boost_three_2,
        input$background_boost_three_3)
      if (anyNA(scores) || any(!scores %in% allowed) || anyDuplicated(scores)) return(NULL)
      return(setNames(rep(1L, 3L), scores))
    }
    NULL
  }

  final_scores <- reactive({
    increases <- chosen_ability_increases()
    if (is.null(increases)) return(chosen_scores())
    apply_ability_increases(chosen_scores(), increases)
  })

  points_spent <- reactive({
    scores <- score_values()
    if (anyNA(scores)) return(NA_integer_)
    sum(score_costs[as.character(scores)])
  })

  output$background_boost_inputs <- renderUI({
    allowed <- background_rules[[chosen_background()]]$abilities
    choices <- setNames(allowed, allowed)
    increases <- value_or(chosen_ability_increases(),
      default_ability_increases(chosen_background(), chosen_scores()))
    mode <- value_or(input$background_bonus_mode,
      if (length(increases) == 3L) "three_one" else "two_one")
    if (identical(mode, "two_one")) {
      selected_two <- names(increases)[which(increases == 2L)]
      selected_one <- names(increases)[which(increases == 1L)]
      return(tagList(
        selectInput("background_boost_two", "Increase by +2", choices,
          selected = if (length(selected_two)) selected_two[[1]] else character()),
        selectInput("background_boost_one", "Increase by +1", choices,
          selected = if (length(selected_one)) selected_one[[1]] else character())
      ))
    }
    selected <- names(increases)
    tagList(lapply(seq_len(3L), function(i) {
      selectInput(
        paste0("background_boost_three_", i),
        paste("Increase by +1 (ability", i, ")"),
        choices,
        selected = if (length(selected) >= i) selected[[i]] else character()
      )
    }))
  })

  output$final_score_preview <- renderUI({
    scores <- score_values()
    increases <- collect_ability_increases()
    if (is.null(increases)) increases <- chosen_ability_increases()
    if (is.null(increases)) return(NULL)
    final <- apply_ability_increases(scores, increases)
    div(
      class = "points-total text-center",
      paste("Scores after background increases:",
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
      if (is.null(collect_ability_increases())) {
        return(div(class = "text-warning text-center",
          "Choose distinct abilities for your background increases."
        ))
      }
    }
  })

  observeEvent(input$confirm_stats, {
    points <- points_spent()
    increases <- collect_ability_increases()
    if (is.na(points) || points > 27 || is.null(increases)) return()
    chosen_scores(score_values())
    chosen_ability_increases(increases)
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
    available_skills <- setdiff(skill_choices[[chosen_class()]],
      background_rules[[chosen_background()]]$skills)
    if (current_screen() == "skills" &&
        !is.null(input$confirm_skills) && input$confirm_skills > 0 &&
        (length(input$selected_skills) != skill_counts[[chosen_class()]] ||
          any(!input$selected_skills %in% available_skills))) {
      div(class = "text-warning text-center",
        paste("Choose exactly", skill_counts[[chosen_class()]], "class skills.")
      )
    }
  })

  observeEvent(input$confirm_skills, {
    skills <- value_or(input$selected_skills, character())
    available_skills <- setdiff(skill_choices[[chosen_class()]],
      background_rules[[chosen_background()]]$skills)
    if (length(skills) != skill_counts[[chosen_class()]] ||
        any(!skills %in% available_skills)) return()
    chosen_skills(skills)
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
    chosen_cantrips(cantrips)
    chosen_spells(spells)
    current_screen("equipment")
  })

  observeEvent(input$back_to_spells, {
    current_screen("spells")
  })

  output$equipment_error <- renderUI({
    if (current_screen() == "equipment" &&
        !is.null(input$confirm_equipment) && input$confirm_equipment > 0 &&
        (is.null(input$selected_equipment) || !nzchar(input$selected_equipment))) {
      div(class = "text-warning text-center", "Choose an equipment pack before continuing.")
    }
  })

  observeEvent(input$confirm_equipment, {
    if (is.null(input$selected_equipment) || !nzchar(input$selected_equipment)) return()
    chosen_equipment(input$selected_equipment)
    current_screen("summary")
  })

  observeEvent(input$back_to_equipment, {
    current_screen("equipment")
  })

  observeEvent(input$submit_character, {
    if (isTRUE(party_save_pending())) return()
    party_save_status(NULL)
    if (!character_is_valid()) {
      party_save_status(list(ok = FALSE,
        message = "Finish the character details before saving."))
      return()
    }
    email <- trimws(value_or(input$player_email, ""))
    if (!grepl("^[^[:space:]@]+@[^[:space:]@]+\\.[^[:space:]@]+$", email)) {
      party_save_status(list(ok = FALSE,
        message = "Enter a valid email address to receive your character sheet."))
      return()
    }
    if (!nzchar(save_endpoint) || !nzchar(save_token)) {
      party_save_status(list(ok = FALSE,
        message = "PDF email isn't configured yet. Contact the DM to finish the email service setup."))
      return()
    }

    details <- list(
      character_name = current_detail("character_name"),
      alignment = current_detail("alignment", "Unspecified")
    )
    sheet_lines <- character_sheet_lines(
      chosen_species(), chosen_class(), chosen_background(), chosen_scores(),
      chosen_ability_increases(), details, chosen_skills(), chosen_cantrips(),
      chosen_spells(), chosen_equipment()
    )
    submission_id <- value_or(party_submission_id(), NULL)
    if (is.null(submission_id)) {
      submission_id <- paste0(
        format(Sys.time(), "%Y%m%d%H%M%S"),
        "-",
        paste(sample(c(letters, 0:9), 32, replace = TRUE), collapse = "")
      )
      party_submission_id(submission_id)
    }
    request_body <- list(
      token = save_token,
      submission_id = submission_id,
      player_email = email,
      character_name = details$character_name,
      character_sheet = paste(sheet_lines, collapse = "\n")
    )

    party_save_pending(TRUE)
    party_save_status(list(ok = TRUE, message = "Sending character to the DM and emailing your copy..."))
    on.exit(party_save_pending(FALSE), add = TRUE)
    result <- withProgress(message = "Saving your character", value = 0, {
      tryCatch({
        response <- httr::POST(
          save_endpoint,
          body = request_body,
          encode = "json",
          httr::timeout(30)
        )
        response_text <- httr::content(response, as = "text", encoding = "UTF-8")
        service_result <- tryCatch(
          jsonlite::fromJSON(response_text, simplifyVector = FALSE),
          error = function(error) NULL
        )
        if (httr::http_error(response)) {
          stop(paste("The save service returned HTTP", httr::status_code(response), "."),
            call. = FALSE)
        }
        if (is.null(service_result)) {
          stop("The save service returned an unreadable response. You can retry safely.",
            call. = FALSE)
        }
        if (!isTRUE(service_result$ok)) {
          stop(value_or(service_result$message,
            "The save service could not save this character."), call. = FALSE)
        }
        list(ok = TRUE,
          message = paste0("PDF emailed to you (", email, ") and the DM."))
      }, error = function(error) {
        list(ok = FALSE,
          message = paste("Couldn't save the character:", conditionMessage(error)))
      })
    })
    party_save_status(result)
    if (isTRUE(result$ok)) party_submission_id(NULL)
  })

  output$character_sheet <- renderUI({
    if (!character_is_valid()) {
      name <- trimws(current_detail("character_name"))
      if (!nzchar(name)) {
        return(p("Enter a character name to see the sheet preview.", class = "text-muted"))
      }
      return(p("Spend no more than 27 points to preview this character.", class = "text-danger"))
    }

    section <- function(label, value) {
      value <- unlist(value, use.names = FALSE)
      value <- value[!is.na(value) & nzchar(trimws(value))]
      if (!length(value)) return(NULL)
      tagList(
        div(
          class = "overview-section",
          h3(paste0(label, ":")),
          if (length(value) == 1L) p(value) else tags$ul(lapply(value, tags$li))
        )
      )
    }

    tagList(
      div(class = "overview-name", current_detail("character_name")),
      p(class = "overview-subtitle", paste(
        chosen_species(), chosen_class(), "Level 1",
        sep = " · "
      )),
      section("Alignment", current_detail("alignment", "Unspecified")),
      section("Ability scores", lapply(seq_along(ability_scores), function(i) {
          id <- unname(ability_scores[[i]])
          paste0(names(ability_scores)[i], ": ", final_scores()[[id]])
        })),
        section("Background", format_background(chosen_background())),
        section("Background ability increases", paste0(
          names(chosen_ability_increases()), " +", chosen_ability_increases()
        )),
        section("Skill proficiencies", c(
          background_rules[[chosen_background()]]$skills,
          chosen_skills()
        )),
        section("Tool proficiency", background_rules[[chosen_background()]]$tool),
        section("Origin feat", background_rules[[chosen_background()]]$feat),
        section("Species traits", species_traits[[chosen_species()]]),
        section("Level 1 class features", class_rules[[chosen_class()]]$features),
        section("Saving throw proficiencies", class_rules[[chosen_class()]]$saves),
        section("Hit points", as.character(level_one_hit_points(
          chosen_class(), final_scores(), chosen_species()
        ))),
        section("Cantrips", if (length(chosen_cantrips())) chosen_cantrips() else "None"),
        section(if (identical(chosen_class(), "Wizard")) "Spellbook" else "Level 1 spells",
          if (length(chosen_spells())) chosen_spells() else "None"),
        section("Level 1 spell slots", if (class_rules[[chosen_class()]]$slots == 0L) {
          "None"
        } else if (identical(chosen_class(), "Warlock")) {
          "1 Pact Magic slot"
        } else {
          paste(class_rules[[chosen_class()]]$slots, "1st-level spell slots")
        }),
        section("Background equipment", background_rules[[chosen_background()]]$equipment),
        section(
          chosen_equipment(),
          unname(equipment_options[[chosen_equipment()]])
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
      details <- list(
        character_name = current_detail("character_name"),
        alignment = current_detail("alignment", "Unspecified")
      )
      payload <- character_payload(
        chosen_species(),
        chosen_class(),
        chosen_background(),
        chosen_scores(),
        chosen_ability_increases(),
        details,
        chosen_skills(),
        chosen_cantrips(),
        chosen_spells(),
        chosen_equipment()
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
      details <- list(
        character_name = current_detail("character_name"),
        alignment = current_detail("alignment", "Unspecified")
      )
      lines <- character_sheet_lines(
        chosen_species(), chosen_class(), chosen_background(), chosen_scores(),
        chosen_ability_increases(), details, chosen_skills(), chosen_cantrips(),
        chosen_spells(), chosen_equipment()
      )
      writeLines(lines, file, useBytes = TRUE)
    }
  )
}

shinyApp(ui = ui, server = server)
