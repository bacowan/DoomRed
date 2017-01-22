cfg = require 'cfg'

local M={}



PokemonEncryptor = {}

function PokemonEncryptor:new ()
    self.retrieveDecrypted = function(array, indexes, key)
        return {array[(indexOf(indexes,key)-1)*3+1],
            array[(indexOf(indexes,key)-1)*3+2],
            array[(indexOf(indexes,key)-1)*3+3]}
    end
    
    self.getSubstructureOrder = getSubstructureOrder
    self.setRequestedValues = setRequestedValues
    self.calculateChecksum = calculateChecksum
    self.encrypt = encrypt
    
    o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PokemonEncryptor:encryptAll(growth, attacks, ev, misc, personality, encryptionKey)
    substructureOrder = self.getSubstructureOrder(personality)
    newUnencryptedData = self.setRequestedValues(growth, attacks, ev, misc, substructureOrder)
    newChecksum = self.calculateChecksum(newUnencryptedData)
    return self.encrypt(newUnencryptedData, encryptionKey), newChecksum
end

function setRequestedValues(growth, attacks, ev, misc, substructureOrder)
    ret = {0,0,0,0,0,0,0,0,0,0,0,0}
    ret[(indexOf(substructureOrder,cfg.G)-1)*3+1] = growth[1]
    ret[(indexOf(substructureOrder,cfg.G)-1)*3+2] = growth[2]
    ret[(indexOf(substructureOrder,cfg.G)-1)*3+3] = growth[3]
    ret[(indexOf(substructureOrder,cfg.A)-1)*3+1] = attacks[1]
    ret[(indexOf(substructureOrder,cfg.A)-1)*3+2] = attacks[2]
    ret[(indexOf(substructureOrder,cfg.A)-1)*3+3] = attacks[3]
    ret[(indexOf(substructureOrder,cfg.E)-1)*3+1] = ev[1]
    ret[(indexOf(substructureOrder,cfg.E)-1)*3+2] = ev[2]
    ret[(indexOf(substructureOrder,cfg.E)-1)*3+3] = ev[3]
    ret[(indexOf(substructureOrder,cfg.M)-1)*3+1] = misc[1]
    ret[(indexOf(substructureOrder,cfg.M)-1)*3+2] = misc[2]
    ret[(indexOf(substructureOrder,cfg.M)-1)*3+3] = misc[3]
    return ret
end

function indexOf(table, val)
    for i=1,#table do
        if table[i] == val then
            return i
        end
    end
    return 0
end

function calculateChecksum(dwordArray)
    sum = 0
    for i=1, #dwordArray do
        sum = sum +
            bit.rshift(dwordArray[i],16) +
            bit.band(dwordArray[i],0x0000FFFF)
    end
    return bit.band(sum, 0xFFFF)
end

function encrypt(unencryptedData, key)
    encryptedData = {}
    for i=1,#unencryptedData do
        encryptedData[i] = bit.bxor(unencryptedData[i], key)
    end
    return encryptedData
end

function PokemonEncryptor:decryptAll(encryptedData, personality, otId)
    local encryptionKey = bit.bxor(otId, personality)
    
    decryptedData = {}
    for i=1,12 do
        decryptedData[i] = bit.bxor(encryptedData[i], encryptionKey)
    end
    
    substructureOrder = self.getSubstructureOrder(personality)
    decryptedGrowth = self.retrieveDecrypted(decryptedData,substructureOrder,cfg.G)
    decryptedAttacks = self.retrieveDecrypted(decryptedData,substructureOrder,cfg.A)
    decryptedEv = self.retrieveDecrypted(decryptedData,substructureOrder,cfg.E)
    decryptedMisc = self.retrieveDecrypted(decryptedData,substructureOrder,cfg.M)
    
    return decryptedGrowth, decryptedAttacks, decryptedEv, decryptedMisc, encryptionKey
end

function getSubstructureOrder(personality)
    return cfg.substructureOrders[personality%24]
end

M.PokemonEncryptor = PokemonEncryptor
M.getSubstructureOrder = getSubstructureOrder

return M