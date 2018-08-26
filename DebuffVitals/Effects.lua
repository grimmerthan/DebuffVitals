-- ------------------------------------------------------------------------
-- List of effects and state
-- ------------------------------------------------------------------------
ListOfEffects =  {
    -- class,       debuff name,                  on, open-ended
    {"common",      "Dazed",                        1, 0},    
    {"common",      "Stunned",                      1, 0},
    {"common",      "Rooted",                       1, 0},
    {"common",      "Temporary State Immunity",     1, 0},
    {"burglar",     "reveal weakness",              0, 0}, 
    {"burglar",     "trick: enrage",                0, 0},
    {"burglar",     "trick: disable",               0, 0},
    {"burglar",     "addle",                        0, 0},
    {"burglar",     "a small snag",                 0, 0},
    {"burglar",     "quite a snag",                 0, 0},
    {"captain",     "Revealing Mark",               1, 1},
    {"captain",     "Telling Mark",                 1, 1},
    {"captain",     "oathbreaker's shame",          0, 0},
    {"captain",     "armour rend",                  0, 0},
    {"champion",    "Rend",                         0, 0},
    {"hunter",      "penetrating shot",             0, 0},
    {"lore-master", "Fire-lore",                    1, 0},
    {"lore-master", "Frost-lore",                   1, 0},    
    {"lore-master", "Wind-lore",                    0, 0},
    {"lore-master", "sticky tar",                   0, 0},
    {"lore-master", "ancient craft",                0, 0},
    {"lore-master", "shatter arms",                 0, 0},
    {"lore-master", "benediction of the raven",     0, 0},
    {"lore-master", "root strike",                  0, 0},
    {"lore-master", "warding knowledge",            0, 0},
    {"lore-master", "knowledge of the lore-master", 0, 0},
    {"runekeeper",  "essence of winter",            0, 0},
    {"runekeeper",  "flurry of words",              0, 0},
    {"warden",      "diminished target",            0, 0},
    {"warden",      "marked target",                0, 0},
}

function GenerateEffectsSet()
    local count = 1
    for k, v in ipairs (ListOfEffects) do
        if v[3] == 1 then
            DebugWriteLine("Adding in "..tostring(v[2]))        
            EffectsSet[count] = v
            count = count + 1
        end
    end
end