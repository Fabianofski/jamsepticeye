extends Resource 
class_name LawnMower

@export var unlocked: bool = false
@export var price: int = 100
@export var stats: LawnMowerStats
@export var mesh: PackedScene
var upgrades: Upgrades = Upgrades.new()

@export var speed_upgrade_info : UpgradeInfo
@export var durability_upgrade_info : UpgradeInfo
@export var fuel_tank_upgrade_info : UpgradeInfo
@export var fuel_efficiency_upgrade_info : UpgradeInfo

func get_upgrade_info(upgrade_type: Upgrades.UpgradeType) -> UpgradeInfo: 
	match upgrade_type: 
		Upgrades.UpgradeType.SPEED: 
			return speed_upgrade_info
		Upgrades.UpgradeType.DURABILITY: 
			return durability_upgrade_info
		Upgrades.UpgradeType.FUELTANK:
			return fuel_tank_upgrade_info
		Upgrades.UpgradeType.FUELEFFICIENCY: 
			return fuel_efficiency_upgrade_info

	return null

