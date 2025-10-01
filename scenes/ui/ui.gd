extends CanvasLayer

@onready var money_label: Label = $MoneyLabel

func _ready() -> void:
	SignalBus.money_updated.connect(on_money_updated) 

func on_money_updated(money: int): 
	money_label.text = "Money: %d" % money
