extends CharacterBody2D

var y_velocity = 0
var x_velocity = 0
var stop = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not stop:
		velocity.x = x_velocity
		velocity.y = y_velocity
	else:
		if velocity.x != 0:
			velocity.x -= 20
		if velocity.y != 0:
			velocity.y -= 20
	var target_angle = atan2(velocity.y, velocity.x)
	rotation = lerp_angle(rotation, target_angle, 0.2)
	move_and_slide()
