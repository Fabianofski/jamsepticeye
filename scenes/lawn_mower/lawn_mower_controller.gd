extends RigidBody3D

@export var stats: LawnMowerStats

var max_speed: float
var max_fuel: float
var fuel_consum: float
var fuel: float
var durability: float

@onready var model: Node3D = $Model
@onready var player_animations: AnimationPlayer = $Model/person/AnimationPlayer
@onready var camera_rig: Node3D = $CameraRig

@onready var speed_lines: ColorRect = $"CameraRig/Camera3D/Speed Lines"

var speed = 0.0
var direction = 0.0

func _ready():
	GameManager.player_node = self
	
	camera_rig.top_level = true
	model.top_level = true

	SignalBus.fuel_updated.emit(fuel/max_fuel)
	SignalBus.add_fuel.connect(func(amount): 
		fuel += amount
		fuel = clampf(fuel, 0, max_fuel)
		SignalBus.fuel_updated.emit(fuel/max_fuel)
	)
	SignalBus.remove_fuel.connect(func(amount): 
		fuel -= amount
		SignalBus.fuel_updated.emit(fuel/max_fuel)
	)
	SignalBus.upgrades_updated.connect(update_upgrades)

func update_upgrades(upgrades: Upgrades):
	print("Lawn Mower")
	print(upgrades)
	max_speed = stats.base_max_speed * upgrades.speed_upgrades
	max_fuel = stats.base_max_fuel * upgrades.fuel_tank_upgrades
	fuel_consum = stats.base_fuel_consum * upgrades.fuel_efficiency_upgrades
	fuel = max_fuel
	durability = stats.base_durability

func get_steering(delta): 
	var input_dir = 0.0
	if Input.is_action_pressed("left"):
		input_dir = 1.0
	elif Input.is_action_pressed("right"):
		input_dir = -1.0

	if Input.is_action_pressed("drift"): 
		var speed_factor = abs(speed) / max_speed
		input_dir *= stats.drift_speed * speed_factor

	direction += input_dir * stats.steering_speed * delta * (speed / max_speed)

func get_speed(delta): 
	if Input.is_action_pressed("forward"):
		speed += stats.acceleration * delta
	elif Input.is_action_pressed("back"):
		speed -= stats.acceleration * delta
	else:
		speed = lerp(speed, 0.0, 0.05)

	speed = clamp(speed, -max_speed, max_speed)
	
	speed_lines.material.set_shader_parameter("effect_power", remap(speed, 0, 20, 0, 1))

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
	model.global_position = global_position - Vector3(0, 0.5, 0) # Offset so the character properly touches the ground
	model.rotation.y = direction

func _physics_process(delta):
	if not GameManager.game_started: 
		return	

	get_speed(delta)
	get_steering(delta)

	var forward = Vector3(sin(direction), 0, cos(direction))
	linear_velocity = forward * speed

	update_camera()
	update_model()

func _process(delta: float) -> void:
	play_animations()
	if not GameManager.game_started: 
		return

	fuel -= fuel_consum * delta
	SignalBus.fuel_updated.emit(fuel / max_fuel)
	if fuel <= 0: 
		SignalBus.game_over.emit("Ran out of fuel!")
	
	
func play_animations(): 
	if abs(speed) >= 1 and not player_animations.current_animation == "walk":
		player_animations.play("walk")
	elif abs(speed) < 1 and not player_animations.current_animation == "idle":
		player_animations.play("idle")

func take_damage(damage: float): 
	durability -= damage
	SignalBus.durability_updated.emit(durability)
	if durability <= 0: 
		SignalBus.game_over.emit("Ran out of durability!")
