extends Node3D
class_name Collectible

enum PopupType { FUEL, MONEY, DURABILITY}

@export var money_amount = 10
@export var destructible = true 
@export var damage = 1.0
@export var fuel_amount = 0

@onready var mesh: Node3D = $"../Mesh"
@export var randomize_size: bool = false
@export var randomize_rotation: bool = false
@export var min_size = 0.6 
@export var max_size = 1.0 

@export var particle: PackedScene

func _ready() -> void:
	SignalBus.reset_game.connect(func(): 
		get_parent().queue_free()
	)
	if randomize_size: 
		var size = randf_range(min_size, max_size)
		mesh.scale = Vector3.ONE * size
	if randomize_rotation:
		mesh.rotation_degrees.y = randf_range(0, 360)

func trigger(player: LawnMowerHealth):
	if particle != null: 
		var part = particle.instantiate()
		get_parent().get_parent().add_child(part)
		part.global_position = global_position
		part.emitting = true

	var popup_pos = global_position
	if money_amount > 0:
		SignalBus.add_money.emit(money_amount)
		SignalBus.ui_popup_called.emit(PopupType.MONEY, str(money_amount), popup_pos)
		player.play_shredding_sound()
	if fuel_amount > 0:
		SignalBus.add_fuel.emit(fuel_amount)
		SignalBus.ui_popup_called.emit(PopupType.FUEL, str(fuel_amount), popup_pos)
	if damage > 0:
		player.take_damage(damage)
		SignalBus.ui_popup_called.emit(PopupType.DURABILITY, str(damage), popup_pos)

	if destructible: 
		get_parent().queue_free()
