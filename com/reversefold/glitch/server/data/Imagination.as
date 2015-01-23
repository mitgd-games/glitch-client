package com.reversefold.glitch.server.data {
    public class Imagination {


public var data_imagination_upgrades = {
	achievement_reward_bonus_1: {
		name: "Overachiever I",
		desc: "Get 2% more rewards from each Achievement you earn. One less thing for the bucket list!",
		max_uses: 1,
		chance: 7,
		cost: 250,
		config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"achievement","icon":"upgrade"},
		conditions: [
			{
				type: 2,
				data: {
					"level" : 4
				}
			},
		],
		rewards: [
		]
	},

	achievement_reward_bonus_2: {
		name: "Overachiever II",
		desc: "More goodies for you, goodie two-shoes. Earn 4% more rewards from each Achievement.",
		max_uses: 1,
		chance: 6,
		cost: 500,
		config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"achievement","icon":"upgrade"},
		conditions: [
			{
				type: 3,
				data: {
					"imagination_id"    : "achievement_reward_bonus_1"
				}
			},
			{
				type: 2,
				data: {
					"level" : 6
				}
			},
		],
		rewards: [
		]
	},

	achievement_reward_bonus_3: {
		name: "Overachiever III",
		desc: "Dang! You're so achieving, your report card is jealous. Earn 6% more rewards from each Achievement.",
		max_uses: 1,
		chance: 5,
		cost: 750,
		config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"achievement","icon":"upgrade"},
		conditions: [
			{
				type: 3,
				data: {
					"imagination_id"    : "achievement_reward_bonus_2"
				}
			},
			{
				type: 2,
				data: {
					"level" : 8
				}
			}
		],
		rewards: [
		]
	},

	achievement_reward_bonus_4: {
		name: "Overachiever IV",
		desc: "It's not the journey, it's the destination! Earn 8% more rewards from each Achievement.",
		max_uses: 1,
		chance: 4,
		cost: 1000,
		config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"achievement","icon":"upgrade"},
		conditions: [
			{
				type: 3,
				data: {
					"imagination_id"    : "achievement_reward_bonus_3"
				}
			},
			{
				type: 2,
				data: {
					"level" : 11
				}
			},
		],
		rewards: [
		]
	},

	achievement_reward_bonus_5: {
		name: "Overachiever V",
		desc: "Time to find a new obsession, Type A. With this upgrade, you'll earn 10% more rewards from each Achievement.",
		max_uses: 1,
		chance: 3,
		cost: 1500,
		config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"achievement","icon":"upgrade"},
		conditions: [
			{
				type: 3,
				data: {
					"imagination_id"    : "achievement_reward_bonus_4"
				}
			},
			{
				type: 2,
				data: {
					"level" : 14
				}
			},
		],
		rewards: [
		]
	},

	alchemy_1_imagination: {
		name: "Compound Interest",
		desc: "Earn bonus Imagination from making compounds. How compounding!",
		max_uses: 1,
		chance: 5,
		cost: 400,
		config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_alchemy","icon":"imagination"},
		conditions: [
			{
				type: 4,
				data: {
					"skill_id"  : "alchemy_1"
				}
			},
		],
		rewards: [
		]
	},

	alchemy_2_imagination: {
		name: "Rub 'er Up",
		desc: "Forbidden, carnal knowledge of Plain Metal that grants you a chance of bonus Imagination when rubbing it with the Alchemical Tongs. Yeah, that's the spot...",
		max_uses: 1,
		chance: 5,
		cost: 600,
		config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_alchemy","icon":"imagination"},
		conditions: [
			{
				type: 4,
				data: {
					"skill_id"  : "alchemy_2"
				}
			},
		],
		rewards: [
		]
	},

	ancestral_lands_time_1: {
		name: "Prepared For Ancestral Nostalgia I",
		desc: "Be prepared for the onset of the Ancestral Nostalgia: gain an extra minute to spend in the Ancestral lands (in the regions of Baqala, Xalanga, Choru or Zhambu).",
		max_uses: 1,
		chance: 5,
		cost: 12000,
		config: {"bg":"gold","pattern":"clock","suit":"clock","art":"avatar_walking","icon":"clock"},
		conditions: [
			{
				type: 6,
				data: {
					"quest_id"  : "baqala_nostalgia"
				}
			},
			{
				type: 2,
				data: {
					"level" : 18
				}
			},
		],
		rewards: [
		]
	},

ancestral_lands_time_2: {
        name: "Prepared For Ancestral Nostalgia II",
        desc: "Gain a second extra minute to spend in the Ancestral lands for a total of twelve glorious minutes.",
        max_uses: 1,
        chance: 4,
        cost: 25000,
        config: {"bg":"gold","pattern":"clock","suit":"clock","art":"avatar_walking","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "ancestral_lands_time_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 25
                    }
            },
        ],
        rewards: [
        ]
    },


animal_husbandry_twin_animals_1: {
        name: "Twinsies I",
        desc: "Sometimes the stork knocks twice. This upgrade will give you (or rather, a Chicken) a chance to incubate two animals from one seasoned egg.",
        max_uses: 1,
        chance: 6,
        cost: 600,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_animalhusbandry","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalhusbandry_1"
                    }
            },
        ],
        rewards: [
        ]
    },


animal_husbandry_twin_animals_2: {
        name: "Twinsies II",
        desc: "This upgrade will better the Chicken's chances of incubating two animals from one seasoned egg.",
        max_uses: 1,
        chance: 4,
        cost: 1000,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_animalhusbandry","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "animal_husbandry_twin_animals_1"
                    }
            },
        ],
        rewards: [
        ]
    },


animal_kinship_grain: {
        name: "Grain Attraction",
        desc: "Each normal squeeze of a chicken will net you 10 grain and the grain-doubling applies to super harvests too. Huge!",
        max_uses: 1,
        chance: 4,
        cost: 15000,
        config: {"bg":"gold","pattern":"skill","suit":"skill","art":"skill_animalkinship","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_7"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "animal_kinship_super_harvest_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 21
                    }
            },
        ],
        rewards: [
        ]
    },


animal_kinship_super_harvest_1: {
        name: "Super Animal Harvest I",
        desc: "Love to squeeze, milk and nibble? Earn an occasional 2X Super Harvest with this upgrade.",
        max_uses: 1,
        chance: 6,
        cost: 200,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_animalkinship","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_4"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "hen_hugger"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "piggy_nibbler"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "butterfly_whisperer"
                    }
            },
        ],
        rewards: [
        ]
    },


animal_kinship_super_harvest_2: {
        name: "Super Animal Harvest II",
        desc: "This upgrade allows you to earn an occasional 3X Super Harvest.",
        max_uses: 1,
        chance: 5,
        cost: 400,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_animalkinship","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_4"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "hen_hugger_deluxe"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "bacon_biter"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "apprentice_lepidopteral_manipulator"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "animal_kinship_super_harvest_1"
                    }
            },
        ],
        rewards: [
        ]
    },


animal_kinship_super_harvest_3: {
        name: "Super Animal Harvest III",
        desc: "This upgrade allows you to earn an occasional 4X Super Harvest, Animal Lober!",
        max_uses: 1,
        chance: 4,
        cost: 750,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_animalkinship","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_7"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "hen_hugger_supremalicious"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "ham_hocker"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "practical_lepidopteral_manipulator"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "animal_kinship_super_harvest_2"
                    }
            },
        ],
        rewards: [
        ]
    },


barnacle_scraping_drop_1: {
        name: "Barnacular Drops",
        desc: "Hey scrapey! Purchase this upgrade for a chance to score awesome drops when scraping Barnacles.",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"lightnavy","pattern":"drop","suit":"skill","art":"scraper","icon":"drop","hide_front_name":0},
        conditions: [
            {
                type: 5,
                data: {
                        "achievement_id"    : "amateur_decrustifier"
                    }
            },
        ],
        rewards: [
        ]
    },


barnacle_scraping_speed_1: {
        name: "Fast Scraper",
        desc: "Cut down the time it takes you to scrape Barnacles and Ice in half, to 2 seconds.",
        max_uses: 1,
        chance: 5,
        cost: 8000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"avatar_walking","icon":"clock"},
        conditions: [
            {
                type: 5,
                data: {
                        "achievement_id"    : "amateur_decrustifier"
                    }
            },
        ],
        rewards: [
        ]
    },


batterfly_bonus_guano: {
        name: "Efficient Prunes",
        desc: "Feeding Batterflies a meal worth at least 50 currants makes them poop three guano at once, instead of two.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"navy","pattern":"upgrade","suit":"reward","art":"skill_animalkinship","icon":"drop","hide_front_name":0},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_2"
                    }
            },
        ],
        rewards: [
        ]
    },


batterfly_bonus_guano_2: {
        name: "Lavish Laxative",
        desc: "Feeding Batterflies a meal worth at least 80 currants makes them poop five guano at once (instead of three guano for a meal worth 100+ currants).",
        max_uses: 1,
        chance: 5,
        cost: 8000,
        config: {"bg":"navy","pattern":"upgrade","suit":"reward","art":"skill_animalkinship","icon":"drop","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "batterfly_bonus_guano"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_5"
                    }
            },
        ],
        rewards: [
        ]
    },


blending_imagination: {
        name: "Creative Blending",
        desc: "Imaginatively delicious! Gives you a chance of bonus Imagination when using a Blender.",
        max_uses: 1,
        chance: 4,
        cost: 400,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_blending","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "blending_1"
                    }
            },
        ],
        rewards: [
        ]
    },


blending_tool_wear: {
        name: "Sharper Blades",
        desc: "Blending lots of drinks? Tired of repairing the damage? Extend your Blender's lifespan by 50%.",
        max_uses: 1,
        chance: 4,
        cost: 250,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_blending","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "blending_1"
                    }
            },
        ],
        rewards: [
        ]
    },


blockmaking_save_fuel_1: {
        name: "Better Blockmaker",
        desc: "Study the intricacies of Urth, resulting in 20% less fuel spent when using a Blockmaker.",
        max_uses: 1,
        chance: 5,
        cost: 750,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_blockmaking","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "blockmaking_1"
                    }
            },
        ],
        rewards: [
        ]
    },


blockmaking_save_fuel_2: {
        name: "Betterer Blockmaker",
        desc: "Further illumination of the mysteries of Urth, resulting in 40% fuel savings when using a Blockmaker.",
        max_uses: 1,
        chance: 4,
        cost: 2000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_blockmaking","icon":"tool"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "blockmaking_save_fuel_1"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "blockmaking_1"
                    }
            },
        ],
        rewards: [
        ]
    },


bogspecialization_dig_peat_drop: {
        name: "Peaty Expectations",
        desc: "This upgrade grants you a deeper understanding of digging, which gives you a chance of finding something special when you Dig a Peat Bog!",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_bogspecialization","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "bogspecialization_1"
                    }
            },
        ],
        rewards: [
        ]
    },


bogspecialization_more_peat: {
        name: "Getting Pretty Peaty",
        desc: "A strange, transformational flash of inspiration that allows you to dig up 5 blocks of Peat in one digging.",
        max_uses: 1,
        chance: 6,
        cost: 2000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_bogspecialization","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "bogspecialization_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "re_peater"
                    }
            },
        ],
        rewards: [
        ]
    },


bog_specialization_dig_peat_bog_twice: {
        name: "Dig a Bog Twice A Day",
        desc: "Through a deeper familiarity with bog mechanics, you are now able to dig a single Peat Bog twice in one game day.",
        max_uses: 1,
        chance: 5,
        cost: 10000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_bogspecialization","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "bogspecialization_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "compulsive_re_peater"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
        ]
    },


botany_imagination: {
        name: "Creative Seasoner",
        desc: "Gives you a chance of bonus Imagination when you use a Bean Seasoner.",
        max_uses: 1,
        chance: 5,
        cost: 1000,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_botany","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "botany_1"
                    }
            },
        ],
        rewards: [
        ]
    },


