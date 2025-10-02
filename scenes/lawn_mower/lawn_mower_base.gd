extends Node3D 

@export var lawn_mowers: Array[LawnMower] = []

func _ready() -> void:
	if GameManager.current_lawn_mower == null: 
		GameManager.set_lawn_mower(lawn_mowers[0])
	spawn_lawn_mower()

func spawn_lawn_mower(): 
	SignalBus.mower_updated.emit(GameManager.current_lawn_mower)

	var mower = GameManager.current_lawn_mower.mesh.instantiate() 
	mower.update_upgrades(GameManager.current_lawn_mower.upgrades)
	add_child(mower)
