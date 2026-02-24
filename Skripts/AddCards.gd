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

var fun = [add_foot_enemy]
var effect_list = ["lifesteal", "scaling", "multi_attack", "double_attack", "matroschka", "death_bomb", "death_bomb_immunity"]
var opponent_starting_cards = 7
var level
	
func start():
	for i in range(opponent_starting_cards):
		fun.pick_random().call()
	for i in range(5):
		add_foot()

func level_up_enemy():
	level = DataBase.level
	for card in DataBase.deck_enemy:
		card.effects.append(effect_list.pick_random())
		card.health =  1 + level
		if level == 2:
			DataBase.opponent_effects.append("start_play")
		if level == 3:
			card.effects.append("lifesteal")
		if level == 4:
			if "lifesteal" in card.effects:
				card.effects.erase("lifesteal")
			card.effects.append("double_attack")
		if level == 5:
			DataBase.opponent_effects.append("play")
		if level == 6:
			if "double_attack" in card.effects:
				card.effects.erase("double_attack")
			card.effects.append("multi_attack")
		if level == 9:
			DataBase.opponent_effects = []
			DataBase.deck_enemy = []
			DataBase.starting_hand_size_enemy = 1
			add_boss()

func add_foot_enemy():
	left_or_right = randi_range(0, 1)
	if left_or_right == 1:
		foot = "L_Foot"
		left_or_right = false
	else:
		left_or_right = true
		foot = "R_Foot"
		
	enemy_next_id += 1
	card_name = "Card" + str(enemy_next_id)
	
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
	"effects" : []
	})
	DataBase.deck_enemy.append(card_name)
	body_parts_count = 0
	toe_finger_list = []

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
	"health": 3,
	"cost": 2,
	"image_path": str("res://Pics/Gliedmaßen/" + foot + ".png"),
	 "toe_finger_places": toe_finger_list,
	"left_or_right": left_or_right,
	#"effects": ["matroschka"]
	})
	DataBase.deck_list.append(card_name)
	body_parts_count = 0
	toe_finger_list = []

func add_bigfoot():
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
		toe_finger_list.append(true)
	
	card_name = Card_Data.new({
	"name": "BigFoot",
	"damage": 5,
	"health": 7,
	"cost": 3,
	"image_path": str("res://Pics/Gliedmaßen/" + foot + ".png"),
	 "toe_finger_places": toe_finger_list,
	"left_or_right": left_or_right,
	"effects": ["double_attack", "lifesteal"]
	})
	DataBase.deck_list.append(card_name)
	toe_finger_list = []

func add_boss():
	enemy_next_id += 1
	card_name = "Card" + str(enemy_next_id)
	
	card_name = Card_Data.new({
	"name": "Scavalouche",
	"damage": 3,
	"health": 999,
	"cost": 3,
	"image_path": "res://Pics/Boss.png",
	"effects": ["double_attack", "lifesteal", "multi_attack", "death_bomb_immunity"]
	})
	DataBase.deck_enemy.append(card_name)
	toe_finger_list = []
