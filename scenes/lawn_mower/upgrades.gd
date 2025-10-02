class_name Upgrades
enum UpgradeType { MOWERBASE, SPEED, DURABILITY, FUELTANK, FUELEFFICIENCY}

var mower_base_upgrades: int = 1
var speed_upgrades: int = 1
var durability_upgrades: int = 1 
var fuel_tank_upgrades: int = 1
var fuel_efficiency_upgrades: int = 1 

func _to_string() -> String:
	return "
		mower_base_upgrades %d
        speed_upgrades %d
	    durability_upgrades %d
        fuel_tank_upgrades %d
        fuel_efficiency_upgrades %d
	" % [mower_base_upgrades, speed_upgrades, durability_upgrades, fuel_tank_upgrades, fuel_efficiency_upgrades]
