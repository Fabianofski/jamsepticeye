extends RigidBody3D

@export var acceleration = 20.0
@export var steering_speed = 1.5
@export var drift_speed = 1.5
@export var max_speed = 30.0
@export var durability = 100.0
@export var fuel = 100.0
@export var fuel_consum = 1.0 

@onready var model: Node3D = $Model
@onready var player_animations: AnimationPlayer = $Model/person/AnimationPlayer
@onready var camera_rig: Node3D = $CameraRig

var speed = 0.0
var direction = 0.0

func _ready():
	camera_rig.top_level = true
	model.top_level = true

	SignalBus.fuel_updated.emit(fuel)

func get_steering(delta): 
	var input_dir = 0.0
	if Input.is_action_pressed("left"):
		input_dir = 1.0
	elif Input.is_action_pressed("right"):
		input_dir = -1.0

	if Input.is_action_pressed("drift"): 
		var speed_factor = abs(speed) / max_speed
		input_dir *= drift_speed * speed_factor

	direction += input_dir * steering_speed * delta * (speed / max_speed)

func get_speed(delta): 
	if Input.is_action_pressed("forward"):
		speed += acceleration * delta
	elif Input.is_action_pressed("back"):
		speed -= acceleration * delta
	else:
		speed = lerp(speed, 0.0, 0.05)

	speed = clamp(speed, -max_speed, max_speed)

func update_camera(): 
	camera_rig.global_transform.origin = lerp(
		camera_rig.global_transform.origin, 
		global_transform.origin, 0.1
	)
	camera_rig.global_transform.basis = camera_rig.global_transform.basis.slerp(
		Basis(Quaternion(Vector3.UP, direction)),
		0.1
	)

func update_model(): 
	model.position = position 
	model.rotation.y = direction


func _physics_process(delta):
	get_speed(delta)
	get_steering(delta)

	var forward = Vector3(sin(direction), 0, cos(direction))
	linear_velocity = forward * speed

	update_camera()
	update_model()

func _process(delta: float) -> void:
	fuel -= fuel_consum * delta
	SignalBus.fuel_updated.emit(fuel)
	if fuel <= 0: 
		SignalBus.ran_out_of_fuel.emit()
	
	if abs(speed) >= 1 and not player_animations.current_animation == "walk":
		player_animations.play("walk")
	elif abs(speed) < 1 and not player_animations.current_animation == "idle":
		player_animations.play("idle")

func take_damage(damage: float): 
	durability -= damage
	SignalBus.durability_updated.emit(durability)
	if durability <= 0: 
		SignalBus.ran_out_of_durability.emit()
