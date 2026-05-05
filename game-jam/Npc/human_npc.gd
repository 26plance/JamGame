class_name humanNpc
extends CharacterBody2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

enum NpcState {Wandering, Scared, Following}
var current_state: NpcState = NpcState.Wandering
@export var target_wandering_points: Array[Vector2] = []

var point_just_moved_to:Vector2 

const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func calculate_target_positon():
	match current_state:
		NpcState.Wandering:
			var desired_target : Vector2 = target_wandering_points.pick_random()
			if desired_target:
				navigation_agent_2d.target_position = desired_target
				

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if navigation_agent_2d.is_navigation_finished():
		print("nav finished")
		point_just_moved_to = navigation_agent_2d.target_position
		calculate_target_positon()
		return
	var way_to_go = navigation_agent_2d.get_next_path_position() 
	print(way_to_go)


	velocity = global_position.direction_to(way_to_go) * SPEED

	navigation_agent_2d.velocity = velocity
	move_and_slide()
	

func get_if_a_point_matches_last_point(point:Vector2):
	if point_just_moved_to:
		if point == point_just_moved_to:
			return false
	return true
func get_index_of_a_point(point:Vector2):
	pass


#func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	#velocity = safe_velocity
	#move_and_slide()
