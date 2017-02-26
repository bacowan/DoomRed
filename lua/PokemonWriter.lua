cfg = require 'cfg'
InputConverter = require 'InputConverter'
utils = require 'utils'

local M={}

-- via http://lua-users.org/wiki/LuaCsv
function ParseCSVLine (line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

function getLevelsToExp()
    local levelsToExpCsv = {}
    for line in io.lines('levels.csv') do
        levelsToExpCsv[#levelsToExpCsv+1] = line
    end
    local ret = {}
    for i=2,#levelsToExpCsv do
        ret[#ret+1] = ParseCSVLine(levelsToExpCsv[i], ",")
    end
    return ret
end

levelsToExp = getLevelsToExp()

function writePokemon(input, pokemonPointer, nextPokemonId)
    
    local otId = memory.readdword(pokemonPointer+4)
    local personality = memory.readdword(pokemonPointer)
    local encryptionKey = utils.getEncryptionKey(otId, personality)
    local substructureOrder = utils.getSubstructureOrder(personality)
    local growth, attacks, ev, misc = utils.readPokemon(pokemonPointer)
    
    -- read in the base stats
    local baseStats = memory.readbyterange(cfg.baseStatsPointer + (nextPokemonId-1)*cfg.baseStatsSize, cfg.baseStatsSize)
    
    -- overwrite the substructres with the input data
    level = memory.readbyte(pokemonPointer+cfg.levelOffset)
    levelUpType = memory.readbyte(cfg.pokemonBaseStatsPointer + (nextPokemonId-1)*28 + 19)
    InputConverter.convertSubstructures(input, nextPokemonId, level, levelUpType, growth, attacks, ev, misc)
    
    -- create new data to write
    local newUnencryptedData = {}
    newUnencryptedData[indexOf(substructureOrder,cfg.G)] = growth
    newUnencryptedData[indexOf(substructureOrder,cfg.A)] = attacks
    newUnencryptedData[indexOf(substructureOrder,cfg.E)] = ev
    newUnencryptedData[indexOf(substructureOrder,cfg.M)] = misc
    
    -- calculate the checksum
    local checksum = calculateChecksum(newUnencryptedData)
    
    -- re-encrypt the data
    local newEncryptedData = {}
    for i=1,4 do
        newEncryptedData[i] = xor(newUnencryptedData[i], encryptionKey)
    end
    
    -- write the new encrypted data
    for i=1,4 do
        for j=1,#newEncryptedData[i] do
            memory.writebyte(pokemonPointer + cfg.dataStructureOffset + (i-1)*cfg.substructureSize + (j-1), newEncryptedData[i][j])
        end
    end
    memory.writeword(pokemonPointer+cfg.checksumOffset, checksum)
    
    -- write nickname
    for i=1,#input.name do
        memory.writebyte(pokemonPointer+i+cfg.pokemonNicknameOffset-1, cfg.chars[string.upper(input.name:sub(i,i))])
    end
    memory.writebyte(pokemonPointer+cfg.pokemonNicknameOffset+#input.name, 0xFF)
    
    -- Write the species name
    for i=1,#input.name do
        memory.writebyte(cfg.pokemonNamesPointer + (cfg.pokemonNameSize+1)*nextPokemonId + i-1, cfg.chars[string.upper(input.name:sub(i,i))])
    end
    memory.writebyte(cfg.pokemonNamesPointer + (cfg.pokemonNameSize+1)*nextPokemonId + #input.name, 0xFF)
    
    -- write the base stats
    InputConverter.convertBaseStats(input, baseStats)
    for i=1,#baseStats do
        memory.writebyte(cfg.baseStatsPointer + (nextPokemonId-1)*cfg.baseStatsSize + i-1, baseStats[i])
    end
    
    -- remove old moves learnable
    local oldMovesLearnableAddress = memory.readdword(cfg.movesetPointers+nextPokemonId*4)
    local currentByte = 0
    while currentByte ~= 0xFF do
        memory.writebyte(oldMovesLearnableAddress, 0xFF)
        oldMovesLearnableAddress = oldMovesLearnableAddress + 1
        currentByte = memory.readbyte(oldMovesLearnableAddress)
    end
    
    -- write the moves learnable
    local newMovesLearnableAddress = findEmptySpace(#input.moveset*2+1)
    for i=1,#input.moveset do
        memory.writebyte(newMovesLearnableAddress + (i-1)*2, input.moveset[i][2])
        memory.writebyte(newMovesLearnableAddress + (i-1)*2 + 1, input.moveset[i][1])
    end
    memory.writebyte(newMovesLearnableAddress + #input.moveset*2, 0xFF)
    memory.writedword(cfg.movesetPointers+nextPokemonId*4, newMovesLearnableAddress)
    
    -- remove old image
    -- todo. For now, I should just keep track of how large each sprite is and remove that. Calculating the size of the sprite on the fly is hard
    
    -- write the image
    local baseImageAddress = findEmptySpace(#input.image)
    for i=1,#input.image do
        memory.writebyte(baseImageAddress+i-1, input.image[i])
    end
    memory.writedword(cfg.frontSpritePointer+nextPokemonId*8, baseImageAddress)
    memory.writedword(cfg.backPalettePointer+nextPokemonId*8, baseImageAddress)
    
    -- write the palette
    local basePaletteAddress = memory.readdword(cfg.frontPalettePointer+nextPokemonId*8)
    for i=1,#input.palette do
        memory.writebyte(basePaletteAddress+i-1, input.palette[i])
    end
    
    -- write the icon
    local baseIconAddress = memory.readdword(cfg.iconPointers+nextPokemonId*4)
    for i=0,#input.icon*2-1 do
        memory.writebyte(baseIconAddress+i, input.icon[i%#input.icon+1])
    end
end

-- xor a table of bytes with a double word repeatedly
function xor(byteTable, val)
    valTable = {
        bit.band(val,0xFF),
        bit.ror(bit.band(val,bit.rol(0xFF,8)), 8),
        bit.ror(bit.band(val,bit.rol(0xFF,16)), 16),
        bit.ror(bit.band(val,bit.rol(0xFF,24)), 24)
    }
    ret = {}
    for i=1,#byteTable do
        ret[i] = bit.bxor(byteTable[i], bit.bxor(valTable[(i-1)%4+1]))
    end
    return ret
end

function calculateChecksum(unencryptedData)
    sum = 0
    for i=1,#unencryptedData do
        for j=1,#unencryptedData[i],2 do
            sum = sum +
                unencryptedData[i][j] +
                unencryptedData[i][j+1]*0x100
        end
    end
    return bit.band(sum, 0xFFFF)
end

function indexOf(table, val)
    for i=1,#table do
        if table[i] == val then
            return i
        end
    end
    return 0
end

function findEmptySpace(length)
    emptyByteCount = 0
    
    offset = cfg.romStartAddress
    while offset < cfg.romEndAddress do
        if memory.readbyte(offset) == 0xFF then
            if emptyByteCount == length + 2*cfg.surroundingBlankSpace then
                return offset - emptyByteCount + cfg.surroundingBlankSpace
            end
            emptyByteCount = emptyByteCount + 1
            offset = offset + 1
        else
            emptyByteCount = 0
            offset = offset + 4-(offset%4)
        end
    end
    print('no empty space found!')
end

M.writePokemon = writePokemon
return M