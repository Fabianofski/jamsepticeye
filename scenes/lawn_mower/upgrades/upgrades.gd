class_name Upgrades
enum UpgradeType { REPAIR, SPEED, DURABILITY, FUELTANK, FUELEFFICIENCY}

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

func calculate_value(base: float, upgrade_type: UpgradeType) -> float: 
	match upgrade_type:
		UpgradeType.SPEED:
			return base * speed_upgrades
		UpgradeType.DURABILITY: 
			return base * durability_upgrades
		UpgradeType.FUELTANK:
			return base * fuel_tank_upgrades
		UpgradeType.FUELEFFICIENCY:
			return base * fuel_efficiency_upgrades
	return 0
