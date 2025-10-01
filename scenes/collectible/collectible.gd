extends RigidBody3D

@export var money_amount = 10

func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D):
	if body.is_in_group("LawnMower"):
		queue_free()
		SignalBus.add_money.emit(money_amount)
