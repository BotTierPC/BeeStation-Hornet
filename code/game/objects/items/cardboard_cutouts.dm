//Cardboard cutouts! They're man-shaped and can be colored with a crayon to look like a human in a certain outfit, although it's limited, discolored, and obvious to more than a cursory glance.
/obj/item/cardboard_cutout
	name = "cardboard cutout"
	desc = "A vaguely humanoid cardboard cutout. It's completely blank."
	icon = 'icons/obj/cardboard_cutout.dmi'
	icon_state = "cutout_basic"
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FLAMMABLE
	// Possible restyles for the cutout;
	// add an entry in change_appearance() if you add to here
	var/list/possible_appearances = list("Assistant", "Clown", "Mime",
		"Traitor", "Nuke Op", "Cultist", "Clockwork Cultist",
		"Revolutionary", "Wizard", "Shadowling", "Xenomorph", "Xenomorph Maid", "Swarmer",
		"Ash Walker", "Deathsquad Officer", "Ian", "Slaughter Demon",
		"Laughter Demon", "Private Security Officer")
	var/pushed_over = FALSE //If the cutout is pushed over and has to be righted
	var/deceptive = FALSE //If the cutout actually appears as what it portray and not a discolored version

	var/lastattacker = null

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/cardboard_cutout/attack_hand(mob/living/user)
	if(!user.combat_mode || pushed_over)
		return ..()
	user.visible_message(span_warning("[user] pushes over [src]!"), span_danger("You push over [src]!"))
	playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
	push_over()

/obj/item/cardboard_cutout/proc/push_over()
	name = initial(name)
	desc = "[initial(desc)] It's been pushed over."
	icon = initial(icon)
	icon_state = "cutout_pushed_over"
	remove_atom_colour(FIXED_COLOUR_PRIORITY)
	alpha = initial(alpha)
	pushed_over = TRUE

/obj/item/cardboard_cutout/attack_self(mob/living/user)
	if(!pushed_over)
		return
	to_chat(user, span_notice("You right [src]."))
	desc = initial(desc)
	icon = initial(icon)
	icon_state = initial(icon_state) //This resets a cutout to its blank state - this is intentional to allow for resetting
	pushed_over = FALSE

/obj/item/cardboard_cutout/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/crayon))
		change_appearance(I, user)
		return
	// Why yes, this does closely resemble mob and object attack code.
	if(I.item_flags & NOBLUDGEON)
		return
	if(!I.force)
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), 1, -1)
	else if(I.hitsound)
		playsound(loc, I.hitsound, get_clamped_volume(), 1, -1)

	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)

	if(I.force)
		user.visible_message(span_danger("[user] hits [src] with [I]!"), \
			span_danger("You hit [src] with [I]!"))
		if(prob(I.force))
			push_over()

/obj/item/cardboard_cutout/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if(istype(P, /obj/projectile/bullet/reusable))
		P.on_hit(src, 0, piercing_hit)
	visible_message(span_danger("[src] is hit by [P]!"))
	playsound(src, 'sound/weapons/slice.ogg', 50, 1)
	if(prob(P.damage))
		push_over()
	return BULLET_ACT_HIT

