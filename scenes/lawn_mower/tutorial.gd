extends Node3D
class_name Tutorial

enum Stage { MOVEMENT, BOOST, DRIFT, COMPLETE }
var transition = false

@onready var controller: LawnMowerController = $"../.."

@onready var movement_tutorial: Node3D = $Movement
@onready var boost_tutorial: Node3D = $Boost
@onready var drift_tutorial: Node3D = $Drift 

func _ready():
	SignalBus.game_started.connect(change_state)

func _process(_delta: float) -> void:
	if transition: 
		return 

	match GameManager.tutorial_stage:
		Stage.MOVEMENT:
			if controller.throttle: 
				next_stage()
		Stage.BOOST: 
			if controller.boosting: 
				next_stage()
		Stage.DRIFT: 
			if controller.drifting: 
				next_stage()

func change_state():
	var stage = GameManager.tutorial_stage
	movement_tutorial.set_visible(stage == Stage.MOVEMENT)
	boost_tutorial.set_visible(stage == Stage.BOOST)
	drift_tutorial.set_visible(stage == Stage.DRIFT)


func next_stage(): 
	transition = true
	if GameManager.tutorial_stage != Stage.COMPLETE: 
		await get_tree().create_timer(1).timeout
		GameManager.tutorial_stage = (GameManager.tutorial_stage + 1) as Stage 
		change_state()
		transition = false

