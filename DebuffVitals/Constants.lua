-- ------------------------------------------------------------------------
-- List of effects and state
--   class,        effect name,                       use or not, toggle, regex pattern   
-- ------------------------------------------------------------------------
DEFAULT_FREEP_EFFECTS =  {
    {"Common",      "Dazed",                                    1, 0},
    {"Common",      "Force Attack",                             1, 0},    
    {"Common",      "Recovering",                               0, 0},
    {"Common",      "Stunned",                                  1, 0},
    {"Common",      "Rooted",                                   1, 0},
    {"Common",      "Temporary State Immunity",                 1, 0},
    {"Burglar",     "Addle",                                    0, 0},
    {"Burglar",     "Debuffing Gamble",                         0, 0, "Debuffing Gamble"},
    {"Burglar",     "Quite A Snag",                             0, 0, {"A Small Snag", "Quite A Snag"}},    
    {"Burglar",     "Reveal Weakness",                          0, 1},
    {"Burglar",     "Trick: Enraged (Trick)",                   0, 0, "Trick: Enraged %(Trick%)"},
    {"Burglar",     "Trick: Disable",                           0, 0, "Trick: Disable"},    
    {"Captain",     "Armour Rend",                              0, 0},
    {"Captain",     "Lead the Charge",                          0, 0},
    {"Captain",     "Oathbreaker's Shame",                      0, 0},
    {"Captain",     "Revealing Mark",                           0, 1},
    {"Captain",     "Telling Mark",                             0, 1},
    {"Champion",    "Aggressive Exchange",                      0, 0},
    {"Champion",    "Armour Rend",                              0, 0},    
    {"Champion",    "Coward's Fate",                            0, 1, "Coward's Fate"},
    {"Champion",    "Deep Strikes",                             0, 0},    
    {"Champion",    "Devastated",                               0, 0},
    {"Champion",    "Horn of Gondor Physical Mitigation",       0, 0},    
    {"Champion",    "Rend",                                     0, 0, "Rend Tier"},
    {"Hunter",      "Barbed Arrow",                             0, 0, {"Burning Arrow", "Barbed Arrow", "Glowing Arrow"}},
    {"Hunter",      "Exsanguinate",                             0, 0},
    {"Hunter",      "Heart Seeker",                             0, 0},
    {"Hunter",      "Penetrating Shot",                         0, 0},
    {"Lore-master", "Ancient Craft",                            0, 0}, 
    {"Lore-master", "Benediction of the Raven",                 0, 0}, 
    {"Lore-master", "Fire-lore",                                1, 0, "Fire%-lore"}, 
    {"Lore-master", "Frost-lore",                               1, 0, "Frost%-lore"}, 
    {"Lore-master", "Knowledge of the Lore-master",             0, 0, "Knowledge of the Lore%-master"},
    {"Lore-master", "Ranged Critical Chance",                   0, 0},
    {"Lore-master", "Shatter Arms",                             0, 0},
    {"Lore-master", "Sign of Power: Command",                   0, 0},    
    {"Lore-master", "Sign of Power: See all Ends",              0, 0},    
    {"Lore-master", "Sticky Tar: Fire Vulnerability",           0, 1},
    {"Lore-master", "Sticky Tar: Slow",                         0, 1},
    {"Lore-master", "Warding Lore",                             0, 1},
    {"Lore-master", "Wind-lore",                                0, 0, "Wind%-lore"},
    {"Runekeeper",  "Essence of Winter",                        0, 0},
    {"Runekeeper",  "Flurry of Words",                          0, 0},
    {"Warden",      "Battering Strikes - Tier 1",               0, 0, "Battering Strikes %- Tier 1"},
    {"Warden",      "Battering Strikes - Tier 2",               0, 0, "Battering Strikes %- Tier 2"},
    {"Warden",      "Battering Strikes - Tier 3",               0, 0, "Battering Strikes %- Tier 3"},
    {"Warden",      "Desolation",                               0, 0},
    {"Warden",      "Diminished Target",                        0, 0},
    {"Warden",      "Goad DoT",                                 0, 0, "Goad Damage over Time"},
    {"Warden",      "Hampering Javelin",                        0, 0, "Hampering Javelin"},
    {"Warden",      "Marked Target",                            0, 0},
    {"Warden",      "Mighty Blow",                              0, 0},
    {"Warden",      "Morale-tap",                               0, 0, "Morale%-tap"},
    {"Warden",      "No Respite",                               0, 0},    
    {"Warden",      "Piercing Strike - LDoT",                   0, 0, "Piercing Strike %- Light Damage over Time"},
    {"Warden",      "Power Attack",                             0, 0},
    {"Warden",      "Precise Blow - LDoT",                      0, 0, "Precise Blow %- Light Damage over Time"},
    {"Warden",      "Shield Piercer",                           0, 0},
    {"Warden",      "Spear of Virtue - LDoT",                   0, 0, "Spear of Virtue %- Light Damage over Time"},
    {"Warden",      "Suppression - Tier 1",                     0, 0, "Suppression %- Tier 1"},
    {"Warden",      "Suppression - Tier 2",                     0, 0, "Suppression %- Tier 2"},
    {"Warden",      "Warning Shot",                             0, 0},
    {"Warden",      "LDoT - Tier 1",                            0, 0, "Light Damage over Time %- Tier 1"},
    {"Warden",      "LDoT - Tier 2",                            0, 0, "Light Damage over Time %- Tier 2"},
    {"Warden",      "LDoT - Tier 3",                            0, 0, "Light Damage over Time %- Tier 3"},
    {"Warden",      "LDoT - Tier 4",                            0, 0, "Light Damage over Time %- Tier 4"},
    {"Warden",      "Low Bleed",                                0, 0, "Low Bleed"}, -- Out of alphabetical order!!!
    {"Warden",      "Moderate Bleed",                           0, 0, "Moderate Bleed"},
    {"Warden",      "Major Bleed",                              0, 0, "Major Bleed"},
    {"Warden",      "Severe Bleed",                             0, 0, "Severe Bleed"},
}

DEFAULT_FREEP_PLAYER_EFFECTS = {
    {"Common", "Temporary State Immunity",                      0, 0},
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
DEBUFF_AND_EFFECTS_OFFSET = 80
DEFAULT_WIDTH = 200
DEFAULT_HEIGHT = 20
DEFAULT_SAVE_FRAME_POSITIONS = false
DEFAULT_LOCKED_POSITION = false
DEFAULT_SHOW_MORALE = true
DEFAULT_SHOW_POWER = true

