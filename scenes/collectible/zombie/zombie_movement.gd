extends CharacterBody3D

enum State { IDLE, HUNTING, PATH }
enum Personality { VICIOUS, SCAREDYCAT }

var movement_speed: float = 2.0
var state: State = State.IDLE
var base_state: State = State.IDLE
var player: Node3D = null

var personality: Personality = Personality.SCAREDYCAT

var path: Array[Vector3] = []
var index: int = 0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var mesh_animation: AnimationPlayer = $Mesh/AnimationPlayer

@export var moan_sounds: Array[AudioStream] = []
@export var scared_moan_sounds: Array[AudioStream] = []
@onready var moan_sound_player: AudioStreamPlayer3D = $"MoanSound"
@export var min_moan_time: float = 5 
@export var max_moan_time: float = 30
var next_moan: float = 0.0

func _ready():
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	calc_next_moan()

func calc_next_moan(): 
	moan_sound_player.stream = moan_sounds[randi() % moan_sounds.size()]
	next_moan = randf_range(min_moan_time, max_moan_time)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func set_path(_path: Array[Vector3], _index: int) -> void: 
	path = _path 
	index = _index

	state = State.PATH
	base_state = State.PATH

	set_movement_target(path[index])

	if not mesh_animation.current_animation == "walk":
		mesh_animation.play("walk")

func hunt(_player: Node3D): 
	player = _player
	state = State.HUNTING
	play_animations()

	if personality == Personality.SCAREDYCAT: 
		moan_sound_player.stream = scared_moan_sounds[randi() % scared_moan_sounds.size()]
	moan_sound_player.play()
	# calc_next_moan()

func stop_hunt(): 
	player = null 
	state = base_state
	play_animations()
	
func play_animations():
	if state == State.HUNTING and not mesh_animation.current_animation == "run":
		mesh_animation.play("run")
	elif state == State.PATH and not mesh_animation.current_animation == "walk":
		mesh_animation.play("walk")
	elif not mesh_animation.current_animation == "idle":
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
	if state == State.IDLE or GameManager.game_paused:  
		return

	if state == State.HUNTING and player != null: 
		if personality == Personality.VICIOUS:
			set_movement_target(player.global_position)
		elif personality == Personality.SCAREDYCAT:
			var direction = (self.global_position - player.global_position).normalized()
			set_movement_target(global_position + direction)
		else:
			print("If you reach this point something's gone very wrong.")

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

func _process(delta: float) -> void:
	next_moan -= delta 
	if next_moan <= 0: 
		calc_next_moan()
		moan_sound_player.play()
