extends Control

@onready var pllay: Button = $Panel/VBoxContainer/pllay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pllay.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pllay_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Levels/AustinTestLeve.tscn")


func _on_quit_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