brain_capacity: {
        name: "Increase your Brain Capacity by {amount}",
        desc: "Your brain capacity determines how fast you learn skills: when you're over capacity, learning slows down.",
        max_uses: 0,
        chance: 12,
        cost: 0,
        config: {"bg":"magenta","pattern":"upgrade","suit":"upgrade","art":"brain","icon":"upgrade"},
        conditions: [
            {
                type: 5,
                data: {
                        "achievement_id"    : "first_eleven_skills"
                    }
            },
        ],
        rewards: [
        ],
        options: {
    20: {
        cost_per: 400,
        chances: [16, 4, 0],
        min_skills: 15
    },
    21: {
        cost_per: 500,
        chances: [15, 4, 0],
        min_skills: 16
    },
    22: {
        cost_per: 630,
        chances: [14, 4, 0],
        min_skills: 17
    },
    23: {
        cost_per: 780,
        chances: [13, 4, 0],
        min_skills: 18
    },
    24: {
        cost_per: 980,
        chances: [12, 4, 0],
        min_skills: 19
    },
    25: {
        cost_per: 1220,
        chances: [11, 4, 0],
        min_skills: 20
    },
    26: {
        cost_per: 1530,
        chances: [10, 4, 0],
        min_skills: 21
    },
    27: {
        cost_per: 1910,
        chances: [9, 4, 0],
        min_skills: 22
    },
    28: {
        cost_per: 2380,
        chances: [8, 4, 0],
        min_skills: 23
    },
    29: {
        cost_per: 2980,
        chances: [8, 4, 0],
        min_skills: 24
    },
    30: {
        cost_per: 3730,
        chances: [8, 4, 0],
        min_skills: 25
    },
    31: {
        cost_per: 4400,
        chances: [7, 4, 1],
        min_skills: 26
    },
    32: {
        cost_per: 5190,
        chances: [7, 4, 1],
        min_skills: 27
    },
    33: {
        cost_per: 6120,
        chances: [7, 4, 1],
        min_skills: 28
    },
    34: {
        cost_per: 7220,
        chances: [7, 4, 1],
        min_skills: 29
    },
    35: {
        cost_per: 8520,
        chances: [6, 5, 1],
        min_skills: 30
    },
    36: {
        cost_per: 10060,
        chances: [6, 5, 1],
        min_skills: 31
    },
    37: {
        cost_per: 11870,
        chances: [6, 5, 1],
        min_skills: 32
    },
    38: {
        cost_per: 14000,
        chances: [6, 5, 1],
        min_skills: 33
    },
    39: {
        cost_per: 16520,
        chances: [5, 5, 2],
        min_skills: 34
    },
    40: {
        cost_per: 19500,
        chances: [5, 5, 2],
        min_skills: 35
    },
    41: {
        cost_per: 22230,
        chances: [5, 5, 2],
        min_skills: 36
    },
    42: {
        cost_per: 25340,
        chances: [5, 5, 2],
        min_skills: 37
    },
    43: {
        cost_per: 28890,
        chances: [5, 5, 2],
        min_skills: 38
    },
    44: {
        cost_per: 32930,
        chances: [5, 5, 2],
        min_skills: 39
    },
    45: {
        cost_per: 37540,
        chances: [5, 5, 2],
        min_skills: 40
    },
    46: {
        cost_per: 42800,
        chances: [6, 5, 1],
        min_skills: 41
    },
    47: {
        cost_per: 48790,
        chances: [7, 4, 1],
        min_skills: 42
    },
    48: {
        cost_per: 55620,
        chances: [8, 4, 0],
        min_skills: 43
    },
    49: {
        cost_per: 63410,
        chances: [10, 2, 0],
        min_skills: 44
    },
    50: {
        cost_per: 72300,
        chances: [12, 0, 0],
        min_skills: 45
    },
    51: {
        cost_per: 80000,
        chances: [12, 0, 0],
        min_skills: 46
    }
}
    },


bubbletuning_imagination: {
        name: "Bubble-licioius",
        desc: "Some might argue that tuning Bubbles is a frivolous pastime. But what do they know? With this upgrade, you'll occasionally earn extra Imagination when using your Bubble Tuner... and show them who's boss!",
        max_uses: 1,
        chance: 5,
        cost: 300,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_bubbletuning","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "bubbletuning_1"
                    }
            },
        ],
        rewards: [
        ]
    },


camera_mode: {
        name: "Camera Mode",
        desc: "Camera mode gives you the ability to peek around the level a bit without moving. When you're in Camera Mode, arrow keys pan the camera around your location. Easy — and it works great with Zoomability!",
        max_uses: 1,
        chance: 50,
        cost: 75,
        config: {"bg":"blue","pattern":"upgrade","suit":"upgrade","art":"cameramode","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 1,
                data: null
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "jump_2"
                    }
            },
        ],
        rewards: [
        ]
    },


cheffery_imagination: {
        name: "Pantastic",
        desc: "Beef up your Frying Pan skills for a chance to earn bonus Imagination every time you fry somethin' up. Mmm, it's gonna be tasty!",
        max_uses: 1,
        chance: 4,
        cost: 400,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_cheffery","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "cheffery_1"
                    }
            },
        ],
        rewards: [
        ]
    },


cheffery_tool_wear: {
        name: "It's Teflon Time",
        desc: "Time to coat your Frying Pan in a thin layer of mysteriously resilient goo. Sure, it's pretty - but it also extends the pan's lifespan by 50%!",
        max_uses: 1,
        chance: 4,
        cost: 250,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_cheffery","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "cheffery_1"
                    }
            },
        ],
        rewards: [
        ]
    },


cocktail_crafting_imagination: {
        name: "Shake Things Up",
        desc: "Upgrade your Cocktail Shaker for a chance to earn bonus Imagination when using it. Even more reason to throw a party!",
        max_uses: 1,
        chance: 4,
        cost: 800,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_cocktailcrafting","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "cocktailcrafting_1"
                    }
            },
        ],
        rewards: [
        ]
    },


cocktail_crafting_tool_wear: {
        name: "Shaken, not Stirred",
        desc: "All the party, half the hangover. This upgrade extends your Cocktail Shaker's lifespan by 50%.",
        max_uses: 1,
        chance: 4,
        cost: 375,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_cocktailcrafting","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "cocktailcrafting_1"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_growing_drop_1: {
        name: "Big Crop Bonus",
        desc: "When you Water, Plant, or Clear a plot in a Crop Garden, you have a small chance of finding something interesting.",
        max_uses: 1,
        chance: 5,
        cost: 600,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_croppery","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "croppery_1"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_growing_drop_2: {
        name: "Bigger Crop Bonus",
        desc: "When you Water, Plant, or Clear a plot in a Crop Garden, your chance of finding a bonus item is bigger. Bigger... yeah!",
        max_uses: 1,
        chance: 4,
        cost: 1200,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_croppery","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "croppery_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "croppery_growing_drop_1"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_herbalism_clearing_time: {
        name: "Tendy Gonzales",
        desc: "You know the way of the hoe, and you are not afraid to use it: clear a weedy garden plot in just one solitary second. Bang!",
        max_uses: 1,
        chance: 6,
        cost: 15000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_croppery","icon":"clock"},
        conditions: [
            {
                type: 5,
                data: {
                        "achievement_id"    : "notsogrim_reaper"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "aggressive_agrarian"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_herbalism_watering_time: {
        name: "Watering Whiz",
        desc: "Your long tenure in gardening grants you the ability to water a garden plot in a single second. Breathtaking.",
        max_uses: 1,
        chance: 6,
        cost: 15000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_herbalism","icon":"clock"},
        conditions: [
            {
                type: 5,
                data: {
                        "achievement_id"    : "notsogrim_reaper"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "aggressive_agrarian"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_super_harvest_1: {
        name: "Harvesting Fool",
        desc: "This upgrade grants a chance of a 3X Super Harvest of crops!",
        max_uses: 1,
        chance: 5,
        cost: 400,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_croppery","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "croppery_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "soso_sower"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_super_harvest_2: {
        name: "Harvesting Fiend",
        desc: "This upgrade grants a chance of a 4X Super Harvest of crops! FOUR EXXXX!",
        max_uses: 1,
        chance: 4,
        cost: 800,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_croppery","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "croppery_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "croppery_super_harvest_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "amateur_agronomist"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_time_1: {
        name: "Growth Spurt",
        desc: "Why wait for mother nature? This upgrade makes your crops grow 10% faster.",
        max_uses: 1,
        chance: 4,
        cost: 2000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_croppery","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "croppery_2"
                    }
            },
        ],
        rewards: [
        ]
    },


croppery_time_2: {
        name: "Hella Growth Spurt",
        desc: "It's time for a change! Your voice might crack, but your crops will grow 20% faster!",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_croppery","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "croppery_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "croppery_time_1"
                    }
            },
        ],
        rewards: [
        ]
    },


crystallography_craft_multiple_crystals: {
        name: "Heisenberg",
        desc: "Crystalmalize multiple crystals at once with your Crystalmalizing Chamber",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        is_secret: true,
        config: {"bg":"lightnavy","pattern":"upgrade","suit":"upgrade","art":"skill_crystalography","icon":"tool","hide_front_name":0},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "crystalography_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "plain_crystallizer"
                    }
            },
        ],
        rewards: [
        ]
    },


daily_quoin_limit_1: {
        name: "Quoiner the Market I",
        desc: "Expand your daily quoin limit from 100 to 110.",
        max_uses: 1,
        chance: 6,
        cost: 1500,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"quoinmultiple","icon":"upgrade"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


daily_quoin_limit_2: {
        name: "Quoiner the Market II",
        desc: "Expand your daily quoin limit by another 10 coins to 120.",
        max_uses: 1,
        chance: 6,
        cost: 2000,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"quoinmultiple","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "daily_quoin_limit_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
        ]
    },


daily_quoin_limit_3: {
        name: "Quoiner the Market III",
        desc: "Upgrade your daily quoin limit by another 10 coins to 130. That's alotta quoins!",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"quoinmultiple","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "daily_quoin_limit_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 20
                    }
            },
        ],
        rewards: [
        ]
    },


daily_quoin_limit_4: {
        name: "Quoiner the Market IV",
        desc: "Bump your quoin limit to 140. Almost at the max...",
        max_uses: 1,
        chance: 5,
        cost: 3500,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"quoinmultiple","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "daily_quoin_limit_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 25
                    }
            },
        ],
        rewards: [
        ]
    },


daily_quoin_limit_5: {
        name: "Quoiner the Market V",
        desc: "Max quoin limit: 150 a day. Quoin-a-riffic!",
        max_uses: 1,
        chance: 4,
        cost: 5000,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"quoinmultiple","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "daily_quoin_limit_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 30
                    }
            },
        ],
        rewards: [
        ]
    },


distilling_corn: {
        name: "Corn Hoocher",
        desc: "Special Hooch process that lets you squeeze 20% more hooch out of every ear of Corn you stuff into your Hopper.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_distilling","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "distilling_1"
                    }
            },
        ],
        rewards: [
        ]
    },


distilling_grain: {
        name: "Grain Hoocher",
        desc: "Old-time Hooch secret that lets you squeeze 20% more hooch out of every bit of Grain you pop into your Hopper.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_distilling","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "distilling_1"
                    }
            },
        ],
        rewards: [
        ]
    },


distilling_potato: {
        name: "Potato Hoocher",
        desc: "Lost art of Hooch that lets you squeeze 20% more hooch out of every Potato you cram into your Hopper.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_distilling","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "distilling_1"
                    }
            },
        ],
        rewards: [
        ]
    },


element_handling_bonus_1: {
        name: "Elemental Shake",
        desc: "Learn the secret Elemental Pouch Shake. This maneuver helps Elements mingle, so they can be fruitful and multiply until they fill the pouch.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_elementhandling","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "elementhandling_1"
                    }
            },
        ],
        rewards: [
        ]
    },


element_handling_bonus_2: {
        name: "Super Elemental Shake",
        desc: "Even more bonus elements produced by a nice, long shake in the pouch!",
        max_uses: 1,
        chance: 4,
        cost: 4000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_elementhandling","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "element_handling_bonus_1"
                    }
            },
        ],
        rewards: [
        ]
    },


encyclopeddling: {
        name: "Encyclopeddling",
        desc: "The universe of Glitch is deep and broad (and a little bit tubby). Getting to know it all can be hard. Encyclopeddling aids the process of discovery by giving you instant info on each new item.",
        max_uses: 1,
        chance: 50,
        cost: 90,
        config: {"bg":"yellow","pattern":"upgrade","suit":"upgrade","art":"questbook","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "mappery"
                    }
            },
            {
                type: 1,
                data: null
            },
        ],
        rewards: [
        ]
    },


energy_tank: {
        name: "Energy Tank +{amount}",
        desc: "Life's a lot less fun on an empty tank: make yours bigger!",
        max_uses: 0,
        chance: 20,
        cost: 0,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"quoinenergy","icon":"upgrade"},
        conditions: [
        ],
        rewards: [
        ],
        options: {
    100 : {
        cost_per: 20,
        chances: [18, 2, 0, 0, 0]
    },
    130 : {
        cost_per: 30,
        chances: [18, 2, 0, 0, 0]
    },
    160 : {
        cost_per: 40,
        chances: [18, 2, 0, 0, 0]
    },
    200 : {
        cost_per: 60,
        chances: [16, 3, 1, 0, 0]
    },
    300 : {
        cost_per: 80,
        chances: [14, 4, 2, 0, 0]
    },
    400 : {
        cost_per: 100,
        chances: [10, 6, 3, 1, 0]
    },
    500 : {
        cost_per: 120,
        chances: [7, 7, 4, 2, 0]
    },
    750 : {
        cost_per: 140,
        chances: [5, 8, 5, 2, 0]
    },
    1000 : {
        cost_per: 160,
        chances: [3, 7, 6, 4, 1]
    },
    1500 : {
        cost_per: 180,
        chances: [1, 6, 6, 5, 1]
    },
    2000 : {
        cost_per: 200,
        chances: [0, 6, 6, 6, 2]
    },
    2500 : {
        cost_per: 250,
        chances: [0, 6, 6, 6, 2]
    },
    3000 : {
        cost_per: 300,
        chances: [0, 5, 6, 7, 2]
    },
    4000 : {
        cost_per: 400,
        chances: [0, 4, 5, 8, 3]
    },
    5000 : {
        cost_per: 500,
        chances: [0, 2, 5, 9, 4]
    },
    6000 : {
        cost_per: 600,
        chances: [0, 0, 6, 10, 4]
    },
    7000 : {
        cost_per: 700,
        chances: [0, 0, 6, 10, 4]
    },
    8000 : {
        cost_per: 800,
        chances: [0, 0, 6, 10, 4]
    },
    9000 : {
        cost_per: 900,
        chances: [0, 0, 6, 10, 4]
    },
    10000 : {
        cost_per: 1000,
        chances: [0, 0, 6, 10, 4]
    }
}
    },


engineering_assemble_machine: {
        name: "Master Assembler",
        desc: "Channel the mysteries of Alph and assemble any machine in one swift action, given that you have the required parts. Hint: Start with the Machine Stand.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_engineering","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "engineering_1"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "engineering_reduce_time"
                    }
            },
        ],
        rewards: [
        ]
    },


