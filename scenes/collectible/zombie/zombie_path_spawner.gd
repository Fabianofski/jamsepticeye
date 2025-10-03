extends Node3D
class_name PathSpawner

var path: Array[Vector3] = []
@export var min_spawn: int = 1
@export var max_spawn: int = 10
var prefab: PackedScene = preload("res://scenes/collectible/zombie/zombie.tscn")

func _ready() -> void:
	SignalBus.reset_game.connect(spawn)
	spawn()

func spawn():
	for child in get_children(): 
		path.append(child.global_position)

	var count = randi_range(min_spawn, max_spawn)
	var positions: Array[Vector3] = []
	var indices: Array[int] = []

	while positions.size() < count: 
		var seg_idx = randi_range(0, len(path) - 1)
		var a = path[seg_idx]
		var b_idx = (seg_idx + 1) % len(path) 
		var b = path[b_idx]

		var t = randf()
		var candidate = a.lerp(b, t)

		positions.append(candidate)
		indices.append(b_idx)

	for i in positions.size():
		var instance = prefab.instantiate()
		add_child(instance)
		instance.global_position = positions[i]
		instance.set_path(path, indices[i])
