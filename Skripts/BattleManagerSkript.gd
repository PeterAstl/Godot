extends Node

const CARD_SMALLER_SCALE = 1
const CARD_MOVE_SPEED = 0.25

var empty_card_slots_opponent = []
var empty_card_slots_player = []
var opponent_cards_on_board = []
var player_cards_on_board = []
var player_health
var opponent_health
var player_effects

func _ready() -> void:
	player_effects = DataBase.player_effects.duplicate()
	player_health = DataBase.player_health
	opponent_health = DataBase.opponent_health
	
	$"../Texts/Health_Enemy".text = "🫀".repeat(opponent_health)
	$"../Texts/Health_Player".text = "🫀".repeat(player_health)
	
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
	
	await wait(1)
	if DataBase.starting_fight:
		if "start_play" in DataBase.opponent_effects:
			await try_play_card_random_card_start()
		DataBase.starting_fight = false

func wait(t):
	await get_tree().create_timer(t).timeout
	
var player_turn = true
	
			
func _input(event):
	if player_turn and event.is_action_pressed("end_turn"):
		opponent_turn()
		player_turn = false

func _on_button_pressed() -> void:
	if player_turn:
		opponent_turn()
		player_turn = false

func opponent_turn() -> void:
	$"../Button".disabled = true
	$"../Button".visible = false
	$"../CardManager".your_turn = false
	$"../InputManager".your_turn = false

	await player_turn_attack()
	await wait(0.2)
	
	if "play" in DataBase.opponent_effects:
		if $"../OpponentDeck".opponent_deck.size() > 0:
			$"../OpponentDeck".draw_card()
			await wait(1)
	$"../OpponentDeck".draw_card()
	await wait(1)

	await opponent_turn_attack()
	await wait(1)
	
	end_opponent_turn()
	$"../PlayerDeck".draw_card()
	$"../CardManager".your_turn = true
	$"../InputManager".your_turn = true
	player_turn = true
	player_effects.erase("immunity")

func player_turn_attack() -> void:
	var cards = player_cards_on_board.duplicate()

	for card in cards:
		card.fought = false
		await wait(0.3)

		if "multi_attack" in card.data.effects:
			await fight_attack_player_multi(card)
			if "double_attack" in card.data.effects:
				await fight_attack_player_multi(card)

		else:
			if "double_attack" in card.data.effects:
				await fight_attack_player(card)
				
			await fight_attack_player(card)

func opponent_turn_attack() -> void:
	if "play" in DataBase.opponent_effects:
		await try_play_card_random_card()
	await try_play_card_random_card()
	await wait(0.3)

	var cards = opponent_cards_on_board.duplicate()

	for card in cards:
		card.fought = false
		await wait(0.3)
		
		if "multi_attack" in card.data.effects:
			await fight_attack_opponent_multi(card)
			if "double_attack" in card.data.effects:
				await fight_attack_opponent_multi(card)

		else:
			if "double_attack" in card.data.effects:
				await fight_attack_opponent(card)
				
			await fight_attack_opponent(card)

func fight_attack_player(card):
	card.fought = false
	for enemy in opponent_cards_on_board:
		if card.card_slot_card_in.name == enemy.card_slot_card_in.name:
			await animate_attack_to_card(card, enemy, true)
			return

	if not card.fought:
		var slot_index = int(card.card_slot_card_in.name.substr(card.card_slot_card_in.name.length() - 1))
		var slot_node = get_node("../CardSlots_Enemy/CardSlot" + str(slot_index))
		await animate_attack_to_player(card, true, slot_node)

func fight_attack_opponent(card):
	for player in player_cards_on_board:
		if card.card_slot_card_in.name == player.card_slot_card_in.name:
			await animate_attack_to_card(card, player, false)
			return

	if not card.fought:
		var slot_index = int(card.card_slot_card_in.name.substr(card.card_slot_card_in.name.length() - 1))
		var slot_node = get_node("../CardSlots_Player/CardSlot" + str(slot_index))
		await animate_attack_to_player(card, false, slot_node)

func fight_attack_player_multi(card):
	var my_slot = card.card_slot_card_in
	var my_index = int(my_slot.name.substr(my_slot.name.length() - 1))
	var target_indices = [my_index - 1, my_index, my_index + 1]

	for index in target_indices:
		if index < 1 or index > 5:
			continue

		var target_slot = null
		var target_found = false

		for enemy in opponent_cards_on_board:
			var enemy_index = int(enemy.card_slot_card_in.name.substr(enemy.card_slot_card_in.name.length() - 1))
			if enemy_index == index:
				target_slot = enemy
				target_found = true
				break
				
		if target_found:
			await animate_attack_to_card(card, target_slot, true)
		else:
			var slot_node = get_node("../CardSlots_Enemy/CardSlot" + str(index))
			await animate_attack_to_player(card, true, slot_node)
			
