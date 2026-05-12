extends Control

func _ready() -> void:
	var i = 0
	for button in $HBoxContainer.get_children():
		button.connect("pressed", selectSave.bind(i))
		button.get_node("Delete").connect("pressed", deleteSave.bind(i))
		if SaverLoader.save_exists(i):
			button.text = "Load save " + str(i+1)
			button.get_node("Delete").visible = true
		else:
			button.text = "New Save"
			
		i += 1
		
func selectSave(saveNum):
	SaverLoader.load_game(saveNum)
	get_tree().change_scene_to_file("res://Scenes/Shop/shop.tscn")

func deleteSave(saveNum):
	SaverLoader.delete_save(saveNum)
	$HBoxContainer.find_child("Save" + str(saveNum)).text = "New Save"
	$HBoxContainer.find_child("Save" + str(saveNum)).get_node("Delete").visible = false
