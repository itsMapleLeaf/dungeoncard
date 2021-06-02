extends KinematicBody2D

var max_health := 5.0
var health := max_health

const speed := 300.0

onready var health_bar := $HealthBar as ColorRect

onready var damage_timeout := create_damage_timeout()

var controller = PhysicsController.new()

func _physics_process(delta: float) -> void:
	controller.update(delta, self)
	
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		if collision.collider is Enemy:
			damage()

func create_damage_timeout() -> Timer:
	var timer := Timer.new()
	timer.wait_time = 1.5
	timer.one_shot = true
	add_child(timer)
	return timer

func move(direction: Vector2) -> void:
	controller.velocity = direction * speed

func damage() -> void:
	if not damage_timeout.is_stopped(): return
	
	damage_timeout.start()
	health = max(health - 1, 0)
	health_bar.rect_scale.x = health / max_health

	# todo: end game, erase self from computer, set computer on fire, end planet
