extends CanvasLayer

@onready var money_label: Label = $MoneyLabel
@onready var fuel_label: Label = $FuelLabel

func _ready() -> void:
	SignalBus.money_updated.connect(on_money_updated) 
	SignalBus.fuel_updated.connect(on_fuel_updated) 
	on_money_updated(GameManager.money)

func on_money_updated(money: int): 
	money_label.text = "Money: %d" % money

func on_fuel_updated(fuel: float): 
	fuel_label.text = "Fuel: %d" % fuel
