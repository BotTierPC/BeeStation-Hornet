GLOBAL_LIST_EMPTY(all_wormholes) // So we can pick wormholes to teleport to

/datum/round_event_control/wormholes
	name = "Wormholes"
	typepath = /datum/round_event/wormholes
	max_occurrences = 3
	weight = 2
	min_players = 2


/datum/round_event/wormholes
	announceWhen = 10
	endWhen = 60

	var/list/wormholes = list()
	var/shift_frequency = 3
	var/number_of_wormholes = 400

/datum/round_event/wormholes/setup()
	announceWhen = rand(0, 20)
	endWhen = rand(40, 80)

/datum/round_event/wormholes/start()
	for(var/i in 1 to number_of_wormholes)
		var/turf/T = get_random_station_turf()	//side effect - wormholes won't spawn in space
		wormholes += new /obj/effect/portal/wormhole(T, null, 0, null, FALSE)

/datum/round_event/wormholes/announce(fake)
	priority_announce("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert", ANNOUNCER_SPANOMALIES)

/datum/round_event/wormholes/tick()
	if(activeFor % shift_frequency == 0)
		for(var/obj/effect/portal/wormhole/O in wormholes)
			var/turf/T = get_random_station_turf()
			if(T)
				O.forceMove(T)

/datum/round_event/wormholes/end()
	QDEL_LIST(wormholes)
	wormholes = null
	var/turf/T = get_random_station_turf()
	T.generate_fake_pierced_realities(FALSE, 6)

/obj/effect/portal/wormhole
	name = "wormhole"
	desc = "It looks highly unstable; It could close at any moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	mech_sized = TRUE


CREATION_TEST_IGNORE_SUBTYPES(/obj/effect/portal/wormhole)

/obj/effect/portal/wormhole/Initialize(mapload, _creator, _lifespan = 0, obj/effect/portal/_linked, automatic_link = FALSE, turf/hard_target_override)
	. = ..()
	GLOB.all_wormholes += src

/obj/effect/portal/wormhole/Destroy()
	. = ..()
	GLOB.all_wormholes -= src

/obj/effect/portal/wormhole/teleport(atom/movable/M)
	if(iseffect(M))	//sparks don't teleport
		return
	if(M.anchored)
		if(!(ismecha(M) && mech_sized))
			return

	if(ismovable(M))
		if(GLOB.all_wormholes.len)
			var/obj/effect/portal/wormhole/P = pick(GLOB.all_wormholes)
			if(P && isturf(P.loc))
				hard_target = P.loc
		if(!hard_target)
			return
		do_teleport(M, hard_target, TRUE, no_effects = TRUE, channel = TELEPORT_CHANNEL_WORMHOLE) ///You will appear adjacent to the beacon
