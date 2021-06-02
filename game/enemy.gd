extends KinematicBody2D
class_name Enemy

signal damaged_target

const speed := 200.0
const max_health := 3.0
var health := max_health
var target: Node2D

onready var health_bar := $HealthBar
onready var controller := $PhysicsController

func _ready():
	health_bar.rect_pivot_offset = health_bar.rect_size / 2
	
	var movement_timer := Timer.new()
	movement_timer.wait_time = 2
	movement_timer.autostart = true
	movement_timer.connect("timeout", self, "move_towards_target")
	add_child(movement_timer)
	
func _physics_process(delta: float) -> void:
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		var node: Node2D = collision.collider
		if node.is_in_group("player"):
			emit_signal("damaged_target")

func damage() -> void:
	health -= 1
	health_bar.rect_scale.x = health / max_health
	if health <= 0:
		queue_free()
		
func set_target(new_target: Node2D) -> void:
	if target: target.disconnect("tree_exiting", self, "clear_target")
	target = new_target
	target.connect("tree_exiting", self, "clear_target")
	
func clear_target() -> void:
	target = null

func move_towards_target() -> void:
	if !target: return
	
	# AStar would be more correct for this but later aaaaa
	var direction := global_position.direction_to(target.global_position)
	controller.velocity = direction * speed

func to_nearest_cardinal(vec: Vector2) -> Vector2:
	if abs(vec.x) > abs(vec.y):
		return Vector2(sign(vec.x), 0)
	return Vector2(0, sign(vec.y))
