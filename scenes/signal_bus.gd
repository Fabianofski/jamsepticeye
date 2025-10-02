extends Node 

@warning_ignore_start("unused_signal")
signal money_updated(amount: int)
signal add_money(amount: int)
signal remove_money(amount: int)
signal set_money(amount: int)

signal add_fuel(amount: int)
signal remove_fuel(amount: int)
signal fuel_updated(amount: float, max_amount: float)
signal ran_out_of_fuel()

signal durability_updated(amount: float)
signal ran_out_of_durability()

signal ui_popup_called(type: String, value: Variant)
@warning_ignore_restore("unused_signal")
