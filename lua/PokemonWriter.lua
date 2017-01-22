PokemonEncryptor = require 'PokemonEncryptor'
cfg = require 'cfg'
InputConverterClass = require 'InputConverter'

local M={}

PokemonWriter = {
    encryptor = PokemonEncryptor.PokemonEncryptor:new{},
    lastPokemonSlotUsed = 0,
    pokemonSlotsUsed = {}
}

function PokemonWriter:new ()
    
    local overwriteNickname = function(self, text, pokemonPointer)
        for i=1,#text do
            memory.writebyte(pokemonPointer+i+cfg.pokemonNicknameOffset-1, cfg.chars[string.upper(text:sub(i,i))])
        end
        memory.writebyte(pokemonPointer+cfg.pokemonNicknameOffset+#text, 0xFF)
    end
    
    local overwriteData = function(self, growth, attacks, ev, misc, substructureOrder, input, pokemonPointer)
        InputConverter = InputConverterClass.InputConverter(substructureOrder)
        InputConverter:convertInput(input, growth, attacks, ev, misc, self.lastPokemonSlotUsed)
        InputConverter:convertUnencryptedData(input)
        InputConverter:setRequestedValues(self.encryptor)
    end
    
    local writeNewData = function(encryptedData,pokemonPointer)
        for i=1,12 do
            memory.writedword(pokemonPointer+cfg.pokemonDataOffset+(i-1)*4, encryptedData[i])
        end
    end
    
    self.overwriteNickname = overwriteNickname
    self.overwriteData = overwriteData
    self.writeNewData = writeNewData
    
    o = {}
    setmetatable(o, self)
    self.__index = self

    return o
end

function PokemonWriter:writePokemon(input, pokemonPointer)
    otId = memory.readdword(pokemonPointer+4)
    personality = memory.readdword(pokemonPointer)
    
    encryptedData = {}
    for i=1,12 do
        encryptedData[i] = memory.readdword(pokemonPointer+cfg.pokemonDataOffset+(i-1)*4)
    end
    
    growth, attacks, ev, misc, encryptionKey = self.encryptor:decryptAll(encryptedData, personality, otId)
    
    substructureOrder = PokemonEncryptor.getSubstructureOrder(personality)
    self:overwriteData(growth, attacks, ev, misc, substructureOrder, input)
    
    reEncryptedData, checksum = self.encryptor:encryptAll(growth, attacks, ev, misc, personality, encryptionKey)
    
    self:overwriteNickname(input.name, pokemonPointer)
    self.writeNewData(reEncryptedData,pokemonPointer)
    memory.writeword(pokemonPointer+cfg.pokemonChecksumOffset, newChecksum) --checksum
end

function PokemonWriter:incrementNewPokemonSpecies()
    self.lastPokemonSlotUsed = self.lastPokemonSlotUsed + 1
    self.pokemonSlotsUsed[#self.pokemonSlotsUsed] = self.lastPokemonSlotUsed
end

M.PokemonWriter = PokemonWriter

return M