class_name PlayableCat
extends CharacterBody2D
@onready var cat_scene = preload("res://player/FollowingCat.tscn")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

const SPEED = 300.0
func _ready():
	motion_mode = MOTION_MODE_FLOATING
#<<<<<<< Updated upstream
	self.add_to_group("npcs")

#=======
	sprite_2d.play("sit_forward")
#>>>>>>> Stashed changes

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * deltas

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITYwasd

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if Input.is_action_pressed("ui_left"):
		sprite_2d.play("side_walk_to_left")
	elif Input.is_action_pressed("ui_right"):
		sprite_2d.play("side_walk")
	elif Input.is_action_pressed("ui_up"):
		sprite_2d.play("back_walk")
	elif Input.is_action_pressed("ui_down"):
		sprite_2d.play("walk_forward")
	if Input.is_action_just_released("ui_up"):
		sprite_2d.play("back_stand")
		await get_tree().create_timer(1).timeout
		sprite_2d.play("back_sit")
	elif Input.is_action_just_released("ui_down"):
		sprite_2d.play("stand_forward")
		await get_tree().create_timer(1.25).timeout
		sprite_2d.play("sit_forward")
	elif Input.is_action_just_released("ui_left"):
		sprite_2d.play("side_stand_to_left")
		await get_tree().create_timer(1.7).timeout
		sprite_2d.play("sit_side_left_face")
	elif Input.is_action_just_released("ui_right"):
		sprite_2d.play("side_stand_to_right")
		await get_tree().create_timer(1.56).timeout
		sprite_2d.play("side_sit_face_right")
		
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
	
