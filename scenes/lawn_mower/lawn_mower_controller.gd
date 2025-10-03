extends RigidBody3D

@export var stats: LawnMowerStats
@export var sitting: bool = false

var max_speed: float
var max_fuel: float
var fuel_consum: float
var fuel: float
var durability: float

@onready var model: Node3D = $Model
@onready var collision_shape: Node3D = $CollisionShape3D
@onready var player_animations: AnimationPlayer = $Model/person/AnimationPlayer
@onready var camera_rig: Node3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/Camera3D

@onready var speed_lines: ColorRect = $"CameraRig/Camera3D/Speed Lines"

var speed = 0.0
var direction = 0.0
var boosting = false

func _ready():
	GameManager.player_node = self
	
	camera_rig.top_level = true
	model.top_level = true

	SignalBus.game_started.connect(func(): 
		SignalBus.set_camera_target.emit(camera.global_position, camera.quaternion)
	)
	SignalBus.reset_game.connect(func(): 
		queue_free()
	)

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
	
	speed_lines.material.set_shader_parameter("effect_power", 0)

	if sitting:
		if not player_animations.current_animation == "driving":
			player_animations.play("driving")

func update_upgrades(upgrades: Upgrades):
	print(name)
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
	var acceleration = stats.acceleration if !boosting else stats.acceleration*2
	if Input.is_action_pressed("forward"):
		speed += acceleration * delta
	elif Input.is_action_pressed("back"):
		speed -= acceleration * delta
	else:
		speed = lerp(speed, 0.0, 0.05)

	var _max_speed = max_speed if !boosting else max_speed * 2
	speed = clamp(speed, -_max_speed/2, _max_speed)
	

func update_camera(): 
	if !camera.current: 
		camera.current = true
	camera_rig.global_transform.origin = lerp(
		camera_rig.global_transform.origin, 
		global_transform.origin, 0.1
	)
	camera_rig.global_transform.basis = camera_rig.global_transform.basis.slerp(
		Basis(Quaternion(Vector3.UP, direction)),
		0.1
	)

func update_model(): 
	model.global_position = global_transform.origin
	model.rotation.y = direction

func _physics_process(delta):
	update_model()

	if not GameManager.game_started: 
		return	

	if Input.is_action_pressed("boost"):
		boosting = true
		speed_lines.material.set_shader_parameter("effect_power", 1)
	else: 
		boosting = false
		speed_lines.material.set_shader_parameter("effect_power", 0)

	get_speed(delta)
	get_steering(delta)

	var y_vel = linear_velocity.y
	linear_velocity = Vector3(sin(direction), 0, cos(direction)) * speed
	linear_velocity.y = y_vel

	update_camera()

func _process(delta: float) -> void:
	play_animations()
	if not GameManager.game_started: 
		return

	var _fuel_consum = fuel_consum if !boosting else 2*fuel_consum
	fuel -= _fuel_consum * delta
	SignalBus.fuel_updated.emit(fuel / max_fuel)
	if fuel <= 0: 
		SignalBus.game_over.emit("Ran out of fuel!")
	
	
func play_animations(): 
	if sitting:
		return
	if abs(speed) >= 1 and not player_animations.current_animation == "walk":
		player_animations.play("walk")
	elif abs(speed) < 1 and not player_animations.current_animation == "idle":
		player_animations.play("idle")

func take_damage(damage: float): 
	if !GameManager.game_started: 
		return 
	
	durability -= damage
	SignalBus.durability_updated.emit(durability)
	if durability <= 0: 
		SignalBus.game_over.emit("Ran out of durability!")
