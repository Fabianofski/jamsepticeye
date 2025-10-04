extends Node3D 

var money: float = 100 
var current_lawn_mower: LawnMower
var current_lawn_mower_index: int = 0
var current_round_earnings: float = 0
var game_started = false
var game_paused = false

var player_node: Node3D

var tutorial_stage: Tutorial.Stage

func _ready():
	SignalBus.add_money.connect(on_add_money)
	SignalBus.remove_money.connect(on_remove_money)
	SignalBus.game_over.connect(on_game_over)
	SignalBus.game_started.connect(start_game)
	SignalBus.reset_game.connect(reset_game)

func on_add_money(amount: int): 
	money += amount
	current_round_earnings += amount
	SignalBus.money_updated.emit(money)

func on_remove_money(amount: int): 
	money -= amount
	SignalBus.money_updated.emit(money)

func on_game_over(_message: String): 
	game_started = false 

func reset_game():
	current_round_earnings = 0

func start_game(): 
	await get_tree().create_timer(1).timeout
	game_started = true

func set_lawn_mower(mower: LawnMower): 
	current_lawn_mower = mower 
	SignalBus.mower_updated.emit(mower)
