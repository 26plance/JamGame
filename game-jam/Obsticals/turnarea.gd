extends Area2D

var Roadpart = "turn"
@export_category ("Left")
@export var leftturnl = true
@export var straitl = true
@export var rightturnl = true
@export_category ("Right")
@export var leftturnr = true
@export var straitr = true
@export var rightturnr = true
@export_category ("Up")
@export var leftturnu = true
@export var straitu = true
@export var rightturnu = true
@export_category ("Down")
@export var leftturnd = true
@export var straitd = true
@export var rightturnd = true
var leftoptions = []
var rightoptions = []
var upoptions = []
var downoptions = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if leftturnl:
		leftoptions.append("left")
	if rightturnl:
		leftoptions.append("right")
	if straitl:
		leftoptions.append("strait")
	if leftturnr:
		rightoptions.append("left")
	if rightturnr:
		rightoptions.append("right")
	if straitr:
		rightoptions.append("strait")
	if leftturnu:
		upoptions.append("left")
	if rightturnu:
		upoptions.append("right")
	if straitu:
		upoptions.append("strait")
	if leftturnd:
		downoptions.append("left")
	if rightturnd:
		downoptions.append("right")
	if straitd:
		downoptions.append("strait")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
