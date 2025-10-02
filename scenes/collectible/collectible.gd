extends RigidBody3D

@export var money_amount = 10
@export var destructible = true 
@export var hardness = 1.0
@export var fuel_amount = 0
@export var popup_type: String = "" ## Can be "money", "durability" or "fuel", or left empty for no popups on interaction.

func _ready() -> void:
	print("SDFSDFF")
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D):
	if body.is_in_group("LawnMower"):
		if destructible: 
			queue_free()
		if money_amount > 0:
			SignalBus.add_money.emit(money_amount)
		if fuel_amount > 0:
			pass # TODO: Consider fuel pickups that extend your timer.

		body.take_damage(hardness)
		
		var popup_value
		match popup_type:
			"money":
				popup_value = money_amount
			"durability":
				popup_value = hardness
			"fuel":
				popup_value = fuel_amount
		SignalBus.ui_popup_called.emit(popup_type, popup_value, self.position)
