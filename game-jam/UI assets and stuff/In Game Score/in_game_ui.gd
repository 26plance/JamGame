extends Control
@onready var score_label: Label = $ScoreLabel
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "Score: 0"
	PointHandler.score_changed.connect(score_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func score_changed():
	score_label.text = "Score: " + str(int(PointHandler.current_score))
	animation_player.play("appear then disapear")
