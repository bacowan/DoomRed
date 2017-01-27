local M = {}

UsedPokemonContainer = {
    currentPokemon = 0
}

function UsedPokemonContainer:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function UsedPokemonContainer:nextPokemon()
    self.currentPokemon = self.currentPokemon + 1
    return self.currentPokemon
end

M.UsedPokemonContainer = UsedPokemonContainer
return M