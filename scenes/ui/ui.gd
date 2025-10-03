extends CanvasLayer

@onready var money_visual: AnimatedSprite2D = $Money/MoneyVisual
@onready var money_label: Label = $Money/MoneyLabel

@onready var fuel_bar: TextureProgressBar = $Game/Fuel
@onready var fuel_label: Label = $Game/Fuel/FuelLabel

@onready var durability_visual: AnimatedSprite2D = $Game/Durability/DurabilityVisual
@onready var durability_label: Label = $Game/Durability/DurabilityLabel

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

func on_fuel_updated(fuel: float): 
	fuel_label.text = "Fuel: %d %%" % (fuel * 100)
	fuel_bar.max_value = 1
	fuel_bar.value = fuel

func on_durability_updated(durability: float): 
	durability_label.text = str(int(durability)) + "%"
	
	if durability <= 25:
		durability_visual.frame = 3
	elif durability <= 50:
		durability_visual.frame = 2
	elif durability <= 75:
		durability_visual.frame = 1
	else:
		durability_visual.frame = 0

func create_popup(popup_type: Collectible.PopupType, popup_value: String, popup_position: Vector3):
	if popup_type != null and popup_value != null and popup_position != null:
		var popup_instance = popup_scene.instantiate()
		self.add_child(popup_instance)
		match popup_type:
			Collectible.PopupType.MONEY:
				popup_instance.set_text(popup_type, "+$" + popup_value)
			Collectible.PopupType.DURABILITY:
				popup_instance.set_text(popup_type, "-" + popup_value)
			Collectible.PopupType.FUEL:
				popup_instance.set_text(popup_type, "+" + popup_value + " fuel!")
		popup_instance.position = get_viewport().get_camera_3d().unproject_position(popup_position) - Vector2(0, 128)
		popup_instance.start_tween()
	else:
		print("Tried to create a popup with at least one null value... bit silly innit...")
		return
