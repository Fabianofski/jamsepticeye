extends RigidBody3D

@export var acceleration = 20.0
@export var steering = 1.5
@export var max_speed = 30.0

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var camera_rig: Node3D = $CameraRig

var speed = 0.0
var direction = 0.0

func _ready():
	camera_rig.top_level = true
	mesh.top_level = true

func _physics_process(delta):
	var input_dir = 0.0
	if Input.is_action_pressed("forward"):
		speed -= acceleration * delta
	elif Input.is_action_pressed("back"):
		speed += acceleration * delta
	else:
		speed = lerp(speed, 0.0, 0.05)

	speed = clamp(speed, -max_speed, max_speed)

	if Input.is_action_pressed("left"):
		input_dir = -1.0
	elif Input.is_action_pressed("right"):
		input_dir = 1.0

	direction += input_dir * steering * delta * (speed / max_speed)
	var forward = Vector3(sin(direction), 0, cos(direction))
	linear_velocity = forward * speed

	mesh.position = position 
	mesh.rotation.y = direction
	camera_rig.global_transform.origin = lerp(
		camera_rig.global_transform.origin, 
		global_transform.origin, 0.1
	)
	camera_rig.global_transform.basis = camera_rig.global_transform.basis.slerp(
		Basis(Quaternion(Vector3.UP, direction)),
		0.1
	)
