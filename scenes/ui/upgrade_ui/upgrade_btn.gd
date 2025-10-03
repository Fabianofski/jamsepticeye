extends Button 

@export var upgrade_type: Upgrades.UpgradeType 
@onready var label: Label = $Label
var upgrades : Upgrades
var upgrade_info : UpgradeInfo 

func _ready():
	SignalBus.money_updated.connect(update_button)
	pressed.connect(buy_upgrade)
	SignalBus.mower_updated.connect(set_lawn_mower)

func update_button(amount: int): 
	disabled = amount < upgrade_info.base_price or upgrade_info.bought >= upgrade_info.max_bought 
	label.text = "%s %d$ %d/%d" % [Upgrades.UpgradeType.keys()[upgrade_type], upgrade_info.base_price ,upgrade_info.bought, upgrade_info.max_bought]

func set_lawn_mower(mower: LawnMower):
	upgrades = mower.upgrades
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
		_:
			pass
	upgrade_info.bought += 1

	SignalBus.remove_money.emit(upgrade_info.base_price)
	SignalBus.upgrades_updated.emit(upgrades)
