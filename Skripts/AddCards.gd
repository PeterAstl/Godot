extends Node

var foot
var hand
var nose
var mouth
var eye
var left_or_right
var body_parts_count = 0
var true_or_false
var toe_finger_list = []
var true_false = [true, false]
var foot_name = ["Fußibert", "Fußion", "Barfuß", "Kurfüßt", "Fußel"]
var hand_name = ["Handy"]

var next_id = 0
var enemy_next_id = 0
var card_name


func level_enemy_deck():
	add_foot_enemy(DataBase.level)

func add_foot_enemy(level):
	if DataBase.starting:
		left_or_right = randi_range(0, 1)
		if left_or_right == 1:
			foot = "L_Foot"
			left_or_right = false
		else:
			left_or_right = true
			foot = "R_Foot"
			
		enemy_next_id += 1
		card_name = "Card" + str(next_id)
		
		for i in range(5):
			true_or_false = true_false.pick_random()
			toe_finger_list.append(true_or_false)
			if true_or_false:
				body_parts_count += 1
		
		card_name = Card_Data.new({
		"damage": body_parts_count,
		"health": 5,
		"image_path": str("res://Pics/Gliedmaßen/" + foot + ".png"),
		 "toe_finger_places": toe_finger_list,
		"left_or_right": left_or_right,
		})
		DataBase.deck_enemy.append(card_name)
		body_parts_count = 0
		toe_finger_list = []
	else:
		for card in DataBase.deck_enemy:
			if level == 2:
				card.effects.append("lifesteal")
			card.health =  3 + level

func add_foot():
	left_or_right = randi_range(0, 1)
	if left_or_right == 1:
		foot = "L_Foot"
		left_or_right = false
	else:
		left_or_right = true
		foot = "R_Foot"
		
	next_id += 1
	card_name = "Card" + str(next_id)
	
	for i in range(5):
		true_or_false = true_false.pick_random()
		toe_finger_list.append(true_or_false)
		if true_or_false:
			body_parts_count += 1
	
	card_name = Card_Data.new({
	"name": foot_name.pick_random(),
	"damage": body_parts_count,
	"health": 5,
	"cost": 2,
	"image_path": str("res://Pics/Gliedmaßen/" + foot + ".png"),
	 "toe_finger_places": toe_finger_list,
	"left_or_right": left_or_right,
	})
	DataBase.deck_list.append(card_name)
	body_parts_count = 0
	toe_finger_list = []
