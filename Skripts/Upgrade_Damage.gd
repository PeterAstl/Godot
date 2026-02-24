extends Node2D

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
	if points >= 2:
		DataBase.player_health += 1
		$Hearts.text = "🫀".repeat(DataBase.opponent_health)
		points -= 2
		$Points.text = "Points: " + str(points)
		if points == 0:
				DataBase.battle_path.upgrade_card()

func Button2() -> void:
	if points >= 3:
		for card in DataBase.deck_list:
			card.damage += 1
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()

func Button3() -> void:
	if points >= 3:
		DataBase.deck_list.shuffle()
		for card in DataBase.deck_list:
			if "double_attack" not in card.effects:
				card.card_name = "DoubleTrouble"
				card.effects.append("double_attack")
				points -= 3
				$Points.text = "Points: " + str(points)
				break
		if points == 0:
			DataBase.battle_path.upgrade_card()

func Button4() -> void:
	if points >= 5:
		DataBase.deck_list.shuffle()
		for card in DataBase.deck_list:
			if "multi_attack" not in card.effects:
				card.card_name = "Mutlimedia"
				card.effects.append("multi_attack")
				points -= 5
				$Points.text = "Points: " + str(points)
				break
		if points == 0:
			DataBase.battle_path.upgrade_card()
			
func Button5() -> void:
	if points >= 2:
		var double
		var starting = true
		for card in DataBase.deck_list:
			if starting:
				double = card
				starting = false
			if card.damage <= double.damage:
				double = card
		double.damage *= 2
		double = null
		points -= 2
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()
			
func Button6() -> void:
	if points >= 2:
		DataBase.upgrade_amount += 1
		points -= 2
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()

func Continue_Button() -> void:
	DataBase.points = points
	DataBase.battle_path.upgrade_card()
