extends Node3D 

var fuel_consum: float
var fuel: float
var max_fuel: float
@onready var controller: LawnMowerController = $".."

func _ready() -> void:
	SignalBus.add_fuel.connect(func(amount): 
		fuel += amount
		fuel = clampf(fuel, 0, max_fuel)
		SignalBus.fuel_updated.emit(fuel/max_fuel)
	)
	SignalBus.remove_fuel.connect(func(amount): 
		fuel -= amount
		SignalBus.fuel_updated.emit(fuel/max_fuel)
	)
	SignalBus.upgrades_updated.connect(update_upgrades)

func update_upgrades(upgrades: Upgrades):
	var stats = controller.stats

	max_fuel = upgrades.calculate_value(stats.base_max_fuel, Upgrades.UpgradeType.FUELTANK)
	fuel_consum = upgrades.calculate_value(stats.base_fuel_consum, Upgrades.UpgradeType.FUELEFFICIENCY)
	fuel = max_fuel
	SignalBus.fuel_updated.emit(fuel/max_fuel)

func _process(delta: float) -> void:
	if not GameManager.game_started or GameManager.game_paused or !controller.throttle:  
		return	

	var _fuel_consum = fuel_consum if !controller.boosting else 2*fuel_consum
	fuel -= _fuel_consum * delta
	SignalBus.fuel_updated.emit(fuel / max_fuel)
	if fuel <= 0: 
		SignalBus.game_over.emit("Ran out of fuel!")