func fight_attack_opponent_multi(card):
	var my_slot = card.card_slot_card_in
	var my_index = int(my_slot.name.substr(my_slot.name.length() - 1))
	var target_indices = [my_index - 1, my_index, my_index + 1]

	for index in target_indices:
		if index < 1 or index > 5:
			continue

		var target_slot = null
		var target_found = false

		for player_cards in player_cards_on_board:
			var enemy_index = int(player_cards.card_slot_card_in.name.substr(player_cards.card_slot_card_in.name.length() - 1))
			if enemy_index == index:
				target_slot = player_cards
				target_found = true
				break
				
		if target_found:
			await animate_attack_to_card(card, target_slot, false)
		else:
			var slot_node = get_node("../CardSlots_Player/CardSlot" + str(index))
			await animate_attack_to_player(card, false, slot_node)

func animate_attack_to_card(attacker, defender, player_side):
	if attacker != null:
		attacker.fought = true
		var damage = attacker.data.damage
		var attacker_alive = true
		if player_side:
			if "immunity" in player_effects:
				damage = 0
		if damage <= 0:
			return

		var health = int(defender.get_node("size/Health").text)

		attacker.z_index = 10
		var original_pos = attacker.position

		var tween = create_tween()
		tween.tween_property(attacker, "position", defender.position, CARD_MOVE_SPEED)
		$"../Sounds/Hit_Sound".play()
		await tween.finished
		

		if damage >= health:
			defender.card_slot_card_in.card_in_slot = false
			if "death_bomb" in defender.data.effects and not "death_bomb_immunity" in attacker.data.effects:
				attacker.card_slot_card_in.card_in_slot = false
				attacker_alive = false
				$"../Sounds/Explosion_Sound".play()
				await wait(1)
				attacker.queue_free()
				if player_side:
					player_cards_on_board.erase(attacker)
				else:
					empty_card_slots_opponent.append(attacker.card_slot_card_in)
					opponent_cards_on_board.erase(attacker)
			if "matroschka" in defender.data.effects:
				var node = defender.get_node("size")
				node.scale = Vector2(node.scale.x*0.9,node.scale.y*0.9)
				defender.data.health -= 1
				defender.get_node("size/Health").text = str(defender.data.health)
				if defender.data.health == 0:
					defender.queue_free()
					if player_side:
						empty_card_slots_opponent.append(defender.card_slot_card_in)
						opponent_cards_on_board.erase(defender)
					else:
						player_cards_on_board.erase(defender)
			else:
				defender.queue_free()
				if player_side:
					empty_card_slots_opponent.append(defender.card_slot_card_in)
					opponent_cards_on_board.erase(defender)
				else:
					player_cards_on_board.erase(defender)
		else:
			defender.get_node("size/Health").text = str(health - damage)
		
		if attacker_alive:
			tween = create_tween()
			tween.tween_property(attacker, "position", original_pos, CARD_MOVE_SPEED)
			await tween.finished
			attacker.z_index = 0

func animate_attack_to_player(card, player_side, slot_node):
	if card != null:
		var damage = int(card.get_node("size/Attack").text)
		if "immunity" in player_effects:
			damage = 0
		if damage <= 0:
			return

		card.z_index = 10
		var original_pos = card.position
		var target = slot_node.position
		
		var tween = create_tween()
		tween.tween_property(card, "position", target, CARD_MOVE_SPEED)
		$"../Sounds/Hit_Sound".play()
		await tween.finished

		if player_side:
			if "lifesteal" in card.data.effects:
				player_health += 1
				$"../Texts/Health_Player".text = "🫀".repeat(player_health)

			opponent_health -= 1
			if opponent_health <= 0:
				await continue_screen(true)
			else:
				$"../Texts/Health_Enemy".text = "🫀".repeat(opponent_health)
		else:
			if "lifesteal" in card.data.effects:
				opponent_health += 1
				$"../Texts/Health_Enemy".text = "🫀".repeat(opponent_health)
			player_health -= 1
			if player_health <= 0:
				await continue_screen(false)
			else:
				$"../Texts/Health_Player".text = "🫀".repeat(player_health)
		
		tween = create_tween()
		tween.tween_property(card, "position", original_pos, CARD_MOVE_SPEED)
		await tween.finished
		card.z_index = 0

func continue_screen(win):
	if win:
		$"../Texts/Win".visible = true
	else:
		$"../Texts/Loose".visible = true

	$"../Continue_Button".visible = true
	$"../Continue_Button".disabled = false
	$"../Continue_Button".battle_won = win

	get_tree().paused = true

func try_play_card_random_card():
	var hand = $"../OpponentHand".opponent_hand
	if hand.is_empty() or empty_card_slots_opponent.is_empty():
		return

	var slot = empty_card_slots_opponent.pick_random()
	empty_card_slots_opponent.erase(slot)

	var card = hand.pick_random()
	card.card_slot_card_in = slot
	
	var tween = create_tween()
	tween.tween_property(card, "position", slot.position, CARD_MOVE_SPEED)
	await tween.finished
	
	tween = create_tween()
	tween.tween_property(card, "scale", Vector2.ONE * CARD_SMALLER_SCALE, CARD_MOVE_SPEED)
	await tween.finished

	card.get_node("size/AnimationPlayer").play("card_flip")
	await wait(0.3)

	$"../OpponentHand".remove_card_from_hand(card)
	opponent_cards_on_board.append(card)

func try_play_card_random_card_start():
	await try_play_card_random_card()

func end_opponent_turn():
	$"../CardManager".reset_played_card()
	$"../PlayerDeck".reset_draw()
	$"../Button".visible = true
	$"../Button".disabled = false
