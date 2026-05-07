class_name PlayableCat
extends CharacterBody2D
@onready var cat_scene = preload("res://player/FollowingCat.tscn")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

const SPEED = 300.0
func _ready():
	motion_mode = MOTION_MODE_FLOATING

	self.add_to_group("npcs")


	sprite_2d.play("sit_forward")


func _physics_process(_delta: float) -> void:


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("leftward","rightward","upward","downward")
	if Input.is_action_pressed("leftward"):
		sprite_2d.play("side_walk_to_left")
		broadcast_animation("side_walk_to_left")
	elif Input.is_action_pressed("rightward"):
		sprite_2d.play("side_walk")
		broadcast_animation("side_walk")
	elif Input.is_action_pressed("upward"):
		sprite_2d.play("back_walk")
		broadcast_animation("back_walk")
	elif Input.is_action_pressed("downward"):
		sprite_2d.play("walk_forward")
		broadcast_animation("walk_forward")
	if Input.is_action_just_released("upward"):
		sprite_2d.play("back_stand")
		broadcast_animation("back_stand")
		await get_tree().create_timer(1).timeout
		sprite_2d.play("back_sit")
		broadcast_animation("back_sit")
	elif Input.is_action_just_released("downward"):
		sprite_2d.play("stand_forward")
		broadcast_animation("stand_foward")
		await get_tree().create_timer(1.25).timeout
		sprite_2d.play("sit_forward")
		broadcast_animation("sit_forward")
	elif Input.is_action_just_released("leftward"):
		sprite_2d.play("side_stand_to_left")
		broadcast_animation("side_stand_to_left")
		await get_tree().create_timer(1.7).timeout
		sprite_2d.play("sit_side_left_face")
		broadcast_animation("sit_side_left_face")
	elif Input.is_action_just_released("rightward"):
		sprite_2d.play("side_stand_to_right")
		broadcast_animation("side_stand_to_right")
		await get_tree().create_timer(1.56).timeout
		sprite_2d.play("side_sit_face_right")
		broadcast_animation("side_sit_face_right")
		
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
	add_sibling(new_cat)
	new_cat.add_to_group("followingcats")
	new_cat.follow_target = self
	new_cat.global_position = global_position
func broadcast_animation(anim_name: String):
	get_tree().call_group("followingcats", "sync_animation", anim_name)
