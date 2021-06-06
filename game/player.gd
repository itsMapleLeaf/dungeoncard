# i don't know how to make this better yet
extends Node2D
class_name Player

const animation_speed := 18

onready var body := $Body as Node2D
onready var body_offset := body.position

onready var right_hand := $RightHand as Node2D
onready var right_hand_offset := right_hand.position

onready var left_hand := $LeftHand as Node2D
onready var left_hand_offset := left_hand.position

onready var shadow := $Shadow as Node2D
onready var shadow_offset := shadow.position

func animate_screen_position(pos: Vector2, delta: float) -> void:
	body.global_position = lerp(body.global_position, pos + body_offset, min(delta * animation_speed, 1))
	right_hand.global_position = lerp(right_hand.global_position, pos + right_hand_offset, min(delta * animation_speed * 0.7, 1))
	left_hand.global_position = lerp(left_hand.global_position, pos + left_hand_offset, min(delta * animation_speed * 0.7, 1))
	shadow.global_position = lerp(shadow.global_position, pos + shadow_offset, min(delta * animation_speed, 1))
