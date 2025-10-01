extends Node3D 

var money: int = 0

func _ready():
	SignalBus.add_money.connect(on_add_money)
	SignalBus.ran_out_of_fuel.connect(on_ran_out_of_fuel)

func on_add_money(amount: int): 
	money += amount
	SignalBus.money_updated.emit(money)

func on_ran_out_of_fuel(): 
	get_tree().reload_current_scene()
