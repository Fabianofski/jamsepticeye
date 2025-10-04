extends Button 

@onready var label: Label = $Label
signal disable_ui
var current_mower: LawnMower

func _ready() -> void:
	SignalBus.mower_updated.connect(on_mower_selected)
	SignalBus.money_updated.connect(update_button)
	pressed.connect(on_pressed)

func on_mower_selected(mower: LawnMower): 
	current_mower = mower
	update_button(GameManager.money)

func update_button(money: float):
	if current_mower.unlocked: 
		label.text = "Start"
	else: 
		label.text = "Buy $%d" % (current_mower.price)

	disabled = !current_mower.unlocked and money < current_mower.price  
	if current_mower.stats.get_durability() == 0: 
		disabled = true
		
func on_pressed(): 
	if current_mower.unlocked: 
		SignalBus.game_started.emit()
		disable_ui.emit()
	elif GameManager.money >= current_mower.price: 
		SignalBus.remove_money.emit(current_mower.price) 
		current_mower.unlocked = true 
		update_button(GameManager.money)
