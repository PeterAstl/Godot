extends Node2D

var points
var luck = 95
var lucky_hit

func wait(t):
	await get_tree().create_timer(t).timeout

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
	if points >= 3:
		DataBase.opponent_health *= 2
		$Hearts.text = "🫀".repeat(DataBase.opponent_health)
		$Points.text = "Points: " + str(points)
		DataBase.deck_list.shuffle()
		for card in DataBase.deck_list:
			if "multi_attack" not in card.effects:
				card.card_name = "Multimedia"
				card.effects.append("multi_attack")
				break
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()

func Button2() -> void:
	lucky_hit = randi_range(1,100)
	if lucky_hit <= luck:
		points += 1
		$Points.text = "Points: " + str(points)
		luck -= 10
		$Button2.text = "Gain 1 Point\nLoose Game " + str(100 - luck) + "% Chance\n"
	else:
		$"../AudioStreamPlayer".play()
		await wait(2)
		get_tree().free()


func Button3() -> void:
	if points >= 3:
		DataBase.deck_list.shuffle()
		for i in range(2):
			DataBase.deck_list.pick_random().cost -= 1
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()

func Button4() -> void:
	if points >= 10:
		DataBase.deck_list.shuffle()
		for card in DataBase.deck_list:
			if "multi_attack" not in card.effects and "double_attack" not in card.effects:
				card.card_name = "Exodia"
				card.effects.append("multi_attack")
				card.effects.append("double_attack")
				points -= 10
				$Points.text = "Points: " + str(points)
				break
		if points == 0:
			DataBase.battle_path.upgrade_card()
			
func Button5() -> void:
	if points >= 3:
		for card in DataBase.deck_list:
			card.health += 2
			card.damage -= 1
		points -= 3
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()
			
func Button6() -> void:
	if points >= 6:
		DataBase.upgrade_points += 1
		points -= 6
		$Points.text = "Points: " + str(points)
		if points == 0:
			DataBase.battle_path.upgrade_card()

func Continue_Button() -> void:
	DataBase.points = points
	DataBase.battle_path.upgrade_card()
