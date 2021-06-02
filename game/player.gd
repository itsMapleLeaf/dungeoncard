extends KinematicBody2D

const speed := 300.0

var max_health := 5.0
var health := max_health

var ghosting := false # if the player can take damage
const ghosting_time := 1.5

onready var health_bar := $HealthBar
onready var controller := $PhysicsController
onready var sprite := $IdleAnimation

func _process(_delta: float) -> void:
	sprite.modulate.a = 0.5 if ghosting else 1.0

func _physics_process(_delta: float) -> void:
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		if collision.collider is Enemy:
			damage()

func move(direction: Vector2) -> void:
	controller.velocity = direction * speed

func damage() -> void:
	if ghosting: return
	
	health = max(health - 1, 0)
	health_bar.rect_scale.x = health / max_health
	
	ghosting = true
	yield(get_tree().create_timer(ghosting_time), "timeout")
	ghosting = false

	# todo: end game, erase self from computer, set computer on fire, end planet