engineering_disassemble_machine: {
        name: "Master Exploder",
        desc: "Disassemble any machine with one swift action.",
        max_uses: 1,
        chance: 5,
        cost: 800,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_engineering","icon":"tool"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "engineering_reduce_time"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "engineering_1"
                    }
            },
        ],
        rewards: [
        ]
    },


engineering_reduce_time: {
        name: "Speedy Assembler",
        desc: "Reduce the time it takes you to assemble any machine part.",
        max_uses: 1,
        chance: 5,
        cost: 100,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_engineering","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "engineering_1"
                    }
            },
        ],
        rewards: [
        ]
    },


ezcooking_less_imagination: {
        name: "Sweet Knife Skills",
        desc: "Improve your chopping skills so you occasionally get extra Imagination when you use the Knife and Board. Tear it UP!",
        max_uses: 1,
        chance: 4,
        cost: 200,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_ezcooking","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "ezcooking_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 3
                    }
            },
        ],
        rewards: [
        ]
    },


ezcooking_tool_wear: {
        name: "Tempered Steel",
        desc: "Toughen up your Knife & Board, for a 50% longer lifespan.",
        max_uses: 1,
        chance: 4,
        cost: 125,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_ezcooking","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "ezcooking_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 3
                    }
            },
        ],
        rewards: [
        ]
    },


fiber_arts_bonus_1: {
        name: "Spellbound Spindle",
        desc: "A magical incantation that gives you a chance of spinning String instead of Thread with your Spindle.",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_fiberarts","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "fiber_arts_1"
                    }
            },
        ],
        rewards: [
        ]
    },


fiber_arts_bonus_2: {
        name: "Wondrous Weave",
        desc: "An ancient weaving technique that gives you a rare chance of making thrice the Fabric when using a Loomer.",
        max_uses: 1,
        chance: 5,
        cost: 3500,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_fiberarts","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "fiber_arts_2"
                    }
            },
        ],
        rewards: [
        ]
    },


focused_meditation_imagination: {
        name: "Focused Imagination",
        desc: "Channels your focus for a chance of bonus Imagination when using the Orb for Focused Meditation.",
        max_uses: 1,
        chance: 3,
        cost: 1000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_focusedmeditation","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "meditativearts_3"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "focused_meditation_1"
                    }
            },
        ],
        rewards: [
        ]
    },


food_variety_bonus: {
        name: "Appreciation of Food Variety",
        desc: "Each crafted meal which you have not eaten for a full game day (four real hours) grants 25% of its energy value as an iMG bonus. Bonus doubled if you have not eaten it for 30 game days.",
        max_uses: 1,
        chance: 100,
        cost: 500,
        config: {"bg":"darkgray","pattern":"avatar","suit":"avatar","art":"food","icon":"imagination","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 3
                    }
            },
        ],
        rewards: [
        ]
    },


fox_brushing_bonus: {
        name: "Bristling Bonus",
        desc: "Boost your Brushing skills so you can get more Fiber when you use the Fox Brush!",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_foxbrushing","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "foxbrushing_1"
                    }
            },
        ],
        rewards: [
        ]
    },


fruitchanging_imagination: {
        name: "Fruity Goodness",
        desc: "Upgrade your knowledge of all things fruity, so that you occasionally get extra Imagination from Changing Fruit. You go, girl!",
        max_uses: 1,
        chance: 5,
        cost: 250,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_fruitchanging","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "fruitchanging_1"
                    }
            },
        ],
        rewards: [
        ]
    },


fuelmaking_imagination: {
        name: "Fuel Efficiency",
        desc: "Bestow upon yourself a series of deep, keen insights into the nature of Fuel. With this knowledge, you'll occasionally earn more Imagination when using your Fuelmaker.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_fuelmaking","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "fuelmaking_1"
                    }
            },
        ],
        rewards: [
        ]
    },


furnituremaking_bonus_upgrade_1: {
        name: "Bonus Furniture Upgrade I",
        desc: "5% chance of an instant upgrade of a base furniture item to a FM1 item worth 25 credits or less",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        is_secret: true,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_furnituremaking","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "furnituremaking_1"
                    }
            },
        ],
        rewards: [
        ]
    },


furnituremaking_bonus_upgrade_2: {
        name: "Bonus Furniture Upgrade II",
        desc: "5% chance of an instant upgrade of a base furniture item to a FM2 item worth 25 credits or less",
        max_uses: 1,
        chance: 5,
        cost: 7500,
        is_secret: true,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_furnituremaking","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "furnituremaking_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "furnituremaking_bonus_upgrade_1"
                    }
            },
        ],
        rewards: [
        ]
    },


furnituremaking_bonus_upgrade_3: {
        name: "Bonus Furniture Upgrade III",
        desc: "5% chance of an instant upgrade of a base furniture item to a FM2 + Engineering item worth 25 credits or less",
        max_uses: 1,
        chance: 5,
        cost: 10000,
        is_secret: true,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_furnituremaking","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "furnituremaking_2"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "engineering_1"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "furnituremaking_bonus_upgrade_2"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_bean: {
        name: "Beenier Harvest",
        desc: "Advanced knowledge of Bean Trees, which gives you the chance of a whopping 4X harvest.",
        max_uses: 1,
        chance: 4,
        cost: 500,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "bean_counter"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_bubble: {
        name: "Bubblier Harvest",
        desc: "Arcane knowledge of Bubble Trees, which gives you the chance of a whopping 4X harvest.",
        max_uses: 1,
        chance: 4,
        cost: 800,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "better_bubble_farmer"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_egg: {
        name: "Eggier Harvest",
        desc: "Inspired understanding of Egg Plants, which gives you the chance of a whopping 4X harvest.",
        max_uses: 1,
        chance: 4,
        cost: 1200,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "egg_poacher"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_fruit: {
        name: "Fruitier Harvest",
        desc: "Flowering realization about the nature of Fruit Trees, which gives you the chance of a whopping 4X harvest.",
        max_uses: 1,
        chance: 4,
        cost: 500,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "midmanagement_fruit_tree_harvester"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_gas: {
        name: "Gassier Harvest",
        desc: "Ethereal inclinations regarding Gas Plants, which gives you the chance of a whopping 4X harvest.",
        max_uses: 1,
        chance: 4,
        cost: 1200,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "hobbyist_gas_fancier"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_paper: {
        name: "Papery Harvest",
        desc: "Long-lost note on the wonders of Paper Trees, which increases your chance of bonus Paper when you harvest.",
        max_uses: 1,
        chance: 4,
        cost: 750,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "gardening_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "paper_plucker"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_spice: {
        name: "Spicier Harvest",
        desc: "Scintillating insight into the wonders of Spice Plants, which gives you the chance of a whopping 4X harvest.",
        max_uses: 1,
        chance: 4,
        cost: 800,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "intermediate_spice_collector"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_harvest_wood: {
        name: "Woodier Harvest",
        desc: "Reduces the energy required to harvest wood from 20 to 12, AND Hatchet wear from 5 to 3 per chopping. What a bargain!",
        max_uses: 1,
        chance: 4,
        cost: 750,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "gardening_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "timber_jack"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_tree_super_harvest_1: {
        name: "Tree Hugger I",
        desc: "Gives you a chance of 2X Super Harvest with all trees except Paper and Wood Tree.",
        max_uses: 1,
        chance: 5,
        cost: 200,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "gardening_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "novice_precipitator"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "okbutneedsimprovement_tree_hugger"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_tree_super_harvest_2: {
        name: "Tree Hugger II",
        desc: "Further boost your chances of a 2X Super Harvest with all trees except Paper and Wood Tree.",
        max_uses: 1,
        chance: 4,
        cost: 400,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "gardening_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "secondrate_rainmaker"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "decent_tree_hugger"
                    }
            },
        ],
        rewards: [
        ]
    },


gardening_tree_super_harvest_3: {
        name: "Tree Hugger III",
        desc: "Not boosted enough? Bump that chance for a 2X Super Tree Harvest just a little more...",
        max_uses: 1,
        chance: 3,
        cost: 1000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_gardening","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "gardening_5"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "gardening_tree_super_harvest_2"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "firstrate_rainmaker"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "gettingthere_tree_hugger"
                    }
            },
        ],
        rewards: [
        ]
    },


gassifying_imagination: {
        name: "Sassy Gassifier",
        desc: "Get to know the Gassifier better for a chance of bonus Imagination when using it.",
        max_uses: 1,
        chance: 5,
        cost: 400,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_gasmogrification","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "gasmogrification_1"
                    }
            },
        ],
        rewards: [
        ]
    },


grilling_less_imagination: {
        name: "Grilliant",
        desc: "Advance your skill with the Famous Pugilist Grill for a chance of bonus Imagination when using it.",
        max_uses: 1,
        chance: 4,
        cost: 800,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_grilling","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "grilling_1"
                    }
            },
        ],
        rewards: [
        ]
    },


grilling_tool_wear: {
        name: "Resilient Grill",
        desc: "Extend your Famous Pugilist Grill's lifespan by 50%. It sure can take a beating now!",
        max_uses: 1,
        chance: 4,
        cost: 435,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_grilling","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "grilling_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herbalism_shucking_1: {
        name: "Seedy Powers",
        desc: "75% chance of doubled seeds when shucking herbs.",
        max_uses: 1,
        chance: 5,
        cost: 1000,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_herbalism","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herbalism_3"
                    }
            },
        ],
        rewards: [
        ]
    },


herbalism_shucking_2: {
        name: "Super Seedy Powers",
        desc: "Always get double seeds when shucking herbs.",
        max_uses: 1,
        chance: 3,
        cost: 1600,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_herbalism","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herbalism_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "herbalism_shucking_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herbalism_super_harvest_1: {
        name: "Special Herbs",
        desc: "Increase your chances of a 3X Super Harvest to 20%.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_herbalism","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herbalism_3"
                    }
            },
        ],
        rewards: [
        ]
    },


herbalism_super_harvest_2: {
        name: "Super Special Herbs",
        desc: "Increase your chances of a 3X Super Harvest to 30%.",
        max_uses: 1,
        chance: 5,
        cost: 750,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_herbalism","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herbalism_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "mixed_herbalist"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "herbalism_super_harvest_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herbalism_time_1: {
        name: "Speedy Herbs",
        desc: "Got a strong craving for Herbs? Shorten their growth time by 10%. But remember, faster delivery doesn't mean they'll last longer...",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_herbalism","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herbalism_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herbalism_time_2: {
        name: "Speedier Herbs",
        desc: "Shorten the growth time for your herbs by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_herbalism","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herbalism_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "herbalism_time_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herdkeeping_animal_sadness_1: {
        name: "Happy Animals",
        desc: "Improve the happiness of your domestic animals, so you can pack 10% more of them on your land.",
        max_uses: 1,
        chance: 4,
        cost: 3000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_herdkeeping","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herdkeeping_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herdkeeping_animal_sadness_2: {
        name: "Super Happy Animals",
        desc: "Squeeze 20% more happy animals onto your land. So many happy animals, it's wild!",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_herdkeeping","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "herdkeeping_animal_sadness_1"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "herdkeeping_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herdkeeping_butterfly_stick: {
        name: "Butterfly Control Freak",
        desc: "Control the range a Butterfly'll fly around a Butterfly Stick!",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_herdkeeping","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herdkeeping_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herdkeeping_chicken_stick: {
        name: "Chicken Control Freak",
        desc: "Control the range a Chicken'll wander around a Chicken Stick!",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_herdkeeping","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herdkeeping_1"
                    }
            },
        ],
        rewards: [
        ]
    },


herdkeeping_pig_stick: {
        name: "Piggy Control Freak",
        desc: "Control the range a Piggy'll roam around a Pig Stick!",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_herdkeeping","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "herdkeeping_1"
                    }
            },
        ],
        rewards: [
        ]
    },


hoeing_more_img_more_wear: {
        name: "Hoe Down",
        desc: "More aggressive hoeing gives you more Imagination but wears your Hoe (or High Class Hoe) down faster.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_soilappreciation","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "soil_appreciation_3"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "tinkering_1"
                    }
            },
        ],
        rewards: [
        ]
    },


ice_scraping_yield: {
        name: "Cool As Ice",
        desc: "Increase your scraping yields from the vanilla 1 to 3 Ice to a much cooler 2 to 5 Ice.",
        max_uses: 1,
        chance: 4,
        cost: 4000,
        config: {"bg":"blue","pattern":"upgrade","suit":"skill","art":"scraper","icon":"tool","hide_front_name":0},
        conditions: [
            {
                type: 5,
                data: {
                        "achievement_id"    : "ice_baby"
                    }
            },
        ],
        rewards: [
        ]
    },


icon_bestow_chance_1: {
        name: "Giants' Beloved I",
        desc: "Open your mind. 10% greater chance of receiving Giant Love from an Icon.",
        max_uses: 1,
        chance: 6,
        cost: 5000,
        config: {"bg":"green","pattern":"upgrade","suit":"upgrade","art":"giant","icon":"drop","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 20
                    }
            },
        ],
        rewards: [
        ]
    },


icon_bestow_chance_2: {
        name: "Giants' Beloved II",
        desc: "Open your heart. Altogether 20% greater chance of receiving Giant Love from an Icon.",
        max_uses: 1,
        chance: 5,
        cost: 12000,
        config: {"bg":"green","pattern":"upgrade","suit":"upgrade","art":"giant","icon":"drop","hide_front_name":0},
        conditions: [
            {
                type: 6,
                data: {
                        "quest_id"  : "create_giant_icon"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "icon_bestow_chance_1"
                    }
            },
        ],
        rewards: [
        ]
    },


