class_name humanNpc
extends CharacterBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

enum NpcState {Wandering, Scared, Following}
@export var reputation: float = 0

var current_state: NpcState = NpcState.Wandering
var target_wandering_points: Array[Vector2] = []

var point_just_moved_to:Vector2 

var cat_seen_for_how_long = 0.0

var TIME_UNTIL_STOP_CHASE_DUE_TO_disinterest = 10

var chase_time_disinterest = 0

var distance_for_npc_to_keep_interest = 250


var TIME_NPC_NEEDS_TO_FOLLOW_CAT = 5
var LOSE_TRACK_OF_TIME = 1
var MAX_TIME_SEEN_STORED = 8

var MAX_REP_FOR_SCARED = -5


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@export var cat_to_locate:PlayableCat

func _ready() -> void:
	for child_node in get_children():
		if child_node is Marker2D:
			target_wandering_points.append(child_node.global_position)


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
		NpcState.Scared:
			var vector_to_add = (cat_to_locate.global_position - global_transform.origin) * -1
			var desired_target : Vector2 = global_position + vector_to_add
			if desired_target:
				navigation_agent_2d.target_position = desired_target

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if chase_time_disinterest > TIME_UNTIL_STOP_CHASE_DUE_TO_disinterest:
		current_state = NpcState.Wandering
		cat_seen_for_how_long = 0
		chase_time_disinterest = 0
	
	check_if_cat_in_line_of_sight(delta)
	
	match current_state:
		NpcState.Following:
			if (cat_to_locate.global_position - global_transform.origin).length() > distance_for_npc_to_keep_interest:
				chase_time_disinterest += delta
				print(chase_time_disinterest)
	if navigation_agent_2d.is_navigation_finished():
		point_just_moved_to = navigation_agent_2d.target_position
		calculate_target_positon()
		return
	var way_to_go = navigation_agent_2d.get_next_path_position() 
	
	
			
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
				cat_seen_for_how_long += delta
				cat_seen_for_how_long = min(MAX_TIME_SEEN_STORED, cat_seen_for_how_long)
				if cat_seen_for_how_long >= TIME_NPC_NEEDS_TO_FOLLOW_CAT:
					if reputation > MAX_REP_FOR_SCARED:
						if current_state != NpcState.Following:
							chase_time_disinterest = 0
						current_state = NpcState.Following
						
					else:
						current_state = NpcState.Scared
			else:
				cat_seen_for_how_long = max(cat_seen_for_how_long - delta, 0)
				match current_state:
					NpcState.Following,NpcState.Scared:
						if cat_seen_for_how_long < LOSE_TRACK_OF_TIME:
							current_state = NpcState.Wandering
	else:
		print("ncp doens't have a tie to a cat will not follow if sees it")



func get_if_a_point_matches_last_point(point:Vector2):
	if point_just_moved_to:
		if point == point_just_moved_to:
			return false
	return true
func get_index_of_a_point(point:Vector2):
	pass


func die():
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
