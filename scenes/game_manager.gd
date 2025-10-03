extends Node3D 

var money: int = 100 
var current_lawn_mower: LawnMower
var current_lawn_mower_index: int = 0
var game_started = false

var player_node: Node3D

func _ready():
	SignalBus.add_money.connect(on_add_money)
	SignalBus.remove_money.connect(on_remove_money)
	SignalBus.game_over.connect(on_game_over)
	SignalBus.game_started.connect(start_game)

func on_add_money(amount: int): 
	money += amount
	SignalBus.money_updated.emit(money)

func on_remove_money(amount: int): 
	money -= amount
	SignalBus.money_updated.emit(money)

func on_game_over(_message: String): 
	game_started = false 
	get_tree().reload_current_scene()

func start_game(): 
	game_started = true

func set_lawn_mower(mower: LawnMower): 
	current_lawn_mower = mower 
	SignalBus.mower_updated.emit(mower)
