extends Node2D



var health
var damage
var name_card
var effects
var costs


var points
var cards_left

var card_instance
var card_scene
@onready var card_container = $CardContainer
var card_list = []
var random_card
var shown_card
var button_list = []


func _ready() -> void:
	for button in $"../Buttons".get_children():
		if not button == $"../Buttons/Next_Card":
			button_list.append(button)
	
	card_scene = load("res://Scenes/Card.tscn")
	
	for i in range(DataBase.upgrade_card_amount):
		random_card = DataBase.deck_list.pick_random()
		card_list.append(random_card)
		
	cards_left = card_list.size() - 1
	
	for card in card_list:
		randomize_buttons()
		points = DataBase.upgrade_points
		shown_card = card
		$"../Texts/Card_Name".text = shown_card.card_name
		
		if "scaling" in shown_card.effects:
			$"../Counters/Scaling".visible = true
			shown_card.damage += 1
			shown_card.health += 1
		if "double_attack" in shown_card.effects:
			$"../Counters/Double_Attack".visible = true
		if "multi_attack" in shown_card.effects:
			$"../Counters/Multi_Attack".visible = true
		if "lifesteal" in shown_card.effects:
			$"../Counters/Lifesteal".visible = true
		if "death_bomb" in shown_card.effects:
			$"../Counters/Death Bomb".visible = true
		if "death_bomb_immunity" in shown_card.effects:
			$"../Counters/D-B Immunity".visible = true
		if "matroschka" in shown_card.effects:
			$"../Counters/Matroschka".visible = true
			
		$"../Counters/Punkte_Counter".text = str(points)
		$"../Counters/Cards_Counter".text = str(cards_left)
		show_card(shown_card)
			
		await $"../Buttons/Next_Card".pressed
			
		shown_card.card_name = $"../Texts/Card_Name".text
		cards_left -= 1
		hide_counters()
		card_container.remove_child(card_instance)
	
	DataBase.battle_path.fight_scene()

func show_card(card_data: Card_Data):
	card_instance = card_scene.instantiate()
	card_instance.set_data(card_data)
	card_container.add_child(card_instance)
	card_instance.scale = Vector2(3, 3)
	card_instance.get_node("size/Costs").modulate.a = 1
	card_instance.get_node("size/Name").modulate.a = 1
	card_instance.get_node("size/Attack").modulate.a = 1
	card_instance.get_node("size/Health").modulate.a = 1

func hide_counters():
	$"../Texts/Card_Name".clear()
	$"../Counters/Double_Attack".visible = false
	$"../Counters/Multi_Attack".visible = false
	$"../Counters/Scaling".visible = false
	$"../Counters/Lifesteal".visible = false
	$"../Counters/Death Bomb".visible = false
	$"../Counters/D-B Immunity".visible = false
	$"../Counters/Matroschka".visible = false

func update_stats():
	$"../Counters/Punkte_Counter".text = str(points)
	$"../Counters/Cards_Counter".text = str(cards_left)
	card_container.remove_child(card_instance)
	show_card(shown_card)
	
func randomize_buttons():
	for button in button_list:
		button.visible = false
		
	button_list.shuffle()
	for i in range(DataBase.upgrade_amount):
		button_list[i].visible = true
	
func Attack() -> void:
	if points >= 1:
		shown_card.damage += 2
		points -= 1
		update_stats()

func Health() -> void:
	if points >= 1:
		shown_card.health += 3
		points -= 1
		update_stats()

func Costs_Downgrade() -> void:
	if points >= 1:
		shown_card.cost -= 1
		points -= 1
		update_stats()

func Double_Attack() -> void:
	if points >= 1:
		if "double_attack" not in shown_card.effects:
			shown_card.effects.append("double_attack")
			shown_card.health -= 1
			$"../Counters/Double_Attack".visible = true
			points -= 1
			update_stats()

func Multi_Attack() -> void:
	if points >= 1:
		if "multi_attack" not in shown_card.effects:
			shown_card.effects.append("multi_attack")
			shown_card.damage -= 2
			$"../Counters/Multi_Attack".visible = true
			points -= 1
			update_stats()

func Lifesteal() -> void:
	if points >= 1:
		if "lifesteal" not in shown_card.effects:
			shown_card.effects.append("lifesteal")
			$"../Counters/Lifesteal".visible = true
			points -= 1
			update_stats()

func Scaling() -> void:
	if points >= 1:
		if "scaling" not in shown_card.effects:
			shown_card.effects.append("scaling")
			shown_card.health -= 1
			$"../Counters/Scaling".visible = true
			points -= 1
			update_stats()

func Death_Bomb() -> void:
	if points >= 1:
		if "death_bomb" not in shown_card.effects:
			shown_card.effects.append("death_bomb")
			$"../Counters/Death Bomb".visible = true
			points -= 1
			update_stats()

func Death_Bomb_Immunity() -> void:
	if points >= 1:
		if "death_bomb_immunity" not in shown_card.effects:
			shown_card.effects.append("death_bomb_immunity")
			$"../Counters/D-B Immunity".visible = true
			points -= 1
			update_stats()

func Matroschka() -> void:
	if points >= 1:
		if "matroschka" not in shown_card.effects:
			shown_card.effects.append("matroschka")
			shown_card.health = floor(shown_card.health / 2.0)
			$"../Counters/Matroschka".visible = true
			points -= 1
			update_stats()
