extends CanvasLayer

@onready var upgrades: Control = $Upgrade 
@onready var game: Control = $Game
@onready var end: Control = $End
@onready var end_label: Control = $End/Label

@onready var money_visual: AnimatedSprite2D = $Money/MoneyVisual
@onready var money_label: Label = $Money/MoneyLabel

@onready var fuel_bar: TextureProgressBar = $Game/Fuel
@onready var fuel_label: Label = $Game/Fuel/FuelLabel

@onready var durability_visual: AnimatedSprite2D = $Durability/DurabilityVisual
@onready var durability_label: Label = $Durability/DurabilityLabel

@onready var gameplay_music: AudioStreamPlayer = $"Gameplay Music"
@onready var menu_music: AudioStreamPlayer = $"Menu Music"

var popup_scene = preload("res://scenes/ui/popup.tscn")

func _ready() -> void:
	SignalBus.money_updated.connect(on_money_updated) 
	SignalBus.fuel_updated.connect(on_fuel_updated) 
	SignalBus.durability_updated.connect(on_durability_updated)
	SignalBus.ui_popup_called.connect(create_popup)
	SignalBus.game_started.connect(on_game_start) 
	SignalBus.game_over.connect(on_game_end)
	SignalBus.reset_game.connect(on_game_restart)
	on_money_updated(GameManager.money)

func on_game_start(): 
	game.set_visible(true)
	upgrades.set_visible(false)
	
	gameplay_music.volume_db = -5
	menu_music.volume_db = -80

func on_game_end(message: String): 
	end.set_visible(true)
	end_label.text = "%s\n You earned $%d!" % [message, GameManager.current_round_earnings]

func on_game_restart(): 
	game.set_visible(false)
	end.set_visible(false)
	upgrades.set_visible(true)
	
	gameplay_music.volume_db = -80
	menu_music.volume_db = -5

func on_money_updated(money: float): 
	money_label.text = "$%.f" % money
	
	if money != 0:
		money_visual.frame = 1
	else:
		money_visual.frame = 0

func on_fuel_updated(fuel: float): 
	fuel_label.text = "Fuel: %d %%" % (fuel * 100)
	fuel_bar.max_value = 1
	fuel_bar.value = fuel

func on_durability_updated(durability: float): 
	durability_label.text = "%d%%" % (durability * 100)
	
	if durability <= 0.25:
		durability_visual.frame = 3
	elif durability <= 0.50:
		durability_visual.frame = 2
	elif durability <= 0.75:
		durability_visual.frame = 1
	else:
		durability_visual.frame = 0

func create_popup(popup_type: Collectible.PopupType, popup_value: String, popup_position: Vector3):
	if popup_type == null or popup_value == null or popup_position == null:
		return

	var popup_instance = popup_scene.instantiate()

	var viewport = get_viewport()
	var shift = randi_range(0, 50)
	var random_pos = viewport.get_camera_3d().unproject_position(popup_position) - Vector2(0 + shift, 128 + shift)

	self.add_child(popup_instance)
	match popup_type:
		Collectible.PopupType.MONEY:
			popup_instance.set_text(popup_type, "+$" + popup_value)
			popup_instance.position = random_pos
		Collectible.PopupType.DURABILITY:
			popup_instance.set_text(popup_type, "-" + popup_value)
			popup_instance.position = Vector2(viewport.size.x * 0.1 + shift, viewport.size.y * 0.9 - shift)
		Collectible.PopupType.FUEL:
			popup_instance.set_text(popup_type, "Refill!")
			popup_instance.position = random_pos
	popup_instance.start_tween()
