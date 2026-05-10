class_name SaverLoader
extends Node

#@onready var store_inventory = $".."
@export var store_inventory : Node2D

func new_game():
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	var saved_data = {}
	
	var store_items = {
		"unlocked_colors": [],
		"unlocked_shirts": [],
		"unlocked_pants": [],
		"unlocked_shoes": [],
		"unlocked_shirt_designs": [],
	}
	saved_data["store_items"] = store_items
	var store_display = {
		"0": {
			"shirts": null,
			"pants": null,
			"shoes": null,
			"shirt_designs": null,
		}
	}
	saved_data["store_display"] = store_display
	var player = {
		"money": null,
		"appearance": null
	}
	saved_data["player"] = player
	
	file.store_var(saved_data)
	file.close()

func save_game():
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	var saved_data = {}
	
	var store_items = {
		"unlocked_colors": store_inventory.unlocked_colors,
		"unlocked_shirts": store_inventory.unlocked_shirts,
		"unlocked_pants": store_inventory.unlocked_pants,
		"unlocked_shoes": store_inventory.unlocked_shoes,
		"unlocked_shirt_designs": store_inventory.unlocked_shirt_designs,
	}
	saved_data["store_items"] = store_items
	var store_display = {
		"0": {
			"shirts": null,
			"pants": null,
			"shoes": null,
			"shirt_designs": null,
		}
	}
	saved_data["store_display"] = store_display
	var player = {
		"money": null,
		"appearance": null
	}
	saved_data["player"] = player
	
	file.store_var(saved_data)
	file.close()
	
func load_game():
	var file = FileAccess.open("user://savegame.data", FileAccess.READ)
	var saved_data = file.get_var()
	
#	TODO: load saved data to appropriate variables
	store_inventory.unlocked_colors = saved_data["store_items"]["unlocked_colors"] 
	store_inventory.unlocked_shirts = saved_data["store_items"]["unlocked_shirts"]
	store_inventory.unlocked_pants = saved_data["store_items"]["unlocked_pants"]
	store_inventory.unlocked_shoes = saved_data["store_items"]["unlocked_shoes"] 
	store_inventory.unlocked_shirt_designs = saved_data["store_items"]["unlocked_shirt_designs"]
	
	file.close()
