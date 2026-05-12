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
@export var unlockedArray : Array:
	set(value):
		unlockedArray = value
		updateText()
		
signal buy_successful

func updateText() -> void:
	$"Buy Item Menu/Label".text = "Do you want to buy " + str(itemName) + " for " + str(cost)

func _on_exit_menu_pressed() -> void:
	visible = false
	
func _on_cancel_pressed() -> void:
	visible = false

func _on_buy_pressed() -> void:
	unlockItem()
	visible = false

func unlockItem():
	if itemName in unlockedArray:
		print(itemName + " already unlocked... Something has gone wrong")
		return
	
#	Not sure if we want to grab the cost from the source of truth or rely on passing it from the try on page
	#GameDataManager.wallet.subtract_money(GameDataManager.shopInventory.cost[costKey])
	GameDataManager.wallet.subtract_money(cost)
	
#	By letting the shop inventory add the item to the array, we are letting it handle calling the saving function
	GameDataManager.shopInventory.addToList(itemName, unlockedArray)
	
#	After successfully buying the item, we will emit a signal so any updates from the other scenes can be made
#	For example, after buying a color, the TryOn scene will need to know about it so it can remove the lock button over that color.  
	buy_successful.emit(itemName)
	
#	Save after unlocking a new item
	#SaverLoader.save_game()
	
# When a locked item is clicked on, it will open the Buy Item Menu Container scene and wait for the user to either cancel or buy the item.
# itemName: the exact name that will be appended to the unlockedArray
# unlockedArray: a reference to one of the "unlocked_X" arrays in GameDataManger.shopInventory
# costKey: the key that will be searched in the GameDataManger.shopInventory.cost array to find the cost of the item.
# message: a special message that may be integrated later (not currently in use).
# Future idea: move this function to be in the buy_item_menu_container script. Like as an initializer/setter function. 
func setItemInfo(itemNamep, unlockedArrayp, costKeyp, messagep):
	itemName = itemNamep
	unlockedArray = unlockedArrayp
	cost = GameDataManager.shopInventory.cost[costKeyp]
	updateText()
	
func openMenu():
	visible = true
