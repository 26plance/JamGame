extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("meow"):
		meow(delta)
	elif Input.is_action_pressed("hiss"):
		hiss(delta)



func meow(delta):
	print("meow")
	get_tree().call_group("npcs", "cat_meowed", global_position,delta)


func hiss(delta):
	print("hiss")
	get_tree().call_group("npcs", "cat_hissed", global_position,delta)
