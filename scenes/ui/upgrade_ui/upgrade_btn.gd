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
	disabled = amount < upgrade_info.base_price 

func set_lawn_mower(mower: LawnMower):
	upgrades = mower.upgrades
	upgrade_info = mower.upgrade_infos[upgrade_type]
	update_button(GameManager.money)

	label.text = "%s %d$ %d/%d" % [Upgrades.UpgradeType.keys()[upgrade_type], upgrade_info.base_price ,upgrade_info.bought, upgrade_info.max_bought]

func buy_upgrade(): 
	SignalBus.remove_money.emit(upgrade_info.base_price)

	match upgrade_type:
		Upgrades.UpgradeType.SPEED:
			upgrades.speed_upgrades += upgrade_info.amount
		_:
			pass

	SignalBus.upgrades_updated.emit(upgrades)
