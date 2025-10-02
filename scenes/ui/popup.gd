extends Control

@onready var label: Label = $Label

func _ready() -> void: # TODO: Proper tweened popup animation
	await get_tree().create_timer(3).timeout
	self.queue_free()

func set_text(popup_contents: String):
	label.text = popup_contents
