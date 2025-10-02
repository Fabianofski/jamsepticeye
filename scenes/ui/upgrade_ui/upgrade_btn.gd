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
	GameManager.upgrades.speed_upgrades += 1
