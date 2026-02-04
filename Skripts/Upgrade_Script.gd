extends Node2D

var health
var attack
var points
var cards_left
var name_card
var costs

func _ready() -> void:
	points = 10
	cards_left = len(DataBase.cards_buff.keys())
	for card in DataBase.cards_buff.keys():
		attack = DataBase.cards_buff[card][0]
		health = DataBase.cards_buff[card][1]
		name_card = DataBase.cards_buff[card][2]
		costs = DataBase.cards_buff[card][3]
		$"../Texts/Card_Name".text = name_card
		
		update_stats()
		
		await $"../Buttons/Next_Card".pressed
		
		name_card = $"../Texts/Card_Name".text
		$"../Texts/Card_Name".clear()
		DataBase.cards_buff[card] = [attack, health, name_card, costs]
		cards_left -= 1
		
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func update_stats():
	$"../Counters/Health_Counter".text = str(health)
	$"../Counters/Attack_Counter".text = str(attack)
	$"../Counters/Punkte_Counter".text = str(points)
	$"../Counters/Cards_Counter".text = str(cards_left)
	$"../Counters/Cost_Counter".text = str(costs)
	

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
