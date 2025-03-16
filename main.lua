local success, dpAPI = pcall(require, "debugplus-api")
local logger = {
    log = print,
    debug = print,
    info = print,
    warn = print,
    error = print
}

if success and dpAPI.isVersionCompatible(1) then
    local debugplus = dpAPI.registerID("NinfiaMod")
    logger = debugplus.logger
end

-- Atlasses
if SMODS.Atlas then
    SMODS.Atlas({
        key = "modicon",
        path = "modicon.png",
        px = 32,
        py = 32
    })

	SMODS.Atlas {
		key = "sylveone",
		path = "sylveone.png",
		px = 69,
		py = 93
	}	
end

-- Joker
SMODS.Joker {
	key = 'sylveone',
	loc_txt = {
		name = 'Sylveon',
		text = {
			"I hate you"
		}
	},
	config = { all_hearts = false, all_spades = false },
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	rarity = 4,
	atlas = 'sylveone',
	pos = { x = 0, y = 0 },
	cost = 2,
	yes_pool_flag = "sylveon_never_should_appear_in_normal_runs",
	calculate = function(self, card, context)
		if context.before then 
			card.ability.all_hearts = true;

			for i = 1, #context.full_hand do
				if not context.full_hand[i]:is_suit('Hearts') then
					card.ability.all_hearts = false;
					break
				end
			end

			card.ability.all_spades = true;

			for i = 1, #context.full_hand do
				if not context.full_hand[i]:is_suit('Spades') then
					card.ability.all_spades = false;
					break
				end
			end
		end

		if context.individual and not context.end_of_round then
			if context.cardarea == G.play then
				if context.other_card:is_suit('Hearts') then
					return {
						message = "Fuck you",
						colour = G.C.CHIPS,
						mult = 3
					}
				end

				if context.other_card:is_suit('Spades') then
					return {
						message = "Kys",
						colour = G.C.CHIPS,
						mult = -5
					}
				end
			end
		end

		if context.post_joker then
			if card.ability.all_hearts then
				for i = 1, #context.full_hand do
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() context.full_hand[i]:change_suit('Spades');return true end }))
				end
			end

			if card.ability.all_spades then
				for i = 1, #context.full_hand do
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() context.full_hand[i]:change_suit('Hearts');return true end }))
				end
			end
		end
		

		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 7 then
				return {
					message = 'You motherfucker',
					repetitions = 3,
					card = context.other_card
				}
			end
		end

		if context.end_of_round and context.cardarea == G.jokers then
			if pseudorandom('sylveon2') < 0.2 then
				local my_pos = nil;
				for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] == card then 
						my_pos = i; 
						break 
					end
				end

				if my_pos and G.jokers.cards[ my_pos + 1 ] and not self.getting_sliced and not G.jokers.cards[ my_pos + 1 ].ability.eternal and not G.jokers.cards[my_pos + 1].getting_sliced then 
					local sliced_card = G.jokers.cards[my_pos + 1]
					sliced_card.getting_sliced = true

					G.GAME.joker_buffer = G.GAME.joker_buffer - 1
					G.E_MANAGER:add_event(
						Event({
							func = function()
                        		G.GAME.joker_buffer = 0
                        		sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                       			play_sound('slice1', 0.96+math.random()*0.08)
                    			return true 
							end }
						))
		
					return {
						message = "Mine uwu",
						colour = G.C.CHIPS
					}
				end
			end

			if pseudorandom('sylveon') < 0.25 then
				if ((G.jokers.config.card_limit - #G.jokers.cards) >= 1) then
					play_sound('timpani')
					SMODS.add_card({
						key = "j_superposition",
						message = "I hate you",
						colour = G.C.CHIPS,
					})
				end
			end

			if (pseudorandom('sylveon3') < 0.2) then
				return {
					saved = true,
					message = "Onde vas tu?",
					colour = G.C.CHIPS
				}
			end	
		end


		if context.discard then
			if context.other_card:is_suit('Diamonds') and context.other_card:is_face() then
				return {
					message = 'No',
					dollars = -12
				}
			end

			if pseudorandom('sylveon4') < 0.1 then
				return {
					message = 'Mine uwu',
					colour = G.C.CHIPS,
					remove = true
				}	
			end
		end	
		
	end
}

-- Challenge
SMODS.Challenge {
	key = "nymphia",
	loc_txt = {
		name = "Draining Kiss"
	},
	jokers = {
		{ id = "j_sylvboss_sylveone", eternal = true }
	},
	unlocked = function(self)
		return true
	end
}