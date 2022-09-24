/*
	These are simple defaults for your project.
 */

/world
	fps = 60		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	map_format = SIDE_MAP
	view = 7		// show up to 6 tiles outward from center (13x13 view)


// Make objects move 8 pixels per tick when walking

/mob
	step_size = 1

/mob/New()
	x = 5
	y = 5
	. = ..()

/obj
	step_size = 1
