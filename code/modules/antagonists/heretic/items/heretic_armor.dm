// Eldritch armor. Looks cool, hood lets you cast heretic spells.
/obj/item/clothing/head/hooded/cult_hoodie/eldritch
	name = "ominous hood"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "eldritch"
	desc = "A torn, dust-caked hood. Strange eyes line the inside."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flash_protect = 2

/obj/item/clothing/head/hooded/cult_hoodie/eldritch/equipped(mob/user, slot)
	..()
	ADD_TRAIT(user, TRAIT_ALLOW_HERETIC_CASTING, CLOTHING_TRAIT)

/obj/item/clothing/head/hooded/cult_hoodie/eldritch/dropped(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_ALLOW_HERETIC_CASTING, CLOTHING_TRAIT)

/obj/item/clothing/head/hooded/cult_hoodie/eldritch/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/heretic_focus)

/obj/item/clothing/suit/hooded/cultrobes/eldritch
	name = "ominous armor"
	desc = "A ragged, dusty set of robes. Strange eyes line the inside."
	icon_state = "eldritch_armor"
	item_state = null
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	allowed = list(/obj/item/melee/sickly_blade)
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/eldritch
	// Slightly better than normal cult robes
	armor_type = /datum/armor/cultrobes_eldritch


/datum/armor/cultrobes_eldritch
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 35
	bio = 20
	rad = 20
	fire = 20
	acid = 20
	stamina = 50
	bleed = 40

/obj/item/clothing/suit/hooded/cultrobes/eldritch/examine(mob/user)
	. = ..()
	if(qdel_hood)
		return

	// Our hood gains the heretic_focus element.
	. += span_notice("Allows you to cast heretic spells while the hood is up.")

// Void cloak. Turns invisible with the hood up, lets you hide stuff.
/obj/item/clothing/head/hooded/cult_hoodie/void
	name = "void hood"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "void_cloak"
	flags_inv = NONE
	flags_cover = NONE
	desc = "Black like tar and doesn't reflect any light. Runic symbols line the outside, with each flash you lose comprehension of what you are seeing."
	item_flags = EXAMINE_SKIP
	armor_type = /datum/armor/cult_hoodie_void


/datum/armor/cult_hoodie_void
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 15
	stamina = 30
	bleed = 40

/obj/item/clothing/head/hooded/cult_hoodie/void/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_STRIP, REF(src))

/obj/item/clothing/suit/hooded/cultrobes/void
	name = "void cloak"
	desc = "Black like tar and doesn't reflect any light. Runic symbols line the outside, with each flash you lose comprehension of what you are seeing."
	icon_state = "void_cloak"
	item_state = "void_cloak"
	allowed = list(/obj/item/melee/sickly_blade)
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/void
	flags_inv = NONE
	// slightly worse than normal cult robes
	armor_type = /datum/armor/cultrobes_void
	body_parts_covered = CHEST|GROIN|ARMS
	qdel_hood = TRUE
	pockets = FALSE


/datum/armor/cultrobes_void
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 15
	stamina = 30
	bleed = 40

/obj/item/clothing/suit/hooded/cultrobes/void/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/void_cloak)
	make_visible()

/obj/item/clothing/suit/hooded/cultrobes/void/RemoveHood()
	// This is before the hood actually goes down
	// We only make it visible if the hood is being moved from up to down
	if(qdel_hood && hood)
		make_visible()
	return ..()

/obj/item/clothing/suit/hooded/cultrobes/void/MakeHood()
	if(!isliving(loc))
		CRASH("[src] attempted to make a hood on a non-living thing: [loc]")

	var/mob/living/wearer = loc
	if(!IS_HERETIC_OR_MONSTER(wearer))
		loc.balloon_alert(loc, "you can't get the hood up!")
		return

	// When we make the hood, that means we're going invisible
	make_invisible()
	return ..()

/// Makes our cloak "invisible". Not the wearer, the cloak itself.
/obj/item/clothing/suit/hooded/cultrobes/void/proc/make_invisible()
	item_flags |= EXAMINE_SKIP
	ADD_TRAIT(src, TRAIT_NO_STRIP, REF(src))
	RemoveElement(/datum/element/heretic_focus)

	if(isliving(loc))
		loc.balloon_alert(loc, "cloak hidden")
		loc.visible_message(span_notice("Light shifts around [loc], making the cloak around them invisible!"))

/// Makes our cloak "visible" again.
/obj/item/clothing/suit/hooded/cultrobes/void/proc/make_visible()
	item_flags &= ~EXAMINE_SKIP
	REMOVE_TRAIT(src, TRAIT_NO_STRIP, REF(src))
	AddElement(/datum/element/heretic_focus)

	if(isliving(loc))
		loc.balloon_alert(loc, "cloak revealed")
		loc.visible_message(span_notice("A kaleidoscope of colours collapses around [loc], a cloak appearing suddenly around their person!"))
