local M={}

function convertSubstructures(input, pokemonId, level, levelUpType, growth, attacks, ev, misc)
    -- attacks
    attacks[1] = bit.band(input.attack1, 0xFF)
    attacks[2] = bit.band(bit.rshift(input.attack1, 8), 0xFF)
    attacks[3] = bit.band(input.attack2, 0xFF)
    attacks[4] = bit.band(bit.rshift(input.attack2, 8), 0xFF)
    attacks[5] = bit.band(input.attack3, 0xFF)
    attacks[6] = bit.band(bit.rshift(input.attack3, 8), 0xFF)
    attacks[7] = bit.band(input.attack4, 0xFF)
    attacks[8] = bit.band(bit.rshift(input.attack4, 8), 0xFF)
    
    -- pps
    attacks[9] = bit.bor(input.pp1)
    attacks[10] = bit.bor(input.pp2)
    attacks[11] = bit.bor(input.pp3)
    attacks[12] = bit.bor(input.pp4)

    -- overwrite the pokemon species
    growth[1] = bit.band(pokemonId, 0xFF)
    growth[2] = bit.rshift(pokemonId, 8)
    
    -- overwrite the exp. Not sure why it's organized like this.
    local exp = levelsToExp[level][levelUpType+2]
    growth[5] = bit.band(exp, 0xFF)
    growth[6] = bit.band(bit.rshift(exp,8),0xFF)
    growth[7] = bit.band(bit.rshift(exp,16),0xFF)
    growth[8] = bit.band(bit.rshift(exp,24),0xFF)
end

function convertBaseStats(input, baseStats)
    baseStats[7] = input.type1
    baseStats[8] = input.type2
    baseStats[23] = input.ability
    baseStats[24] = input.ability
    print (baseStats)
end

M.convertSubstructures = convertSubstructures
M.convertBaseStats = convertBaseStats

return M