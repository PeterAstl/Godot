extends Node

const CARD_SMALLER_SCALE = 1
const CARD_MOVE_SPEED = 0.5

var battle_timer
var empty_card_slots_opponent = []
var empty_card_slots_player = []
var opponent_cards_on_board = []
var player_cards_on_board = []
var player_health = 3
var opponent_health = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	
	$"../Health_Enemy".text = "❤️".repeat(opponent_health)
	$"../Health_Player".text = "❤️".repeat(player_health)
	
	empty_card_slots_opponent.append($"../CardSlots_Enemy/CardSlot1")
	empty_card_slots_opponent.append($"../CardSlots_Enemy/CardSlot2")
	empty_card_slots_opponent.append($"../CardSlots_Enemy/CardSlot3")
	empty_card_slots_opponent.append($"../CardSlots_Enemy/CardSlot4")
	empty_card_slots_opponent.append($"../CardSlots_Enemy/CardSlot5")
	
	empty_card_slots_player.append($"../CardSlots_Player/CardSlot1")
	empty_card_slots_player.append($"../CardSlots_Player/CardSlot2")
	empty_card_slots_player.append($"../CardSlots_Player/CardSlot3")
	empty_card_slots_player.append($"../CardSlots_Player/CardSlot4")
	empty_card_slots_player.append($"../CardSlots_Player/CardSlot5")

func wait(wait_time):
	battle_timer.wait_time = wait_time
	battle_timer.start()
	await battle_timer.timeout

func _on_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	$"../Button".disabled = true
	$"../Button".visible = false
	
	await wait(1)

	await player_turn_attack()
	
	await wait(1)
	
	if $"../OpponentDeck".opponent_deck.size() != 0:
		$"../OpponentDeck".draw_card()
		await wait(1)
	
	await opponent_turn_attack()
			
	
func opponent_turn_attack():
	if empty_card_slots_opponent.size() != 0:
		try_play_card_random_card()
		
		await wait(1)
		
		if opponent_cards_on_board.size() != 0:
			var cards_to_attack = opponent_cards_on_board.duplicate()
			for card in cards_to_attack:
				card.fought = false
			for card in cards_to_attack:
				if player_cards_on_board.size() == 0:
					await wait(1)
					hit_attack_opponent(card)
				else:
					await wait(1)
					fight_attack_opponent(card)
	end_opponent_turn()
	
func fight_attack_opponent(card):
	if card.fought:
		return
	
	for player_card in player_cards_on_board:
		if card.card_slot_card_in.name == player_card.card_slot_card_in.name:
			if card.fought == false:
				print("fight_opponent")
				card.fought = true
				animate_attack_to_card(card, player_card, 1)
				return
				
	hit_attack_opponent(card)
	card.fought = true

func hit_attack_opponent(card):
	print("health_hit_opponent")
	animate_attack_to_player(card, false)
	
func player_turn_attack():
	if empty_card_slots_player.size() != 0:
		if player_cards_on_board.size() != 0:
			var cards_to_attack = player_cards_on_board.duplicate()
			for card in cards_to_attack:
				card.fought = false
			for card in cards_to_attack:
				if opponent_cards_on_board.size() == 0:
					await wait(1)
					hit_attack_player(card)
				else:
					await wait(1)
					fight_attack_player(card)
					
func fight_attack_player(card):
	if card.fought:
		return
	
	for opponent_card in opponent_cards_on_board:
		if card.card_slot_card_in.name == opponent_card.card_slot_card_in.name:
			if card.fought == false:
				print("fight-player")
				card.fought = true
				animate_attack_to_card(card, opponent_card, 0)
				return
	
	hit_attack_player(card)
	card.fought = true

func hit_attack_player(card):
	print("health_hit_player")
	animate_attack_to_player(card, true)
					
	
func animate_attack_to_card(attacking_card, damaged_card, side):
	var attacking_damage = int(attacking_card.get_node("Attack").text)
	
	if attacking_damage != 0:
		var damaged_health = int(damaged_card.get_node("Health").text)
		attacking_card.z_index = 5
		var tween = get_tree().create_tween()
		tween.tween_property(attacking_card, "position", damaged_card.position, CARD_MOVE_SPEED/2)
		tween.tween_property(attacking_card, "position", attacking_card.position, CARD_MOVE_SPEED/2)
		attacking_card.z_index = 0
		if attacking_damage >= damaged_health:
			###Spieler killt Karte###
			if side == 0:
				damaged_card.card_slot_card_in.card_in_slot = false
				damaged_card.queue_free()
				opponent_cards_on_board.erase(damaged_card)
			###Gegner killt Karte###
			else:
				damaged_card.card_slot_card_in.card_in_slot = false
				damaged_card.queue_free()
				player_cards_on_board.erase(damaged_card)
		else:
			damaged_card.get_node("Health").text = str(damaged_health - attacking_damage)
			
		await wait(1)
	
func animate_attack_to_player(card, boolean):
	card.z_index = 5
	var tween = get_tree().create_tween()
	if boolean:
		tween.tween_property(card, "position", Vector2(card.position.x, card.position.y - 400), CARD_MOVE_SPEED)
		opponent_health = opponent_health - 1
		if opponent_health == 0:
			$"../Win".visible = true
			$"../Continue_Button".visible = true
			$"../Continue_Button".disabled = false
			$"../Continue_Button".battle_won = true
			get_tree().paused = true
		else:
			$"../Health_Enemy".text = "❤️".repeat(opponent_health)
	else:
		tween.tween_property(card, "position", Vector2(card.position.x, card.position.y + 400), CARD_MOVE_SPEED)
		player_health = player_health - 1
		if player_health == 0:
			$"../Loose".visible = true
			$"../Continue_Button".visible = true
			$"../Continue_Button".disabled = false
			$"../Continue_Button".battle_won = false
			get_tree().paused = true
		else:
			$"../Health_Player".text = "❤️".repeat(player_health)
	tween.tween_property(card, "position", card.position , CARD_MOVE_SPEED)
	card.z_index = 0
	
func try_play_card_random_card():
	var opponend_hand = $"../OpponentHand".opponent_hand
	if opponend_hand.size() == 0:
		end_opponent_turn()
		return
	
	var random_empty_card_slot = empty_card_slots_opponent[randi_range(0,empty_card_slots_opponent.size() -1)]
	empty_card_slots_opponent.erase(random_empty_card_slot)
	var random_card = opponend_hand.pick_random()
	random_card.card_slot_card_in = random_empty_card_slot
	
	var tween = get_tree().create_tween()
	tween.tween_property(random_card, "position", random_empty_card_slot.position, CARD_MOVE_SPEED)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(random_card, "scale", Vector2(CARD_SMALLER_SCALE, CARD_SMALLER_SCALE), CARD_MOVE_SPEED)
	random_card.get_node("AnimationPlayer").play("card_flip")
	await wait(1)
		
	$"../OpponentHand".remove_card_from_hand(random_card)
	opponent_cards_on_board.append(random_card)

func end_opponent_turn():
	$"../CardManager".reset_played_card()
	$"../PlayerDeck".reset_draw()
	$"../Button".visible = true
	$"../Button".disabled = false
