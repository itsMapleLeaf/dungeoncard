extends Entity
class_name Slime

const animation_speed := 4

var time := 0.0
var move_timer: Timer

onready var body := $Body as Sprite

func _process(delta: float):
	time += delta
	body.scale.y = lerp(0.8, 1, abs(sin(time * animation_speed)))
	($TimeDisplay as Arc).angle_to = (move_timer.time_left / move_timer.wait_time) * 360
