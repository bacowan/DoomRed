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
    self.growth = growth
    self.attacks = attacks
    self.ev = ev
    self.misc = misc
    print('attacks')
    print(string.format("0x%x", self.attacks[1]))
    print(string.format("0x%x", self.attacks[2]))
    print(string.format("0x%x", self.attacks[3]))
    self.attacks[1] = bit.bor(input.attack1, input.attack2*0x10000)
    self.attacks[2] = bit.bor(input.attack3, input.attack4*0x10000)
    self.growth[1] = bit.bor(bit.band(self.growth[1],0xFFFF0000),pokemonNumber)
end

function InputConverter:setRequestedValues(encryptor)
    encryptor.setRequestedValues(self.growth, self.attacks, self.ev, self.misc, self.substructureOrder)
end

function InputConverter:convertUnencryptedData(input)
    
end

M.InputConverter = InputConverter

return M