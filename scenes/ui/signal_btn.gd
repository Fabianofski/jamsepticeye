extends Button

@export var signal_name: String 

func _ready():
	pressed.connect(call_signal)

func call_signal(): 
	SignalBus.emit_signal(signal_name)
