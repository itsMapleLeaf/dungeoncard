extends Entity
class_name Player

# TODO clean this up somehow
const animation_speed := 18

onready var body := $Body as Node2D
onready var body_offset := body.position

onready var right_hand := $RightHand as Node2D
onready var right_hand_offset := right_hand.position

onready var left_hand := $LeftHand as Node2D
onready var left_hand_offset := left_hand.position

onready var shadow := $Shadow as Node2D
onready var shadow_offset := shadow.position

func update_screen_position(screen_pos: Vector2, delta: float) -> void:
	body.global_position = lerp(body.global_position, screen_pos + body_offset, min(delta * animation_speed, 1))
	right_hand.global_position = lerp(right_hand.global_position, screen_pos + right_hand_offset, min(delta * animation_speed * 0.7, 1))
	left_hand.global_position = lerp(left_hand.global_position, screen_pos + left_hand_offset, min(delta * animation_speed * 0.7, 1))
	shadow.global_position = lerp(shadow.global_position, screen_pos + shadow_offset, min(delta * animation_speed, 1))

func play_attack_animation() -> void:
	var player := $AnimationPlayer as AnimationPlayer
	player.stop()
	player.play("SwordSwing")
