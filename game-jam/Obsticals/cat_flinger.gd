extends Area2D

@export var desired_cat_fling_velocity = Vector2(10,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:

	if body is PlayableCat:
		body.added_velocity = desired_cat_fling_velocity.rotated(global_rotation)
