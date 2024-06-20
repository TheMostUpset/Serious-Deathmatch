// Created by Crowbar 0.74

$modelname "serioussam/powerups/invisibility.mdl"

$bodygroup "invisibility"
{
	studio "invisibility.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -0.118 1.231 18.395

$cdmaterials "models\powerups\"

$cbox 0 0 0 0 0 0

$bbox -17.002 -11.996 -0.579 14.541 11.76 37.36

$definebone "Implicit" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"invisibility_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "invisibility_physics.smd"
{
	$mass 1
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 5

}
