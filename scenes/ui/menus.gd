extends Node3D 

@onready var game_canvas: CanvasLayer = $GameUi
@onready var main_menu_canvas: CanvasLayer = $MainMenu


func _ready():
	SignalBus.play.connect(func(): 
		game_canvas.set_visible(true)
		main_menu_canvas.set_visible(false)
	)
