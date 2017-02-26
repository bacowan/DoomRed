import csv
from downloadEmote import getEmote
import binascii

types = {
    "normal": 0,
    "fighting": 1,
    "flying": 2,
    "poison": 3,
    "ground": 4,
    "rock": 5,
    "bug": 6,
    "ghost": 7,
    "steel": 8,
    "???": 9,
    "fire": 10,
    "water": 11,
    "grass": 12,
    "electric": 13,
    "psychic": 14,
    "ice": 15,
    "dragon": 16,
    "dark": 17
}

movePPs = {}
attackCount = 354
abilityCount = 77
typesCount = 18

with open('movePPs.csv', 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        movePPs[row[0]] = row[1]

def formatInput(inputValue):
    output = ""
    # name
    for i in range(0,10):
        if len(inputValue['Name']) > i:
            output += inputValue['Name'][i]
        else:
            output += "\t"
    # attacks
    output += "{:0>3d}".format(int(inputValue['Attack1']))
    output += "{:0>3d}".format(int(inputValue['Attack2']))
    output += "{:0>3d}".format(int(inputValue['Attack3']))
    output += "{:0>3d}".format(int(inputValue['Attack4']))
    # PP
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack1']]))
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack2']]))
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack3']]))
    output += "{:0>3d}".format(int(movePPs[inputValue['Attack4']]))
    # Types
    output += "{:0>2d}".format(int(inputValue['Type1']))
    output += "{:0>2d}".format(int(inputValue['Type2']))
    # Abilities
    output += "{:0>2d}".format(int(inputValue['Ability']))
    # Gender
    output += inputValue['Gender']
    # Moves Learnable
    output += "{:0>2d}".format(len(inputValue['Moves Learnable']))
    for move in inputValue["Moves Learnable"]:
        output += "{:0>2d}".format(int(inputValue["Moves Learnable"][move]["'level'"]) - 1) # levels are 1-100, so 1 will have to be added on the other end
        output += "{:0>3d}".format(int(inputValue["Moves Learnable"][move]["'move'"]) - 1)
    # Image Palette and bytes
    palette, imageBytes, iconBytes = getEmote(inputValue['Image Link'])
    output += "{:0>3d}".format(palette.getbuffer().nbytes*2)
    output += binascii.hexlify(palette.getbuffer()).decode('utf-8')
    output += "{:0>4d}".format(imageBytes.getbuffer().nbytes*2)
    output += binascii.hexlify(imageBytes.getbuffer()).decode('utf-8')
    # Image Icon bytes
    output += "{:0>4d}".format(iconBytes.getbuffer().nbytes*2)
    output += binascii.hexlify(iconBytes.getbuffer()).decode('utf-8')

    return output