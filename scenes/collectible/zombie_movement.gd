extends CharacterBody3D

enum State { IDLE, HUNTING, PATH }

var movement_speed: float = 2.0
var state: State = State.IDLE
var player: Node3D = null

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func hunt(_player: Node3D): 
	player = _player
	state = State.HUNTING

func stop_hunt(): 
	player = null 
	state = State.IDLE

func _physics_process(_delta):
	if state == State.IDLE: 
		return

	if state == State.HUNTING and player != null: 
		set_movement_target(player.global_position)

	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
