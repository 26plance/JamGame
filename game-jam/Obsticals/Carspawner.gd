extends Node2D

@export var vertical = false
@export var direction : int = 0
var timetillspawn = 0
var timercurant = false
func  _ready() -> void:
	timetillspawn = randi_range(2,15)
	
func _process(delta: float) -> void:
	if not timercurant:
		timercurant = true
		await  get_tree().create_timer(timetillspawn).timeout
		var cartospawn = load("res://Obsticals/car.tscn")
		var random_hue = randf() 
		var car = cartospawn.instantiate()
		car.modulate = Color.from_hsv(random_hue, 0.8, 0.9)
		if vertical and direction > 0:
			car.y_velocity = -10
		elif vertical and direction < 0:
			car.y_velocity = 10
		elif not vertical and direction < 0:
			car.x_velocity = -10
		elif  not vertical and direction > 0:
			car.x_velocity = 10
		car.global_position = self.global_position
		get_parent().add_child(car)
		timercurant = false
		timetillspawn = randi_range(2,15)
