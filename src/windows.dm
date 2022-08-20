/obj
	screen_loc = "CENTER"

#define PARENT_PLANE 10
#define CHILD_PLANE 11

/mob
	plane = PARENT_PLANE

/turf/wall
	plane = CHILD_PLANE

/obj/plane_master
	appearance_flags = PLANE_MASTER

// Parent goes to the base plane, and goes blue
/obj/plane_master/parent
	plane = PARENT_PLANE
	render_target = "*parent"
	blend_mode = BLEND_MULTIPLY

/mob/verb/alpha_254()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.alpha = 254

/mob/verb/alpha_255()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.alpha = 255

/mob/verb/unlink_parent()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.render_target = ""

/mob/verb/link_parent()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.render_target = "*parent"

/obj/relay_parent
	render_source = "*parent"
	plane = CHILD_PLANE

// Child plane master shrinks its contents
/obj/plane_master/child
	plane = CHILD_PLANE

/obj/plane_master/child/New()
	. = ..()
	transform = transform.Scale(0.8)

/client/proc/create_screen_obj(obj_type)
	var/obj/screen_obj = new obj_type()
	register_map_obj(screen_obj)
	return screen_obj

/client/proc/register_map_obj(obj/screen_obj)
	screen |= screen_obj

/client/New()
	. = ..()
	// Lets do our base setup of planes and relays
	create_screen_obj(/obj/plane_master/parent)
	create_screen_obj(/obj/relay_parent)
	create_screen_obj(/obj/plane_master/child)
