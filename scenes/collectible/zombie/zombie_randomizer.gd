extends Node3D 

enum Personality { VICIOUS, SCAREDYCAT }

@onready var zombie: Node3D = $"../"
@onready var collectible: Collectible = $"../Collectible"

@export_group("Colors")
@export var shirt_colors: Array[Color] = []
@export var skin_colors: Array[Color] = []

@export_group("Size")
@export var min_size: float = 0.6
@export var max_size: float = 1.4
@onready var mesh: Node3D = $"../Mesh"
@onready var arm_r: MeshInstance3D = $"../Mesh/Armature/Skeleton3D/Arm_R"
@onready var arm_l: MeshInstance3D = $"../Mesh/Armature/Skeleton3D/Arm_L"
@onready var head: MeshInstance3D = $"../Mesh/Armature/Skeleton3D/Head"
@onready var body: MeshInstance3D = $"../Mesh/Armature/Skeleton3D/Body"
@onready var collider: Node3D = $"../CollisionShape3D"

@export_group("Hats")
@export var hats: Array[Hat] = []
@export var hat_chance = 0.3

@export var common_rarity = 0.6
@export var rare_rarity = 0.3
@export var epic_rarity = 0.1

@export var common_multiplier = 1
@export var rare_multiplier = 4
@export var epic_multiplier = 10

@export_group("Behaviour")
@export var personality: Personality = Personality.VICIOUS


func _ready():
	randomize_size()
	randomize_hat()
	randomize_personality()
	randomize_color()

func randomize_size(): 
	var size = randf_range(min_size, max_size) 
	collectible.damage *= size
	collectible.damage = snappedf(collectible.damage, 2)
	collectible.money_amount *= size
	collectible.money_amount = snappedf(collectible.money_amount, 2)
	mesh.scale = Vector3.ONE * size
	collider.scale = Vector3.ONE * size

func randomize_hat():
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

func randomize_personality():
	var enum_values = Personality.values()
	var random_idx = randi() % enum_values.size()
	var random_personality = enum_values[random_idx]
	zombie.personality = random_personality

func randomize_color(): 
	var shirt_color = shirt_colors[randi() % shirt_colors.size()]
	var shirt_material = StandardMaterial3D.new()
	shirt_material.albedo_color = shirt_color

	var skin_color = skin_colors[randi() % skin_colors.size()]
	var skin_material = StandardMaterial3D.new()
	skin_material.albedo_color = skin_color

	arm_r.set_surface_override_material(0, shirt_material)
	arm_r.set_surface_override_material(1, skin_material)
	arm_l.set_surface_override_material(0, shirt_material)
	arm_l.set_surface_override_material(1, skin_material)
	head.set_material_override(skin_material)
	body.set_material_override(shirt_material)
