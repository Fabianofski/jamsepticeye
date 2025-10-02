extends Resource 
class_name LawnMower

@export var stats: LawnMowerStats
@export var mesh: PackedScene
var upgrades: Upgrades = Upgrades.new()
@export var upgrade_infos: Array[UpgradeInfo]

