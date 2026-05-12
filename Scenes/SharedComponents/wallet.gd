extends Node2D
class_name Wallet

var money = 0

func add_money(amount : int):
	money += amount
	print("New Balance: " + str(money))

func subtract_money(amount : int):
	if amount > money:
		print("Insufficient Funds: " + str(amount) + " > current balance of " + str(money))
		return null
	else:
		money -= amount
		print("New Balance: " + str(money))
