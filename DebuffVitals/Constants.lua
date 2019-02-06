-- ------------------------------------------------------------------------
-- List of effects and state
--   class,        effect name,                       use or not, type*, regex pattern
--
-- *type : 0 - timed skill, 1 - untimed skill, 2 - timed skill with break on damage
-- ------------------------------------------------------------------------
DEFAULT_FREEP_EFFECTS =  {
    {"Common",      "Dazed",                                    1, 2},
    {"Common",      "Force Attack",                             1, 0},    
    {"Common",      "Recovering",                               0, 0},
    {"Common",      "Stunned",                                  1, 0},
    {"Common",      "Rooted",                                   1, 2},
    {"Common",      "Temporary State Immunity",                 1, 0},
    {"Beorning",    "Bash",                                     0, 0},
    {"Beorning",    "Bee Swarm",                                0, 0},    
    {"Beorning",    "Bee Swarm Critical Defence Debuff",        0, 0},
    {"Beorning",    "Debilitating Bees",                        0, 0},
    {"Beorning",    "Defensive Blow",                           0, 0},    
    {"Beorning",    "Mark of Beorn",                            0, 1},
    {"Beorning",    "Piercing Roar",                            0, 0},
    {"Beorning",    "Rake",                                     0, 0, "Rake"},
    {"Beorning",    "Slammed",                                  0, 0},
    {"Beorning",    "Slash",                                    0, 0, "Slash"},
    {"Beorning",    "Serrated Edge",                            0, 0},
    {"Beorning",    "Sluggish Bees",                            0, 0},
    {"Beorning",    "Weakened",                                 0, 0, "Weakened"},
    {"Burglar",     "Addle",                                    0, 0},
    {"Burglar",     "Cunning Attack",                           0, 0},
    {"Burglar",     "Damaging Gamble",                          0, 0, "Damaging Gamble"},
    {"Burglar",     "Debuffing Gamble",                         0, 0, "Debuffing Gamble"},
    {"Burglar",     "Gambler's Advantage",                      0, 0, "Gambler's Advantage"},    
    {"Burglar",     "Provoke",                                  0, 0},    
    {"Burglar",     "Quite A Snag",                             0, 0, {"A Small Snag", "Quite A Snag"}},    
    {"Burglar",     "Reveal Weakness",                          0, 1},
    {"Burglar",     "Trick: Counter Defence",                   0, 0},    
    {"Burglar",     "Trick: Dust in the Eyes",                  0, 0},    
    {"Burglar",     "Trick: Enraged (Trick)",                   0, 0, "Trick: Enraged %(Trick%)"},
    {"Burglar",     "Trick: Disable",                           0, 0},    
    {"Captain",     "Armour Rend",                              0, 0},
    {"Captain",     "Cutting Attack",                           0, 0, "Cutting Attack"},    
    {"Captain",     "Grave Wound",                              0, 0, "Grave Wound"},    
    {"Captain",     "Lead the Charge",                          0, 0},
    {"Captain",     "Oathbreaker's Shame",                      0, 0},
    {"Captain",     "Noble Mark",                               0, 1},    
    {"Captain",     "Revealing Mark",                           0, 1},
    {"Captain",     "Telling Mark",                             0, 1},
    {"Champion",    "Aggressive Exchange",                      0, 0},
    {"Champion",    "Armour Rend",                              0, 0},    
    {"Champion",    "Coward's Fate",                            0, 1, "Coward's Fate"},
    {"Champion",    "Deep Strikes",                             0, 0},    
    {"Champion",    "Devastated",                               0, 0},
    {"Champion",    "Horn of Champions",                        0, 0},    
    {"Champion",    "Horn of Gondor Physical Mitigation",       0, 0},    
    {"Champion",    "Rend",                                     0, 0, "Rend Tier"},
    {"Guardian",    "Take to Heart",                            0, 1},
    {"Guardian",    "Marked by Light",                          0, 1},
    {"Guardian",    "Slashing Wound",                           0, 0},
    {"Guardian",    "War-Chant",                                0, 0, "War%-Chant"},
    {"Guardian",    "Haemorrhaging Wound",                      0, 0},
    {"Guardian",    "Deep Wound",                               0, 0},
    {"Guardian",    "Terrible Wound",                           0, 0},
    {"Guardian",    "Staggered",                                0, 0},
    {"Hunter",      "Archer's Mark",                            0, 0, "Archer's Mark"},
    {"Hunter",      "Barbed Arrow",                             0, 0, {"Burning Arrow", "Barbed Arrow", "Glowing Arrow"}},
    {"Hunter",      "Exsanguinate",                             0, 0},
    {"Hunter",      "Feared",                                   0, 0},
    {"Hunter",      "Heart Seeker",                             0, 0},
    {"Hunter",      "Lingering Wound",                          0, 0},
    {"Hunter",      "Master Trapper's Piercing Trap",           0, 0},
    {"Hunter",      "Master Trapper's Triple Trap",             0, 0},
    {"Hunter",      "Penetrating Shot",                         0, 0},
    {"Hunter",      "Piercing Trap",                            0, 0},
    {"Hunter",      "Snaring Trap",                             0, 0},    
    {"Hunter",      "The One Trap",                             0, 0},
    {"Lore-master", "Adding Injury to Insult",                  0, 0},
    {"Lore-master", "Ancient Craft",                            0, 0}, 
    {"Lore-master", "Benediction of the Raven",                 0, 0}, 
    {"Lore-master", "Burning Embers",                           0, 0, {"Burning Embers", "Improved Burning Embers"}},
    {"Lore-master", "Burning Embers: Slow Burn",                0, 0},    
    {"Lore-master", "Cool Off",                                 0, 0},
    {"Lore-master", "Deep Freeze",                              0, 0},
    {"Lore-master", "Fire-lore",                                1, 0, "Fire%-lore"}, 
    {"Lore-master", "Frost-lore",                               1, 0, "Frost%-lore"},
    {"Lore-master", "Improved Searing Embers",                  0, 0},
    {"Lore-master", "Knowledge of the Lore-master",             0, 0, "Knowledge of the Lore%-master"},
    {"Lore-master", "Light of Nature",                          0, 1},
    {"Lore-master", "Nature's Light",                           0, 0},
    {"Lore-master", "Ranged Critical Chance",                   0, 0},
    {"Lore-master", "Ring of Flame",                            0, 1},  
    {"Lore-master", "Shatter Arms",                             0, 0},
    {"Lore-master", "Sign of Power: Command",                   0, 0},    
    {"Lore-master", "Sign of Power: See all Ends",              0, 0},    
    {"Lore-master", "Sticky Tar: Fire Vulnerability",           0, 1},
    {"Lore-master", "Sticky Tar: Slow",                         0, 1},
    {"Lore-master", "Turn up the Heat",                         0, 0},    
    {"Lore-master", "Warding Lore",                             0, 1},
    {"Lore-master", "Warm Up",                                  0, 0},    
    {"Lore-master", "Wind-lore",                                0, 0, "Wind%-lore"},
    {"Lore-master", "Winter Storm",                             0, 0},
    {"Minstrel",    "Anthem of the Wizards: Slowed",            0, 0},
    {"Minstrel",    "Call of Orome",                            0, 0, 'Call of Orom'},
    {"Minstrel",    "Echoes of Battle",                         0, 1},
    {"Minstrel",    "Harsh Echoes",                             0, 0},
    {"Minstrel",    "Strike a Chord - Major Ballad",            0, 0},
    {"Minstrel",    "Strike a Chord - Minor Ballad",            0, 0},
    {"Minstrel",    "Strike a Chord - Perfect Ballad",          0, 0},
    {"Minstrel",    "Timeless Echoes of Battle",                0, 1},    
    {"Runekeeper",  "Distracting Flame",                        0, 0},
    {"Runekeeper",  "Essay of Fire",                            0, 0},
    {"Runekeeper",  "Essence of Winter",                        0, 0},
    {"Runekeeper",  "Fiery Ridicule",                           0, 0, "Fiery Ridicule"},
    {"Runekeeper",  "Fiery Ridicule - Tier 2",                  0, 0, "Fiery Ridicule - Tier 2"},    
    {"Runekeeper",  "Fiery Ridicule - Tier 3",                  0, 0, "Fiery Ridicule - Tier 3"},    
    {"Runekeeper",  "Flurry of Words",                          0, 1},
    {"Runekeeper",  "Icy Windstorm",                            0, 1},
    {"Runekeeper",  "Molten Flame",                             0, 0},
    {"Runekeeper",  "Mystifying Flames",                        0, 0},
    {"Runekeeper",  "Scathing Mockery",                         0, 0},
    {"Runekeeper",  "Searing Words",                            0, 0},
    {"Runekeeper",  "Writ of Fire",                             0, 0, "Writ of Fire"},    
    {"Runekeeper",  "Writ of Lightning",                        0, 0, "Writ of Lightning"},    
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
DEFAULT_SHOW_EFFECTS = true


