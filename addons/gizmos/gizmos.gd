@tool
extends EditorPlugin

const SpawnerGizmoPlugin = preload("res://addons/gizmos/spawner_gizmo_plugin.gd")
var gizmo_plugin = SpawnerGizmoPlugin.new() 

func _enter_tree():
	add_node_3d_gizmo_plugin(gizmo_plugin)

func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)
