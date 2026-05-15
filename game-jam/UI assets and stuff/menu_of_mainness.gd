extends Control

@onready var pllay: Button = $Panel/VBoxContainer/pllay
@onready var transition = $transition/AnimationPlayer
var once = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	pllay.grab_focus()



func _on_pllay_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Levels/Portertestlevel.tscn")


func _on_quit_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_credits_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://UI assets and stuff/credits.tscn")
