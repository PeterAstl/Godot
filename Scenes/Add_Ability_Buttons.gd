extends Node2D

var health
var attack
var points
var cards_left

func _ready() -> void:
	points = 10
	cards_left = len(DataBase.cards_buff.keys())
	for card in DataBase.cards_buff.keys():
		attack = DataBase.cards_buff[card][0]
		health = DataBase.cards_buff[card][1]
		print(attack)
		print(health)
		print(DataBase.cards_buff[card][0])
		update_stats()
		
		await $"../Buttons/Next_Card".pressed
		
		DataBase.cards_buff[card] = [attack, health]
		cards_left -= 1
		
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func update_stats():
	$"../Counters/Health_Counter".text = str(health)
	$"../Counters/Attack_Counter".text = str(attack)
	$"../Counters/Punkte_Counter".text = str(points)
	$"../Counters/Cards_Counter".text = str(cards_left)

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
