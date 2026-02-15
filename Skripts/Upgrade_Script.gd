extends Node2D

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
var foot_name = ["Fußibert", "Lord Fußion", "Sir Barfuß", "Der Kurfüßt", "Kleiner Fußel"]
var hand_name = ["Handy"]

var random_card_image
var random_card_image_path

var health
var attack
var name_card
var effects
var costs
var texture

var card_name
var points
var cards_left
var next_id = 0
var player_cards = 5
var card_instance
var card_scene
@onready var card_container = $CardContainer
var card_now

func _ready() -> void:
	get_tree().paused = false
	print(card_container)
	card_scene = load("res://Scenes/Card.tscn")
	if DataBase.starting:
		for i in range(player_cards):
			add_foot()
			#add_hand()
			#add_eye()
			#add_mouth()
			#add_nose()
			DataBase.starting = false
	points = 20
	cards_left = DataBase.deck_list.size()
	
	for card in DataBase.deck_list:
		card_now = card
		show_card(card)
		costs = card.cost
		attack = card.attack
		health = card.health
		name_card = card.card_name
		effects = card.effects
		$"../Texts/Card_Name".text = name_card
		
		if "scaling" in effects:
			$"../Counters/Scaling".visible = true
			attack += 1
			health += 1
		if "double_attack" in effects:
			$"../Counters/Double_Attack".visible = true
		if "multi_attack" in effects:
			$"../Counters/Multi_Attack".visible = true
		if "lifesteal" in effects:
			$"../Counters/Lifesteal".visible = true
			
		update_stats()
			
		await $"../Buttons/Next_Card".pressed
			
		name_card = $"../Texts/Card_Name".text
		card.attack = attack
		card.health = health
		card.cost = costs
		card.card_name = name_card
		card.effects = effects
		
		hide_counters()
		card_container.remove_child(card_instance)
		
		cards_left -= 1
		
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func show_card(card_data: Card_Data):
	card_instance = card_scene.instantiate()
	card_instance.set_data(card_data)
	card_container.add_child(card_instance)
	card_instance.scale = Vector2(3, 3)
	card_instance.get_node("Costs").modulate.a = 1
	card_instance.get_node("Name").modulate.a = 1
	card_instance.get_node("Attack").modulate.a = 1
	card_instance.get_node("Health").modulate.a = 1
	

func hide_counters():
	$"../Texts/Card_Name".clear()
	$"../Counters/Double_Attack".visible = false
	$"../Counters/Multi_Attack".visible = false
	$"../Counters/Scaling".visible = false
	$"../Counters/Lifesteal".visible = false
	
func update_stats():
	$"../Counters/Punkte_Counter".text = str(points)
	$"../Counters/Cards_Counter".text = str(cards_left)
	
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
	"image_path": str("res://Pics/" + foot + ".png"),
	 "toe_finger_places": toe_finger_list,
	"left_or_right": left_or_right,
	})
	DataBase.deck_list.append(card_name)
	body_parts_count = 0
	toe_finger_list = []

func Attack() -> void:
	if points >= 1:
		attack += 1
		points -= 1
		update_stats()

func Health() -> void:
	if points >= 1:
		health += 1
		points -= 1
		update_stats()

func Costs_Downgrade() -> void:
	if points >= 3:
		costs -= 1
		points -= 3
		update_stats()

func Double_Attack() -> void:
	if "double_attack" not in effects:
		if points >= 3:
			effects.append("double_attack")
			$"../Counters/Double_Attack".visible = true
			points -= 3
			$"../Counters/Punkte_Counter".text = str(points)
		

func Multi_Attack() -> void:
	if "multi_attack" not in effects:
		if points >= 5:
			effects.append("multi_attack")
			$"../Counters/Multi_Attack".visible = true
			points -= 5
			$"../Counters/Punkte_Counter".text = str(points)
			
func Lifesteal() -> void:
	if "lifesteal" not in effects:
		if points >= 5:
			effects.append("lifesteal")
			$"../Counters/Lifesteal".visible = true
			points -= 5
			$"../Counters/Punkte_Counter".text = str(points)
			
func Scaling() -> void:
	if "scaling" not in effects:
		if points >= 3:
			effects.append("scaling")
			$"../Counters/Scaling".visible = true
			points -= 3
			$"../Counters/Punkte_Counter".text = str(points)
