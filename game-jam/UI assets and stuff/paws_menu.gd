extends Control

@onready var transition = $transition/AnimationPlayer
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	#REMOVE THIS
	$Panel/VBoxContainer/Button.grab_focus()
	$transition.visible = false


func _on_quit_pressed() -> void:
	$transition.visible = true
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UI assets and stuff/menu_of_mainness.tscn")


func _on_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
	self.queue_free()