icon_bestow_chance_3: {
        name: "Giants' Beloved III",
        desc: "Open your third eye. A total of 30% greater chance of receiving Giant Love from an Icon.",
        max_uses: 1,
        chance: 4,
        cost: 25000,
        config: {"bg":"green","pattern":"upgrade","suit":"upgrade","art":"giant","icon":"drop","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 32
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "icon_bestow_chance_2"
                    }
            },
        ],
        rewards: [
        ]
    },


icon_tithe_1: {
        name: "Iconically Thrifty I",
        desc: "Giants recognize your pious efforts. Tithing Icons now costs 3% less than normal.",
        max_uses: 1,
        chance: 7,
        cost: 1000,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"giant","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
        ]
    },


icon_tithe_2: {
        name: "Iconically Thrifty II",
        desc: "Continued worship produces results. Tithing Icons now costs 5% less than normal.",
        max_uses: 1,
        chance: 6,
        cost: 3000,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"giant","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "icon_tithe_1"
                    }
            },
            {
                type: 6,
                data: {
                        "quest_id"  : "create_giant_icon"
                    }
            },
        ],
        rewards: [
        ]
    },


icon_tithe_3: {
        name: "Iconically Thrifty III",
        desc: "Your radiant worship is paying off. Tithing Icons now costs 10% less than normal.",
        max_uses: 1,
        chance: 5,
        cost: 10000,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"giant","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "icon_tithe_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 25
                    }
            },
        ],
        rewards: [
        ]
    },


icon_tithe_4: {
        name: "Iconically Thrifty IV",
        desc: "Membership is its own reward. As a bonus, tithing now costs a whopping 20% less than normal.",
        max_uses: 1,
        chance: 4,
        cost: 35000,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"giant","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "icon_tithe_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 31
                    }
            },
        ],
        rewards: [
        ]
    },


intermediate_admixing_imagination_1: {
        name: "Beaker Geek",
        desc: "Tune up your Beaker skills for a chance of an Imagination bonus when making powders.",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_intermediateadmixing","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "intermediateadmixing_1"
                    }
            },
        ],
        rewards: [
        ]
    },


intermediate_admixing_imagination_2: {
        name: "Beaker Genius",
        desc: "Tweak that Beaker for a better chance of a bigger Imagination bonus when making powders.",
        max_uses: 1,
        chance: 4,
        cost: 5000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_intermediateadmixing","icon":"imagination"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "intermediate_admixing_imagination_1"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "intermediateadmixing_1"
                    }
            },
        ],
        rewards: [
        ]
    },


inventory_search: {
        name: "Inventory Search",
        desc: "Press ~ key or click on the symbol to type-search your inventory for an item.",
        max_uses: 1,
        chance: 10,
        cost: 100,
        is_secret: true,
        config: {"bg":"yellow","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "encyclopeddling"
                    }
            },
        ],
        rewards: [
        ]
    },


jellisac_hands_drop_1: {
        name: "Jellisacular Drops",
        desc: "Purchase this upgrade for a chance to score an awesome drop when scooping Jellisacs. Gooey!",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"green","pattern":"drop","suit":"skill","art":"skill_jellisachands","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "jellisac_hands_1"
                    }
            },
        ],
        rewards: [
        ]
    },


jellisac_hands_speed_1: {
        name: "Fast Scooper",
        desc: "Decrease the time it takes you to scoop a jellisac down to a single second!",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_jellisachands","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "jellisac_hands_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "slime_harvester"
                    }
            },
        ],
        rewards: [
        ]
    },


jellisac_hands_speed_2: {
        name: "Amazing Scooper",
        desc: "You're so fast in jellisac scooping, it seems like it doesn't take any time at all!",
        max_uses: 1,
        chance: 4,
        cost: 20000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_jellisachands","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "jellisac_hands_1"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "jellisac_hands_speed_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 35
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "goo_getter"
                    }
            },
        ],
        rewards: [
        ]
    },


jump_1: {
        name: "High Jumper I",
        desc: "Only a simple boost from the merest beginner jump — however, this upgrade allows you to easily clear those pesky mushroom tops.",
        max_uses: 1,
        chance: 10,
        cost: 3,
        config: {"bg":"yellow","pattern":"avatar","suit":"avatar","art":"avatar_jump","icon":"upgrade"},
        conditions: [
            {
                type: 1,
                data: null
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : null,
                        "vy_jump"       : 0.907,
                        "gravity"       : 1,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


jump_2: {
        name: "High Jumper II",
        desc: "This is a comfortable jump height. Not too small, certainly: it's just about right!",
        max_uses: 1,
        chance: 10,
        cost: 6,
        config: {"bg":"yellow","pattern":"avatar","suit":"avatar","art":"avatar_jump","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 1,
                data: null
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "walk_speed_1"
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : null,
                        "vy_jump"       : 1,
                        "gravity"       : null,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


jump_3: {
        name: "High Jumper III",
        desc: "This is the jump you've been waiting for: an incredible \"little bit\" higher than the classic Glitchen jump height! BOING!",
        max_uses: 1,
        chance: 7,
        cost: 15000,
        config: {"bg":"yellow","pattern":"avatar","suit":"avatar","art":"avatar_jump","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "jump_triple_3"
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : null,
                        "vy_jump"       : 1.05,
                        "gravity"       : 1,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


jump_triple_1: {
        name: "Baby Triple Jump",
        desc: "This is the \"starter\" Triple Jump. Try it on for size! Usage instructions: jump right after you land three times in a row and … boing!",
        max_uses: 1,
        chance: 10,
        cost: 100,
        config: {"bg":"navy","pattern":"avatar","suit":"avatar","art":"avatar_jump","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "mappery"
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : null,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : 0.7,
                        "can_3_jump"        : 1,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


jump_triple_2: {
        name: "Medium Triple Jump",
        desc: "A bigger Triple Jump - adequate, but not necessarily amazing.",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"navy","pattern":"avatar","suit":"avatar","art":"avatar_jump","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "jump_triple_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : null,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : 0.82,
                        "can_3_jump"        : 1,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


jump_triple_3: {
        name: "Big 'Un Triple Jump",
        desc: "Oh my - what a Triple Jump it is. Boundless and bountiful! Can you handle it?",
        max_uses: 1,
        chance: 5,
        cost: 15000,
        config: {"bg":"navy","pattern":"avatar","suit":"avatar","art":"avatar_jump","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "jump_triple_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : null,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : 1,
                        "can_3_jump"        : 1
                    }
            },
        ]
    },


jump_wall: {
        name: "Off The Wall Jump",
        desc: "Jump off of walls. Seriously. Do it.",
        max_uses: 1,
        chance: 5,
        cost: 7500,
        is_secret: true,
        config: {"bg":"red","pattern":"avatar","suit":"avatar","art":"avatar_jump","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "jump_triple_2"
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : null,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null,
                        "can_wall_jump"     : 1
                    }
            },
        ]
    },


keepable_instant_resurrection: {
        name: "Get Out of Hell Free Card",
        desc: "Get out of Hell instantly, with full health. Lucky devil!!",
        max_uses: 0,
        chance: 4,
        cost: 0,
        config: {"bg":"keepable","pattern":"keepable","suit":"keepable","art":"keepable_hell","icon":"","item_tsid":"upgrade_card_instant_resurrection"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "upgrade_card_instant_resurrection",
                        "num"       : 1
                    }
            },
        ]
    },


keepable_reshuffle: {
        name: "Reshuffle",
        desc: "Reshuffle the Deck, above and beyond your one free daily reshuffle.",
        max_uses: 0,
        chance: 4,
        cost: 0,
        config: {"bg":"keepable","pattern":"keepable","suit":"keepable","art":"keepable_reshuffle","icon":"","item_tsid":"upgrade_card_reshuffle"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "upgrade_card_reshuffle",
                        "num"       : 1
                    }
            },
        ]
    },


learntime_alchemy_1: {
        name: "Alchemy Learning Speed I",
        desc: "Speed up the learning times for Alchemy skills (Alchemy, Element Handling, Intermediate Admixing, Crystallography, Distilling, Tincturing, Potionmaking) by 2%.",
        max_uses: 1,
        chance: 3,
        cost: 400,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_alchemy","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "elementhandling_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 4
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 6,
                        "percent"   : 2
                    }
            },
        ]
    },


learntime_alchemy_2: {
        name: "Alchemy Learning Speed II",
        desc: "Speed up the learning times for Alchemy skills (Alchemy, Element Handling, Intermediate Admixing, Crystallography, Distilling, Tincturing, Potionmaking) by 5%.",
        max_uses: 1,
        chance: 3,
        cost: 1250,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_alchemy","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_alchemy_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 6
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 6,
                        "percent"   : 5
                    }
            },
        ]
    },


learntime_alchemy_3: {
        name: "Alchemy Learning Speed III",
        desc: "Speed up the learning times for Alchemy skills (Alchemy, Element Handling, Intermediate Admixing, Crystallography, Distilling, Tincturing, Potionmaking) by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_alchemy","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_alchemy_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 6,
                        "percent"   : 10
                    }
            },
        ]
    },


learntime_alchemy_4: {
        name: "Alchemy Learning Speed IV",
        desc: "Speed up the learning times for Alchemy skills (Alchemy, Element Handling, Intermediate Admixing, Crystallography, Distilling, Tincturing, Potionmaking) by 15%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_alchemy","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_alchemy_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 6,
                        "percent"   : 15
                    }
            },
        ]
    },


learntime_alchemy_5: {
        name: "Alchemy Learning Speed V",
        desc: "Speed up the learning times for Alchemy skills (Alchemy, Element Handling, Intermediate Admixing, Crystallography, Distilling, Tincturing, Potionmaking) by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 20000,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_alchemy","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_alchemy_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 6,
                        "percent"   : 20
                    }
            },
        ]
    },


learntime_animal_1: {
        name: "Animal Learning Speed I",
        desc: "Speed up the learning times for Animal skills (Animal Kinship, Animal Husbandry, Fox Brushing, Herdkeeping, Remote Herdkeeping) by 2%.",
        max_uses: 1,
        chance: 3,
        cost: 400,
        config: {"bg":"darkgray","pattern":"clock","suit":"clock","art":"skill_animalkinship","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 4
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 14,
                        "percent"   : 2
                    }
            },
        ]
    },


learntime_animal_2: {
        name: "Animal Learning Speed II",
        desc: "Speed up the learning times for Animal skills (Animal Kinship, Animal Husbandry, Fox Brushing, Herdkeeping, Remote Herdkeeping) by 5%.",
        max_uses: 1,
        chance: 3,
        cost: 1250,
        config: {"bg":"darkgray","pattern":"clock","suit":"clock","art":"skill_animalkinship","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_animal_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 6
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 14,
                        "percent"   : 5
                    }
            },
        ]
    },


learntime_animal_3: {
        name: "Animal Learning Speed III",
        desc: "Speed up the learning times for Animal skills (Animal Kinship, Animal Husbandry, Fox Brushing, Herdkeeping, Remote Herdkeeping) by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"darkgray","pattern":"clock","suit":"clock","art":"skill_animalkinship","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_animal_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 14,
                        "percent"   : 10
                    }
            },
        ]
    },


learntime_animal_4: {
        name: "Animal Learning Speed IV",
        desc: "Speed up the learning times for Animal skills (Animal Kinship, Animal Husbandry, Fox Brushing, Herdkeeping, Remote Herdkeeping) by 15%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"darkgray","pattern":"clock","suit":"clock","art":"skill_animalkinship","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_animal_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 14,
                        "percent"   : 15
                    }
            },
        ]
    },


learntime_animal_5: {
        name: "Animal Learning Speed V",
        desc: "Speed up the learning times for Animal skills (Animal Kinship, Animal Husbandry, Fox Brushing, Herdkeeping, Remote Herdkeeping) by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 20000,
        config: {"bg":"darkgray","pattern":"clock","suit":"clock","art":"skill_animalkinship","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_animal_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 14,
                        "percent"   : 20
                    }
            },
        ]
    },


learntime_cooking_1: {
        name: "Cooking Learning Speed I",
        desc: "Speed up the learning times for Cooking skills (EZ Cooking, Cheffery, Grilling, Master Chef, Saucery, Blending, Cocktail Crafting) by 2%.",
        max_uses: 1,
        chance: 3,
        cost: 400,
        config: {"bg":"lightnavy","pattern":"clock","suit":"clock","art":"skill_cheffery","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "ezcooking_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 4
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 8,
                        "percent"   : 2
                    }
            },
        ]
    },


learntime_cooking_2: {
        name: "Cooking Learning Speed II",
        desc: "Speed up the learning times for Cooking skills (EZ Cooking, Cheffery, Grilling, Master Chef, Saucery, Blending, Cocktail Crafting) by 5%.",
        max_uses: 1,
        chance: 3,
        cost: 1250,
        config: {"bg":"lightnavy","pattern":"clock","suit":"clock","art":"skill_cheffery","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_cooking_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 6
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 8,
                        "percent"   : 5
                    }
            },
        ]
    },


learntime_cooking_3: {
        name: "Cooking Learning Speed III",
        desc: "Speed up the learning times for Cooking skills (EZ Cooking, Cheffery, Grilling, Master Chef, Saucery, Blending, Cocktail Crafting) by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"lightnavy","pattern":"clock","suit":"clock","art":"skill_cheffery","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_cooking_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 8,
                        "percent"   : 10
                    }
            },
        ]
    },


