extends Area3D 
class_name LawnMowerHealth

var max_durability: float
@onready var controller: LawnMowerController = $"../.."
@onready var shredding_sound: AudioStreamPlayer3D = $"ShreddingSound"
@export var shredding_sounds: Array[AudioStream] = []
@onready var smoke_particle: GPUParticles3D = $SmokeParticle
@export var base_amount: int = 200
var original_y = 0

func _ready() -> void: 
	SignalBus.upgrades_updated.connect(update_upgrades)
	body_entered.connect(on_body_entered)
	original_y = smoke_particle.position.y

func update_upgrades(upgrades: Upgrades):
	var stats = controller.stats
	max_durability = upgrades.calculate_value(stats.base_durability, Upgrades.UpgradeType.DURABILITY)
	update_particles()

func update_particles(): 
	var stats = controller.stats
	var durability_percent = stats.get_durability() / max_durability

	if durability_percent <= 0.95:
		smoke_particle.position.y = original_y
	else: 
		smoke_particle.position.y = -3
	var particle_amount = round(base_amount * (1 - durability_percent)) 
	smoke_particle.amount = max(1, particle_amount)

	SignalBus.durability_updated.emit(stats.get_durability() / max_durability)

func play_shredding_sound(): 
	shredding_sound.stream = shredding_sounds[randi() % shredding_sounds.size()]
	shredding_sound.play()

func take_damage(damage: float): 
	if !GameManager.game_started or GameManager.game_paused: 
		return 

	var stats = controller.stats
	
	stats.current_durability -= damage
	if stats.current_durability < 0: 
		stats.current_durability = 0

	update_particles()

	if stats.get_durability() <= 0: 
		SignalBus.game_over.emit("Ran out of durability!")

func on_body_entered(body: Node3D) -> void: 
	if not GameManager.game_started: 
		return	

	if body.is_in_group("Collectible"): 
		print(body.name)
		var child = body.get_node("Collectible")
		child.trigger(self)
