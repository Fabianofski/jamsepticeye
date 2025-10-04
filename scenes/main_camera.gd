extends Camera3D

var target_position: Vector3
var target_rotation: Quaternion

func _ready() -> void:
	SignalBus.set_camera_target.connect(set_target)

func set_target(pos: Vector3, rot: Quaternion):
	var current_cam = get_viewport().get_camera_3d() 
	if current_cam != self: 
		global_position = current_cam.global_position
		global_rotation = current_cam.global_rotation

	target_position = pos
	target_rotation = rot
	current = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel()
	tween.tween_property(self, "global_position", target_position, 1) 
	tween.tween_property(self, "quaternion", target_rotation, 1)
