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
	$size/CardImage.texture = load(data.image_path)
	$size/Attack.text = str(data.damage)
	$size/Health.text = str(data.health)
	$size/Name.text = data.card_name
	for i in range(data.toe_finger_places.size()):
		if not data.left_or_right:
			$size/Toe1.texture = load("res://Pics/Gliedmaßen/L_Toe1.png")
			$size/Toe2.texture = load("res://Pics/Gliedmaßen/L_Toe2.png")
			$size/Toe3.texture = load("res://Pics/Gliedmaßen/L_Toe3.png")
			$size/Toe4.texture = load("res://Pics/Gliedmaßen/L_Toe4.png")
			$size/Toe5.texture = load("res://Pics/Gliedmaßen/L_Toe5.png")
		if data.toe_finger_places[i]:
			toe_node = get_node("size/Toe" + str(i+1))
			toe_node.visible = true
	if data.card_name == "BigFoot":
		$size.scale = Vector2(1.5,1.5)
	for effect in data.effects:
		pass
		
