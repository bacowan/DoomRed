local M={}

local InputConverter = {}
InputConverter.__index = InputConverter

setmetatable(InputConverter, {
        __call = function (cls, ...)
            return cls.new(...)
        end,
    })

function InputConverter.new(substructureOrder)
    local self = setmetatable({}, InputConverter)
    self.substructureOrder = substructureOrder
    return self
end

function InputConverter:convertInput(input, growth, attacks, ev, misc, pokemonNumber)
    attacks[1] = bit.bor(input.attack1, input.attack2*0x10000)
    attacks[2] = bit.bor(input.attack3, input.attack4*0x10000)
    attacks[3] = bit.bor(input.pp1, input.pp2*0x100, input.pp3*0x10000, input.pp4*0x1000000)
    growth[1] = bit.bor(bit.band(growth[1],0xFFFF0000),pokemonNumber)
end

function InputConverter:convertUnencryptedData(input, baseStats)
    baseStats[7] = input.type1
    baseStats[8] = input.type2
end

M.InputConverter = InputConverter

return M