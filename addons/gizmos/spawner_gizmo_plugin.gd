@tool
extends EditorNode3DGizmoPlugin

func _init():
	create_material("radius_mat", Color(1, 0, 0, 0.5))

func _has_gizmo(node: Node3D) -> bool:
	print(node.name)
	return node is Spawner

func _redraw(gizmo: EditorNode3DGizmo) -> void:
	print("Draw")
	var node: Spawner = gizmo.get_node_3d()
	var radius = node.radius
	var mat = get_material("radius_mat", gizmo)

	var lines: PackedVector3Array = []
	var steps = 64
	for i in steps:
		var a = TAU * float(i) / float(steps)
		var b = TAU * float(i + 1) / float(steps)
		lines.append(Vector3(cos(a) * radius, 0, sin(a) * radius))
		lines.append(Vector3(cos(b) * radius, 0, sin(b) * radius))
	gizmo.add_lines(lines, mat)

