extends MeshInstance3D

var default_texture = load("res://scenes/buildings/kenney/Textures/colormap.png")
var texture_a = load("res://scenes/buildings/kenney/Textures/variation-a.png")
var texture_b = load("res://scenes/buildings/kenney/Textures/variation-b.png")
var texture_c = load("res://scenes/buildings/kenney/Textures/variation-c.png")

func _ready() -> void:
	var tex_array: Array = [default_texture, texture_a, texture_b, texture_c]
	self.get_surface_override_material(0).albedo_texture = tex_array.pick_random()
