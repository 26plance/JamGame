class_name FollowingCat
extends CharacterBody2D
var follow_target: PlayableCat
var follow_index: int = 0
@export var speed: float = 350.0
@export var min_distance: float = 5
@onready var npc_sprite: AnimatedSprite2D = $Sprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D




var added_velocity = Vector2()

const flung_cat_slow_down = 1000


func _ready():
	navigation_agent_2d.max_speed = speed
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
	
	var target_pos = follow_target.cat_herd_follow.global_position
	navigation_agent_2d.target_position =   target_pos
	var way_to_go = navigation_agent_2d.get_next_path_position() 
	
	var distance = global_position.distance_to(way_to_go)
	if distance > min_distance:
		
		
		navigation_agent_2d.velocity = global_position.direction_to(way_to_go) * speed
	
func sync_animation(anim_name: String):
	# If the sprite variable hasn't loaded yet, try to find it manually
	if npc_sprite == null:
		npc_sprite = get_node_or_null("AnimatedSprite2D")
	
	# Only play if the sprite exists and has the animation
	if npc_sprite and npc_sprite.sprite_frames.has_animation(anim_name):
		npc_sprite.play(anim_name)


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	velocity += added_velocity
	move_and_slide()
 
