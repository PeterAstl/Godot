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
	$Hearts.text = "🫀".repeat(DataBase.opponent_health)
	
func Button1() -> void:
	if points >= 4:
		DataBase.player_ressource_amount = 4
		points -= 4
		$Points.text = "Points: " + str(points)
		if points == 0:
				DataBase.battle_path.fight_scene()

func Button2() -> void:
	if points >= 3:
		DataBase.player_effects.append("draw")
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.fight_scene()

func Button3() -> void:
	if points >= 2:
		Adding.add_foot()
		points -= 2
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.fight_scene()

func Button4() -> void:
	if points >= 3:
		DataBase.player_effects.append("immunity")
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.fight_scene()
			
func Button5() -> void:
	if points >= 2:
		while not while_false:
			DataBase.deck_list.shuffle()
			for card in DataBase.deck_list:
				if "scaling" not in card.effects:
					card.card_name = "Scaling"
					card.effects.append("scaling")
					while_false = true
					points -= 2
					$Points.text = "Points: " + str(points)
					break
			while_false = true
		while_false = false
		if points == 0:
			DataBase.battle_path.fight_scene()

func Button6() -> void:
	if points >= 2:
		if randi_range(1,2) == 2:
			points += 2
		else:
			points -= 2
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.fight_scene()

func Button7() -> void:
	if points >= 5:
		Adding.add_bigfoot()
		

func Continue_Button() -> void:
	DataBase.points = points
	DataBase.battle_path.fight_scene()
