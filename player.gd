extends CharacterBody2D

# currently the triple jump and
# wall jump don't work. I'm actively
# working on this, so just give it
# a bit of time, thanks

var startSpeed = 300								# initial speed
var runSpeed = 450								# max speed (not yet in place)
var jump = -400									# power on jump
var midJump = -600								# power on second jump
var bigJump = -1000								# power on third jump
var doMid = false						  		# do medium jump?
var doBig = false							  	# do big jump?
var gravity = 1000								# constand donwards force
var sprite = Sprite2D								# not needed, but it looks better to me
var wallJump = 200								# wall jump power
@onready var rayCastLeftNode = $RayCastLeft					# left raycast node
@onready var rayCastRightNode = $RayCastRight					# right raycast node

func _physics_process(delta):
# Movement system
	velocity.y += gravity * delta
	var direction = Input.get_axis("Left", "Right")
	velocity.x = direction * startSpeed
	move_and_slide()

func _process(delta):
# Jumping
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			if doMid == false and doBig == false:		# if you haven't jumped yet
				velocity.y = jump
				var doMid = true
			if doMid == true and doBig == false:		# if you've jumped once
				velocity.y = midJump
				var doMid = false
				var doBig = true
			if doMid == false and doBig == true:		# if you've jumped twice (resets)
				velocity.y = bigJump
				var doBig = false
		else:							# if player isn't on floor
			if rayCastLeftNode.is_colliding() or rayCastRightNode.is_colliding(): # check if wall jump possible
				velocity.y = jump * 0.8
			if rayCastLeftNode.is_colliding():
				velocity.x = wallJump
			if rayCastRightNode.is_colliding():
				velocity.x = -wallJump
