extends Node2D

# These are the dog breeds in the order they appear in the DogHeadSpritesheet.png/DogBodySpritesheet.png
var dogTypes = ["corgi", "lab", "pom"]
# If we want to grab the head texture from an AtlasTexture of DogHeadSpritesheet.png, we need to know how wide each sprite is. 
# Currently we just have the heads exported as {dogType}Head.png but if we want it a little more robust we will use this method
var dogWidth = 64

# Base clothing item options
# These are the hex values the clothing is offered in. It should match the same order as the ClothingSpritesheet.png sprites because the index will be used to identify which color was selected. 
var availableColors = ["ffffff", "d11b00", "ff5d00", "ff9200", "ffcf00", "ffdf4f", "b3ff00", "d1ffae", "007e00", "005600", "5f8151", "bdffff", "00d9ff", "0091ff", "0047ff", "ffc0ff", "ff63ff", "771f6e", "544f54", "353135", "c8bec9"]
var clothingTypes = ["shirts", "pants", "shoes"]
# Identify the row indices of each type of clothing that can only have one being worn at a time (you can wear a short sleeve shirt and boots at the same time but you can't wear pants at the same time as shorts).
# By using lists of indices, we are free to append new clothing items as new rows in the spritesheet and then we just add the row index to the corresponding list. 
# No need to keep shirts at the top, pants in the middle, and shoes at the bottom. 
var shirtRows = [0,1,2]
var pantsRows = [3,4]
var shoeRows = [5,6]
# Keep track of the width and height of each sprite so we can move our AtlasTexture region
var clothingWidth = 64
var clothingHeight = 75

@onready var modelSelectionTemplateButton = $"CanvasLayer/CustomizationOptions/Model Selection/TemplateDog"
@onready var colorTemplateButton = $"CanvasLayer/CustomizationOptions/Color Selection/ColorButton"
@onready var clothingItemTemplateButton = $"CanvasLayer/CustomizationOptions/Clothing Selection/ClothingItemButton"

func _ready():
	instantiateDogModelButtons()
	for clothingType in clothingTypes:
		instantiateClothingButtons(clothingType)
#	Start with the shirts tab selected
	clothingTypeSelected("shirts")
	instantiateColorButtons()
	
# DOG MODEL SELECTION GRID CODE

func instantiateDogModelButtons():
	for dog in dogTypes:
		var dogModelButton = modelSelectionTemplateButton.duplicate()
		var dogTexture = "res://Art/Characters/" + dog + "Head.png"
		if ResourceLoader.exists(dogTexture):
			dogModelButton.texture_normal = load(dogTexture)
			modelSelectionTemplateButton.get_parent().add_child(dogModelButton)
			dogModelButton.name = dog
			dogModelButton.pressed.connect(changeModel.bind(dog))
		else:
			print("Error: " + dogTexture + " does not exist!")
			
#	Hide the template button
	modelSelectionTemplateButton.visible = false

#	When a different dog is selected, change the model sprites
func changeModel(dogType):
	$CanvasLayer/DogCharacter.find_child("Head").frame = dogTypes.find(dogType)
	$CanvasLayer/DogCharacter.find_child("Body").frame = dogTypes.find(dogType)
	
	
# COLOR SELECTION GRID CODE

func instantiateColorButtons():
	for color in availableColors:
		var button = colorTemplateButton.duplicate()
		var stylebox = button.get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = Color("#" + color)
		button.add_theme_stylebox_override("normal", stylebox)
		colorTemplateButton.get_parent().add_child(button)
		button.name = color
		button.pressed.connect(changeColor.bind(color))
		
#	Hide the template button now that we have finished adding buttons. 
	colorTemplateButton.visible = false

# When a color button is clicked
func changeColor(color):
#	Check which article of clothing (short sleeve shirt, paw boots, etc) is currently selected and change the color of that
	$CanvasLayer/DogCharacter.find_child("Shirt").frame = availableColors.find(color)
	$CanvasLayer/DogCharacter.find_child("Pants").frame = 63 + availableColors.find(color)
	$CanvasLayer/DogCharacter.find_child("Shoes").frame = 105 + availableColors.find(color)
	
	
# CLOTHING SELECTION GRID CODE

func getClothingRows(clothing):
	var clothingItems
#	Grab the list of rows of the spritesheet corresponding to each clothing type. 
	match clothing:
		"shirts":
			clothingItems = shirtRows
		"pants":
			clothingItems = pantsRows
		"shoes":
			clothingItems = shoeRows
		_:
#			If the clothing is not in this list, we have a serious problem
			print("Error: Clothing type " + clothing + " not found")
			return null
			
	return clothingItems

func instantiateClothingButtons(clothing):
	var x = 0 # Since we want to just show the white clothing we will only use column 0 of the spritesheet (which is from x=0 to x=clothingWidth)
	var y
	var clothingItems = getClothingRows(clothing)
	
	if clothingItems == null:
		return
	
#	Loop through each type of article (as in, short sleeve, long sleeve, and tank top if clothing = shirt. Or pants and shorts if clothing = pants. Does not take color into consideration)
	for clothingItem in clothingItems:
		var clothingItemButton = clothingItemTemplateButton.duplicate(true)
		clothingItemButton.name = clothing + str(clothingItem)
		
#		Set the top pixel based on the current row and the height of the sprites.
		y = clothingItem * clothingHeight # Row 0 will have y = 0. Row 1 will have y = clothingItemHeight, etc.
		
#		Set the region of the spritesheet to cut out based on the origin and the width/height of the sprites.
		clothingItemButton.texture_normal.region = Rect2(x, y, clothingWidth, clothingHeight)
#		Godot has this weird thing where the textures will be shared if duplicating a node unless you explicitly duplicate that texture property. (See https://forum.godotengine.org/t/how-to-make-resource-unique-from-script/26977)
#		So this line just says make a static copy of how the texture is right now and reassign the texture to be this copy. Then later changes will affect the original texture but since none of the buttons are actually using the original texture (they are all using static copies) it won't matter. 
		clothingItemButton.texture_normal = clothingItemButton.texture_normal.duplicate()
		clothingItemTemplateButton.get_parent().add_child(clothingItemButton)

func clothingTypeSelected(clothing):
	var clothingRows = getClothingRows(clothing)
	# Set the number of columns to be at most 5	
	$"CanvasLayer/CustomizationOptions/Clothing Selection".columns = min(float(clothingRows.size()), 5.0)
	
	for child in $"CanvasLayer/CustomizationOptions/Clothing Selection".get_children():
		if child.name.contains(clothing):
			child.visible = true
		else:
			child.visible = false
			
