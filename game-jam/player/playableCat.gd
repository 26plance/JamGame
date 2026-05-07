class_name PlayableCat
extends CharacterBody2D
@onready var cat_scene = preload("res://player/FollowingCat.tscn")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var position_history: Array[Vector2] =[]
const MAX_HISTORY = 300
const SPEED = 300.0
func _ready():
	motion_mode = MOTION_MODE_FLOATING

	


	sprite_2d.play("sit_forward")


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("leftward","rightward","upward","downward")
	
	# Handle Walking
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		if Input.is_action_pressed("leftward"): play_and_sync("side_walk_to_left")
		elif Input.is_action_pressed("rightward"): play_and_sync("side_walk")
		elif Input.is_action_pressed("upward"): play_and_sync("back_walk")
		elif Input.is_action_pressed("downward"): play_and_sync("walk_forward")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * delta * 15)

	# Handle Releases (Moved logic to a separate function to avoid 'await' glitches)
	if Input.is_action_just_released("upward"): start_sit_timer("back_stand", "back_sit", 1.0)
	elif Input.is_action_just_released("downward"): start_sit_timer("stand_forward", "sit_forward", 1.25)
	elif Input.is_action_just_released("leftward"): start_sit_timer("side_stand_to_left", "sit_side_left_face", 1.7)
	elif Input.is_action_just_released("rightward"): start_sit_timer("side_stand_to_right", "side_sit_face_right", 1.56)
	if velocity != Vector2.ZERO:
		position_history.push_front(global_position)
		if position_history.size() > MAX_HISTORY:
			position_history.pop_back()
	move_and_slide()

# New Helper Function
func play_and_sync(anim_name: String):
	sprite_2d.play(anim_name)
	broadcast_animation(anim_name)

# This function runs in the background and won't break your movement
func start_sit_timer(stand_anim: String, sit_anim: String, wait_time: float):
	play_and_sync(stand_anim)
	await get_tree().create_timer(wait_time).timeout
	if velocity == Vector2.ZERO: # Only sit if we haven't started moving again
		play_and_sync(sit_anim)
func _input(event):
	if event.is_action_pressed("ui_accept"):
		spawn_new_cat()
func spawn_new_cat():
	var new_cat = cat_scene.instantiate()
	add_sibling(new_cat)
	new_cat.add_to_group("followingcats")
	var cat_count = get_tree().get_nodes_in_group("followingcats").size()
	new_cat.follow_index = cat_count * 15
	new_cat.follow_target = self
	new_cat.global_position = global_position
func broadcast_animation(anim_name: String):
	get_tree().call_group("followingcats", "sync_animation", anim_name)
