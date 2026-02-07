extends Node

const CARD_SMALLER_SCALE = 1
const CARD_MOVE_SPEED = 0.5

var battle_timer
var empty_card_slots_opponent = []
var empty_card_slots_player = []
var opponent_cards_on_board = []
var player_cards_on_board = []
var player_health = 3
var opponent_health = 6

###effects###
var attack_amount : int
###effects###

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
	
	try_play_card_random_card_start()

func wait(wait_time):
	battle_timer.wait_time = wait_time
	battle_timer.start()
	await battle_timer.timeout

func _on_button_pressed() -> void:
	if $"../PlayerDeck".player_deck.size() != 0:
		if $"../PlayerDeck".drawn_card_this_turn == false:
			$"../Info_Card_Draw_Animation".play("Draw_Your_Card")
			return
	opponent_turn()

func opponent_turn():
	$"../Button".disabled = true
	$"../Button".visible = false
	$"../CardManager".your_turn = false
	
	await wait(1)
	await player_turn_attack()
	await wait(1)
	if $"../OpponentDeck".opponent_deck.size() != 0:
		$"../OpponentDeck".draw_card()
		await wait(1)
	await opponent_turn_attack()
	await wait(1)
	await end_opponent_turn()
	$"../CardManager".your_turn = true


func opponent_turn_attack():
	if empty_card_slots_opponent.size() == 0:
		return
	try_play_card_random_card()
	await wait(1)
	var cards_that_attack = opponent_cards_on_board.duplicate()
	
	if cards_that_attack.size() != 0:
		for opponent_card in cards_that_attack:
			opponent_card.fought = false
			await wait(1)
			fight_attack_opponent(opponent_card)

func player_turn_attack():
	if empty_card_slots_player.size() == 0:
		return
	var cards_that_attack = player_cards_on_board.duplicate()
	
	if cards_that_attack.size() != 0:
		for player_card in cards_that_attack:
			player_card.fought = false
			await wait(1)
			if "double_attack" in player_card.data.effects:
				await fight_attack_player(player_card)
				await wait(1)
				player_card.fought = false
			await fight_attack_player(player_card)
			
			
func fight_attack_opponent(opponent_card):
	for player_card in player_cards_on_board:
		if player_card.card_slot_card_in.name == opponent_card.card_slot_card_in.name:
			animate_attack_to_card(opponent_card, player_card, 1)
			return
	if opponent_card.fought == false:
		animate_attack_to_player(opponent_card, false)
					
func fight_attack_player(player_card):
	for opponent_card in opponent_cards_on_board:
		if player_card.card_slot_card_in.name == opponent_card.card_slot_card_in.name:
			animate_attack_to_card(player_card, opponent_card, 0)
			return
	if player_card.fought == false:
		animate_attack_to_player(player_card, true)

func animate_attack_to_card(attacking_card, damaged_card, side):
	attacking_card.fought = true
	var attacking_damage = int(attacking_card.get_node("Attack").text)
	
	if attacking_damage != 0:
		var damaged_health = int(damaged_card.get_node("Health").text)
		attacking_card.z_index = 5
		var tween = get_tree().create_tween()
		tween.tween_property(attacking_card, "position", damaged_card.position, CARD_MOVE_SPEED/2)
		tween.tween_property(attacking_card, "position", attacking_card.position, CARD_MOVE_SPEED/2)
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
		
		attacking_card.z_index = 0
		await wait(1)
	
func animate_attack_to_player(card, boolean):
	if int(card.get_node("Attack").text) != 0:
		card.z_index = 5
		var tween = get_tree().create_tween()
		if boolean:
			tween.tween_property(card, "position", Vector2(card.position.x, card.position.y - 400), CARD_MOVE_SPEED)
			opponent_health = opponent_health - 1
			if opponent_health <= 0:
				continue_screen(true)
			else:
				$"../Health_Enemy".text = "❤️".repeat(opponent_health)
		else:
			tween.tween_property(card, "position", Vector2(card.position.x, card.position.y + 400), CARD_MOVE_SPEED)
			player_health = player_health - 1
			if player_health <= 0:
				continue_screen(false)
			else:
				$"../Health_Player".text = "❤️".repeat(player_health)
		if opponent_health > 0:
			tween.tween_property(card, "position", card.position , CARD_MOVE_SPEED)
			card.z_index = 0

func continue_screen(win):
	if win:
		$"../Win".visible = true
		$"../Continue_Button".visible = true
		$"../Continue_Button".disabled = false
		$"../Continue_Button".battle_won = true
		await wait(2)
		get_tree().paused = true
	else:
		$"../Loose".visible = true
		$"../Continue_Button".visible = true
		$"../Continue_Button".disabled = false
		$"../Continue_Button".battle_won = false
		await wait(2)
		get_tree().paused = true
	

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
	
func try_play_card_random_card_start():
	var opponend_hand = $"../OpponentHand".opponent_hand
	
	var random_empty_card_slot = empty_card_slots_opponent[randi_range(0,empty_card_slots_opponent.size() - 1)]
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
