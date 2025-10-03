extends Button 

@export var upgrade_type: Upgrades.UpgradeType 
@onready var label: Label = $Label
var upgrades : Upgrades
var stats: LawnMowerStats
var upgrade_info : UpgradeInfo 

func _ready():
	SignalBus.money_updated.connect(update_button)
	pressed.connect(buy_upgrade)
	SignalBus.mower_updated.connect(set_lawn_mower)

func update_button(amount: int): 
	disabled = amount < upgrade_info.price or upgrade_info.bought >= upgrade_info.max_bought 

	var max_durability = upgrades.calculate_value(stats.base_durability, Upgrades.UpgradeType.DURABILITY)
	if upgrade_type == Upgrades.UpgradeType.REPAIR and stats.get_durability() == max_durability:
		disabled = true

	label.text = "%s %d$ %d/%d" % [Upgrades.UpgradeType.keys()[upgrade_type], upgrade_info.price ,upgrade_info.bought, upgrade_info.max_bought]

func set_lawn_mower(mower: LawnMower):
	upgrades = mower.upgrades
	stats = mower.stats
	upgrade_info = mower.get_upgrade_info(upgrade_type)
	update_button(GameManager.money)

	if !mower.unlocked: 
		disabled = true

func buy_upgrade(): 
	match upgrade_type:
		Upgrades.UpgradeType.SPEED:
			print("Upgrade Speed")
			upgrades.speed_upgrades += upgrade_info.amount
		Upgrades.UpgradeType.DURABILITY: 
			print("Upgrade Durability")
			upgrades.durability_upgrades += upgrade_info.amount
		Upgrades.UpgradeType.FUELTANK:
			print("Upgrade Fuel Tank by %f" % upgrade_info.amount)
			upgrades.fuel_tank_upgrades += upgrade_info.amount
		Upgrades.UpgradeType.FUELEFFICIENCY:
			print("Upgrade Fuel Efficiency")
			upgrades.fuel_efficiency_upgrades += upgrade_info.amount
		Upgrades.UpgradeType.REPAIR: 
			var max_durability = upgrades.calculate_value(stats.base_durability, Upgrades.UpgradeType.DURABILITY)
			stats.current_durability = max_durability
			SignalBus.durability_updated.emit(stats.get_durability() / max_durability)
		_:
			pass
	upgrade_info.bought += 1
	upgrade_info.price = upgrade_info.price * upgrade_info.price_increase

	SignalBus.remove_money.emit(upgrade_info.base_price)
	SignalBus.upgrades_updated.emit(upgrades)
