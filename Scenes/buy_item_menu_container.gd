extends Control

#These setters ensure that when the exported variables are updated, the text is automatically updated too
@export var itemName : String:
	set(value):
		itemName = value
		updateText()
@export var cost : int:
	set(value):
		cost = value
		updateText()

func updateText() -> void:
	$"Buy Item Menu/Label".text = "Do you want to buy " + str(itemName) + " for " + str(cost)

func _on_exit_menu_pressed() -> void:
	visible = false
	
func _on_cancel_pressed() -> void:
	visible = false
