extends Node3D 

@export var lawn_mowers: Array[LawnMower] = []
@onready var base_cam: Node3D = $BaseCam
var mower_object: Node3D = null

func _ready() -> void:
	if GameManager.current_lawn_mower == null: 
		GameManager.current_lawn_mower_index = 0
		GameManager.set_lawn_mower(lawn_mowers[0])

	SignalBus.next_mower.connect(next_mower)
	SignalBus.previous_mower.connect(previous_mower)
	SignalBus.reset_game.connect(initialize)
	initialize()

func initialize():
	SignalBus.set_camera_target.emit(base_cam.global_position, base_cam.quaternion)
	spawn_lawn_mower()

func next_mower(): 
	if GameManager.current_lawn_mower_index < len(lawn_mowers) - 1: 
		GameManager.current_lawn_mower_index += 1
	else: 
		GameManager.current_lawn_mower_index = 0
	spawn_lawn_mower()

func previous_mower(): 
	if GameManager.current_lawn_mower_index > 0:
		GameManager.current_lawn_mower_index -= 1
	else: 
		GameManager.current_lawn_mower_index = len(lawn_mowers) - 1 
	spawn_lawn_mower()

func spawn_lawn_mower(): 
	GameManager.current_lawn_mower = lawn_mowers[GameManager.current_lawn_mower_index]
	SignalBus.mower_updated.emit(GameManager.current_lawn_mower)

	if mower_object: 
		mower_object.queue_free()

	mower_object = GameManager.current_lawn_mower.mesh.instantiate() 
	add_child(mower_object)
	SignalBus.upgrades_updated.emit(GameManager.current_lawn_mower.upgrades)
