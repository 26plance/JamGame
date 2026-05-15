class_name humanNpc
extends CharacterBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $Node2D/NavigationAgent2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


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
	for child_node in get_tree().get_nodes_in_group("Wanderpoints"):
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
				calculate_target_positon()
	if navigation_agent_2d.is_navigation_finished():
		point_just_moved_to = navigation_agent_2d.target_position
		calculate_target_positon()
		return
	var way_to_go = navigation_agent_2d.get_next_path_position() 
	
	
			
	velocity = global_position.direction_to(way_to_go) * SPEED

	navigation_agent_2d.velocity = velocity
	
	
func figure_out_animation_from_velocity(velocity:Vector2):
	var angle = velocity.angle()
	
	var closest_distance = 10000000
	var current_animation = "default"
	
	var directions = {
		0:"rightward_walk",
		90:"Downward_walk",
		-90:"upward_walk",
		180:"leftwardWalk",
		-180:"leftwardWalk"
	}
	# figure out closedt directions in positive and negitive ways, need to to do this for reasons
	for direction in directions:
		var diffence_in_angle = abs(angle_difference(angle,deg_to_rad(direction)))
		print(directions[direction])
		print(diffence_in_angle)
		if diffence_in_angle < closest_distance:
			closest_distance = diffence_in_angle
			current_animation = directions[direction]
	
	sprite_2d.play(current_animation)

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
						calculate_target_positon()
					else:
						current_state = NpcState.Scared
						calculate_target_positon()
			else:
				cat_seen_for_how_long = max(cat_seen_for_how_long - delta, 0)
				match current_state:
					NpcState.Following,NpcState.Scared:
						if cat_seen_for_how_long < LOSE_TRACK_OF_TIME:
							current_state = NpcState.Wandering
							calculate_target_positon()
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
	PointHandler.add_score(1,global_position)
	remove_from_group("npcs")


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	figure_out_animation_from_velocity(velocity)
	move_and_slide()


func cat_meowed(meow_posion, delta):
	if cat_to_locate:
		var space_state = get_world_2d().direct_space_state
		
		var origin = global_transform.origin
		var destination = cat_to_locate.global_position # 20 units forward
		var query = PhysicsRayQueryParameters2D.create(origin, destination)
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider is PlayableCat:
				cat_seen_for_how_long += 2 * delta
				chase_time_disinterest -= 1 * delta

func cat_hissed(hiss_positon, delta):
	if cat_to_locate:
		var space_state = get_world_2d().direct_space_state
		
		var origin = global_transform.origin
		var destination = cat_to_locate.global_position # 20 units forward
		var query = PhysicsRayQueryParameters2D.create(origin, destination)
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider is PlayableCat:
				chase_time_disinterest += 2 * delta
				cat_seen_for_how_long -= 2 * delta
