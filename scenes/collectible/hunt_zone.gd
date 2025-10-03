extends Area3D 

@onready var player_node = $".."

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(body: Node3D) -> void: 
	if body.is_in_group("Zombie") and GameManager.game_started:
		print(body.name)
		body.hunt(player_node)

func on_body_exited(body: Node3D) -> void: 
	if body.is_in_group("Zombie") and GameManager.game_started:
		body.stop_hunt()
