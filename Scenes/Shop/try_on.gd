extends Node2D

var availableColors = ["ffffff", "d11b00", "ff5d00", "ff9200", "ffcf00", "ffdf4f", "b3ff00", "d1ffae", "007e00", "005600", "5f8151", "bdffff", "00d9ff", "0091ff", "0047ff", "ffc0ff", "ff63ff", "771f6e", "544f54", "353135", "c8bec9"]
var dogTypes = ["corgi", "lab", "pom"]

@onready var modelSelectionTemplateButton = $"CanvasLayer/Model Selection/TemplateDog"
@onready var colorTemplateButton = $"CanvasLayer/Color Selection/ColorButton"

func _ready():
	instantiateDogModelButtons()
	instantiateColorButtons()
	
func instantiateDogModelButtons():
	for dog in dogTypes:
		var dogModelButton = modelSelectionTemplateButton.duplicate()
		var dogTexture = "res://Art/Characters/" + dog + "Head.png"
		if ResourceLoader.exists(dogTexture):
			dogModelButton.texture_normal = load(dogTexture)
			modelSelectionTemplateButton.add_sibling(dogModelButton)
			dogModelButton.name = dog
			dogModelButton.pressed.connect(changeModel.bind(dog))
		
		else:
			print("Error: " + dogTexture + " does not exist!")
			
	modelSelectionTemplateButton.visible = false

func instantiateColorButtons():
	
	for color in availableColors:
		var button = colorTemplateButton.duplicate()
		var stylebox = button.get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = Color("#" + color)
		button.add_theme_stylebox_override("normal", stylebox)
		colorTemplateButton.add_sibling(button)
		button.name = color
		button.pressed.connect(changeColor.bind(color))
		
#	Hide the template button now that we have finished adding buttons. 
	colorTemplateButton.visible = false

func changeColor(color):
	$CanvasLayer/DogCharacter.find_child("Shirt").frame = availableColors.find(color)
	$CanvasLayer/DogCharacter.find_child("Pants").frame = 63 + availableColors.find(color)
	$CanvasLayer/DogCharacter.find_child("Shoes").frame = 105 + availableColors.find(color)
	
func changeModel(dogType):
	$CanvasLayer/DogCharacter.find_child("Head").frame = dogTypes.find(dogType)
	$CanvasLayer/DogCharacter.find_child("Body").frame = dogTypes.find(dogType)
	
