extends Button 

@export var upgrade_type: Upgrades.UpgradeType 
@onready var label: Label = $Label
@onready var progress: TextureProgressBar = $TextureProgressBar
@onready var chaching: AudioStreamPlayer = $Chaching
var upgrades : Upgrades
var stats: LawnMowerStats
var upgrade_info : UpgradeInfo 
var before_preview_durability: int = 0

func _ready():
	pressed.connect(buy_upgrade)
	mouse_entered.connect(func(): increase_upgrade(true))
	mouse_exited.connect(func(): decrease_upgrade())
	SignalBus.mower_updated.connect(set_lawn_mower)
	SignalBus.money_updated.connect(update_button)

func update_button(amount: float): 
	var max_upgrades_bought = upgrade_info.bought >= upgrade_info.max_bought 
	var not_enough_money = amount < upgrade_info.price

	var max_durability = upgrades.calculate_value(stats.base_durability, Upgrades.UpgradeType.DURABILITY)
	var durability_full = stats.get_durability() == max_durability

	var upgrade_name = Upgrades.UpgradeType.keys()[upgrade_type]

	if upgrade_type == Upgrades.UpgradeType.REPAIR:
		disabled = durability_full or not_enough_money
		label.text = "%s - %d$" % [upgrade_name, upgrade_info.price]
		progress.value = 0
	else: 
		disabled = not_enough_money or max_upgrades_bought
		label.text = "%s - %d$ (%d/%d)" % [upgrade_name, upgrade_info.price ,upgrade_info.bought, upgrade_info.max_bought]
		progress.value = float(upgrade_info.bought) / upgrade_info.max_bought



func set_lawn_mower(mower: LawnMower):
	upgrades = mower.upgrades
	stats = mower.stats
	upgrade_info = mower.get_upgrade_info(upgrade_type)
	if upgrade_info.price == null:
		upgrade_info.price = upgrade_info.base_price
	update_button(GameManager.money)

	if !mower.unlocked: 
		disabled = true

func increase_upgrade(preview: bool): 
	var max_upgrades_bought = upgrade_info.bought >= upgrade_info.max_bought 
	if max_upgrades_bought: 
		return
	before_preview_durability = stats.current_durability

	match upgrade_type:
		Upgrades.UpgradeType.SPEED:
			print("Upgrade Speed")
			upgrades.speed_upgrades += upgrade_info.amount
		Upgrades.UpgradeType.DURABILITY: 
			print("Upgrade Durability")
			upgrades.durability_upgrades += upgrade_info.amount
			var max_durability = upgrades.calculate_value(stats.base_durability, Upgrades.UpgradeType.DURABILITY)
			stats.current_durability = max_durability
			SignalBus.durability_updated.emit(stats.get_durability() / max_durability)
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

	if preview: 
		SignalBus.upgrades_updated.emit(upgrades)

func decrease_upgrade(): 
	var max_upgrades_bought = upgrade_info.bought >= upgrade_info.max_bought 
	if max_upgrades_bought: 
		return
	match upgrade_type:
		Upgrades.UpgradeType.SPEED:
			upgrades.speed_upgrades -= upgrade_info.amount
		Upgrades.UpgradeType.DURABILITY: 
			upgrades.durability_upgrades -= upgrade_info.amount
		Upgrades.UpgradeType.FUELTANK:
			upgrades.fuel_tank_upgrades -= upgrade_info.amount
		Upgrades.UpgradeType.FUELEFFICIENCY:
			upgrades.fuel_efficiency_upgrades -= upgrade_info.amount

	stats.current_durability = before_preview_durability
	var max_durability = upgrades.calculate_value(stats.base_durability, Upgrades.UpgradeType.DURABILITY)
	SignalBus.durability_updated.emit(stats.get_durability() / max_durability)

	SignalBus.upgrades_updated.emit(upgrades)

func buy_upgrade(): 
	chaching.play()
	increase_upgrade(false)
	upgrade_info.bought += 1

	var price = upgrade_info.price
	upgrade_info.price = round(price * upgrade_info.price_increase)

	SignalBus.remove_money.emit(price)
	SignalBus.upgrades_updated.emit(upgrades)
