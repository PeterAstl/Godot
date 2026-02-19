extends Node2D



var health
var damage
var name_card
var effects
var costs


var points
var cards_left

var player_cards = 5
var card_instance
var card_scene
@onready var card_container = $CardContainer
var card_now

func _ready() -> void:
	Adding.level_enemy_deck()
	get_tree().paused = false
	print(card_container)
	card_scene = load("res://Scenes/Card.tscn")
	if DataBase.starting:
		for i in range(10):
			Adding.add_foot_enemy(DataBase.level)
		for i in range(player_cards):
			Adding.add_foot()
			#Adding.add_hand()
			#Adding.add_eye()
			#Adding.add_mouth()
			#Adding.add_nose()
			DataBase.starting = false
	points = 20
	cards_left = DataBase.deck_list.size() - 1
	
	for card in DataBase.deck_list:
		card_now = card
		show_card(card)
		costs = card.cost
		damage = card.damage
		health = card.health
		name_card = card.card_name
		effects = card.effects
		$"../Texts/Card_Name".text = name_card
		
		if "scaling" in effects:
			$"../Counters/Scaling".visible = true
			damage += 1
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
		card.damage = damage
		card.health = health
		card.cost = costs
		card.card_name = name_card
		card.effects = effects
		
		hide_counters()
		card_container.remove_child(card_instance)
		
		cards_left -= 1
		
	DataBase.battle_path.fight_scene()

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


func Attack() -> void:
	if points >= 1:
		damage += 1
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
