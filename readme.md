# Test Case: SIDE_MAP edition

Hi! Lemon here
Action-ninja's paid me in blood and human suffering to make a testcase for the `SIDE_MAP` issues we've been having

This repo contains testcases for two issues

## Issue One

Big icons behave very strangely with `SIDE_MAP` and pixel shifting

If you have a 64x64 size table, and put pixel y shifted objects on it, any movement near it will cause the shifted objects to flicker. This doesn't happen with pixel z, I assume because of how position is handled (I got this from the documentation on Isometric)
This flickering is deterministic, but it doesn't make a whole ton of sense

It's hard to tell if this is just the result of the issues mentioned in https://secure.byond.com/docs/ref/#/{notes}/big-icons or not, but regardless of that it certainly doesn't feel intentional
I've setup a testcase/display of this behavior in `map/testpixelshift.dmm`

There are 4 tables on the map
The bottom 2 are non big icons, top 2 are

The lefthand side is filled with pixel y shifted objects
Righthand side is filled with pixel z

You'll notice just the top left objects flicker. I have a feeling this has to do with position somehow

It's not totally consistent because I'm randomly shifting the little icons, but if you run it a few times it'll show

## Issue Two

*Inhales
When using `SIDE_MAP`, if a big icon is rendered on the same tile as a gaussian blur'd object, it will flicker pixel y shifted objects underneath it. Additionally, the big icon (`64x64`) will cause a `16x32` area to its right to go blank, obscuring whatever objects are behind it. This does not happen if there's no gaussian blur, or if the guassian blur'd objects use pixel z
*Gasps for breath

This behavior is most of what we've seen in testing, and it's really fucky
The same statements from before about big icons apply, but if this is intentional behavior I will break down in tears

You can test this on the other map if you'd like, but I've set `map/testshiftanimate.dmm` aside as a cleanroom

Objects on the left half are pixel y shifted, objects on the right half are pixel z shifted

There are two verbs intended for testing here
* test drop basic - This does a drop with pixel y shifted trails
* test drop better - This does a drop with pixel z shifted trails

## Issue Two Point Five

I've had reports of issues with vis_contents and similar position based flickering, haven't looked closely into it yet
