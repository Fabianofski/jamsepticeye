extends Node3D
class_name Spawner

@export var radius: float = 5 
@export var min_distance: float = 0.5 
@export var min_spawn: int = 1
@export var max_spawn: int = 10
@export var prefab: PackedScene

func _ready() -> void:
	SignalBus.reset_game.connect(spawn)
	spawn()

func spawn():
	var count = randi_range(min_spawn, max_spawn)
	var positions: Array = []

	var tries = 0
	while positions.size() < count and tries < count * 50:
		tries += 1
		var angle = randf() * TAU
		var dist = randf() * radius
		var pos = Vector3(cos(angle) * dist, 0, sin(angle) * dist)
		var valid = true
		for p in positions:
			if p.distance_to(pos) < min_distance:
				valid = false
				break
		if valid:
			positions.append(pos)

	for pos in positions:
		var instance = prefab.instantiate()
		add_child(instance)
		instance.position = pos
