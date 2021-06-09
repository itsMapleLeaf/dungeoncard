extends Control
class_name Card

signal clicked

enum CardType {
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
	ATTACK,
}

var type: int = CardType.MOVE_LEFT

onready var board := $Node/Board as Sprite
onready var move_icon := $Node/MoveIcon as Sprite
onready var attack_icon := $Node/AttackIcon as Sprite

static func get_card_types() -> Array:
	return CardType.values()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if board.get_rect().has_point($Node.to_local(event.position)):
				emit_signal("clicked")

func _process(delta):
	match type:
		CardType.MOVE_LEFT:
			move_icon.visible = true
			move_icon.rotation_degrees = 180
			
		CardType.MOVE_RIGHT:
			move_icon.visible = true
			
		CardType.MOVE_UP:
			move_icon.visible = true
			move_icon.rotation_degrees = -90
			
		CardType.MOVE_DOWN:
			move_icon.visible = true
			move_icon.rotation_degrees = 90
			
		CardType.ATTACK:
			attack_icon.visible = true

func set_type(new_type: int) -> void:
	type = new_type

func play_reveal_animation():
	$AnimationPlayer.play("Reveal", -1, 3)
