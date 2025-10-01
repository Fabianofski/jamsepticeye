extends Node 

@warning_ignore_start("unused_signal")
signal money_updated(amount: int)
signal add_money(amount: int)
signal remove_money(amount: int)
signal set_money(amount: int)

signal fuel_updated(amount: float)
signal ran_out_of_fuel()
@warning_ignore_restore("unused_signal")
