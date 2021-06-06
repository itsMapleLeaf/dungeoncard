extends Node

const card_width := 50
const card_height := card_width
const card_spacing := 4
const card_animation_snappiness := 10
const hand_size := 5
const required_attack_distance := 32
const map_scale := 32

onready var deck := $UI/Deck
onready var hand := $UI/Hand

var map_size := 7

onready var player: Player = preload("res://game/player.tscn").instance()

func _ready() -> void:
	randomize()

	# init player
	player.map_pos = random_map_position()
	add_child(player)
	
	# init enemies
	for i in 5:
		var enemy = preload("res://game/slime.tscn").instance()
		enemy.map_pos = random_map_position()
		add_child(enemy)

	# init cards
	for card in deck.get_children():
		card.get_button().connect("pressed", self, "play_card", [card])
	
	for _i in range(5):
		draw_card()


func _process(delta: float) -> void:
	var cards := hand.get_children()
	cards.sort_custom(self, "sort_by_sort_order")
	
	var hand_width := cards.size() * (card_width + card_spacing) - card_spacing
	var hand_center := float(hand_width) / 2
	
	for index in range(hand.get_child_count()):
		var card: Card = cards[index]
		var x := index * (card_width + card_spacing) - hand_center
		var y := -card_height
		card.rect_position = lerp(card.rect_position, Vector2(x, y), delta * card_animation_snappiness)


func random_map_position() -> Vector2:
	return Vector2(randi() % map_size, randi() % map_size)

func damage_player() -> void:
	player.damage()

func play_card(card: Card) -> void:
	var intents := card.get_intents()
	for intent in intents: handle_intent(intent)
	
	# need to make sure the card is out of the hand before draw_card()
	# so that the positioning stuff in draw_card has the correct card count
	hand.remove_child(card)
	draw_card()
	deck.add_child(card)


func draw_card() -> void:
	if deck.get_child_count() == 0: return
	var card: Card = deck.get_children()[randi() % deck.get_child_count()]
	
	Helpers.reparent(card, deck, hand)
	
	var cards := hand.get_children()
	cards.sort_custom(self, "sort_by_sort_order")
	
	var hand_width := cards.size() * (card_width + card_spacing) - card_spacing
	var hand_center := float(hand_width) / 2
	
	var index := cards.find(card)
	var x := index * (card_width + card_spacing) - hand_center
	var y := -card_height
	
	# make the card start out of screen and animate in
	card.rect_position = Vector2(x, y) + Vector2(0, card_height)

func handle_intent(intent: Object) -> void:
	if intent is MovementIntent:
		player.move(intent.get_direction_vector())
	if intent is AttackIntent:
		player.try_attack()

func get_closest(nodes: Array, pivot: Node2D) -> Node2D:
	if nodes.empty(): return null

	var closest: Node2D = nodes.front()
	var closest_dist := distance_between(closest, pivot)
	for node in nodes.slice(1, nodes.size()):
		if not (node is Node2D):
			continue
		
		var distance := distance_between(node, pivot)
		if distance < closest_dist:
			closest = node
			closest_dist = distance
			
	return closest

func distance_between(a: Node2D, b: Node2D) -> float:
	return (a.global_position - b.global_position).length()

func sort_by_sort_order(a: Card, b: Card) -> bool:
	return a.sort_order < b.sort_order
