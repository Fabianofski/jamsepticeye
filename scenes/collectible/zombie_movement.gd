extends CharacterBody3D

enum State { IDLE, HUNTING, PATH }

var movement_speed: float = 2.0
var state: State = State.IDLE
var base_state: State = State.IDLE
var player: Node3D = null

var path: Array[Vector3] = []
var index: int = 0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var mesh_animation: AnimationPlayer = $Area3D/Mesh/AnimationPlayer

func _ready():
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func set_path(_path: Array[Vector3], _index: int) -> void: 
	path = _path 
	index = _index

	state = State.PATH
	base_state = State.PATH

	set_movement_target(path[index])

	if not mesh_animation.current_animation == "run":
		mesh_animation.play("run")

func hunt(_player: Node3D): 
	player = _player
	state = State.HUNTING
	
	if not mesh_animation.current_animation == "run":
		mesh_animation.play("run")

func stop_hunt(): 
	player = null 
	state = base_state
	
	if state == State.IDLE and not mesh_animation.current_animation == "idle":
		mesh_animation.play("idle")

func look_at_target(): 
	var direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	var flat_direction = navigation_agent.get_next_path_position() - global_position
	flat_direction.y = 0
	flat_direction = flat_direction.normalized()
	if flat_direction.length() > 0:
		look_at(global_transform.origin - flat_direction, Vector3.UP)

func _physics_process(_delta):
	if state == State.IDLE: 
		return

	if state == State.HUNTING and player != null: 
		set_movement_target(player.global_position)

	if navigation_agent.is_navigation_finished():
		if state == State.PATH: 
			index += 1 
			if index >= len(path): 
				index = 0
			set_movement_target(path[index])
		return

	look_at_target()
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
