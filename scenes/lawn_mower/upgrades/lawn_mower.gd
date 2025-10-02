extends Resource 
class_name LawnMower

@export var stats: LawnMowerStats
@export var mesh: PackedScene
var upgrades: Upgrades = Upgrades.new()

@export var speed_upgrade_info = UpgradeInfo.new()
@export var durability_upgrade_info = UpgradeInfo.new() 
@export var fuel_tank_upgrade_info = UpgradeInfo.new()
@export var fuel_efficiency_upgrade_info = UpgradeInfo.new() 

var upgrade_infos: Dictionary[Upgrades.UpgradeType, UpgradeInfo]

func _init(): 
	upgrade_infos[Upgrades.UpgradeType.SPEED] = speed_upgrade_info
	upgrade_infos[Upgrades.UpgradeType.DURABILITY] = durability_upgrade_info
	upgrade_infos[Upgrades.UpgradeType.FUELTANK] = fuel_tank_upgrade_info
	upgrade_infos[Upgrades.UpgradeType.FUELEFFICIENCY] = fuel_efficiency_upgrade_info



