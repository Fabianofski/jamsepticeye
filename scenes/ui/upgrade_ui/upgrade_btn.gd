extends Button 

@export var upgrade_type: Upgrades.UpgradeType 
@export var price: int = 10

func _ready():
	SignalBus.money_updated.connect(func(amount): 
		disabled = amount < price
	)
	pressed.connect(buy_upgrade)

func buy_upgrade(): 
	SignalBus.remove_money.emit(price)
	GameManager.current_lawn_mower.upgrades.speed_upgrades += 1
	SignalBus.upgrades_updated.emit(GameManager.current_lawn_mower.current_upgrades)
