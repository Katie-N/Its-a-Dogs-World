class_name ShopInventory
extends Node2D

# ----SAVE DATA----

# These lists contain the identifiers of the unlocked items.
# Unlocked colors will have the string names of the colors as that is how they're identified.
# The unlocked sprites are identified by their row index in the master spritesheet.
var unlocked_colors = []
var unlocked_shirts = []
var unlocked_pants = []
var unlocked_shoes = []
var unlocked_shirt_designs = []

# As the cost of things will change as the game progresses, we need to keep this array as save data
var cost = {
	"color": 0, # For now, make it all free
	"clothes": 0
}

# -----------------

func addToList(itemName, unlockedArray):
	unlockedArray.append(itemName)
	print(itemName + " has been added to " + unlockedArray)
