extends Node2D

var random_card = {
	"Schwarz": "Card1",
	"Schwarz2": "Card2",
	"Rot": "Card3",
	"Blau": "Card4",
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

var starting = true


func _ready() -> void:
	if starting:
		add_card()
		add_card()
		add_card()
	
	points = 10
	cards_left = DataBase.deck_list.size()
	
	for card in DataBase.deck_list:
		texture = card.image_path
		costs = card.cost
		attack = card.attack
		health = card.health
		name_card = card.card_name
		effects = card.effects
		$"../Texts/Card_Name".text = name_card
			
		update_stats()
			
		await $"../Buttons/Next_Card".pressed
			
		name_card = $"../Texts/Card_Name".text
		card.attack = attack
		card.health = health
		card.cost = costs
		card.card_name = name_card
		card.effects = effects
		
		$"../Texts/Card_Name".clear()
		cards_left -= 1
	
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
		
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
	
	card_name = Card.new({
	"name": random_card_image,
	"damage": 1,
	"health": 2,
	"cost": 1,
	"image_path": str("res://Pics/" + random_card_image_path + ".png")
	})
	DataBase.deck_list.append(card_name)

func Attack() -> void:
	if points > 0:
		attack += 1
		points -= 1
		update_stats()

func Health() -> void:
	if points > 0:
		health += 1
		points -= 1
		update_stats()

func Costs_Downgrade() -> void:
	if points > 2:
		costs -= 1
		points -= 3
		update_stats()
