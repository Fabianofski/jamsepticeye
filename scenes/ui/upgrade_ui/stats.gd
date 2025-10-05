extends Control

@onready var stats_slider = preload("res://scenes/ui/upgrade_ui/stats_slider.tscn")

var current_mower: LawnMower
@export var best_mower: LawnMower
var sliders = {}

func _ready():
	SignalBus.mower_updated.connect(set_lawn_mower)
	SignalBus.upgrades_updated.connect(func(_x): set_lawn_mower(GameManager.current_lawn_mower))

func set_lawn_mower(mower: LawnMower):
	current_mower = mower
	var stats: LawnMowerStats = mower.stats
	var upgrades = mower.upgrades

	var best_stats: LawnMowerStats = best_mower.stats

	var slider_data = {
		"Speed: %d km/h": { 
			"value": stats.base_max_speed * upgrades.speed_upgrades,
			"max_value": best_stats.base_max_speed * best_mower.speed_upgrade_info.max_bought
		},
		"Acceleration: %d m2/s": { 
			"value": stats.acceleration,
			"max_value": best_stats.acceleration,
		},
		"Durability: %d points": {
			"value": stats.base_durability * upgrades.durability_upgrades,
			"max_value": best_stats.base_durability * best_mower.durability_upgrade_info.max_bought, 
		},
		"Fuel Tank: %d litres": { 
			"value": stats.base_max_fuel * upgrades.fuel_tank_upgrades,
			"max_value": best_stats.base_max_fuel * best_mower.fuel_tank_upgrade_info.max_bought, 
		},
		"Fuel Efficiency: %.1f litres/second":{ 
			"value":  stats.base_fuel_consum * upgrades.fuel_efficiency_upgrades, 
			"max_value": best_stats.base_fuel_consum,
		}
	}

	for key in slider_data.keys():
		var slider_instance = sliders.get(key)
		if slider_instance == null:
			slider_instance = stats_slider.instantiate()
		var label: Label = slider_instance.get_node("Label")
		var slider: Slider = slider_instance.get_node("Slider")

		var value = slider_data[key]["value"]
		label.text = key % value
		slider.value = value
		slider.max_value = slider_data[key]["max_value"]

		if !sliders.has(key): 
			add_child(slider_instance)
			sliders[key] = slider_instance