/obj/item/cardboard_cutout/proc/change_appearance(obj/item/toy/crayon/crayon, mob/living/user)
	if(!crayon || !user)
		return
	if(pushed_over)
		to_chat(user, span_warning("Right [src] first!"))
		return
	if(crayon.check_empty(user))
		return
	if(crayon.is_capped)
		to_chat(user, span_warning("Take the cap off first!"))
		return
	var/new_appearance = input(user, "Choose a new appearance for [src].", "26th Century Deception") as null|anything in sort_list(possible_appearances)
	if(!new_appearance || !crayon || !user.canUseTopic(src, BE_CLOSE))
		return
	if(!do_after(user, 1 SECONDS, src, timed_action_flags = IGNORE_HELD_ITEM))
		return
	user.visible_message(span_notice("[user] gives [src] a new look."), span_notice("Voila! You give [src] a new look."))
	crayon.use_charges(1)
	crayon.check_empty(user)
	alpha = 255
	icon = initial(icon)
	if(!deceptive)
		add_atom_colour("#FFD7A7", FIXED_COLOUR_PRIORITY)
	switch(new_appearance)
		if("Assistant")
			name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
			desc = "A cardboat cutout of an assistant."
			icon_state = "cutout_greytide"
		if("Clown")
			name = pick(GLOB.clown_names)
			desc = "A cardboard cutout of a clown. You get the feeling that it should be in a corner."
			icon_state = "cutout_clown"
		if("Mime")
			name = pick(GLOB.mime_names)
			desc = "...(A cardboard cutout of a mime.)"
			icon_state = "cutout_mime"
		if("Traitor")
			name = "[pick("Unknown", "Captain")]"
			desc = "A cardboard cutout of a traitor."
			icon_state = "cutout_traitor"
		if("Nuke Op")
			name = "[pick("Unknown", "COMMS", "Telecomms", "AI", "stealthy op", "STEALTH", "sneakybeaky", "MEDIC", "Medic")]"
			desc = "A cardboard cutout of a nuclear operative."
			icon_state = "cutout_fluke"
		if("Cultist")
			name = "Unknown"
			desc = "A cardboard cutout of a cultist."
			icon_state = "cutout_cultist"
		if("Clockwork Cultist")
			name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
			desc = "A cardboard cutout of a servant of Ratvar."
			icon_state = "cutout_servant"
		if("Revolutionary")
			name = "Unknown"
			desc = "A cardboard cutout of a revolutionary."
			icon_state = "cutout_viva"
		if("Wizard")
			name = "[pick(GLOB.wizard_first)], [pick(GLOB.wizard_second)]"
			desc = "A cardboard cutout of a wizard."
			icon_state = "cutout_wizard"
		if("Shadowling")
			name = "Unknown"
			desc = "A cardboard cutout of a shadowling."
			icon_state = "cutout_shadowling"
		if("Xenomorph")
			name = "alien hunter ([rand(1, 999)])"
			desc = "A cardboard cutout of a xenomorph."
			icon_state = "cutout_fukken_xeno"
			if(prob(25))
				alpha = 75 //Spooky sneaking!
		if("Xenomorph Maid")
			name = "lusty xenomorph maid ([rand(1, 999)])"
			desc = "A cardboard cutout of a xenomorph maid."
			icon_state = "cutout_lusty"
		if("Swarmer")
			name = "Swarmer ([rand(1, 999)])"
			desc = "A cardboard cutout of a swarmer."
			icon_state = "cutout_swarmer"
		if("Ash Walker")
			name = random_lizard_name(pick(MALE, FEMALE))
			desc = "A cardboard cutout of an ash walker."
			icon_state = "cutout_free_antag"
		if("Deathsquad Officer")
			name = pick(GLOB.commando_names)
			desc = "A cardboard cutout of a death commando."
			icon_state = "cutout_deathsquad"
		if("Ian")
			name = "Ian"
			desc = "A cardboard cutout of the HoP's beloved corgi."
			icon_state = "cutout_ian"
		if("Slaughter Demon")
			name = "slaughter demon"
			desc = "A cardboard cutout of a slaughter demon."
			icon = 'icons/mob/mob.dmi'
			icon_state = "daemon"
		if("Laughter Demon")
			name = "laughter demon"
			desc = "A cardboard cutout of a laughter demon."
			icon = 'icons/mob/mob.dmi'
			icon_state = "bowmon"
		if("Private Security Officer")
			name = "Private Security Officer"
			desc = "A cardboard cutout of a private security officer."
			icon_state = "cutout_ntsec"
	return 1

/obj/item/cardboard_cutout/setDir(newdir)
	dir = SOUTH

/obj/item/cardboard_cutout/adaptive //Purchased by Syndicate agents, these cutouts are indistinguishable from normal cutouts but aren't discolored when their appearance is changed
	deceptive = TRUE

//	--- CHESS PIECES ---

// WHITE

/obj/item/cardboard_cutout/adaptive/chess
	desc = "A large cardboard cutout resembling a chess piece."

/obj/item/cardboard_cutout/adaptive/chess/king
	name = "White King"
	icon_state = "cutout_ian";

/obj/item/cardboard_cutout/adaptive/chess/queen
	name = "White Queen"
	icon_state = "cutout_clown";

/obj/item/cardboard_cutout/adaptive/chess/rook
	name = "White Rook"
	icon_state = "cutout_deathsquad";

/obj/item/cardboard_cutout/adaptive/chess/knight
	name = "White Knight"
	icon_state = "cutout_lusty";

/obj/item/cardboard_cutout/adaptive/chess/bishop
	name = "White Bishop"
	icon_state = "cutout_ntsec";

/obj/item/cardboard_cutout/adaptive/chess/pawn
	name = "White Pawn"
	icon_state = "cutout_greytide";

// BLACK

/obj/item/cardboard_cutout/adaptive/chess/black
	color = "#9999BB";

/obj/item/cardboard_cutout/adaptive/chess/black/king
	name = "Black King"
	icon_state = "cutout_wizard";

/obj/item/cardboard_cutout/adaptive/chess/black/queen
	name = "Black Queen"
	icon_state = "cutout_traitor";

/obj/item/cardboard_cutout/adaptive/chess/black/rook
	name = "Black Rook"
	icon_state = "cutout_cultist";

/obj/item/cardboard_cutout/adaptive/chess/black/knight
	name = "Black Knight"
	icon_state = "cutout_fukken_xeno";

/obj/item/cardboard_cutout/adaptive/chess/black/bishop
	name = "Black Bishop"
	icon_state = "cutout_fluke";

/obj/item/cardboard_cutout/adaptive/chess/black/pawn
	name = "Black Pawn"
	icon_state = "cutout_shadowling";
