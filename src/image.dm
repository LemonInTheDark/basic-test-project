/turf/floor/image_holds
	layer = FLOOR_LAYER + 10
	icon_state = "weird_turf"

/turf/floor/image_holds/New()
	var/image/holding = locate(/image/holds_turf)
	holding.vis_contents += src
	return ..()

/turf/floor/image_spawn
	icon_state = "weird_turf_green"

/turf/floor/below
	icon_state = "below"

/turf/floor/image_spawn/New()
	var/image/holds_turf/image = new()
	image.loc = src
	return ..()

var/global/list/image_holder = list()

/image/holds_turf

/image/holds_turf/New()
	var/turf/holds = locate(/turf/floor/image_holds)
	vis_contents += holds
	image_holder += src
	return ..()

/client/verb/show_images()
	images += image_holder

/client/verb/hide_images()
	images -= image_holder