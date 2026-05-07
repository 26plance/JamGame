extends Control

@onready var pllay: Button = $Panel/VBoxContainer/pllay
@onready var transition = $transition/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	pllay.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pllay_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Levels/AustinTestLeve.tscn")


func _on_quit_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
