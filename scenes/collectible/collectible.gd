extends Area3D
class_name Collectible

enum PopupType { FUEL, MONEY, DURABILITY}

@export var money_amount = 10
@export var destructible = true 
@export var damage = 1.0
@export var fuel_amount = 0
@export var popup_type: PopupType = PopupType.MONEY

@onready var mesh: Node3D = $Mesh
@export var randomize_size: bool = false
@export var min_size = 0.6 
@export var max_size = 1.0 

func _ready() -> void:
	body_entered.connect(on_body_entered)
	if randomize_size: 
		var size = randf_range(min_size, max_size)
		mesh.scale = Vector3.ONE * size

func on_body_entered(body: Node3D):
	if body.is_in_group("LawnMower") and GameManager.game_started:
		if destructible: 
			get_parent().queue_free()
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
		SignalBus.ui_popup_called.emit(popup_type, str(popup_value), self.global_position)