learntime_cooking_4: {
        name: "Cooking Learning Speed IV",
        desc: "Speed up the learning times for Cooking skills (EZ Cooking, Cheffery, Grilling, Master Chef, Saucery, Blending, Cocktail Crafting) by 15%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"lightnavy","pattern":"clock","suit":"clock","art":"skill_cheffery","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_cooking_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 8,
                        "percent"   : 15
                    }
            },
        ]
    },


learntime_cooking_5: {
        name: "Cooking Learning Speed V",
        desc: "Speed up the learning times for Cooking skills (EZ Cooking, Cheffery, Grilling, Master Chef, Saucery, Blending, Cocktail Crafting) by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 20000,
        config: {"bg":"lightnavy","pattern":"clock","suit":"clock","art":"skill_cheffery","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_cooking_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 8,
                        "percent"   : 20
                    }
            },
        ]
    },


learntime_gardening_1: {
        name: "Growing Learning Speed I",
        desc: "Speed up the learning times for Growing skills (Botany, Light Green Thumb, Soil Appreciation, Croppery, Herbalism) by 2%.",
        max_uses: 1,
        chance: 3,
        cost: 400,
        config: {"bg":"green","pattern":"clock","suit":"clock","art":"skill_lightgreenthumb","icon":"clock"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 4
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "light_green_thumb_1"
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 17,
                        "percent"   : 2
                    }
            },
        ]
    },


learntime_gardening_2: {
        name: "Growing Learning Speed II",
        desc: "Speed up the learning times for Growing skills (Botany, Light Green Thumb, Soil Appreciation, Croppery, Herbalism) by 5%.",
        max_uses: 1,
        chance: 3,
        cost: 1250,
        config: {"bg":"green","pattern":"clock","suit":"clock","art":"skill_lightgreenthumb","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_gardening_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 6
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 17,
                        "percent"   : 5
                    }
            },
        ]
    },


learntime_gardening_3: {
        name: "Growing Learning Speed III",
        desc: "Speed up the learning times for Growing skills (Botany, Light Green Thumb, Soil Appreciation, Croppery, Herbalism) by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"green","pattern":"clock","suit":"clock","art":"skill_lightgreenthumb","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_gardening_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 17,
                        "percent"   : 10
                    }
            },
        ]
    },


learntime_gardening_4: {
        name: "Growing Learning Speed IV",
        desc: "Speed up the learning times for Growing skills (Botany, Light Green Thumb, Soil Appreciation, Croppery, Herbalism) by 15%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"green","pattern":"clock","suit":"clock","art":"skill_lightgreenthumb","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_gardening_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 17,
                        "percent"   : 15
                    }
            },
        ]
    },


learntime_gardening_5: {
        name: "Growing Learning Speed V",
        desc: "Speed up the learning times for Growing skills (Botany, Light Green Thumb, Soil Appreciation, Croppery, Herbalism) by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 20000,
        config: {"bg":"green","pattern":"clock","suit":"clock","art":"skill_lightgreenthumb","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_gardening_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 17,
                        "percent"   : 20
                    }
            },
        ]
    },


learntime_harvesting_1: {
        name: "Gathering Learning Speed I",
        desc: "Speed up the learning times for Gathering skills (Arborology, Bog Specialization, Jellisac Hands, Fruit Changing, Spice Milling, Gasmogrification, Bubble Tuning) by 2%.",
        max_uses: 1,
        chance: 3,
        cost: 400,
        config: {"bg":"red","pattern":"clock","suit":"clock","art":"skill_gardening","icon":"clock"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 4
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 16,
                        "percent"   : 2
                    }
            },
        ]
    },


learntime_harvesting_2: {
        name: "Gathering Learning Speed II",
        desc: "Speed up the learning times for Gathering skills (Arborology, Bog Specialization, Jellisac Hands, Fruit Changing, Spice Milling, Gasmogrification, Bubble Tuning) by 5%.",
        max_uses: 1,
        chance: 3,
        cost: 1250,
        config: {"bg":"red","pattern":"clock","suit":"clock","art":"skill_gardening","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_harvesting_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 6
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 16,
                        "percent"   : 5
                    }
            },
        ]
    },


learntime_harvesting_3: {
        name: "Gathering Learning Speed III",
        desc: "Speed up the learning times for Gathering skills (Arborology, Bog Specialization, Jellisac Hands, Fruit Changing, Spice Milling, Gasmogrification, Bubble Tuning) by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"red","pattern":"clock","suit":"clock","art":"skill_gardening","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_harvesting_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 16,
                        "percent"   : 10
                    }
            },
        ]
    },


learntime_harvesting_4: {
        name: "Gathering Learning Speed IV",
        desc: "Speed up the learning times for Gathering skills (Arborology, Bog Specialization, Jellisac Hands, Fruit Changing, Spice Milling, Gasmogrification, Bubble Tuning) by 15%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"red","pattern":"clock","suit":"clock","art":"skill_gardening","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_harvesting_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 16,
                        "percent"   : 15
                    }
            },
        ]
    },


learntime_harvesting_5: {
        name: "Gathering Learning Speed V",
        desc: "Speed up the learning times for Gathering skills (Arborology, Bog Specialization, Jellisac Hands, Fruit Changing, Spice Milling, Gasmogrification, Bubble Tuning) by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 20000,
        config: {"bg":"red","pattern":"clock","suit":"clock","art":"skill_gardening","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_harvesting_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 16,
                        "percent"   : 20
                    }
            },
        ]
    },


learntime_industrial_1: {
        name: "Industrial Learning Speed I",
        desc: "Speed up the learning times for Industrial skills (Mining, Refining, Tinkering, Engineering, Blockmaking, Furnituremaking, Fiber Arts, and similar skills) by 2%.",
        max_uses: 1,
        chance: 3,
        cost: 400,
        config: {"bg":"blue","pattern":"clock","suit":"clock","art":"skill_tinkering","icon":"clock"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 4
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "tinkering_1"
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 11,
                        "percent"   : 2
                    }
            },
        ]
    },


learntime_industrial_2: {
        name: "Industrial Learning Speed II",
        desc: "Speed up the learning times for Industrial skills (Mining, Refining, Tinkering, Engineering, Blockmaking, Furnituremaking, Fiber Arts, and similar skills) by 5%.",
        max_uses: 1,
        chance: 3,
        cost: 1250,
        config: {"bg":"blue","pattern":"clock","suit":"clock","art":"skill_tinkering","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_industrial_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 6
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 11,
                        "percent"   : 5
                    }
            },
        ]
    },


learntime_industrial_3: {
        name: "Industrial Learning Speed III",
        desc: "Speed up the learning times for Industrial skills (Mining, Refining, Tinkering, Engineering, Blockmaking, Furnituremaking, Fiber Arts, and similar skills) by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"blue","pattern":"clock","suit":"clock","art":"skill_tinkering","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_industrial_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 11,
                        "percent"   : 10
                    }
            },
        ]
    },


learntime_industrial_4: {
        name: "Industrial Learning Speed IV",
        desc: "Speed up the learning times for Industrial skills (Mining, Refining, Tinkering, Engineering, Blockmaking, Furnituremaking, Fiber Arts, and similar skills) by 15%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"blue","pattern":"clock","suit":"clock","art":"skill_tinkering","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_industrial_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 11,
                        "percent"   : 15
                    }
            },
        ]
    },


learntime_industrial_5: {
        name: "Industrial Learning Speed V",
        desc: "Speed up the learning times for Industrial skills (Mining, Refining, Tinkering, Engineering, Blockmaking, Furnituremaking, Fiber Arts, and similar skills) by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 20000,
        config: {"bg":"blue","pattern":"clock","suit":"clock","art":"skill_tinkering","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_industrial_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 11,
                        "percent"   : 20
                    }
            },
        ]
    },


learntime_wellness_1: {
        name: "Intellectual Learning Speed I",
        desc: "Speed up the learning times for Intellectual skills (Bureaucratic Arts, Meditative Arts, Teleportation, Eyeballery, Penpersonship, Piety and similar skills) by 2%.",
        max_uses: 1,
        chance: 3,
        cost: 400,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_meditativearts","icon":"clock"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 4
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 19,
                        "percent"   : 2
                    }
            },
        ]
    },


learntime_wellness_2: {
        name: "Intellectual Learning Speed II",
        desc: "Speed up the learning times for Intellectual skills (Bureaucratic Arts, Meditative Arts, Teleportation, Eyeballery, Penpersonship, Piety and similar skills) by 5%.",
        max_uses: 1,
        chance: 3,
        cost: 1250,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_meditativearts","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_wellness_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 6
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 19,
                        "percent"   : 5
                    }
            },
        ]
    },


learntime_wellness_3: {
        name: "Intellectual Learning Speed III",
        desc: "Speed up the learning times for Intellectual skills (Bureaucratic Arts, Meditative Arts, Teleportation, Eyeballery, Penpersonship, Piety and similar skills) by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_meditativearts","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_wellness_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 19,
                        "percent"   : 10
                    }
            },
        ]
    },


learntime_wellness_4: {
        name: "Intellectual Learning Speed IV",
        desc: "Speed up the learning times for Intellectual skills (Bureaucratic Arts, Meditative Arts, Teleportation, Eyeballery, Penpersonship, Piety and similar skills) by 15%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_meditativearts","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_wellness_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 19,
                        "percent"   : 15
                    }
            },
        ]
    },


learntime_wellness_5: {
        name: "Intellectual Learning Speed V",
        desc: "Speed up the learning times for Intellectual skills (Bureaucratic Arts, Meditative Arts, Teleportation, Eyeballery, Penpersonship, Piety and similar skills) by 20%.",
        max_uses: 1,
        chance: 3,
        cost: 20000,
        config: {"bg":"yellow","pattern":"clock","suit":"clock","art":"skill_meditativearts","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "learntime_wellness_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
            {
                type: 9,
                data: {
                        "category_id"   : 19,
                        "percent"   : 20
                    }
            },
        ]
    },


levitation_physics: {
        name: "Levitate with Style",
        desc: "This upgrade makes your hang time longer when you Levitate.",
        max_uses: 1,
        chance: 4,
        cost: 5000,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_levitation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "levitation_1"
                    }
            },
        ],
        rewards: [
        ]
    },


levitation_time: {
        name: "Levitate Longer",
        desc: "Levitate longer pretty much explains it. You'll be able to levitate for a longer period of time. Capiche?",
        max_uses: 1,
        chance: 4,
        cost: 2000,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_levitation","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "levitation_1"
                    }
            },
        ],
        rewards: [
        ]
    },


lightgreenthumb_pet_drop_1: {
        name: "Heavy Petting",
        desc: "A chance of getting a special item when you pet trees.",
        max_uses: 1,
        chance: 7,
        cost: 600,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_lightgreenthumb","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "light_green_thumb_2"
                    }
            },
        ],
        rewards: [
        ]
    },


lightgreenthumb_pet_drop_2: {
        name: "Heavier Petting",
        desc: "An even bigger chance of a special item when you pet trees.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_lightgreenthumb","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "light_green_thumb_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "lightgreenthumb_pet_drop_1"
                    }
            },
        ],
        rewards: [
        ]
    },


lightgreenthumb_tool_wear: {
        name: "Heavy Flow",
        desc: "Reduces the wear and tear on your Watering Can or Irrigator 9000 by 50%.",
        max_uses: 1,
        chance: 5,
        cost: 200,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_lightgreenthumb","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "light_green_thumb_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 3
                    }
            },
        ],
        rewards: [
        ]
    },


lightgreenthumb_water_drop_1: {
        name: "Well Watered",
        desc: "A chance of getting a special item when you water trees.",
        max_uses: 1,
        chance: 7,
        cost: 600,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_lightgreenthumb","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "light_green_thumb_2"
                    }
            },
        ],
        rewards: [
        ]
    },


lightgreenthumb_water_drop_2: {
        name: "Thirst Quencher",
        desc: "An even bigger chance of a special item when you water trees.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_lightgreenthumb","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "light_green_thumb_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "lightgreenthumb_water_drop_1"
                    }
            },
        ],
        rewards: [
        ]
    },


mappery: {
        name: "Mappery",
        desc: "Mappery is a generous dose of spatial knowhow: a minimap of your current location and a searchable area map which allows you to set destinations and get street-by-street directions.",
        max_uses: 1,
        chance: 10,
        cost: 20,
        config: {"bg":"green","pattern":"upgrade","suit":"upgrade","art":"map","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 1,
                data: null
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "jump_1"
                    }
            },
        ],
        rewards: [
        ]
    },


map_search: {
        name: "Map Search",
        desc: "Click on the map and then on the magnifying glass to type-search any location or region in the known world of Glitch.",
        max_uses: 1,
        chance: 10,
        cost: 100,
        is_secret: true,
        config: {"bg":"green","pattern":"upgrade","suit":"upgrade","art":"map","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "mappery"
                    }
            },
        ],
        rewards: [
        ]
    },


master_chef_imagination: {
        name: "Better Pot",
        desc: "Truly experience the Awesome Pot, which gives you a chance for bonus Imagination when cooking with it.",
        max_uses: 1,
        chance: 4,
        cost: 1200,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_masterchef","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "masterchef_1"
                    }
            },
        ],
        rewards: [
        ]
    },


master_chef_tool_wear: {
        name: "Stronger Pot",
        desc: "Reduce the depletion of your Awesome Pot by 50%.",
        max_uses: 1,
        chance: 4,
        cost: 1000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_masterchef","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "masterchef_1"
                    }
            },
        ],
        rewards: [
        ]
    },


