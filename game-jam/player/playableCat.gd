class_name PlayableCat
extends CharacterBody2D
@onready var cat_scene = preload("res://player/FollowingCat.tscn")

const SPEED = 300.0
func _ready():
	motion_mode = MOTION_MODE_FLOATING
	

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITYwasd

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction:
		velocity= direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
func _input(event):
	if event.is_action_pressed("ui_accept"):
		spawn_new_cat()
func spawn_new_cat():
	var new_cat = cat_scene.instantiate()
	get_tree().root.add_child(new_cat)
	new_cat.follow_target = self
	new_cat.global_position = global_position
	
