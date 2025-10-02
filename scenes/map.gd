extends Node3D

@onready var grass_multimesh: MultiMeshInstance3D = $GrassMutliMesh

func _process(delta: float) -> void:
	if GameManager.player_node:
		grass_multimesh.material_override.set_shader_parameter("object_position", GameManager.player_node.position)
