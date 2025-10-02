extends Node3D 

func _ready() -> void:
	spawn_lawn_mower()

func spawn_lawn_mower(): 
	var mower = GameManager.current_lawn_mower.mesh.instantiate() 
	mower.update_upgrades(GameManager.current_lawn_mower.upgrades)
	add_child(mower)
