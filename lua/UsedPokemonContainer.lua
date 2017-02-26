cfg = require 'cfg'
utils = require 'utils'

local M = {}

local tempUnusedPokemon = {}
for i=1,cfg.maxPokemonId do
    table.insert(tempUnusedPokemon, i)
end

UsedPokemonContainer = {
    unusedPokemon = tempUnusedPokemon
}

function UsedPokemonContainer:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function UsedPokemonContainer:nextPokemon()
    if #self.unusedPokemon == 0 then
        addUnusedPokemon()
    end
    return table.remove(self.unusedPokemon, 1)
end

function UsedPokemonContainer:addUnusedPokemon()
    local usedPokemon = {}
    for i=0,cfg.boxPositionCount do
        local id = getPokemonIdAtPosition(cfg.box1start+i*cfg.pokemonDataSize)
        if id ~= 0 then
            usedPokemon[id] = true
        end
    end
    for i=1,cfg.maxPokemonId do
        if usedPokemon[i] ~= true then
            table.insert(self.unusedPokemon, i)
        end
    end
end

function getPokemonIdAtPosition(position)
    local growth, attacks, ev, misc = utils.readPokemon(pokemonPointer)
    return growth[1]*0x100 + growth[2]
end

M.UsedPokemonContainer = UsedPokemonContainer
return M