meditative_arts_focus_1: {
        name: "Clear Mind",
        desc: "Upgrade your meditation duration by 20%. Focusssssss.",
        max_uses: 1,
        chance: 5,
        cost: 1000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_meditativearts","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "meditativearts_1"
                    }
            },
            {
                type: 6,
                data: {
                        "quest_id"  : "meditativearts_meditate_for_time_period"
                    }
            },
        ],
        rewards: [
        ]
    },


meditative_arts_focus_2: {
        name: "Clearer Mind",
        desc: "Bump your meditation duration by 50%. Oooohhhmmmm.",
        max_uses: 1,
        chance: 4,
        cost: 3000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_meditativearts","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "meditativearts_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "meditative_arts_focus_1"
                    }
            },
        ],
        rewards: [
        ]
    },


meditative_arts_imagination: {
        name: "Enlightenment",
        desc: "Deepen your understanding of the Focusing Orb, so you sometimes earn bonus Imagination when using the Orb.",
        max_uses: 1,
        chance: 3,
        cost: 2000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_meditativearts","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "meditativearts_3"
                    }
            },
        ],
        rewards: [
        ]
    },


meditative_arts_less_distraction: {
        name: "Tune Out The Chatter Meditation",
        desc: "Incoming chat messages will no longer distract you while meditating.",
        max_uses: 1,
        chance: 6,
        cost: 500,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_meditativearts","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "meditativearts_1"
                    }
            },
        ],
        rewards: [
        ]
    },


meditative_arts_less_distraction_2: {
        name: "Mantra Meditation",
        desc: "Outgoing chat messages will no longer distract you while meditating.",
        max_uses: 1,
        chance: 4,
        cost: 1500,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_meditativearts","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "meditative_arts_less_distraction"
                    }
            },
        ],
        rewards: [
        ]
    },


meditative_arts_max_relax: {
        name: "Double Max Relax",
        desc: "Get double the benefits when you Max Relax!",
        max_uses: 1,
        chance: 3,
        cost: 4000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_meditativearts","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "meditativearts_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "ace_of_om"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "meditative_arts_less_distraction"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "meditative_arts_focus_2"
                    }
            },
        ],
        rewards: [
        ]
    },


metalmaking_imagination: {
        name: "Pedal to the Metal",
        desc: "Expand your expertise of Metal for a chance of bonus Imagination when using a Metal Machine.",
        max_uses: 1,
        chance: 4,
        cost: 1250,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_metalwork","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "metalwork_1"
                    }
            },
        ],
        rewards: [
        ]
    },


metalmaking_music: {
        name: "Making Metal",
        desc: "Plays metal music while you make metal.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_metalwork","icon":"musicnote"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "metalwork_1"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_drop_1: {
        name: "Truly Outrageous I",
        desc: "Study Gem structure for a 4% chance of a bonus Gem when you mine.",
        max_uses: 1,
        chance: 5,
        cost: 1000,
        config: {"bg":"magenta","pattern":"drop","suit":"skill","art":"skill_mining","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_1"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_drop_2: {
        name: "Truly Outrageous II",
        desc: "Continue your investigation of Gems for a 5% chance of a bonus Gem when you mine.",
        max_uses: 1,
        chance: 5,
        cost: 1250,
        config: {"bg":"magenta","pattern":"drop","suit":"skill","art":"skill_mining","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "mining_drop_1"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_drop_3: {
        name: "Truly Outrageous III",
        desc: "Deepen your knowledge of crystalline formations for a 6% chance of a bonus Gem when you mine.",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"magenta","pattern":"drop","suit":"skill","art":"skill_mining","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_3"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "mining_drop_2"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_drop_4: {
        name: "Truly Outrageous IV",
        desc: "Unlock the deepest secrets of precious jewels for an 8% chance of a bonus Gem when you mine.",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"magenta","pattern":"drop","suit":"skill","art":"skill_mining","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_4"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "mining_drop_3"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_expert_beryl: {
        name: "Beryl Expert",
        desc: "Wow! You're such an expert, you can now get 15% more Beryl from mining!",
        max_uses: 1,
        chance: 5,
        cost: 4000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_2"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "creditable_delver"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_expert_dullite: {
        name: "Dullite Expert",
        desc: "Check you out, Dullite expert. You can now get 15% more Dullite from mining!",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "ok_hewer"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_expert_metal_rock: {
        name: "Metal Rock Expert",
        desc: "You're so Metal!! You can now get 15% more Metal Rock from mining!",
        max_uses: 1,
        chance: 5,
        cost: 3000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "creditable_delver"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_expert_sparkly: {
        name: "Sparkly Expert",
        desc: "Shiny happy Sparkly! Your expert status can earn you 15% more Sparkly from mining!",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "serious_scrabbler"
                    }
            },
        ],
        rewards: [
        ]
    },


mining_high_capacity_rock: {
        name: "Rock Whisperer",
        desc: "Ore summoner! Rock wizard! Choose this and Dullite, Beryl & Sparkly rocks alike have a 50% better chance of respawning as mega-capacity rocks when you deplete them.",
        max_uses: 1,
        chance: 3,
        cost: 4000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 9
                    }
            },
        ],
        rewards: [
        ]
    },


mining_multitasking: {
        name: "Multiminingtasking",
        desc: "Let's you eat, sort bags and meditate while mining.",
        max_uses: 1,
        chance: 4,
        cost: 50000,
        is_secret: true,
        config: {"bg":"lightnavy","pattern":"upgrade","suit":"upgrade","art":"skill_mining","icon":"tool","hide_front_name":0},
        conditions: [
        ],
        rewards: [
        ]
    },


mining_time_1: {
        name: "Manic Mining I",
        desc: "Toil less, mine more! Speed up your mining time by 10%.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 7
                    }
            },
        ],
        rewards: [
        ]
    },


mining_time_2: {
        name: "Manic Mining II",
        desc: "Toil less, mine more! Speed up your mining time by 25%.",
        max_uses: 1,
        chance: 4,
        cost: 5000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "mining_time_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


mining_time_3: {
        name: "Manic Mining III",
        desc: "Toil less, mine more! Speed up your mining time by 50%.",
        max_uses: 1,
        chance: 3,
        cost: 10000,
        config: {"bg":"navy","pattern":"skill","suit":"skill","art":"skill_mining","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "mining_4"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "mining_time_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
        ]
    },


pack_internal_sortitude: {
        name: "Internal Sortitude",
        desc: "Ability to \"specialize\" your bags, so the right sort of items will automatically go into the right bags, whenever they can. Brilliant!",
        max_uses: 1,
        chance: 6,
        cost: 30000,
        config: {"bg":"yellow","pattern":"avatar","suit":"avatar","art":"bag","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 11
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "pack_stack_up_bags"
                    }
            },
        ],
        rewards: [
        ]
    },


pack_magic_sort: {
        name: "Magic Sort",
        desc: "Automatically swaps items around across all your bags so that the distribution of items most closely matches your bags' specializations. (Only works if you have specialized some bags!)",
        max_uses: 1,
        chance: 6,
        cost: 20000,
        config: {"bg":"yellow","pattern":"avatar","suit":"avatar","art":"bag","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "pack_internal_sortitude"
                    }
            },
        ],
        rewards: [
        ]
    },


pack_stack_up_bags: {
        name: "Stack Up",
        desc: "Stack up the items across all bags in your pack, so you don't have a bit of one item here and another bit there, when it is possible to put them together.",
        max_uses: 1,
        chance: 8,
        cost: 5000,
        config: {"bg":"yellow","pattern":"avatar","suit":"avatar","art":"bag","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


periodic_mood_loss_reduced_1: {
        name: "Steady On, Mood Loser",
        desc: "A reduction in your periodic mood loss: mood drops from peak highs are 1\/6th slower than the natural rate.",
        max_uses: 1,
        chance: 8,
        cost: 7500,
        config: {"bg":"red","pattern":"avatar","suit":"avatar","art":"quoinmood","icon":""},
        conditions: [
            {
                type: 7,
                data: {
                        "max_energy"    : 600
                    }
            },
        ],
        rewards: [
        ]
    },


periodic_mood_loss_reduced_2: {
        name: "Steady On, Mood Loser II",
        desc: "A reduction in your periodic mood loss: mood drops from peak highs are 1\/3rd slower than the natural rate.",
        max_uses: 1,
        chance: 7,
        cost: 15000,
        config: {"bg":"red","pattern":"avatar","suit":"avatar","art":"quoinmood","icon":""},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "periodic_mood_loss_reduced_1"
                    }
            },
            {
                type: 7,
                data: {
                        "max_energy"    : 1200
                    }
            },
        ],
        rewards: [
        ]
    },


periodic_mood_loss_reduced_3: {
        name: "Steady On, Mood Loser III",
        desc: "A reduction in your periodic mood loss: natural mood drops from peak highs are only half as fast as the natural rate.",
        max_uses: 1,
        chance: 6,
        cost: 35000,
        config: {"bg":"red","pattern":"avatar","suit":"avatar","art":"quoinmood","icon":""},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "periodic_mood_loss_reduced_2"
                    }
            },
            {
                type: 7,
                data: {
                        "max_energy"    : 2000
                    }
            },
        ],
        rewards: [
        ]
    },


piety_shrine_prime_bonus_1: {
        name: "Shrine On I",
        desc: "When you prime a Shrine in a battle with the Rook, all donations do 25% more damage.",
        max_uses: 1,
        chance: 5,
        cost: 3000,
        config: {"bg":"red","pattern":"skill","suit":"skill","art":"skill_piety","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "piety_1"
                    }
            },
        ],
        rewards: [
        ]
    },


piety_shrine_prime_bonus_2: {
        name: "Shrine On II",
        desc: "When you prime a Shrine in a battle with the Rook, all donations do 50% more damage.",
        max_uses: 1,
        chance: 5,
        cost: 6000,
        config: {"bg":"red","pattern":"skill","suit":"skill","art":"skill_piety","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "piety_1"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "piety_shrine_prime_bonus_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


potionmaking_imagination: {
        name: "Potent Potions",
        desc: "Upgrade your potionmaking skills for a chance of bonus imagination when using a Cauldron.",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_potionmaking","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "potionmaking_1"
                    }
            },
        ],
        rewards: [
        ]
    },


quest_reward_bonus_1: {
        name: "Fit for a King I",
        desc: "Improve your Quest rewards by  2%.",
        max_uses: 1,
        chance: 7,
        cost: 200,
        config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"questbook","icon":"upgrade"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
        ]
    },


quest_reward_bonus_2: {
        name: "Fit for a King II",
        desc: "Improve your Quest rewards by 4%.",
        max_uses: 1,
        chance: 6,
        cost: 400,
        config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"questbook","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "quest_reward_bonus_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 7
                    }
            },
        ],
        rewards: [
        ]
    },


quest_reward_bonus_3: {
        name: "Fit for a King III",
        desc: "Improve your Quest rewards by 6%.",
        max_uses: 1,
        chance: 5,
        cost: 600,
        config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"questbook","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "quest_reward_bonus_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 9
                    }
            },
        ],
        rewards: [
        ]
    },


quest_reward_bonus_4: {
        name: "Fit for a King IV",
        desc: "Improve your Quest rewards by 8%.",
        max_uses: 1,
        chance: 4,
        cost: 800,
        config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"questbook","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "quest_reward_bonus_3"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
        ]
    },


quest_reward_bonus_5: {
        name: "Fit for a King V",
        desc: "Improve your quest rewards by 10%.",
        max_uses: 1,
        chance: 3,
        cost: 1200,
        config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"questbook","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "quest_reward_bonus_4"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
        ]
    },


quoin_multiplier: {
        name: "Add {amount} To Your Quoin Multiplier",
        desc: "Your Quoin Multiplier increases the benefit from each quoin you come across.",
        max_uses: 0,
        chance: 16,
        cost: 0,
        config: {"bg":"yellow","pattern":"upgrade","suit":"upgrade","art":"quoinmood","icon":"upgrade"},
        conditions: [
        ],
        rewards: [
        ],
        options: {
    1: {
        cost_per: 200,
        chances: [13, 3, 0],
        min_level: 0
    },
    2: {
        cost_per: 400,
        chances: [11, 5, 0],
        min_level: 3
    },
    3: {
        cost_per: 1200,
        chances: [10, 5, 1],
        min_level: 5
    },
    4: {
        cost_per: 3000,
        chances: [9, 6, 1],
        min_level: 6
    },
    5: {
        cost_per: 4000,
        chances: [8, 6, 2],
        min_level: 7
    },
    6: {
        cost_per: 6000,
        chances: [8, 6, 2],
        min_level: 7
    },
    7: {
        cost_per: 8000,
        chances: [7, 6, 3],
        min_level: 7
    },
    8: {
        cost_per: 10000,
        chances: [7, 6, 3],
        min_level: 8
    },
    9: {
        cost_per: 12000,
        chances: [6, 6, 4],
        min_level: 9
    },
    10: {
        cost_per: 14000,
        chances: [6, 6, 4],
        min_level: 10
    },
    11: {
        cost_per: 16000,
        chances: [6, 6, 4],
        min_level: 12
    },
    12: {
        cost_per: 18000,
        chances: [5, 6, 5],
        min_level: 14
    },
    13: {
        cost_per: 20000,
        chances: [5, 6, 5],
        min_level: 16
    },
    14: {
        cost_per: 22500,
        chances: [5, 6, 5],
        min_level: 18
    },
    15: {
        cost_per: 25000,
        chances: [4, 7, 5],
        min_level: 20
    },
    16: {
        cost_per: 27500,
        chances: [4, 7, 5],
        min_level: 22
    },
    17: {
        cost_per: 30000,
        chances: [4, 7, 5],
        min_level: 24
    },
    18: {
        cost_per: 32500,
        chances: [4, 6, 6],
        min_level: 26
    },
    19: {
        cost_per: 35000,
        chances: [4, 6, 6],
        min_level: 28
    },
    20: {
        cost_per: 37500,
        chances: [4, 6, 6],
        min_level: 30
    },
    21: {
        cost_per: 40000,
        chances: [4, 6, 6],
        min_level: 31
    },
    22: {
        cost_per: 42500,
        chances: [4, 6, 6],
        min_level: 32
    },
    23: {
        cost_per: 45000,
        chances: [4, 6, 6],
        min_level: 33
    },
    24: {
        cost_per: 47500,
        chances: [4, 6, 6],
        min_level: 34
    },
    25: {
        cost_per: 50000,
        chances: [4, 6, 6],
        min_level: 35
    },
    100: {
        cost_per: 50000,
        chances: [0, 0, 0],
        min_level: 35
    }
}
    },


