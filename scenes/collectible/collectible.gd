extends RigidBody3D

@export var money_amount = 10
@export var destructible = true 
@export var hardness = 1.0 

func _ready() -> void:
	print("SDFSDFF")
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D):
	if body.is_in_group("LawnMower"):
		if destructible: 
			queue_free()
		if money_amount > 0:
			SignalBus.add_money.emit(money_amount)

		body.take_damage(hardness)
