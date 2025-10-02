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

signal game_over(message: String) 
signal game_started()

signal ui_popup_called(type: Collectible.PopupType, value: String)

signal mower_updated(mower: LawnMower)
@warning_ignore_restore("unused_signal")
