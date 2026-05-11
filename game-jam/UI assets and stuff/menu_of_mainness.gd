extends Control

@onready var pllay: Button = $Panel/VBoxContainer/pllay
@onready var transition = $transition/AnimationPlayer
var once = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	pllay.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if once:
		await get_tree().create_timer(1).timeout
		transition.play("fade_in")
		once = false


func _on_pllay_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Levels/AustinTestLeve.tscn")


func _on_quit_pressed() -> void:
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_credits_pressed() -> void:
	pass # Replace with function body.
