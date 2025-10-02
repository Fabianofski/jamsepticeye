class_name Upgrades
enum UpgradeType { MOWERBASE, SPEED, DURABILITY, FUELTANK, FUELEFFICIENCY}

var speed_upgrades: float = 1
var durability_upgrades: float = 1 
var fuel_tank_upgrades: float = 1
var fuel_efficiency_upgrades: float = 1 

func _to_string() -> String:
	return "
        speed_upgrades %f
	    durability_upgrades %f
        fuel_tank_upgrades %f
        fuel_efficiency_upgrades %f
	" % [speed_upgrades, durability_upgrades, fuel_tank_upgrades, fuel_efficiency_upgrades]
