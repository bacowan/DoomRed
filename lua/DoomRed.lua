PokemonWriter = require 'PokemonWriter'
PokemonChanges = require 'PokemonChanges'
container = require 'UsedPokemonContainer'
cfg = require 'cfg'

currentBattleType = 0

usedPokemonContainer = container.UsedPokemonContainer:new{}

function readPipe()
    f = io.open(cfg.fileName, 'r')
    io.input(f)
    return io.read()
end

function initializePokemon(pokemonPointer)
    input = readPipe()
    if input == "0" then
        return
    end
    
    local nextPokemon = usedPokemonContainer:nextPokemon()
    pokemonChanges = PokemonChanges.PokemonChanges:new(input)
    PokemonWriter.writePokemon(pokemonChanges, pokemonPointer, nextPokemon)
end

function battleStarting()
    battleType = memory.readbyte(cfg.battleTypePointer)
    if battleType ~= currentBattleType and currentBattleType == 0 or currentBattleType == 8 then
        currentBattleType = battleType
        return true
    end
    currentBattleType = battleType
    return false
end

function tablesEqual(t1,t2)
    if (#t1~=#t2) then return false end
    for i=1,#t1 do
        if (t1[i] ~= t2[i]) then
            return false
        end
    end
    return true
end

function getPokemonCount()
    for i=1,6 do
        nickname = memory.readbyterange(cfg.enemyPokemonPointers[i]+cfg.pokemonNicknameOffset,10)
        if (tablesEqual(nickname,{0,0,0,0,0,0,0,0,0,0})) then return i-1 end
    end
    return 6
end

function run()
    print 'battle start'
    pokemonCount = getPokemonCount()
    for i=1,pokemonCount do
        initializePokemon(cfg.enemyPokemonPointers[i])
    end
end

function onFrame()
    if battleStarting() then
        run()
    end
end

print('script started')
memory.registerexec(cfg.wildPokemonBattleFunction,run)
