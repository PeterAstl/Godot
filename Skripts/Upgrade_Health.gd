extends Node2D

var points
var pressed = false

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
	if points >= 2:
		DataBase.player_health += 1
		$Hearts.text = "🫀".repeat(DataBase.player_health)
		points -= 2
		$Points.text = "Points: " + str(points)
		if points == 0:
				DataBase.battle_path.upgrade_card()

func Button2() -> void:
	if points >= 3:
		DataBase.deck_list.shuffle()
		for card in DataBase.deck_list:
			if "lifesteal" not in card.effects:
				card.card_name = "Lifesteal"
				card.effects.append("lifesteal")
				points -= 3
				$Points.text = "Points: " + str(points)
				break
		if points == 0:
			DataBase.battle_path.upgrade_card()

func Button3() -> void:
	if points >= 3:
		for card in DataBase.deck_list:
			card.health += 1
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()


func Button4() -> void:
	if points >= 5:
		for card in DataBase.deck_list:
			if "death_bomb" not in card.effects:
				card.card_name = "Stinkfuß"
				card.effects.append("death_bomb")
		points -= 5
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()
			
func Button5() -> void:
	if points >= 5:
		DataBase.upgrade_card_amount += 1
		points -= 5
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()
			
func Button6() -> void:
	if points >= 3:
		if not pressed:
			for card in DataBase.deck_list:
				card.health = card.damage
			points -= 3
			$Points.text = "Points: " + str(points)
			pressed = true
			if points == 0:
				DataBase.battle_path.upgrade_card()

func Continue_Button() -> void:
	DataBase.points = points
	DataBase.battle_path.upgrade_card()
