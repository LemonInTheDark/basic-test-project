/mob
    icon = 'icons/mobs.dmi'
    icon_state = "player"

/mob/verb/show_A()
	set name = "Show A"
	var/turf/A = locate("a_source") in world
	A.alpha = 255
	var/turf/onto = locate("a_spawn") in world
	onto.vis_contents += A

/mob/verb/hide_A()
	set name = "Hide A"
	var/turf/A = locate("a_source") in world
	A.alpha = 0
