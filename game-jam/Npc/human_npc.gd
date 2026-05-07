class_name humanNpc
extends CharacterBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

enum NpcState {Wandering, Scared, Following}
var current_state: NpcState = NpcState.Wandering
@export var target_wandering_points: Array[Vector2] = []

var point_just_moved_to:Vector2 

var cat_seen_for_how_long = 0.0

const TIME_NPC_NEEDS_TO_FOLLOW_CAT =2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var cat_to_locate:PlayableCat


func calculate_target_positon():
	match current_state:
		NpcState.Wandering:
			var desired_target : Vector2 = target_wandering_points.pick_random()
			if desired_target:
				navigation_agent_2d.target_position = desired_target
		NpcState.Following:
			var desired_target : Vector2 = cat_to_locate.global_position
			if desired_target:
				navigation_agent_2d.target_position = desired_target

func _physics_process(delta: float) -> void:
	# Add the gravity.
	check_if_cat_in_line_of_sight(delta)
	if navigation_agent_2d.is_navigation_finished():
		point_just_moved_to = navigation_agent_2d.target_position
		calculate_target_positon()
		return
	var way_to_go = navigation_agent_2d.get_next_path_position() 
	print(way_to_go)


	velocity = global_position.direction_to(way_to_go) * SPEED

	navigation_agent_2d.velocity = velocity
	
	

func check_if_cat_in_line_of_sight(delta):
	if cat_to_locate:
		var space_state = get_world_2d().direct_space_state
		
		var origin = global_transform.origin
		var destination = cat_to_locate.global_position # 20 units forward
		var query = PhysicsRayQueryParameters2D.create(origin, destination)
		
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider is PlayableCat:
				print("found cat to follow")
				cat_seen_for_how_long += delta
				if cat_seen_for_how_long >= TIME_NPC_NEEDS_TO_FOLLOW_CAT:
					current_state = NpcState.Following
			else:
				cat_seen_for_how_long = max(cat_seen_for_how_long - delta, 0)
	else:
		print("ncp doens't have a tie to a cat will not follow if sees it")



func get_if_a_point_matches_last_point(point:Vector2):
	if point_just_moved_to:
		if point == point_just_moved_to:
			return false
	return true
func get_index_of_a_point(point:Vector2):
	pass


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
