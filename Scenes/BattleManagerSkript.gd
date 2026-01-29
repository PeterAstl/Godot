extends Node

var battle_timer
var empty_card_slots = []
const CARD_SMALLER_SCALE = 1
const CARD_MOVE_SPEED = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	
	empty_card_slots.append($"../CardSlots_Enemy/CardSlot")
	empty_card_slots.append($"../CardSlots_Enemy/CardSlot2")
	empty_card_slots.append($"../CardSlots_Enemy/CardSlot3")
	empty_card_slots.append($"../CardSlots_Enemy/CardSlot4")
	empty_card_slots.append($"../CardSlots_Enemy/CardSlot5")


func _on_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	$"../Button".disabled = true
	$"../Button".visible = false
	
	battle_timer.start()
	await battle_timer.timeout
	
	if $"../OpponentDeck".opponent_deck.size() != 0:
		$"../OpponentDeck".draw_card()
		battle_timer.start()
		await battle_timer.timeout
	
	if empty_card_slots.size() == 0:
		end_opponent_turn()
		return
		
	await try_play_card_random_card()
	end_opponent_turn()

func try_play_card_random_card():
	
	var opponend_hand = $"../OpponentHand".opponent_hand
	if opponend_hand.size() == 0:
		end_opponent_turn()
		return
	
	var random_empty_card_slot = empty_card_slots[randi_range(0,empty_card_slots.size() -1)]
	empty_card_slots.erase(random_empty_card_slot)
	var random_card = opponend_hand.pick_random()
	
	var tween = get_tree().create_tween()
	tween.tween_property(random_card, "position", random_empty_card_slot.position, CARD_MOVE_SPEED)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(random_card, "scale", Vector2(CARD_SMALLER_SCALE, CARD_SMALLER_SCALE), CARD_MOVE_SPEED)
	random_card.get_node("AnimationPlayer").play("card_flip")
		
	$"../OpponentHand".remove_card_from_hand(random_card)

func end_opponent_turn():
	$"../CardManager".reset_played_card()
	$"../Deck".reset_draw()
	$"../Button".visible = true
	$"../Button".disabled = false
	
