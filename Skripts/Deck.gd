extends Node2D


const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2
const STARTING_HAND_SIZE = 1

var player_deck = DataBase.deck_list
var drawn_card_this_turn = false
var ready_to_start = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		player_deck.shuffle()
		$RichTextLabel.text = str(player_deck.size())
		for i in range(STARTING_HAND_SIZE):
			draw_card()
			drawn_card_this_turn = false



func draw_card():
	if drawn_card_this_turn:
		return
	var drawn_card = player_deck[0]
	player_deck.erase(drawn_card)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	new_card.get_node("CardImage").texture = load(str(drawn_card.image_path))
	new_card.get_node("Attack").text = str(drawn_card.attack)
	new_card.get_node("Health").text = str(drawn_card.health)
	new_card.get_node("Name").text = str(drawn_card.card_name)
	new_card.get_node("Costs").text = str(drawn_card.cost)
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")
	
	drawn_card_this_turn = true
	
func reset_draw():
	drawn_card_this_turn = false
