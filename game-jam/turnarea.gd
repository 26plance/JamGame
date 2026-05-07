extends Area2D

var Roadpart = "turn"
@export var leftturn = true
@export var strait = true
@export var rightturn = true
var options = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if leftturn:
		options.append("left")
	if rightturn:
		options.append("right")
	if strait:
		options.append("strait")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
