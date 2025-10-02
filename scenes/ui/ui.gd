extends CanvasLayer

@onready var money_visual: AnimatedSprite2D = $Money/MoneyVisual
@onready var money_label: Label = $Money/MoneyLabel

@onready var fuel_bar: TextureProgressBar = $Fuel
@onready var fuel_label: Label = $Fuel/FuelLabel

@onready var durability_visual: AnimatedSprite2D = $Durability/DurabilityVisual
@onready var durability_label: Label = $Durability/DurabilityLabel

var popup_scene = preload("res://scenes/ui/popup.tscn")

func _ready() -> void:
	SignalBus.money_updated.connect(on_money_updated) 
	SignalBus.fuel_updated.connect(on_fuel_updated) 
	SignalBus.durability_updated.connect(on_durability_updated)
	SignalBus.ui_popup_called.connect(create_popup)
	on_money_updated(GameManager.money)

func on_money_updated(money: int): 
	money_label.text = "$" + str(money)
	
	if money != 0:
		money_visual.frame = 1
	else:
		money_visual.frame = 0

func on_fuel_updated(fuel: float, max_fuel: float): 
	fuel_label.text = "Fuel: %d" % fuel
	#fuel_bar.max_value = max_fuel NOTE: Doesn't appear to update visually for some reason.
	fuel_bar.value = fuel

func on_durability_updated(durability: float): 
	durability_label.text = str(int(durability)) + "%"
	
	if durability <= 25: # WARNING: Ugly else-if ahead!
		durability_visual.frame = 3
		pass
	elif durability <= 50:
		durability_visual.frame = 2
		pass
	elif durability <= 75:
		durability_visual.frame = 1
		pass
	else:
		durability_visual.frame = 0
		pass

func create_popup(popup_type: String, popup_value: Variant, popup_position: Vector3):
	if popup_type != "":
		var popup_instance = popup_scene.instantiate()
		self.add_child(popup_instance)
		match popup_type:
			"money":
				popup_instance.set_text("+$" + str(popup_value))
			"durability":
				popup_instance.set_text("-" + str(int(popup_value)))
			"fuel":
				popup_instance.set_text("+" + str(int(popup_value)) + " fuel!")
		popup_instance.position = get_viewport().get_camera_3d().unproject_position(popup_position) - Vector2(0, 128)
	else:
		pass
