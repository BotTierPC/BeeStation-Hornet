/obj/vehicle/sealed/mecha/combat/phazon
	desc = "This is a Phazon exosuit. The pinnacle of scientific research and pride of Nanotrasen, it uses cutting edge bluespace technology and expensive materials."
	name = "\improper Phazon"
	icon_state = "phazon"
	base_icon_state = "phazon"
	movedelay = 2
	dir_in = 2 //Facing South.
	step_energy_drain = 3
	max_integrity = 200
	deflect_chance = 30
	armor_type = /datum/armor/combat_phazon
	max_temperature = 25000
	wreckage = /obj/structure/mecha_wreckage/phazon
	internal_damage_threshold = 25
	force = 15
	max_equip = 3
	phase_state = "phazon-phase"


/datum/armor/combat_phazon
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 30
	rad = 50
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/combat/phazon/generate_actions()
	. = ..()
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_toggle_phasing)
	initialize_passenger_action_type(/datum/action/vehicle/sealed/mecha/mech_switch_damtype)
