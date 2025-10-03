extends Control

@onready var label: Label = $Label
var tween = create_tween().set_parallel()

func _ready() -> void:
	label.modulate.a = 0
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)

func set_text(popup_type: Collectible.PopupType, popup_contents: String):
	if label != null:
		label.text = popup_contents
	else:
		print("Tried to call set_text on a null popup... bit silly innit...")
		return
	
	match popup_type:
		Collectible.PopupType.MONEY:
			label.modulate = Color("#00e436") # Colour palette green
		Collectible.PopupType.DURABILITY:
			label.modulate = Color("#ff004d") # Colour palette red
		Collectible.PopupType.FUEL:
			label.modulate= Color("#0beab2") # Colour palette aquamarine

func start_tween():
	tween.tween_property(self, "global_position:y", global_position.y - 32, 1)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 1)
	tween.tween_property(label, "modulate:a", 1, 0.5)
	
	await tween.finished
	self.queue_free()
