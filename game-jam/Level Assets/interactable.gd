extends Area2D
#  unfinished
var player_inside_area:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is PlayableCat:
		player_inside_area = true



func _on_body_exited(body: Node2D) -> void:
	if player_inside_area:
		if  body is PlayableCat:
			player_inside_area = false
