/obj
	screen_loc = "CENTER"

#define PARENT_PLANE 10
#define CHILD_PLANE 11

/atom
	plane = PARENT_PLANE

/obj/plane_master
	appearance_flags = PLANE_MASTER

// Parent goes to the base plane, and goes blue
/obj/plane_master/parent
	plane = PARENT_PLANE
	render_target = "*parent"
	transform

/mob/verb/scale()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.transform = lad.transform.Scale(2)

/mob/verb/descale()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.transform = new /matrix()

/mob/verb/unlink_parent()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.render_target = ""

/mob/verb/link_parent()
	var/obj/lad = locate(/obj/plane_master/parent) in client.screen
	lad.render_target = "*parent"

/obj/relay_parent
	render_source = "*parent"
	plane = CHILD_PLANE

/obj/plane_master/child
	plane = CHILD_PLANE

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
