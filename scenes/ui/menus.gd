extends Node3D 

@onready var game_canvas: CanvasLayer = $GameUi
@onready var main_menu_canvas: CanvasLayer = $MainMenu

@onready var main_menu_pos: Node3D = $MainMenuCameraPosition

func _ready():
	SignalBus.play.connect(func(): 
		game_canvas.set_visible(true)
		main_menu_canvas.set_visible(false)

		await get_tree().create_timer(1).timeout
		GameManager.game_paused = false
	)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("pause"): 
		SignalBus.set_camera_target.emit(main_menu_pos.global_position, main_menu_pos.quaternion)
		game_canvas.set_visible(false)
		main_menu_canvas.set_visible(true)
		if GameManager.game_started:
			GameManager.game_paused = true
