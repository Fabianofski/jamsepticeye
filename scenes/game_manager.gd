extends Node3D 

var money: int = 0

func _ready():
	SignalBus.add_money.connect(on_add_money)
	SignalBus.ran_out_of_fuel.connect(on_game_over)
	SignalBus.ran_out_of_durability.connect(on_game_over)

func on_add_money(amount: int): 
	money += amount
	SignalBus.money_updated.emit(money)

func on_game_over(): 
	get_tree().reload_current_scene()
