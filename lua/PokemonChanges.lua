local M={}

local hex = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}

PokemonChanges = {
    name = ""
}

movesetLenOffset = 42
movesetLenSize = 2
moveSize = 5
paletteLenSize = 3
imageLenSize = 4
iconLenSize = 4

function PokemonChanges:new (inp)
    
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = removeTabs(inp:sub(1,10))
    o.attack1 = tonumber(inp:sub(11,13))
    o.attack2 = tonumber(inp:sub(14,16))
    o.attack3 = tonumber(inp:sub(17,19))
    o.attack4 = tonumber(inp:sub(20,22))
    o.pp1 = tonumber(inp:sub(23,25))
    o.pp2 = tonumber(inp:sub(26,28))
    o.pp3 = tonumber(inp:sub(29,31))
    o.pp4 = tonumber(inp:sub(32,34))
    o.type1 = tonumber(inp:sub(35,36))
    o.type2 = tonumber(inp:sub(37,38))
    o.ability = tonumber(inp:sub(39,40))
    
    local gender = inp:sub(41,41)
    if gender == "0" then
        o.gender = 0 -- male
    elseif gender == "1" then
        o.gender = 254 -- female
    elseif gender == "2" then
        o.gender = 255 -- genderless
    end
    
    local movesetCount = tonumber(inp:sub(movesetLenOffset, movesetLenOffset+movesetLenSize-1))
    o.moveset = {}
    for i=1,movesetCount do
        local currentMoveStart = movesetLenOffset+movesetLenSize+(i-1)*moveSize
        local level = tonumber(inp:sub(currentMoveStart,currentMoveStart+1))+1
        local move = tonumber(inp:sub(currentMoveStart+2,currentMoveStart+4))
        o.moveset[i] = {level*2, move}
    end
    
    local paletteLenOffset = movesetLenOffset + movesetLenSize + movesetCount*moveSize
    local paletteOffset = paletteLenOffset + paletteLenSize
    local paletteLen = tonumber(inp:sub(paletteLenOffset, paletteLenOffset+paletteLenSize-1))
    local paletteAsString = inp:sub(paletteOffset, paletteOffset+paletteLen)
    o.palette = hexStringToByteArray(paletteAsString)
    
    local imageLenOffset = paletteOffset+paletteLen
    local imageLen = tonumber(inp:sub(imageLenOffset, imageLenOffset+imageLenSize-1))
    local imageAsString = inp:sub(imageLenOffset+imageLenSize, imageLenOffset+imageLenSize+imageLen)
    o.image = hexStringToByteArray(imageAsString)
    
    local iconLenOffset = imageLenOffset + imageLenSize + imageLen
    local iconLen = tonumber(inp:sub(iconLenOffset, iconLenOffset+iconLenSize-1))
    local iconAsString = inp:sub(iconLenOffset+iconLenSize, iconLenOffset+iconLenSize+iconLen)
    
    o.icon = hexStringToByteArray(iconAsString)
    
    return o
end

function hexStringToByteArray(string)
    array = {}
    for i=1,#string do
        array[#array+1] = tonumber(string:sub(i*2-1,i*2), 16)
    end
    return array
end

function removeTabs(text)
    if string.find(text, "\t") == nil then
        return text
    end
    return string.match(text, "(%a+)\t")
end

M.PokemonChanges = PokemonChanges

return M