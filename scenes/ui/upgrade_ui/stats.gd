extends Control

@onready var stats_slider = preload("res://scenes/ui/upgrade_ui/stats_slider.tscn")

var current_mower: LawnMower
var sliders = {}

func _ready():
	SignalBus.mower_updated.connect(set_lawn_mower)
	SignalBus.upgrades_updated.connect(func(_x): set_lawn_mower(GameManager.current_lawn_mower))

func set_lawn_mower(mower: LawnMower):
	current_mower = mower
	var stats: LawnMowerStats = mower.stats
	var upgrades = mower.upgrades

	var slider_data = {
		"Speed %d km/h": stats.base_max_speed * upgrades.speed_upgrades,
		"Acceleration %d m2/s": stats.acceleration,
		"Durability %d points": stats.base_durability * upgrades.durability_upgrades,
		"Fuel Tank %d liters": stats.base_max_fuel * upgrades.fuel_tank_upgrades,
		"Fuel Efficiency %d liters/second": stats.base_fuel_consum * upgrades.fuel_efficiency_upgrades
	}

	for key in slider_data.keys():
		var slider_instance = sliders.get(key)
		if slider_instance == null:
			slider_instance = stats_slider.instantiate()
		var label: Label = slider_instance.get_node("Label")
		var slider: Slider = slider_instance.get_node("Slider")

		label.text = key % slider_data[key]
		slider.value = slider_data[key]

		if !sliders.has(key): 
			add_child(slider_instance)
			sliders[key] = slider_instance