recipe_task_limit_drink_1: {
        name: "Boisterous Bartender I",
        desc: "Fiddle with your blender and cocktail shaker to make drinks in batches 50% larger than standard batch sizes.",
        max_uses: 1,
        chance: 5,
        cost: 4000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_blending","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "blending_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 12
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_drink_2: {
        name: "Boisterous Bartender II",
        desc: "Fiddle with your blender and cocktail shaker to make drinks in batches twice as large as standard batch sizes.",
        max_uses: 1,
        chance: 4,
        cost: 8000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_blending","icon":"tool"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "recipe_task_limit_drink_1"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "cocktailcrafting_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 20
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_food_1: {
        name: "Captain Cook I",
        desc: "Tamper with your cooking devices to make food in batches which are 50% larger than standard batch sizes.",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_ezcooking","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "cheffery_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_food_2: {
        name: "Captain Cook II",
        desc: "Tamper with your cooking devices to make food in batches which are twice as large as standard batch sizes.",
        max_uses: 1,
        chance: 4,
        cost: 10000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_ezcooking","icon":"tool"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "recipe_task_limit_food_1"
                    }
            },
            {
                type: 4,
                data: {
                        "skill_id"  : "masterchef_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 20
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_loomer_1: {
        name: "Luscious Loomer",
        desc: "Amplify your Loomer to make String, General Fabric and Rugs in batches that are 2.5 times as large as standard batch sizes.",
        max_uses: 1,
        chance: 5,
        cost: 3000,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_fiberarts","icon":"tool","hide_front_name":0},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "fiber_arts_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_machines_1: {
        name: "Mad Machinist I",
        desc: "Overclock your machines to make things in batches 50% larger than specified by factory settings.",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_engineering","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "engineering_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_machines_2: {
        name: "Mad Machinist II",
        desc: "Overclock your machines to make things in batches twice as large as those specified by factory settings.",
        max_uses: 1,
        chance: 4,
        cost: 10000,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_engineering","icon":"tool"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "recipe_task_limit_machines_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 20
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_tincturing_1: {
        name: "Tincturing Todd",
        desc: "Meddle with your tincturing kit to make tinctures in batches twice as large as standard batch sizes.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_tincturing","icon":"tool","hide_front_name":0},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "tincturing_1"
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_transmog_1: {
        name: "Tireless Transmogrifier I",
        desc: "Tune up your transmogrifying tools (Fruit Changing Machine, Spice Mill, Gassifier and Bubble Tuner) to transmogrify in batches 50% larger than factory specs.",
        max_uses: 1,
        chance: 5,
        cost: 3000,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_fruitchanging","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "fruitchanging_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 8
                    }
            },
        ],
        rewards: [
        ]
    },


recipe_task_limit_transmog_2: {
        name: "Tireless Transmogrifier II",
        desc: "Tune up your transmogrifying tools (Fruit Changing Machine, Spice Mill, Gassifier and Bubble Tuner) to transmogrify in batches twice as large as factory specs.",
        max_uses: 1,
        chance: 4,
        cost: 6000,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_fruitchanging","icon":"tool"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "recipe_task_limit_transmog_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 16
                    }
            },
        ],
        rewards: [
        ]
    },


refining_drop_1: {
        name: "Refinery",
        desc: "Do you love to grind? This upgrade gives you a rare chance for a surprise item when Crushing rocks or barnacles with a Grinder.",
        max_uses: 1,
        chance: 6,
        cost: 1000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_refining","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "refining_1"
                    }
            },
        ],
        rewards: [
        ]
    },


refining_drop_2: {
        name: "Super Refinery",
        desc: "Improve your grinding ability further for a better chance of a special surprise when Crushing rocks or barnacles with a Grinder.",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_refining","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "refining_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "refining_drop_1"
                    }
            },
        ],
        rewards: [
        ]
    },


refining_time_1: {
        name: "Refined Speed",
        desc: "Reduce your crushing time by 20%.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_refining","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "refining_1"
                    }
            },
        ],
        rewards: [
        ]
    },


refining_time_2: {
        name: "Super Refined Speed",
        desc: "Reduce your crushing time by 40%.",
        max_uses: 1,
        chance: 4,
        cost: 4000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_refining","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "refining_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "refining_time_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


remoteherdkeeping_production_1: {
        name: "Happy Herd",
        desc: "Improve your Remote Herdkeeping skills, so your herd produces 10% more!",
        max_uses: 1,
        chance: 4,
        cost: 4000,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_remoteherdkeeping","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "remoteherdkeeping_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


remoteherdkeeping_production_2: {
        name: "Happier Herd",
        desc: "Improve your Remote Herdkeeping skills further, so your herd produces 20% more!",
        max_uses: 1,
        chance: 3,
        cost: 7500,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_remoteherdkeeping","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "remoteherdkeeping_1"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "remoteherdkeeping_production_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 16
                    }
            },
        ],
        rewards: [
        ]
    },


rube_better_items: {
        name: "Rube's Favorite",
        desc: "You're nobody's chump! The Rube will no longer offer you cheap items after this upgrade.",
        max_uses: 1,
        chance: 6,
        cost: 5000,
        config: {"bg":"yellow","pattern":"upgrade","suit":"reward","art":"rube","icon":"upgrade"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


rube_chance_to_meet: {
        name: "Rube Radar",
        desc: "Double your chances of meeting The Rube.",
        max_uses: 1,
        chance: 8,
        cost: 5000,
        config: {"bg":"yellow","pattern":"upgrade","suit":"upgrade","art":"rube","icon":"upgrade"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 14
                    }
            },
        ],
        rewards: [
        ]
    },


saucery_imagination: {
        name: "Saucy Pan",
        desc: "Become a sauce expert, so you sometimes earn bonus Imagination when using the Saucepan. Sweet or sour? You decide!",
        max_uses: 1,
        chance: 4,
        cost: 400,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_saucery","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "saucery_2"
                    }
            },
        ],
        rewards: [
        ]
    },


saucery_tool_wear: {
        name: "Stronger, Saucier Pan",
        desc: "Reduce wear and tear on your Saucepan by 50%.",
        max_uses: 1,
        chance: 4,
        cost: 330,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_saucery","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "saucery_1"
                    }
            },
        ],
        rewards: [
        ]
    },


skill_learning: {
        name: "Skill Learning Brain",
        desc: "Enables the learning of new skills and bestows a skill learning brain with an initial capacity for 20 skills.",
        max_uses: 1,
        chance: 10,
        cost: 500,
        config: {"bg":"green","pattern":"upgrade","suit":"upgrade","art":"brain","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 1,
                data: null
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "mappery"
                    }
            },
        ],
        rewards: [
        ]
    },


sloth_bonus_snails: {
        name: "Friend of Metal",
        desc: "By purchasing this upgrade, you confirm your allegiance to Metal. In appreciation (or perhaps disgust), Sloths will occasionally spit Snails down at you when you walk past their trees.",
        max_uses: 1,
        chance: 5,
        cost: 750,
        config: {"bg":"magenta","pattern":"upgrade","suit":"reward","art":"skill_animalkinship","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "animalkinship_3"
                    }
            },
        ],
        rewards: [
        ]
    },


smelting_drop: {
        name: "Who Smelt It?",
        desc: "Gives you a chance of a surprise item when smelting Metal Rocks with the Smelter.",
        max_uses: 1,
        chance: 5,
        cost: 1500,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_smelting","icon":"drop"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "smelting_1"
                    }
            },
        ],
        rewards: [
        ]
    },


smelting_energy: {
        name: "The Green Smelt",
        desc: "Smelting costs 3 energy instead of 5 per Plain Metal Ingot.",
        max_uses: 1,
        chance: 5,
        cost: 1000,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_smelting","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "smelting_1"
                    }
            },
        ],
        rewards: [
        ]
    },


smelting_tool_wear: {
        name: "Strong Smelter",
        desc: "Reduce wear and tear on your Smelter by 50%.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"yellow","pattern":"skill","suit":"skill","art":"skill_smelting","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "smelting_1"
                    }
            },
        ],
        rewards: [
        ]
    },


snapshottery_basic_filter_pack: {
        name: "Basic Filter Pack",
        desc: "Enhance your Snapshottery upgrade with the Boost, B&W, Chilliwack and Historic filters to spiff up your Snaps!",
        max_uses: 1,
        chance: 30,
        cost: 300,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_snapshotting","icon":"upgrade"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "snapshotting"
                    }
            },
        ],
        rewards: [
        ]
    },


snapshottery_filter_pack_1: {
        name: "Do Hue Want This Filter Pack?",
        desc: "Enhance your Snapshottery upgrade with the Piggy, Firefly and Beryl filters to colorize your Snaps!",
        max_uses: 1,
        chance: 10,
        cost: 400,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_snapshotting","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "snapshotting"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "snapshottery_basic_filter_pack"
                    }
            },
        ],
        rewards: [
        ]
    },


snapshottery_filter_pack_2: {
        name: "Hipst-o-Rama Filter Pack",
        desc: "Enhance your Snapshottery upgrade with the Holga, Ancient and Vintage filters to hipsterize your Snaps!",
        max_uses: 1,
        chance: 10,
        cost: 400,
        config: {"bg":"blue","pattern":"skill","suit":"","art":"skill_snapshotting","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "snapshotting"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "snapshottery_basic_filter_pack"
                    }
            },
        ],
        rewards: [
        ]
    },


snapshottery_filter_pack_3: {
        name: "Psychedelia Filter Pack",
        desc: "Enhance your Snapshottery upgrade with the Dither, Shift and Outline filters to transfigure your Snaps!",
        max_uses: 1,
        chance: 10,
        cost: 400,
        config: {"bg":"blue","pattern":"skill","suit":"","art":"skill_snapshotting","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "snapshotting"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "snapshottery_basic_filter_pack"
                    }
            },
        ],
        rewards: [
        ]
    },


snapshotting: {
        name: "Snapshottery",
        desc: "Gives you the ability to take pictures (or Snaps) and share them with the world! Press 'C' for Camera Mode!",
        max_uses: 1,
        chance: 10,
        cost: 500,
        config: {"bg":"blue","pattern":"upgrade","suit":"reward","art":"skill_snapshotting","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
        ]
    },


soil_appreciation_bean_grow_1: {
        name: "Bean Growing Expert I",
        desc: "Beans planted and petted mature into trees a little faster.",
        max_uses: 1,
        chance: 4,
        cost: 2000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_soilappreciation","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "soil_appreciation_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "whizbang_plantifier"
                    }
            },
        ],
        rewards: [
        ]
    },


soil_appreciation_bean_grow_2: {
        name: "Bean Growing Expert II",
        desc: "Beans planted and petted mature into trees even more quickly.",
        max_uses: 1,
        chance: 3,
        cost: 4000,
        config: {"bg":"green","pattern":"skill","suit":"skill","art":"skill_soilappreciation","icon":"clock"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "soil_appreciation_5"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "soil_appreciation_bean_grow_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "johnny_anyseed"
                    }
            },
        ],
        rewards: [
        ]
    },


soil_appreciation_dirt_pile_1: {
        name: "Dirty",
        desc: "You can now dig one Dirt Pile 4 times a day! Whew!",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_soilappreciation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "soil_appreciation_2"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "shovel_jockey"
                    }
            },
        ],
        rewards: [
        ]
    },


soil_appreciation_dirt_pile_2: {
        name: "Extra Dirty",
        desc: "Increase your ability to dig one Dirt Pile to a whopping 5 times a day!",
        max_uses: 1,
        chance: 3,
        cost: 4000,
        config: {"bg":"darkgray","pattern":"skill","suit":"skill","art":"skill_soilappreciation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "soil_appreciation_5"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "soil_appreciation_dirt_pile_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "dirt_monkey"
                    }
            },
        ],
        rewards: [
        ]
    },


spicemilling_imagination: {
        name: "Spicy Times",
        desc: "This upgrade gives you a chance for bonus Imagination when using the Spice Mill. Grind it out!",
        max_uses: 1,
        chance: 5,
        cost: 200,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_spicemilling","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "spicemilling_1"
                    }
            },
        ],
        rewards: [
        ]
    },


