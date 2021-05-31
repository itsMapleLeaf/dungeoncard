extends Node

const card_width = 50
const card_height = card_width
const card_spacing = 4
const card_animation_snappiness = 10

onready var deck := $ui/deck
onready var hand := $ui/hand

func _ready() -> void:
	for card in deck.get_children():
		card.connect("pressed", self, "play_card", [card])
	
	randomize()
	for _i in range(3): draw_card()


func _process(delta: float) -> void:
	var cards := hand.get_children()
	cards.sort_custom(HandSorter, "sort")
	
	var hand_width := cards.size() * (card_width + card_spacing) - card_spacing
	var hand_center := float(hand_width) / 2
	
	for index in range(hand.get_child_count()):
		var card: TextureButton = cards[index]
		var x := index * (card_width + card_spacing) - hand_center
		var y := -card_height
		card.rect_position = lerp(card.rect_position, Vector2(x, y), delta * card_animation_snappiness)


func play_card(card: TextureButton) -> void:
	# need to make sure the card is out of the hand before draw_card()
	# so that the positioning stuff in draw_card has the correct card count
	hand.remove_child(card)
	draw_card()
	deck.add_child(card)


func draw_card() -> void:
	var card: TextureButton = deck.get_children()[randi() % deck.get_child_count()]
	
	Helpers.reparent(card, deck, hand)
	
	var cards := hand.get_children()
	cards.sort_custom(HandSorter, "sort")
	
	var hand_width := cards.size() * (card_width + card_spacing) - card_spacing
	var hand_center := float(hand_width) / 2
	
	var index := cards.find(card)
	var x := index * (card_width + card_spacing) - hand_center
	var y := -card_height
	
	# make the card start out of screen and animate in
	card.rect_position = Vector2(x, y) + Vector2(0, card_height)


class HandSorter:
	static func sort(a: Card, b: Card) -> bool:
		var order := [
			'move_left',
			'move_down',
			'move_up',
			'move_right',
		]
		return order.find(a.card_id) < order.find(b.card_id)
