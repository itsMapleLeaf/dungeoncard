extends Control
class_name Card

export var card_id := ""

func get_button():
	return get_node("Button")

func get_intents() -> Array:
	var intents_node := get_node("Intents")
	return intents_node.get_children() if intents_node else []
