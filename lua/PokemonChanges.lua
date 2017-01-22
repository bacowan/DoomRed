local M={}

PokemonChanges = {
    name = ""
}

function PokemonChanges:new (inp)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = removeTabs(inp:sub(1,10))
    o.attack1 = tonumber(inp:sub(11,13))
    o.attack2 = tonumber(inp:sub(14,16))
    o.attack3 = tonumber(inp:sub(17,19))
    o.attack4 = tonumber(inp:sub(20,22))
    
    return o
end

function removeTabs(text)
    return string.match(text, "(%a+)\t")
end

M.PokemonChanges = PokemonChanges

return M