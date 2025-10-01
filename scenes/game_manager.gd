extends Node3D 

var money: int = 0

func _ready():
	SignalBus.add_money.connect(on_add_money)

func on_add_money(amount: int): 
	money += amount
	SignalBus.money_updated.emit(money)
