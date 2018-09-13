-- ------------------------------------------------------------------------
-- List of effects and state
--   class,        effect name,           use or not,  toggle, regex pattern   
-- ------------------------------------------------------------------------
DEFAULT_FREEP_EFFECTS =  {
    {"Common",      "Dazed",                          1, 0},    
    {"Common",      "Recovering",                     0, 0}, 
    {"Common",      "Stunned",                        1, 0}, 
    {"Common",      "Rooted",                         1, 0}, 
    {"Common",      "Temporary State Immunity",       1, 0}, 
    {"Burglar",     "Addle",                          0, 0}, 
    {"Burglar",     "A Small Snag",                   0, 0}, 
    {"Burglar",     "Debuffing Gamble",               0, 0, "Debuffing Gamble"},
    {"Burglar",     "Improved Trick: Disable",        0, 0}, 
    {"Burglar",     "Quite A Snag",                   0, 0}, 
    {"Burglar",     "Reveal Weakness",                0, 0}, 
    {"Burglar",     "Trick: Enraged (Trick)",         0, 0, "Trick: Enraged %(Trick%)"},
    {"Captain",     "Armour Rend",                    0, 0}, 
    {"Captain",     "Lead the Charge",                0, 0}, 
    {"Captain",     "Oathbreaker's Shame",            0, 0}, 
    {"Captain",     "Revealing Mark",                 0, 1}, 
    {"Captain",     "Telling Mark",                   0, 1}, 
    {"Champion",    "Rend",                           0, 0}, 
    {"Hunter",      "Penetrating Shot",               0, 0}, 
    {"Lore-master", "Ancient Craft",                  0, 0}, 
    {"Lore-master", "Benediction of the Raven",       0, 0}, 
    {"Lore-master", "Fire-lore",                      1, 0, "Fire%-lore"}, 
    {"Lore-master", "Frost-lore",                     1, 0, "Frost%-lore"}, 
    {"Lore-master", "Knowledge of the Lore-master",   0, 0}, 
    {"Lore-master", "Ranged Critical Chance",         0, 0}, 
    {"Lore-master", "Shatter Arms",                   0, 0}, 
    {"Lore-master", "Sticky Tar: Fire Vulnerability", 0, 0}, 
    {"Lore-master", "Sticky Tar: Slow",               0, 0}, 
    {"Lore-master", "Warding Lore",                   0, 0}, 
    {"Lore-master", "Wind-lore",                      0, 0, "Wind%-lore"},
    {"Runekeeper",  "Essence of Winter",              0, 0}, 
    {"Runekeeper",  "Flurry of Words",                0, 0}, 
    {"Warden",      "Diminished Target",              0, 0}, 
    {"Warden",      "Marked Target",                  0, 0},    
}

DEFAULT_FREEP_PLAYER_EFFECTS = {
    {"Lore-master", "Temporary State Immunity",       0, 0},
}

DEFAULT_CREEP_EFFECTS = {
}

DEFAULT_CREEP_PLAYER_EFFECTS = {
} 

DEFAULT_EFFECTS = DEFAULT_FREEP_EFFECTS

-- ------------------------------------------------------------------------
-- Constants 
-- ------------------------------------------------------------------------
DEBUG_ENABLED = false
DEBUFF_AND_EFFECTS_OFFSET = 190
DEFAULT_WIDTH = 200
DEFAULT_HEIGHT = 20
DEFAULT_SAVE_FRAME_POSITIONS = false
DEFAULT_LOCKED_POSITION = false
DEFAULT_PRELOAD_COUNT = 1
DEFAULT_SHOW_MORALE = true
DEFAULT_SHOW_POWER = true

