@tool
extends EditorScript

func _run():
	var scene = get_editor_interface().get_edited_scene_root()
	if scene == null:
		return
		
	var gridmap = scene.get_node("Houses")
	if gridmap == null:
		return

	var house_indices = [0, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

	var used_cells = gridmap.get_used_cells()
	for cell in used_cells:
		var idx = gridmap.get_cell_item(cell)
		if idx in house_indices:
			var new_idx = house_indices[randi() % house_indices.size()]
			gridmap.set_cell_item(cell, new_idx, gridmap.get_cell_item_orientation(cell))
