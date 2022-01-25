/obj/pod_trail
	icon = 'icons/normal_icon.dmi'
	icon_state = "smoke"
	layer = TRAIL_LAYER
	alpha = 128

/obj/pod
	var/list/trails
	icon = 'icons/big_icon.dmi'
	icon_state = "pod"
	layer = POD_LAYER
	bound_x = 16
	bound_height = 48

#define DROP_HEIGHT 300
#define PIXELS_PER_TICK 6

/obj/pod/proc/drop()
	set_y()
	make_trail()
	sleep(DROP_HEIGHT / PIXELS_PER_TICK)
	world << "Done"
	for(var/thing in trails)
		del(thing)
	del(src)

/obj/pod/proc/set_y()
	pixel_y = DROP_HEIGHT
	animate(src, pixel_y = 0, time = DROP_HEIGHT / PIXELS_PER_TICK)

/obj/pod/proc/set_trail_y(obj/trail, i)
	trail.pixel_y = i * 32

/obj/pod/proc/make_trail()
	trails = new /list(DROP_HEIGHT / 32)
	for(var/i in 1 to length(trails))
		var/obj/pod_trail/trail = new(loc)
		if (i == 1)
			trail.layer = FLY_LAYER
		trail.pixel_x = 16
		set_trail_y(trail, i)
		trails[i] = trail
		trail.filters += filter("type" = "blur", "size" = 4)
		
// A pod, but with z shifting for its trail. No strange bahavior
/obj/pod/z

/obj/pod/z/set_trail_y(obj/trail, i)
	trail.pixel_z = i * 32

// A pod, but with no trail filer. No strange behavior
/obj/pod/no_filter

/obj/pod/no_filter/make_trail()
	trails = new /list(DROP_HEIGHT / 32)
	for(var/i in 1 to length(trails))
		var/obj/pod_trail/trail = new(loc)
		if (i == 1)
			trail.layer = FLY_LAYER
		trail.pixel_x = 16
		set_trail_y(trail, i)
		trails[i] = trail
		//trail.filters += filter("type" = "blur", "size" = 4)

/mob/verb/test_drop_default()
	var/obj/pod/our_pod = new(loc)
	our_pod.drop()

/mob/verb/test_drop_z_shift()
	var/obj/pod/z/our_pod = new(loc)
	our_pod.drop()

/mob/verb/test_drop_no_filter()
	var/obj/pod/no_filter/our_pod = new(loc)
	our_pod.drop()