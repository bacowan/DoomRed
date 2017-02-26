cfg = require 'cfg'

local M = {}

function getSubstructureOrder(personality)
    return cfg.substructureOrders[personality%24]
end

function encrypt()
end

function readPokemon(pokemonPointer)
    local otId = memory.readdword(pokemonPointer+4)
    local personality = memory.readdword(pokemonPointer)
    local encryptionKey = utils.getEncryptionKey(otId, personality)
    local substructureOrder = utils.getSubstructureOrder(personality)
    return decrypt(pokemonPointer, encryptionKey, substructureOrder)
end

function decrypt(pokemonPointer, encryptionKey, substructureOrder)
    local encryptedData = {}
    for i=1,4 do
        encryptedData[i] = memory.readbyterange(pokemonPointer+cfg.dataStructureOffset+(i-1)*cfg.substructureSize,cfg.substructureSize)
    end
    
    -- decrypt the data
    local decryptedData = {}
    for i=1,4 do
        decryptedData[i] = xor(encryptedData[i], encryptionKey)
    end
    
    -- organize the data
    local growth = decryptedData[indexOf(substructureOrder,cfg.G)]
    local attacks = decryptedData[indexOf(substructureOrder,cfg.A)]
    local ev = decryptedData[indexOf(substructureOrder,cfg.E)]
    local misc = decryptedData[indexOf(substructureOrder,cfg.M)]
    
    return growth, attacks, ev, misc
end

function getEncryptionKey(otId, personality)
    return bit.bxor(otId, personality)
end

M.readPokemon = readPokemon
M.encrypt = encrypt
M.decrypt = decrypt
M.getEncryptionKey = getEncryptionKey

M.getSubstructureOrder = getSubstructureOrder
return M