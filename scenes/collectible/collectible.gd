extends RigidBody3D

enum PopupType { FUEL, MONEY, DURABILITY}

@export var money_amount = 10
@export var destructible = true 
@export var damage = 1.0
@export var fuel_amount = 0
@export var popup_type: PopupType = PopupType.MONEY

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D):
	if body.is_in_group("LawnMower"):
		if destructible: 
			queue_free()
		if money_amount > 0:
			SignalBus.add_money.emit(money_amount)
		if fuel_amount > 0:
			SignalBus.add_fuel.emit(fuel_amount)

		body.take_damage(damage)
		
		var popup_value
		match popup_type:
			PopupType.MONEY:
				popup_value = money_amount
			PopupType.DURABILITY:
				popup_value = damage
			PopupType.FUEL:
				popup_value = fuel_amount
		SignalBus.ui_popup_called.emit(popup_type, popup_value, self.position)
