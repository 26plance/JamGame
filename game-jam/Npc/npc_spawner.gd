extends Node2D
@export var cat : PlayableCat

var timetillspawn = 0
var timercurant = false
func  _ready() -> void:
	timetillspawn = randi_range(12,25)
	
func _process(delta: float) -> void:
	if not timercurant:
		timercurant = true
		await  get_tree().create_timer(timetillspawn).timeout
		var cartospawn = load("res://Npc/HumanNpc.tscn")
		var random_hue = randf() 
		var npc = cartospawn.instantiate()
		npc.modulate = Color.from_hsv(random_hue, 0.8, 0.9)
		npc.global_position = self.global_position
		npc.cat_to_locate = cat
		get_parent().add_child(npc)
		timercurant = false
		timetillspawn = randi_range(12,25)
