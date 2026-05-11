class_name car
extends CharacterBody2D

var y_velocity = 0
var x_velocity = 0
var stop = false
var speedset = false
var cartype = "emergency"
var Cartypes = ["standard","slow","fast","emergency"]
var carstypedata = {
	"standard":{"speed": 35},
	"slow": {"speed": 15},
	"fast":{"speed": 55},
	"emergency": {"speed": 70}
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cartype = Cartypes.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if y_velocity == 0 and x_velocity == 0:
		speedset = false
	if  not speedset:
		if y_velocity != 0 or x_velocity != 0:
			speedset = true
			y_velocity *= carstypedata[cartype]["speed"]
			x_velocity *= carstypedata[cartype]["speed"]
	if not stop:
		velocity.x = x_velocity
		velocity.y = y_velocity
	else:
		if velocity.x != 0:
			velocity.x -= 20
		if velocity.y != 0:
			velocity.y -= 20
	var target_angle = atan2(velocity.y, velocity.x)
	rotation = lerp_angle(rotation, target_angle, 0.2)
	move_and_slide()


func _on_roadpart_detection_area_entered(area: Area2D) -> void:
	var desision
	if area.Roadpart == "turn":
		if area.position.x - 5 > position.x:
			desision = area.rightoptions.pick_random()
			print("right",area.position.x - 20," "+str(position.x))
		elif area.position.x + 5 < position.x:
			desision = area.leftoptions.pick_random()
			print("left")
		elif area.position.y - 5 > position.y:
			desision = area.downoptions.pick_random()
			print("down")
		elif area.position.y + 5 < position.y:
			desision = area.upoptions.pick_random()
			print("up")
		print(desision)
		match desision:
			"left":
				if x_velocity != 0:
					if x_velocity > 0:
						y_velocity = -10
						x_velocity = 0
					else:
						y_velocity = 10
						x_velocity = 0
				elif y_velocity != 0:
					if y_velocity > 0:
						y_velocity = 0
						x_velocity = 10
					else:
						y_velocity = 0
						x_velocity = -10
				speedset = false
			"right":
				if x_velocity != 0:
					if x_velocity > 0:
						y_velocity = 10
						x_velocity = 0
					else:
						y_velocity = -10
						x_velocity = 0
				elif y_velocity != 0:
					if y_velocity > 0:
						y_velocity = 0
						x_velocity = -10
					else:
						y_velocity = 0
						x_velocity = 10
				speedset = false
			"strait":
				pass
