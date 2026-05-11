class_name FollowingCat
extends CharacterBody2D
var follow_target: Node2D
var follow_index: int = 0
@export var speed: float = 300.0
@export var min_distance: float = 5
@onready var npc_sprite: AnimatedSprite2D = $Sprite2D

var added_velocity = Vector2()

const flung_cat_slow_down = 1000


func _ready():
	motion_mode = MOTION_MODE_FLOATING
	set_as_top_level(true)

func _physics_process(delta: float) -> void:
	velocity = Vector2()
	if added_velocity.length() > 0:
		print(added_velocity)
		added_velocity = added_velocity.move_toward(Vector2.ZERO, flung_cat_slow_down * delta)
		velocity = added_velocity
	
	if follow_target == null or follow_target.position_history.size() < follow_index :
		follow_index = -1
	var target_pos = follow_target.position_history[follow_index]
	var distance = global_position.distance_to(target_pos)
	if distance > min_distance:
		var direction = global_position.direction_to(target_pos)
		velocity += direction * speed
	
	
	
	move_and_slide()
func sync_animation(anim_name: String):
	# If the sprite variable hasn't loaded yet, try to find it manually
	if npc_sprite == null:
		npc_sprite = get_node_or_null("AnimatedSprite2D")
	
	# Only play if the sprite exists and has the animation
	if npc_sprite and npc_sprite.sprite_frames.has_animation(anim_name):
		npc_sprite.play(anim_name)
