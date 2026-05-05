extends CharacterBody2D
class_name Cat
var follow_target: Node2D
@export var speed: float = 200.0
@export var min_distance: float = 50.0
func _ready():
	motion_mode = MOTION_MODE_FLOATING
	set_as_top_level(true)

func _physics_process(_delta: float) -> void:
	if follow_target == null:
		velocity = Vector2.ZERO
		return
	var target_pos = follow_target.global_position
	var distance = global_position.distance_to(target_pos)
	if distance > min_distance:
		var direction = global_position.direction_to(target_pos)
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
