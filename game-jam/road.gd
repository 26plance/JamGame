extends Node2D

@export var vertical = false
@export var bothways = true
@export var lanes = 2
var laneslist = {}
var lanewidth
var lanelength

func  _ready() -> void:
	if not vertical:
		lanelength = $"Area detection/CollisionShape2D".shape.size.x
		lanewidth = $"Area detection/CollisionShape2D".shape.size.y / lanes
	else:
		lanewidth = $"Area detection/CollisionShape2D".shape.size.x
		lanelength = $"Area detection/CollisionShape2D".shape.size.y / lanes
	var verticalwidthadd
	var widthadd
	for lane in range(lanes):
		laneslist["lane"+str(lane)] = { "lanestart" = $"Area detection/CollisionShape2D".position + verticalwidthadd, "laneend" = $"Area detection/CollisionShape2D".position + verticalwidthadd + lanelength, "widthstart" = $"Area detection/CollisionShape2D".position + widthadd, "widthend" = $"Area detection/CollisionShape2D".position + widthadd + lanewidth,}

func _process(delta: float) -> void:
	for lane in range(lanes):
		pass
