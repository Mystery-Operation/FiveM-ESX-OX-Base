return {
	['black_money'] = {
		label = 'Dirty Money',
	},

	['money'] = {
		label = 'Money',
	},

	-- // [ WIET GROEIEN ] \\ --

	['plant_tub'] = {
		label = 'Bloempot',
		weight = 1500
	},

	['full_watering_can'] = {
		label = 'Waterkan',
		weight = 800
	},
	
	['empty_watering_can'] = {
		label = 'Lege Waterkan',
		weight = 150
	},

	['weed_nutrition'] = {
		label = 'Potgrond',
		weight = 750
	},

	['seed_amnesia'] = {
		label = 'Amnesia Zaadje',
		weight = 0.2,
		client = {
			event = 'ml-growing:client:useSeed'
		}
	}
}