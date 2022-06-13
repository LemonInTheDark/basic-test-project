/obj/cookie
	icon = 'icons/cookies.dmi'
	icon_state = "grey"
	layer = COOKIE_LAYER

/obj/cookie/New()
	random_y()
	random_x()
	random_state()
	return ..()

#define STRAY 16
/obj/cookie/proc/random_y()
	pixel_y = rand(-STRAY, STRAY)

/obj/cookie/proc/random_x()
	pixel_x = rand(-STRAY, STRAY)

/obj/cookie/proc/random_state()
	icon_state = pick(icon_states(icon))