ticket_to_paradise_abysmal_thrill: {
        name: "Ticket to Abysmal Thrill",
        desc: "Activate this card to dive to the depths of Abysmal Thrill and test your skills at quoin getting.",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_abysmalthrill","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_abysmal_thrill"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_abysmal_thrill",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_arbor_hollow: {
        name: "Ticket To Arbor Hollow",
        desc: "Follow a trail of quoins to the tops of tall trees. Then collect more as you plunge back down!",
        max_uses: 0,
        chance: 2,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_arborhollow","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_arbor_hollow"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_arbor_hollow",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_beam_me_down: {
        name: "Ticket To Beam Me Down",
        desc: "Activate this card to start your descent. Feel the wind in your hair, grab some quoins and maybe get a little help from some unidentifiable friends.",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_beammedown","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_beam_me_down"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_beam_me_down",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_bippity_bop: {
        name: "Ticket to Bippity Bop",
        desc: "Activate this card to bounce your way through a fluffy sky scape of joy! you'll probably get some quoins out of it too.",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_bippitybop","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_bippity_bop"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_bippity_bop",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_cloud_flight: {
        name: "Ticket To Cloud Flight",
        desc: "Leap into the sky above the tree-tops, and collect quoins as you fly through the air!",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_cloudflight","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_cloud_flight"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_cloud_flight",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_cloud_rings: {
        name: "Ticket To Cloud Rings",
        desc: "Activate this card to blast through all the cloud rings, collecting quoins as you go. Don't forget to enjoy the view a bit.",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_cloudrings","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_cloud_rings"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_cloud_rings",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_mountain_scaling: {
        name: "Ticket to Mountain Scaling",
        desc: "Activate this card to traverse the tippity top of the mountains and try not to fall down into the clouds.",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_mountainscaling","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_mountain_scaling"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_mountain_scaling",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_radial_heights: {
        name: "Ticket To Radial Heights",
        desc: "Fly about the evening sky, discovering a spiral of stars. Extra care earns you a special message!",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_radialheights","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_radial_heights"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_radial_heights",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_sky_plunge: {
        name: "Ticket To Sky Plunge",
        desc: "Take the plunge! A fast drop through soft, morning clouds. Can you collect every quoin?",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_skyplunge","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_sky_plunge"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_sky_plunge",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_slip_n_slide: {
        name: "Ticket to Slip 'N Slide",
        desc: "Activate this card to jump and slide your way up and down the slippery hills of this quoin filled winter wonderland.",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_slipnslide","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_slip_n_slide"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_slip_n_slide",
                        "num"       : 1
                    }
            },
        ]
    },


ticket_to_paradise_starlit_night: {
        name: "Ticket To Starlit Night",
        desc: "Ever wonder what stars sound like? Collect quoins as you float in the night-time sky.",
        max_uses: 0,
        chance: 3,
        cost: 25,
        config: {"bg":"keepable","pattern":"","suit":"keepable","art":"keepable_t2p_starlitnight","icon":"","hide_front_name":1,"item_tsid":"paradise_ticket_starlit_night"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 5
                    }
            },
        ],
        rewards: [
            {
                type: 8,
                data: {
                        "class_id"  : "paradise_ticket_starlit_night",
                        "num"       : 1
                    }
            },
        ]
    },


tincturing_imagination: {
        name: "Tincture Time",
        desc: "Gives a chance for bonus Imagination when using a Tincturing Kit.",
        max_uses: 1,
        chance: 5,
        cost: 1200,
        config: {"bg":"magenta","pattern":"skill","suit":"skill","art":"skill_tincturing","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "tincturing_1"
                    }
            },
        ],
        rewards: [
        ]
    },


tinkering_repairing_gives_mood: {
        name: "Tink Happy Thoughts",
        desc: "Repairing tools improves your mood, bit for bit.",
        max_uses: 1,
        chance: 5,
        cost: 2500,
        config: {"bg":"red","pattern":"skill","suit":"skill","art":"skill_tinkering","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "tinkering_4"
                    }
            },
        ],
        rewards: [
        ]
    },


toolcrafting_bonus_tool: {
        name: "Bonus Tool From Spare Parts",
        desc: "Take all those spare parts left over from assembling your new tool and occasionally make an extra tool with them.",
        max_uses: 1,
        chance: 3,
        cost: 5000,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_tinkering","icon":"tool"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "tinkering_5"
                    }
            },
        ],
        rewards: [
        ]
    },


toolcrafting_imagination_1: {
        name: "Tinker Time",
        desc: "Gives a chance for bonus Imagination when crafting tools with your Tinkertool.",
        max_uses: 1,
        chance: 5,
        cost: 500,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_tinkering","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "tinkering_4"
                    }
            },
        ],
        rewards: [
        ]
    },


toolcrafting_imagination_2: {
        name: "Tinker Plus",
        desc: "Gives an even better chance for more bonus Imagination when crafting tools with your Tinkertool.",
        max_uses: 1,
        chance: 4,
        cost: 1000,
        config: {"bg":"blue","pattern":"skill","suit":"skill","art":"skill_tinkering","icon":"imagination"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "tinkering_4"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "toolcrafting_imagination_1"
                    }
            },
        ],
        rewards: [
        ]
    },


trade_channel: {
        name: "Trade Channelling",
        desc: "Gives access to the \"Trade Channel\" a game-wide chat channel for buyers to find those selling the things they want to buy, and also the same thing but the other way around.",
        max_uses: 1,
        chance: 255,
        cost: 200,
        config: {"bg":"gold","pattern":"upgrade","suit":"upgrade","art":"rube","icon":"","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 3
                    }
            },
        ],
        rewards: [
        ]
    },


transcendental_benefits_1: {
        name: "Radiation Prolonger",
        desc: "Increase the duration of your transcendental radiation by 20%.",
        max_uses: 1,
        chance: 5,
        cost: 3000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_transcendentalradiation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "transcendental_radiation_1"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "ace_of_om"
                    }
            },
        ],
        rewards: [
        ]
    },


transcendental_benefits_2: {
        name: "Radiation Prolongest",
        desc: "Increase the duration of your transcendental radiation by 30%, to a total of 50%.",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_transcendentalradiation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "transcendental_radiation_1"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "transcendental_benefits_1"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "harmony_hound"
                    }
            },
        ],
        rewards: [
        ]
    },


transcendental_imagination: {
        name: "Transcendental Highway",
        desc: "Further your Transcendental Radiation studies for a chance to earn bonus Imagination when you Radiate.",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_transcendentalradiation","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "transcendental_radiation_2"
                    }
            },
        ],
        rewards: [
        ]
    },


transcendental_radius_1: {
        name: "Transcendental Radius I",
        desc: "Radiate 50% further during Transcendental Radiation.",
        max_uses: 1,
        chance: 5,
        cost: 2000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_transcendentalradiation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "transcendental_radiation_1"
                    }
            },
        ],
        rewards: [
        ]
    },


transcendental_radius_2: {
        name: "Transcendental Radius II",
        desc: "Radiate 100% further during Trancendental Radiation.",
        max_uses: 1,
        chance: 5,
        cost: 4000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_transcendentalradiation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "transcendental_radiation_1"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "transcendental_radius_1"
                    }
            },
        ],
        rewards: [
        ]
    },


transcendental_radius_3: {
        name: "Transcendental Radius III",
        desc: "Radiate to everyone in the location during Transcendental Radiation",
        max_uses: 1,
        chance: 5,
        cost: 8000,
        config: {"bg":"lightnavy","pattern":"skill","suit":"skill","art":"skill_transcendentalradiation","icon":"upgrade"},
        conditions: [
            {
                type: 4,
                data: {
                        "skill_id"  : "transcendental_radiation_2"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "transcendental_radius_2"
                    }
            },
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


unlearning_ability: {
        name: "Unlearning Ability",
        desc: "Need to free up your brain for better skills? You can now unlearn a skill at the same rate that it took to learn it.",
        max_uses: 1,
        chance: 7,
        cost: 3000,
        config: {"bg":"red","pattern":"skill","suit":"skill","art":"skill_unlearning","icon":"clock"},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 10
                    }
            },
        ],
        rewards: [
        ]
    },


unlearning_time_1: {
        name: "Speedy Unlearning",
        desc: "Reduce your Unlearning Time by 25%.",
        max_uses: 1,
        chance: 5,
        cost: 5000,
        config: {"bg":"red","pattern":"skill","suit":"skill","art":"skill_unlearning","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "unlearning_ability"
                    }
            },
        ],
        rewards: [
        ]
    },


unlearning_time_2: {
        name: "Speedier Unlearning",
        desc: "Reduce your Unlearning Time by 50%.",
        max_uses: 1,
        chance: 3,
        cost: 7500,
        config: {"bg":"red","pattern":"skill","suit":"skill","art":"skill_unlearning","icon":"clock"},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "unlearning_time_1"
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_higher_buy_price_1: {
        name: "Fast Talker",
        desc: "Get more for what you paid for. Vendor buyback prices are 2% higher.",
        max_uses: 1,
        chance: 8,
        cost: 10000,
        config: {"bg":"gold","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 11
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_higher_buy_price_2: {
        name: "Wheeler Dealer",
        desc: "Who said it was used? Vendor buyback prices are 5% higher.",
        max_uses: 1,
        chance: 7,
        cost: 25000,
        config: {"bg":"gold","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 15
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "vendors_higher_buy_price_1"
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_higher_buy_price_3: {
        name: "The Real Rube",
        desc: "Practically new, you say? Vendor buyback prices are 7% higher.",
        max_uses: 1,
        chance: 6,
        cost: 50000,
        config: {"bg":"gold","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 19
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "vendors_higher_buy_price_2"
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_higher_buy_price_4: {
        name: "Ultimate Closer",
        desc: "Flip it, baby! Vendor buyback prices are 10% higher.",
        max_uses: 1,
        chance: 5,
        cost: 100000,
        config: {"bg":"gold","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 23
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "vendors_higher_buy_price_3"
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_lower_sell_price_1: {
        name: "Beginner Haggler",
        desc: "Get haggling! Vendor prices are lowered by 2%.",
        max_uses: 1,
        chance: 8,
        cost: 2000,
        config: {"bg":"darkgray","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 9
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_lower_sell_price_2: {
        name: "Bargain Driver",
        desc: "Drive that bargain! Vendor prices lowered by 5%.",
        max_uses: 1,
        chance: 7,
        cost: 5000,
        config: {"bg":"darkgray","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 13
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "vendors_lower_sell_price_1"
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_lower_sell_price_3: {
        name: "Price Dropper",
        desc: "Keep pushing that line! Vendor prices lowered by 7%.",
        max_uses: 1,
        chance: 6,
        cost: 8000,
        config: {"bg":"darkgray","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 17
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "vendors_lower_sell_price_2"
                    }
            },
        ],
        rewards: [
        ]
    },


vendors_lower_sell_price_4: {
        name: "Harry the Haggler",
        desc: "Value is your new middle name! Vendor prices lowered by 10%.",
        max_uses: 1,
        chance: 5,
        cost: 15000,
        config: {"bg":"darkgray","pattern":"upgrade","suit":"upgrade","art":"bag","icon":"currant","hide_front_name":0},
        conditions: [
            {
                type: 2,
                data: {
                        "level" : 21
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "vendors_lower_sell_price_3"
                    }
            },
        ],
        rewards: [
        ]
    },


walk_speed_1: {
        name: "Walk Speed I",
        desc: "Truly the minimum acceptable walk speed. Anything else is maddening. You really MUST get this upgrade.",
        max_uses: 1,
        chance: 10,
        cost: 2,
        config: {"bg":"blue","pattern":"avatar","suit":"avatar","art":"avatar_walking","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 1,
                data: null
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : 0.6567,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


walk_speed_2: {
        name: "Walk Speed II",
        desc: "A decently brisk speed, though still slightly slower than the average mature Glitch.",
        max_uses: 1,
        chance: 10,
        cost: 6,
        config: {"bg":"blue","pattern":"avatar","suit":"avatar","art":"avatar_walking","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 1,
                data: null
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : 0.8268,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


walk_speed_3: {
        name: "Walk Speed III",
        desc: "This is the tin standard — the most common walking speed, the one the Giants intended as the speed at which a Glitch walks.",
        max_uses: 1,
        chance: 7,
        cost: 250,
        config: {"bg":"blue","pattern":"avatar","suit":"avatar","art":"avatar_walking","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 5,
                data: {
                        "achievement_id"    : "junior_ok_explorer"
                    }
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "walk_speed_2"
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : 1,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null,
                        "can_wall_jump"     : null
                    }
            },
        ]
    },


walk_speed_4: {
        name: "Walk Speed IV",
        desc: "Snappy walk speed that puts you slightly ahead of the pack. Just slightly. But, enough to notice.",
        max_uses: 1,
        chance: 6,
        cost: 20000,
        config: {"bg":"blue","pattern":"avatar","suit":"avatar","art":"avatar_walking","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 3,
                data: {
                        "imagination_id"    : "walk_speed_3"
                    }
            },
            {
                type: 5,
                data: {
                        "achievement_id"    : "rambler_first_class"
                    }
            },
        ],
        rewards: [
            {
                type: 1,
                data: {
                        "vx_max"        : 1.06,
                        "vy_jump"       : null,
                        "gravity"       : null,
                        "multiplier_3_jump" : null,
                        "can_3_jump"        : null
                    }
            },
        ]
    },


zoomability: {
        name: "Zoomability",
        desc: "Zooming … how does one live without it?! Zoomability lets you zoom your view of the game in and out to get the whole picture. Works very well with Camera Mode!",
        max_uses: 1,
        chance: 50,
        cost: 75,
        config: {"bg":"red","pattern":"upgrade","suit":"upgrade","art":"magnifyingglass","icon":"upgrade","hide_front_name":0},
        conditions: [
            {
                type: 1,
                data: null
            },
            {
                type: 3,
                data: {
                        "imagination_id"    : "walk_speed_2"
                    }
            },
        ],
        rewards: [
        ]
    }

};

    }
}