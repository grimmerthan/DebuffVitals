-- ------------------------------------------------------------------------
-- List of effects and state
--   class,        debuff name,             in use,  toggle  
-- ------------------------------------------------------------------------
DefaultEffects =  {
    {"Common",      "Dazed",                         1, 0},    
    {"Common",      "Stunned",                       1, 0},
    {"Common",      "Rooted",                        1, 0},
    {"Common",      "Temporary State Immunity",      1, 0},
    {"Burglar",     "Addle",                         0, 0},
    {"Burglar",     "A Small Snag",                  0, 0},
    {"Burglar",     "Improved Trick: Disable",       0, 0},
    {"Burglar",     "Quite a Snag",                  0, 0},
    {"Burglar",     "Reveal Weakness",               0, 0}, 
    {"Burglar",     "Trick: Enraged (Trick)",        0, 0},
    {"Captain",     "Armour Rend",                   0, 0},
    {"Captain",     "Oathbreaker's Shame",           0, 0},
    {"Captain",     "Revealing Mark",                0, 1},
    {"Captain",     "Telling Mark",                  0, 1},
    {"Champion",    "Rend",                          0, 0},
    {"Hunter",      "Penetrating Shot",              0, 0},
    {"Lore-master", "Ancient Craft",                 0, 0},
    {"Lore-master", "Benediction of the Raven",      0, 0},
    {"Lore-master", "Fire-lore",                     1, 0},
    {"Lore-master", "Frost-lore",                    1, 0},    
    {"Lore-master", "Knowledge of the Lore-master",  0, 0},
    {"Lore-master", "Root Strike",                   0, 0},
    {"Lore-master", "Shatter Arms",                  0, 0},
    {"Lore-master", "Sticky Tar: Fire Vulnerability",0, 0},
    {"Lore-master", "Sticky Tar: Slow",              0, 0},
    {"Lore-master", "Warding Lore",                  0, 0},
    {"Lore-master", "Wind-lore",                     0, 0},
    {"Runekeeper",  "Essence of Winter",             0, 0},
    {"Runekeeper",  "Flurry of Words",               0, 0},
    {"Warden",      "Diminished Target",             0, 0},
    {"Warden",      "Marked Target",                 0, 0},
}

function LoadEffects()
    local count = 1
    
    local SavedEffects = Turbine.PluginData.Load(Turbine.DataScope.Character, "DebuffVitals", nil);
    
    for k, v in ipairs (SavedEffects or DefaultEffects) do
        DebugWriteLine("Loading  in "..tostring(v[1]).." / "..tostring(v[2])..
                        " / "..tostring(v[3]).." / "..tostring(v[4]))        
        TrackedEffects[count] = {v[1], v[2], v[3], v[4]}
        count = count + 1
    end
end    

function GenerateEnabledSet()      
    local count = 1    
    DebugWriteLine("count "..tostring(#TrackedEffects))
    
    EffectsSet = {}
    
    for k, v in ipairs (TrackedEffects) do
        if v[3] == 1 then
            DebugWriteLine("Adding in "..tostring(v[1]).." / "..tostring(v[2])..
                            " / "..tostring(v[3]).." / "..tostring(v[4]))        
            EffectsSet[count] = {v[1], v[2], v[3], v[4]}
            count = count + 1
        end
    end
end