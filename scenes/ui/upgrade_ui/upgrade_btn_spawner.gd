extends Control 

@onready var button: PackedScene = load("res://scenes/ui/upgrade_ui/upgrade_btn.tscn")

func _ready() -> void:
	for upgrade_type in len(Upgrades.UpgradeType): 
		if upgrade_type == Upgrades.UpgradeType.REPAIR: 
			continue
		var btn = button.instantiate() 
		add_child(btn)
		btn.upgrade_type = upgrade_type
