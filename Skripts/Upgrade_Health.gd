extends Node2D

var while_false = false
var points

func _ready() -> void:
	get_tree().paused = false
	if DataBase.starting:
		Adding.start()
		DataBase.starting = false
	Adding.level_up_enemy()
	
	points = DataBase.points
	points += 5
	
	$Points.text = "Points: " + str(points)
	$Hearts.text = "🫀".repeat(DataBase.player_health)
	
func Button1() -> void:
	if points >= 1:
		DataBase.player_health += 1
		$Hearts.text = "🫀".repeat(DataBase.player_health)
		points -= 1
		$Points.text = "Points: " + str(points)
		if points == 0:
				DataBase.battle_path.fight_scene()

func Button2() -> void:
	if points >= 2:
		while not while_false:
			DataBase.deck_list.shuffle()
			for card in DataBase.deck_list:
				if "lifesteal" not in card.effects:
					card.card_name = "Lifesteal"
					card.effects.append("lifesteal")
					while_false = true
					points -= 2
					$Points.text = "Points: " + str(points)
					break
			while_false = true
		while_false = false
		if points == 0:
			DataBase.battle_path.fight_scene()

func Button3() -> void:
	if points >= 3:
		for card in DataBase.deck_list:
			card.health += 1
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.fight_scene()


func Button4() -> void:
	if points >= 5:
		for card in DataBase.deck_list:
			if "death_bomb" not in card.effects:
				card.card_name = "death_bomb"
				card.effects.append("death_bomb")
		points -= 5
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.fight_scene()


func Continue_Button() -> void:
	DataBase.points = points
	DataBase.battle_path.fight_scene()
