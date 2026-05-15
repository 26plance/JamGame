extends Node

signal score_changed(positon_of_object:Vector2)
var current_score:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_score(score_to_add:float,positon_of_object:Vector2):
	current_score += score_to_add
	score_changed.emit(positon_of_object)
	
