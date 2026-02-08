extends Node2D

var random_card = {
	"Le'Murr": "Le'Murr",
	"Lion Mask": "Lion Mask",
	"Lucy'Faer": "Lucy'Faer",
	"Mirae": "Mirae",
	"Mor’Yra": "Mor’Yra",
	"Serxia": "Serxia",
	"Sun Mask": "Sun Mask",
	"Xera": "Xera",
	"Zeyx": "Zeyx",
}

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


func _ready() -> void:
	get_tree().paused = false
	if DataBase.starting:
		for i in range(player_cards):
			add_card()
			DataBase.starting = false
	points = 20
	cards_left = DataBase.deck_list.size()
	
	for card in DataBase.deck_list:
		texture = card.image_path
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
		
		cards_left -= 1
		
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func hide_counters():
	$"../Texts/Card_Name".clear()
	$"../Counters/Double_Attack".visible = false
	$"../Counters/Multi_Attack".visible = false
	$"../Counters/Scaling".visible = false
	$"../Counters/Lifesteal".visible = false
	
func update_stats():
	$Sprite2D.texture = load(texture)
	$"../Counters/Health_Counter".text = str(health)
	$"../Counters/Attack_Counter".text = str(attack)
	$"../Counters/Punkte_Counter".text = str(points)
	$"../Counters/Cards_Counter".text = str(cards_left)
	$"../Counters/Cost_Counter".text = str(costs)
	
func add_card():
	next_id += 1
	card_name = "Card" + str(next_id)
	random_card_image = random_card.keys().pick_random()
	random_card_image_path = random_card[random_card_image]
	
	card_name = Card_Data.new({
	"name": random_card_image,
	"damage": 1,
	"health": 2,
	"cost": 1,
	"image_path": str("res://Pics/" + random_card_image_path + ".png")
	})
	DataBase.deck_list.append(card_name)

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
