local obj={}

obj.chars = {
    ["A"]=0xBB,
    ["B"]=0xBC,
    ["C"]=0xBD,
    ["D"]=0xBE,
    ["E"]=0xBF,
    ["F"]=0xC0,
    ["G"]=0xC1,
    ["H"]=0xC2,
    ["I"]=0xC3,
    ["J"]=0xC4,
    ["K"]=0xC5,
    ["L"]=0xC6,
    ["M"]=0xC7,
    ["N"]=0xC8,
    ["O"]=0xC9,
    ["P"]=0xCA,
    ["Q"]=0xCB,
    ["R"]=0xCC,
    ["S"]=0xCD,
    ["T"]=0xCE,
    ["U"]=0xCF,
    ["V"]=0xD0,
    ["W"]=0xD1,
    ["X"]=0xD2,
    ["Y"]=0xD3,
    ["Z"]=0xD4
}

-- pokemon data structure http://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9mon_data_substructures_in_Generation_III
G = 1
A = 2
E = 3
M = 4
obj.G = G
obj.A = A
obj.E = E
obj.M = M
obj.substructureOrders = {
    [0] = {G,A,E,M},
    [1] = {G,A,M,E},
    [2] = {G,E,A,M},
    [3] = {G,E,M,A},
    [4] = {G,M,A,E},
    [5] = {G,M,E,A},
    [6] = {A,G,E,M},
    [7] = {A,G,M,E},
    [8] = {A,E,G,M},
    [9] = {A,E,M,G},
    [10] = {A,M,G,E},
    [11] = {A,M,E,G},
    [12] = {E,G,A,M},
    [13] = {E,G,M,A},
    [14] = {E,A,G,M},
    [15] = {E,A,M,G},
    [16] = {E,M,G,A},
    [17] = {E,M,A,G},
    [18] = {M,G,A,E},
    [19] = {M,G,E,A},
    [20] = {M,A,G,E},
    [21] = {M,A,E,G},
    [22] = {M,E,G,A},
    [23] = {M,E,A,G}
}

obj.wildPokemonBattleFunction = 0x08010672

obj.startWildBattle = 0
obj.startTrainerBattle = 8
obj.battleTypePointer = 0x02022B4C
obj.fileName = '\\\\.\\pipe\\doomred'
obj.pokemonDataOffset = 32
obj.pokemonChecksumOffset = 28
obj.pokemonNicknameOffset = 8
obj.enemyPokemonPointers = {
    0x0202402C, 0x02024090, 0x020240F4, 0x02024158, 0x020241BC, 0x02024220
}

--obj.pokemonNamesPointer = 0x08245F5B
obj.pokemonNamesPointer = 0x08245EE0
obj.pokemonNameSize = 10
obj.baseStatsOffset = 0x082111A8
obj.baseStatsSize = 28
obj.frontSpritePointer = 0x082350AC
obj.backSpritePointer = 0x0823654C
obj.frontPalettePointer = 0x0823730C
obj.backPalettePointer = 0x082380CC
obj.iconPointers = 0x083D37A0
obj.iconPalettes = 0x083D3E80
obj.cries = 0x0848C914
obj.tmsLearnable = 0x08252bc8
obj.movesets =  0x08257494


return obj