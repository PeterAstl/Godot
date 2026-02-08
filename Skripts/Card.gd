extends Node2D

class_name Card

var data: Card_Data
var card_slot_card_in
var position_in_hand
var fought

func _ready():
	$Area2D.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	$Area2D.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	if data:
		setup_from_data()

func set_data(card_data: Card_Data):
	data = card_data
	if is_inside_tree():
		setup_from_data()

func setup_from_data():
	$CardImage.texture = load(data.image_path)
	$Attack.text = str(data.attack)
	$Health.text = str(data.health)
	$Name.text = data.card_name
	$Costs.text = str(data.cost)

signal hovered(card)
signal hovered_off(card)


func _on_mouse_entered():
	emit_signal("hovered", self)

func _on_mouse_exited():
	emit_signal("hovered_off", self)
