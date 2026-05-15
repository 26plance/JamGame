extends Control
@onready var transition = $transition/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	$Button.grab_focus()

func _on_button_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UI assets and stuff/menu_of_mainness.tscn")
