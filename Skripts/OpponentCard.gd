extends Node2D

class_name Card_Enemy

var data: Card_Data
var card_slot_card_in
var position_in_hand
var fought
var toe_node

func _ready():
	if data:
		setup_from_data()

func set_data(card_data: Card_Data):
	data = card_data
	if is_inside_tree():
		setup_from_data()

func setup_from_data():
	$CardImage.texture = load(data.image_path)
	$Attack.text = str(data.damage)
	$Health.text = str(data.health)
	$Name.text = data.card_name
	for i in range(data.toe_finger_places.size()):
		if not data.left_or_right:
			$Toe1.texture = load("res://Pics/Gliedmaßen/L_Toe1.png")
			$Toe2.texture = load("res://Pics/Gliedmaßen/L_Toe2.png")
			$Toe3.texture = load("res://Pics/Gliedmaßen/L_Toe3.png")
			$Toe4.texture = load("res://Pics/Gliedmaßen/L_Toe4.png")
			$Toe5.texture = load("res://Pics/Gliedmaßen/L_Toe5.png")
		if data.toe_finger_places[i]:
			toe_node = get_node("Toe" + str(i+1))
			toe_node.visible = true
