extends RigidBody3D
class_name LawnMowerController

@export var stats: LawnMowerStats
@export var sitting: bool = false

var max_speed: float

@onready var rotation_less: Node3D = $RotationLess
@onready var player_animations: AnimationPlayer = $RotationLess/Model/person/AnimationPlayer
@onready var camera_rig: Node3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/Camera3D

@onready var speed_lines: ColorRect = $"CameraRig/Camera3D/Speed Lines"

var speed = 0.0
var direction = 0.0
var boosting = false

func _ready():
	GameManager.player_node = self
	
	camera_rig.top_level = true
	rotation_less.top_level = true

	SignalBus.game_started.connect(func(): 
		SignalBus.set_camera_target.emit(camera.global_position, camera.quaternion)
	)
	SignalBus.reset_game.connect(func(): 
		await get_tree().create_timer(1).timeout
		queue_free()
	)

	SignalBus.upgrades_updated.connect(update_upgrades)
	
	speed_lines.material.set_shader_parameter("effect_power", 0)

	if sitting:
		if not player_animations.current_animation == "driving":
			player_animations.play("driving")

func update_upgrades(upgrades: Upgrades):
	max_speed = upgrades.calculate_value(stats.base_max_speed, Upgrades.UpgradeType.SPEED)

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

func _physics_process(delta):
	update_rotation_less()
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

func _process(_delta: float) -> void:
	play_animations()
	
func play_animations(): 
	if sitting:
		return
	if not boosting and abs(speed) >= 1 and not player_animations.current_animation == "walk":
		player_animations.play("walk")
	elif boosting and abs(speed) >= 1 and not player_animations.current_animation == "dash":
		player_animations.play("dash")
	elif abs(speed) < 1 and not player_animations.current_animation == "idle":
		player_animations.play("idle")

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

func update_rotation_less(): 
	rotation_less.global_position = global_transform.origin
	rotation_less.rotation.y = direction
