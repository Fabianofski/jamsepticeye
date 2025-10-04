extends Node3D 

@onready var collectible: Collectible = $"../Collectible"
@export var hats: Array[Hat] = []
@export var hat_chance = 0.3

@export var common_rarity = 0.6
@export var rare_rarity = 0.3
@export var epic_rarity = 0.1

@export var common_multiplier = 1
@export var rare_multiplier = 4
@export var epic_multiplier = 10 

func _ready():
	if randf() <= hat_chance:
		var roll = randf()
		var pool: Array[Hat] = []

		if roll <= common_rarity:
			pool = hats.filter(func(h): return h.rarity == Hat.Rarity.COMMON)
			collectible.money_amount *= common_multiplier
		elif roll <= common_rarity + rare_rarity:
			pool = hats.filter(func(h): return h.rarity == Hat.Rarity.RARE)
			collectible.money_amount *= rare_multiplier
		else:
			pool = hats.filter(func(h): return h.rarity == Hat.Rarity.EPIC)
			collectible.money_amount *= epic_multiplier

		var hat = pool[randi() % pool.size()]
		collectible.rarity = hat.rarity
		hat.set_visible(true)
