extends Node2D

var availableColors = ["ffffff", "d11b00", "ff5d00", "ff9200", "ffcf00", "ffdf4f", "b3ff00", "d1ffae", "007e00", "005600", "5f8151", "bdffff", "00d9ff", "0091ff", "0047ff", "ffc0ff", "ff63ff", "771f6e", "544f54", "353135", "c8bec9"]

func _ready():
	instantiateColorButtons()
	
func instantiateColorButtons():
	for color in availableColors:
		var button = $CanvasLayer/GridContainer/ColorButton.duplicate()
		var stylebox = button.get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = Color("#" + color)
		button.add_theme_stylebox_override("normal", stylebox)
		$CanvasLayer/GridContainer.add_child(button)
		button.name = color
		button.pressed.connect(changeColor.bind(color))
		
#	Hide the template button now that we have finished adding buttons. 
	$CanvasLayer/GridContainer/ColorButton.visible = false

func changeColor(color):
	$CanvasLayer/DogCharacter.find_child("Shirt").frame = availableColors.find(color)
	
