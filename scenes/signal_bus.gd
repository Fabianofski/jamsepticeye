extends Node

@warning_ignore_start("unused_signal")
signal money_updated(amount: int)
signal add_money(amount: int)
signal remove_money(amount: int)
signal set_money(amount: int)

signal upgrades_updated(upgrade: Upgrades)

signal add_fuel(amount: int)
signal remove_fuel(amount: int)
signal fuel_updated(amount: float)

signal durability_updated(amount: float)

signal play()
signal game_over(message: String) 
signal game_started()
signal reset_game()

signal ui_popup_called(type: Collectible.PopupType, value: String)

signal mower_updated(mower: LawnMower)
signal next_mower()
signal previous_mower()

signal set_camera_target(position: Vector3, rotation: Quaternion)
@warning_ignore_restore("unused_signal")
