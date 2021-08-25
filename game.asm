#####################################################################
# Features
# 1. Enemies move faster as the game progresses; this increases difficulty
# 2. The player can deploy bombs that will detonate on colliding with an alien.
#    Moreover, once a bomb is deployed, the player can deploy another one only after at least 
#    one new set of aliens enter and exit the screen. 
# 3. Grazing; on a head-on collision with an alien, the spaceship loses two health points.
#    However, when the spaceship just grazes past an alien, it loses only one health point
# 4. A 'special' blue alien appears randomly, once in a while. If the spaceship succeeds in
#    killing this alien with a bomb, it gains an extra health point.
#
# Link to video demonstration:
# ==> https://youtu.be/ZkwjMP5DgkA <==
# * There is also a subtitles option associated with the video for convineince, which can 
# be activated by clicking the CC button.

######################################################################
# Game description and controls:
# This game involves a spaceship flying through space avoiding enemy aliens on its way. The 
# aliens appear randomly on the screen's right. Their speeds increase as the game progresses.
# Use 'a' to move the spaceship to the left, 'd' to move it to the right, 'w' to move it up,
# and 's' to move it down; use 'p' to restart the game. The spaceship has 14 health points.
# On a head-on collision with an alien, it loses 2 health points; however, if the spaceship
# merely grazes past an alien, it loses only one health point. The spaceship also has an
# option to deploy a bomb which kills an alien on collision.
# Press the space bar to deploy the bomb; keep in mind that once a bomb is deployed, another 
# one can be deployed only after at least one new set of aliens enter and exit the screen. 
# So, deploy bombs wisely! Once in a while a 'special' blue alien enters the screen. On killing
# this alien with a bomb, the spaceship gains an extra healthpoint. After the spaceship dies,
# a GAME OVER screen is displayed, and the game restarts after three seconds.
# Happy playing!!

# Tips on how to play:
# We recommend that you gain as many health points you can get (by killing blue aliens with
# a bomb) when the aliens move slowly. Once the aliens reach their maximum speed, do not use 
# bombs just with the aim to kill blue aliens. Use them freely to kill aliens of all sorts; after
# all, when the aliens race towards you, it is best that use a bomb to kill them!
######################################################################

# Game 

.data
# Global variables 
displayAddress: .word 0x10008000
enemyPos: .space 12
enemyRandCounter: .word 0
bombCoordinates: .word 0
speedControl: .word 0
healthTrack: .word 224
canDeployBomb: .word 0


# Colors used in our program
.eqv black 0x000000
.eqv orange 0xff7f23
.eqv purple 0x6d6091
.eqv grey 0xc0c0c0
.eqv pink 0xff1e7e
.eqv yellow 0xffff00
.eqv byellow 0xd9d559
.eqv white 0xffffff
.eqv bbrown 0xc3ae7f
.eqv dgrey 0xa2afb6
.eqv spawnOffset 512

.text
# Starting phase of our game
main: 
	li $s7, 0
	li $t9, 0xffff0000 
	sw $0, 0($t9)
	
# update the variables to their starting value when the game restarts
	la $t8, speedControl 
	li $t6, 0
	sw $t6, 0($t8) 
	
	la $t8, healthTrack
	li $t6, 224
	sw $t6, 0($t8)
	
	la $t8, canDeployBomb
	li $t6, 0
	sw $t6, 0($t8) 

# Drawing health bar of player
drawHealthBar: # begin drawing the health bar
	lw $t0, displayAddress
	addi $t1, $t0, 28672
	li $t2, grey
	addi $t3, $t0, 32768

loopToDrawBar: # use a loop to draw the health bar
	beq $t1, $t3, drawHealth
	sw $t2, 0($t1)
	addi $t1, $t1, 4
	j loopToDrawBar
	
drawHealth: # draw the health points
	li $t2, 0x0000ff
	addi $t1, $t0, 29696
	addi $t1, $t1, 20
	addi $t3, $t1, 224
	sw $t2, 0($t1)

loopToDrawSquares: # use a loop to draw health points in a square shape
	beq $t1, $t3, drawShip
	sw $t2, 0($t1)
	sw $t2, 4($t1)
	sw $t2, 512($t1)
	sw $t2, 516($t1)
	addi $t1, $t1, 16
	j loopToDrawSquares
	
# Drawing the spaceship on the screen
drawShip:
	lw $t0, displayAddress
	li $t9, 12312 # takes first value of playerPos
	add $t0, $t0, $t9
	addi $v1, $t0, 4 
	li $t9, 0
	# $a1 will be use as a function arguement to updateShip later 

# Updating the coordinates of the sspacehip
updateShip:
	li $t1, purple
	li $t2, grey
	li $t4, pink
	li $t6, black
	li $t7, white
	addi $t0, $v1, -4
	
	# Drawing first row
	sw $t1, 8($t0)
	li $t1, yellow
	# Drawing second row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, 4($t0)
	sw $t2, 8($t0)
	
	# Drawing third row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t7, 4($t0)
	sw $t2, 8($t0)
	
	# Drawing fourth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	
	# Drawing fifth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t2, 4($t0)
	sw $t7, 8($t0)
	sw $t7, 12($t0)
	sw $t2, 16($t0)
	
	# Drawing sixth row
	addi $t0, $t0, spawnOffset # going one row down
	li $t4, orange
	sw $t4, -4($t0)
	sw $t1, -8($t0)
	sw $t1, -12($t0)
	sw $t2, 4($t0)
	sw $t7, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 20($t0)
	sw $t7, 24($t0)
	sw $t1, 28($t0)
	
	# Drawing seventh row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t2, 4($t0)
	sw $t7, 8($t0)
	sw $t7, 12($t0)
	sw $t2, 16($t0)
	
	# Drawing eigth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	
	# Drawing ninth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t7, 4($t0)
	sw $t2, 8($t0)
	
	# Drawing tenth row
	addi $t0, $t0, spawnOffset # going one row down
	li $t4, pink
	sw $t4, 4($t0)
	sw $t2, 8($t0)
	
	# Drawing eleventh row
	addi $t0, $t0, spawnOffset # going one row down
	li $t1, purple
	sw $t1, 8($t0)

	beq $t9, 0, drawEnemies
	jr $ra

# Draws 3 aliens on the screen
drawEnemies:
	li $v0, 42
	li $a0, 0
	li $a1, 4 # ensure that whether a blue alien appears or not is random
	syscall
	move $s2, $a0  
	beq $s2, 0, drawAlienBlue # draw one alien blue if $s2 == 0
	
continue:
	la $s6, speedControl 
	lw $t6, 0($s6)
	addi $t6, $t6, 1
	sw $t6, 0($s6) # updating the counter which controls the aliens' speed
	# Deallocating the memory for s1
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	li $t8, 0
	li $t5, 0 # resetting enemyRandCounter
	sw $t5, enemyRandCounter($zero)

# Generates 3 coordinates for all the 3 aliens
randomizeEnemyCoords:
	lw $t5, enemyRandCounter	
	# Randomizing coordinates of the first enemy
	li $v0, 42
	li $a0, 0
	li $a1, 8 # maximum number
	syscall
	move $t1, $a0 # Storing the randomized number in t1
	
	# Randomizing coordinates of the second enemy	
	li $v0, 42
	li $a0, 0 
	li $a1, 8 # maximum number
	syscall
	
	# Setting Distance between first and second enemies
	add $t2, $t1, $a0 
	addi $t2, $t2, 10
	
	# Randomizing coordinates of the third enemy
	li $v0, 42
	li $a0, 0 
	li $a1, 8 # maximum number
	syscall
	
	# Setting Distance between second and third enemies
	add $t3, $t2, $a0
	addi $t3, $t3, 15
	
	# Computing coordinates of the first enemy
	li $v0, 42
	li $a0, 0
	li $a1, 32 # maximum number
	syscall
	move $t9, $a0 # Storing the randomized number in t1
	addi $t9, $t9, 86
	#li $t9, 118
	
	# Randomizing starting position of the first enemy
	mul $t1, $t1, spawnOffset
	mul $t9, $t9, 4
	add $t1, $t1, $t9 
	sw $t1, enemyPos($t5)
	addi $t5, $t5, 4
	sw $t5, enemyRandCounter($zero)
	
	# Computing coordinates of the second enemy
	addi $t9, $0, 118
	mul $t2, $t2, spawnOffset
	mul $t9, $t9, 4
	add $t2, $t2, $t9
	sw $t2, enemyPos($t5)
	addi $t5, $t5, 4
	sw $t5, enemyRandCounter($zero)
	
	# Randomizing starting position of the first enemy
	li $v0, 42
	li $a0, 0
	li $a1, 32 # maximum number
	syscall
	move $t9, $a0 # Storing the randomized number in t1
	addi $t9, $t9, 86
	#li $t9, 118
	#addi $t9, $0, 118
	
	# Computing coordinates of the third enemy
	mul $t3, $t3, spawnOffset
	mul $t9, $t9, 4
	add $t3, $t3, $t9
	sw $t3, enemyPos($t5)
	
# Begin drawing the aliens and spaceship
drawAll:	
	li $t6, 0
	li $t7, 0
	
	# Allocating the memory for s1
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	li $s1, 504
	
	li $t8, -12
	li $t5, -1 # when $t5 is -1, the first alien hasn't collided yet
	li $a1, -1 # when $a1 is -1, the second alien hasn't collided yet
	li $a2, -1 # when $a2 is -1, the third alien hasn't collided yet

updateEnemies: # use a loop to have the aliens move
	li $t6, 0
	beq $t8, $s1, drawEnemies # When $t8 == $s1, the aliens have reached right; redraw them
	addi $t8, $t8, 4

# Drawing the aliens
beginRedrawingEnemies:
	li $s5, 0
	beq $s7, 1, checkIfBombToDelete # check if the bomb is to be deleted (to re-draw it on its new position) 
continueDrawing:
	beq $t7, 3, getKeyboardInput
	beq $t7, 0, checkFirstAlien 
	beq $t7, 1, checkSecondAlien
	beq $t7, 2, checkThirdAlien

# Drawing the aliens and detecting collisions
draw:	
	li $t4, pink
	beq $s2, 0, checkIfBlue # check whether the alien to be drawn should be painted blue
	
paintAlien:
	lw $t0, displayAddress
	lw $t1, enemyPos($t6)
	add $t0, $t0, $t1
	sub $t0, $t0, $t8

	# check for collision before drawing the alien
	lw $t1, 0($t0)
	jal checkCollision
	addi $t9, $t0, spawnOffset
	lw $t1, -4($t9)
	jal checkCollision
	addi $t9, $t9, spawnOffset
	lw $t1, -8($t9)
	jal checkCollision
	addi $t9, $t9, spawnOffset
	lw $t1, -12($t9)
	jal checkCollision
	addi $t9, $t9, spawnOffset
	lw $t1, -8($t9)
	jal checkCollision
	addi $t9, $t9, spawnOffset
	lw $t1, -12($t9)
	jal checkCollision
	addi $t9, $t9, spawnOffset
	lw $t1, -16($t9)
	jal checkCollision
	lw $t1, 500($t9)
	jal checkCollision
	lw $t1, 508($t9)
	jal checkCollision
	lw $t1, 524($t9)
	jal checkCollision
	addi $t9, $t9, 20
	lw $t1, 512($t9)
	jal checkCollision
		
	sw $t4, 4($t0)
	
	# Drawing second row
	addi $t0, $t0, spawnOffset
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)

	# Drawing third row
	addi $t0, $t0, spawnOffset
	sw $t4, -4($t0)
	sw $t6, 0($t0)
	sw $t4, 4($t0)
	sw $t6, 8($t0)
	sw $t4, 12($t0)

	# Drawing fourth row
	addi $t0, $t0, spawnOffset
	sw $t4, -8($t0)
	sw $t4, -4($t0)
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

	# Drawing fifth row
	addi $t0, $t0, spawnOffset
	sw $t4, -4($t0)
	sw $t6, 0($t0)
	sw $t4, 12($t0)
	
	# Drawing sixth row
	addi $t0, $t0, spawnOffset
	sw $t4, -8($t0)
	sw $t4, 0($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 16($t0)
	
	# Drawing seventh row
	addi $t0, $t0, spawnOffset
	sw $t4, -12($t0)
	sw $t4, -4($t0)
	sw $t4, 12($t0)
	sw $t4, 20($t0)

# Incrementing counters
updateCounters:
	# Counter is incremented by 1
	addi $t7, $t7, 1
	# move t0 to the next coordinate
	addi $t6, $t6, 4 # counter for colors
	j beginRedrawingEnemies
	
# Handling collision between the alien(s) and the player
collisionDetected:
	beq $t1, purple, decreaseOneHealth
	jal decreaseTwoHealths
	li $t9, 0 
	li, $t4, 0xff0000 # have the spaceship flash red when it grazes past an alien
	j startPaintingSpaceship
	
warn:	# prevent the alien which has just collided from being drawn again
	beq $t7, 0, firstAlienCollided
	beq $t7, 1, secondAlienCollided
	beq $t7, 2, thirdAlienCollided
	
firstAlienCollided:
	li $t5, 1 # $t5 being 1 signifies the first alien has collided and won't be drawn again
	j updateCounters
	
secondAlienCollided:
	li $a1, 1 # $a1 being 1 signifies the second alien has collided and won't be drawn again
	j updateCounters
	
thirdAlienCollided: 
	li $a2, 1 # $a2 being 1 signifies the third alien has collided and won't be drawn again
	j updateCounters
	
# Checking collisions with aliens
checkFirstAlien:
	beq $t5, 1, updateCounters # if $t5 is 1, the first alien has collided before; don't draw this alien again
	j draw

checkSecondAlien:
	beq $a1, 1, updateCounters # if $t5 is 1, the second alien has collided before; don't draw this alien again
	j draw
	
checkThirdAlien:
	beq $a2, 1, updateCounters # if $t5 is 1, the third alien has collided before; don't draw this alien again
	j draw
	
checkCollision: # check if the alien has collided with the spaceship or bomb
	beq $t1, purple, collisionDetected      # the alien has collided with the spaceship
	beq $t1, grey, collisionDetected        # the alien has collided with the spaceship
	beq $t1, yellow, collisionDetected      # the alien has collided with the spaceship
	beq $t1, orange, bombCollisionDetected  # the alien has collided with the bomb
	beq $t1, dgrey, bombCollisionDetected   # the alien has collided with the bomb
	beq $t1, bbrown, bombCollisionDetected  # the alien has collided with the bomb
	jr $ra

drawAlienBlue: # choose which of the three aliens is to be painted blue
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall
	move $a3, $a0
	j continue

checkIfBlue: # check if the given alien is to be painted blue
	bgt $a3, $t7, paintAlien
	blt $a3, $t7, paintAlien
	li $t4, 0x00ffff
	j paintAlien
	
checkIfBombToDelete: # delete the bomb when $t7 == 3, i.e. when the loop drawing the three aliens has finished executing
	beq $t7, 3, startDeletingBomb
	j continueDrawing

dropBombOffScreen: # delete the bomb when it has reached the end of the screen
	li $s7, 0
	j getKeyboardInput

# Deleting the enemies from the screen
deleteEnemies:
	la $s6, speedControl # control the aliens' speed before deleting
	lw $t3, 0($s6)
	div $t3, $t3, 5
	addi $t3, $t3, 1
	li $s6, 6
	sub $t3, $s6, $t3
	mul $t3, $t3, 10
	blt $t3, 10, maxSpeedReached
wait:
	li $v0, 32
	addi $a0, $t3, 0 # wait $a0 milliseconds before deleting the enemies
	syscall

	li $t6, black
	li $t9, 0
		
beginDeletingEnemies: # delete aliens to re-draw them on their new co-ordinates
	beq $t7, 0, drawShipAgain
	
	lw $t0, displayAddress
	lw $t1, enemyPos($t9)
	add $t0, $t0, $t1
	sub $t0, $t0, $t8
	
	# Deleting first row
	sw $t6, 4($t0)
	
	# Deleting second row
	addi $t0, $t0, spawnOffset
	sw $t6, 0($t0)
	sw $t6, 4($t0)
	sw $t6, 8($t0)

	# Deleting third row
	addi $t0, $t0, spawnOffset
	sw $t6, -4($t0)
	sw $t6, 0($t0)
	sw $t6, 4($t0)
	sw $t6, 8($t0)
	sw $t6, 12($t0)

	# Deleting fourth row
	addi $t0, $t0, spawnOffset
	sw $t6, -8($t0)
	sw $t6, -4($t0)
	sw $t6, 0($t0)
	sw $t6, 4($t0)
	sw $t6, 8($t0)
	sw $t6, 12($t0)
	sw $t6, 16($t0)

	# Deleting fifth row
	addi $t0, $t0, spawnOffset
	sw $t6, -4($t0)
	sw $t6, 0($t0)
	sw $t6, 12($t0)
	
	# Deleting sixth row
	addi $t0, $t0, spawnOffset
	sw $t6, -8($t0)
	sw $t6, 0($t0)
	sw $t6, 4($t0)
	sw $t6, 8($t0)
	sw $t6, 16($t0)
	
	# Deleting seventh row
	addi $t0, $t0, spawnOffset
	sw $t6, -12($t0)
	sw $t6, -4($t0)
	sw $t6, 12($t0)
	sw $t6, 20($t0)
	
	# Counter is deccremented by 1
	addi $t7, $t7, -1
	# move $t9 to the next coordinate
	addi $t9, $t9, 4
	j beginDeletingEnemies

# Redrawing the spaceship
drawShipAgain:
	li $t9, 1
	jal updateShip
	li $t7, 0
	j updateEnemies

# Listening for key presses
getKeyboardInput:
	li $t9, 0xffff0000 
	lw $t1, 0($t9)
	beq $s7, 2, updateBomb
	beq $t1, 1, keypressHappened
	j deleteEnemies
	
# Handling a key press
keypressHappened: # the player has pressed a button
	lw $t2, 4($t9)
# delete the spaceship (before re-drawing it on its new location) on receiving valid keyboard input
	beq $t2, 0x61, deleteSpaceship # ASCII code of 'a' is 0x61
	beq $t2, 0x73, deleteSpaceship # ASCII code of 's' is 0x73
	beq $t2, 0x64, deleteSpaceship # ASCII code of 'd' is 0x73
	beq $t2, 0x77, deleteSpaceship # ASCII code of 'w' is 0x77
	beq $t2, 0x70, deleteSpaceship # ASCII code of 'p' is 0x70
	beq $t2, 0x20, deleteSpaceship # ASCII code of space is 0x70
	#beq $s6, 1, deleteBullet 
	j deleteEnemies
	
deleteSpaceship: # used to delete the spaceship before drawing it again on its new position
	li $t9, 1
	li $t4, black
	
startPaintingSpaceship: # flash red or orange depending upon whether the spaceship had a head-on collision or 
# has grazed past an alien respectively
	addi $t0, $v1, -4
	sw $t4, 8($t0)
	
# Drawing second row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	
# Drawing third row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	
# Drawing fourth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, -4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	
# Drawing fifth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, -8($t0)
	sw $t4, -4($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	
# Drawing sixth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, -4($t0)
	sw $t4, -8($t0)
	sw $t4, -12($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)
	sw $t4, 20($t0)
	sw $t4, 24($t0)
	sw $t4, 28($t0)
	
# Drawing seventh row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, -8($t0)
	sw $t4, -4($t0)
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	sw $t4, 16($t0)

# Drawing eigth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, -4($t0)
	sw $t4, 8($t0)
	sw $t4, 12($t0)
	
# Drawing ninth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	
# Drawing tenth row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, 4($t0)
	sw $t4, 8($t0)
	
# Drawing eleventh row
	addi $t0, $t0, spawnOffset # going one row down
	sw $t4, 8($t0)
	
beq $t9, 0, warn # signifies that the spaceship has a head-on collision with an alien; the spacehip has just flahed red
beq $t9, 2, warn # signifies that the spaceship has grazed past an alien; the spacehip has just flahed orange

beq $t2, 0x61, respond_to_a
beq $t2, 0x73, respond_to_s
beq $t2, 0x64, respond_to_d
beq $t2, 0x77, respond_to_w
beq $t2, 0x70, respond_to_p
beq $t2, 0x20 respond_to_space

respond_to_a: # move spaceship to the left when the user presses w
	li $t4, 512
	addi $t2, $v1, -20
	addi $t2, $t2, -0x10008000
	div $t2, $t4
	mfhi $t2
	addi $v1, $v1, -8
	beq $t2, $0, reachedLeft
	j redrawShip

respond_to_s: # move spaceship down when the user presses w
	addi $t2, $v1, 0
	addi $t2, $t2, -27136
	addi $t2, $t2, -0x10008000
	addi $v1, $v1, 1024
	bgt $t2, -5000, reachedBottom
	j redrawShip

respond_to_d: # move spaceship to the right when the user presses w
	li $t4, 512
	addi $t2, $v1, 28
	addi $t2, $t2, -0x10008000
	div $t2, $t4
	mfhi $t2
	addi $v1, $v1, 8
	beq $t2, $0, reachedRight
	j redrawShip

respond_to_w: # move spaceship up when the user presses w
	addi $t2, $v1, 0
	addi $t2, $t2, -spawnOffset
	sub $t2, $t2, 0x10008000
	addi $v1, $v1, -1024
	bgt $0, $t2, reachedTop
	j redrawShip

respond_to_space: # deploy a bomb when space is pressed
	la $t2, canDeployBomb 
	lw $t1, 0($t2)
	beq $t1, 0, drawBomb
	la $t2, speedControl
	lw $t2, 0($t2)
	addi $t1, $t1, 1
	bgt $t2, $t1, drawBomb # a bomb can be deployed just once after every (at least) 1 time a new set
	j redrawShip			# of aliens enter and exit the screen
				
drawBomb: # draw bomb for when it is deployed
	la $t1, speedControl
	lw $t1, 0($t1)
	sw $t1, canDeployBomb($0)
	
	add $s3, $0, $t0
	li $s4, spawnOffset
	mul $s4, $s4, 5
	sub $s3, $s3, $s4
	addi $s3, $s3, 44
	
	# saving coordinates of bomb
	sw $s3, bombCoordinates($0)
	j updateBomb

bombCollisionDetected: # an alien collides with a bomb
	# get rid of intersecting alien and delete bomb
	li $s5, 1 # signifies that the bomb is to be to be deleted for once and for all before calling startDeletingBomb
	jal startDeletingBomb
	li $s7, 0
	beq $t4, 0x00ffff, increaseOneHealth # if the alien that has collided is blue, increase health by one health point
	beq $t7, 0, firstAlienCollided   # the first alien is pink and has collided with the bomb
	beq $t7, 1, secondAlienCollided  # the first alien is pink nd has collided with the bomb
	beq $t7, 2, thirdAlienCollided   # the first alien is pink and has collided with the bomb
	
# count down til explosion + explosion animation
updateBomb: # update bomb to its new position after deleting it from its previous position on the screen

	# loading coordinates of bomb
	lw $s3, bombCoordinates($0)
	
	addi $t6, $s3, 24
	lw $t1, displayAddress
	sub $t6, $t6, $t1 
	li $t1, 512
	div $t6, $t1
	mfhi $t1
	beq $t1, 0, dropBombOffScreen
	
	# first row
	li $t1, byellow	
	li $t6, orange
	
	sw $t6, ($s3)
	add $s3, $s3, spawnOffset
	# second row
	sw $t6, -4($s3)
	sw $t1, ($s3)
	sw $t6, 4($s3)
	add $s3, $s3, spawnOffset
	# third row
	sw $t6, ($s3)
	li $t6, bbrown # loading bright brown
	sw $t6, 4($s3)
	add $s3, $s3, spawnOffset
	# fourth row
	sw $t6, 4($s3)
	sw $t6, 8($s3)
	add $s3, $s3, spawnOffset
	li $t1, dgrey
	# fifth row
	sw $t6, 8($s3)
	sw $t1, 12($s3)
	sw $t1, 16($s3)
	sw $t1, 20($s3)
	add $s3, $s3, spawnOffset
	# sixth row
	sw $t6, 8($s3)
	sw $t1, 12($s3)
	sw $t1, 16($s3)
	sw $t1, 20($s3)
	add $s3, $s3, spawnOffset
	# seventh row
	sw $t6, 8($s3)
	sw $t1, 12($s3)
	sw $t1, 16($s3)
	sw $t1, 20($s3)
	
	li $s7, 1 # marking the player is currently shooting
	j getKeyboardInput
	
startDeletingBomb: # deleting the bomb either before re-drawing it again on its new location, or on detecting its collision with an alien
	# loading coordinates of deployed bomb
	lw $s3, bombCoordinates($0)
	li $t6, black

	addi $s3, $s3, 4
	sw $s3, bombCoordinates($0)
	addi $s3, $s3, -4
	
	# first row
	sw $t6, ($s3)
	add $s3, $s3, spawnOffset
	# second row
	sw $t6, -4($s3)
	sw $t6, 0($s3)
	sw $t6, 4($s3)
	add $s3, $s3, spawnOffset
	# third row
	sw $t6, 0($s3)
	sw $t6, 4($s3)
	add $s3, $s3, spawnOffset
	# fourth row
	sw $t6, 4($s3)
	sw $t6, 8($s3)
	add $s3, $s3, spawnOffset
	# fifth row
	sw $t6, 8($s3)
	sw $t6, 12($s3)
	sw $t6, 16($s3)
	sw $t6, 20($s3)
	add $s3, $s3, spawnOffset
	# sixth row
	sw $t6, 8($s3)
	sw $t6, 12($s3)
	sw $t6, 16($s3)
	sw $t6, 20($s3)
	add $s3, $s3, spawnOffset
	# seventh row
	sw $t6, 8($s3)
	sw $t6, 12($s3)
	sw $t6, 16($s3)
	sw $t6, 20($s3)

	li $s7, 2 # ensuring the bomb gets updated to its new co-ordinates when the time comes
	beq $s5, 0, getKeyboardInput # get keyboard input if the bomb hasn't yet met its target
	li $s7, 0 # signifying that the bomb has been deleted once and for all after colliding with an alien
	jr $ra

respond_to_p: # restart the game when the player presses lowecarse p
	jal eraseAll
	j main

eraseAll: # erase the screen when the spaceship dies so as to display the GAME OVER screen
	lw $t0, displayAddress
	li $t1, 0 # counter
	li $t2, spawnOffset
	mul $t2, $t2, 16 # 4*4 = (unit width * unit height)
	li $t4, black
	j eraseAllLoop
	
eraseAllLoop: # loop to erase screen
	beq $t1, $t2, finishErasing
	addi $t1, $t1, 1
	sw $t4, ($t0)
	addi $t0, $t0, 4
	j eraseAllLoop
	
finishErasing:
	jr $ra
	
displayGameOver: # display a GAME OVER screen when the spaceship dies
	jal eraseAll
	lw $t0, displayAddress
	li $t1, orange
	li $t2, spawnOffset
	mul $t2, $t2 16
	addi $t2, $t2 1100
	add $t0, $t0, $t2

	# Drawing G
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	
	
	# Adjusting height of A
	li $t9, spawnOffset
	mul $t9, $t9, 3
	sub $t0, $t0, $t9 
	
	# Drawing A
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 84($t0)
	sw $t1, 88($t0)
	sw $t1, 92($t0)
	sw $t1, 96($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 84($t0)
	sw $t1, 88($t0)
	sw $t1, 92($t0)
	sw $t1, 96($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 80($t0)
	sw $t1, 76($t0)
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 80($t0)
	sw $t1, 76($t0)
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 84($t0)
	sw $t1, 88($t0)
	sw $t1, 92($t0)
	sw $t1, 96($t0)	
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 80($t0)
	sw $t1, 76($t0)
	sw $t1, 84($t0)
	sw $t1, 88($t0)
	sw $t1, 92($t0)
	sw $t1, 96($t0)	
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 80($t0)
	sw $t1, 76($t0)
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 80($t0)
	sw $t1, 76($t0)
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 80($t0)
	sw $t1, 76($t0)
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 80($t0)
	sw $t1, 76($t0)
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	
	# Adjusting height of m
	li $t9, spawnOffset
	mul $t9, $t9, 9
	sub $t0, $t0, $t9 
	
	#Darwing M
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 152($t0)
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	sw $t1, 164($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 152($t0)
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	sw $t1, 164($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	
	# Adjusting height of E
	li $t9, spawnOffset
	mul $t9, $t9, 9
	sub $t0, $t0, $t9 

	# Drawing E
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)	
	sw $t1, 296($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)	
	sw $t1, 296($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)	
	sw $t1, 296($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)	
	sw $t1, 296($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)	
	sw $t1, 296($t0)
	
	# Adjusting distance between first and second rows
	li $t9, spawnOffset
	mul $t9, $t9, 9
	add $t0, $t0, $t9 
	
	# Drawing O
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)	
	sw $t1, 20($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)	
	sw $t1, 20($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, -8($t0)
	sw $t1, -4($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)	
	sw $t1, 20($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)	
	sw $t1, 20($t0)	
	
	# Adjusting height of V
	li $t9, spawnOffset
	mul $t9, $t9, 10
	sub $t0, $t0, $t9 
	
	# Drawing A
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 112($t0)
	sw $t1, 116($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 112($t0)
	sw $t1, 116($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 112($t0)
	sw $t1, 116($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 112($t0)
	sw $t1, 116($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 104($t0)
	sw $t1, 108($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 104($t0)
	sw $t1, 108($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 104($t0)
	sw $t1, 108($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 104($t0)
	sw $t1, 108($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 104($t0)
	sw $t1, 108($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 104($t0)
	sw $t1, 108($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 84($t0)
	sw $t1, 88($t0)
	sw $t1, 92($t0)
	sw $t1, 96($t0)
	sw $t1, 100($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 88($t0)
	sw $t1, 92($t0)
	sw $t1, 96($t0)
	
	# Adjusting height of E
	li $t9, spawnOffset
	mul $t9, $t9, 9
	sub $t0, $t0, $t9 

	# Drawing E
	subi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	sw $t1, 164($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)	
	sw $t1, 204($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	sw $t1, 164($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)	
	sw $t1, 204($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)

	sw $t1, 164($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)	
	sw $t1, 204($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	sw $t1, 164($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)	
	sw $t1, 204($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	sw $t1, 164($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)	
	sw $t1, 204($t0)
	
	# Adjusting height of E
	li $t9, spawnOffset
	mul $t9, $t9, 9
	sub $t0, $t0, $t9 

	# Drawing R
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 292($t0)
	sw $t1, 296($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 292($t0)
	sw $t1, 296($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 292($t0)
	sw $t1, 296($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 292($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)	
	sw $t1, 268($t0)	
	sw $t1, 272($t0)	
	sw $t1, 276($t0)	
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)	
	
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)	
	sw $t1, 268($t0)	
	sw $t1, 272($t0)	
	sw $t1, 276($t0)	
	sw $t1, 280($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	
	sw $t1, 284($t0)	
	sw $t1, 288($t0)
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	
	sw $t1, 292($t0)	
	sw $t1, 296($t0)	
	addi $t0, $t0, spawnOffset # going one row down
	sw $t1, 248($t0)
	sw $t1, 252($t0)

	sw $t1, 300($t0)	
	sw $t1, 304($t0)
	
	# restarts the game
	# add delay
	li $v0, 32
	li $a0, 3000  # wait 3 seconds before restarting game
	syscall
	jal eraseAll 
	j main

# Ensuring the spaceship does not move off screen
reachedTop: # prevent the spaceship from exiting the screen from up
	addi $v1, $v1, 1024
	j redrawShip

reachedBottom: # prevent the spaceship from exiting the screen from down
	sub $v1, $v1, 1024
	j redrawShip

reachedRight: # prevent the spaceship from exiting the screen from the right
	addi $v1, $v1, -8
	j redrawShip

reachedLeft: # prevent the spaceship from exiting the screen from the left
	addi $v1, $v1, 8
	j redrawShip

redrawShip: # draw the spaceship again
	jal updateShip
	li $t7, 3
	j deleteEnemies

decreaseTwoHealths: # reduce two health points on a head-on collsion of the spaceship with an alien
	lw $t0, displayAddress
	addi $t1, $t0, 29696
	la $t0, healthTrack
	
	lw $t0, 0($t0)
	addi $t1, $t1, 20
	add $t3, $t1, $t0
	beq $t0, 16, displayGameOver # end the game if there is only one health point is remaining
	beq $t0, 32, displayGameOver # end the game if there are only two health points remaining
	
	addi $t3, $t3, -32
	
	li $t2, grey
	sw $t2, 0($t3)
	sw $t2, 4($t3)
	sw $t2, 512($t3)
	sw $t2, 516($t3)
	
	addi $t3, $t3, 16 
	
	sw $t2, 0($t3)
	sw $t2, 4($t3)
	sw $t2, 512($t3)
	sw $t2, 516($t3)
	
	la $t2, healthTrack
	lw $t0, 0($t2)
	addi $t0, $t0, -32
	sw $t0, 0($t2)
	
	jr $ra
		
maxSpeedReached: # the aliens' move at their maximum speed
	li $t3, 10	 # prevent aliens from going faster than their maximum speed
	j wait

decreaseOneHealth: # reduce one health point if the spaceship grazes past an alien
	li $t2, grey
	lw $t0, displayAddress
	addi $t1, $t0, 29696
	la $t0, healthTrack
	
	lw $t0, 0($t0)
	beq $t0, 16, displayGameOver # end the game if there is only one health point is remaining
	addi $t1, $t1, 20
	add $t3, $t1, $t0
	
	addi $t3, $t3, -16
	
	sw $t2, 0($t3)
	sw $t2, 4($t3)
	sw $t2, 512($t3)
	sw $t2, 516($t3)
	
	addi $t0, $t0, -16
	
	la $t3, healthTrack
	sw $t0, 0($t3) 
	li $t4, 0xff6600 # have the spaceship flash orange when it grazes past an alien
	li $t9, 2
	j startPaintingSpaceship
	
increaseOneHealth: # increase one health if a blue alien collides with the bomb
	li $t2, 0x0000ff
	lw $t0, displayAddress
	addi $t1, $t0, 29696
	la $t0, healthTrack
	
	lw $t0, 0($t0)
	addi $t1, $t1, 20
	add $t3, $t1, $t0
	
	sw $t2, 0($t3)
	sw $t2, 4($t3)
	sw $t2, 512($t3)
	sw $t2, 516($t3)
	
	addi $t0, $t0, 16
	
	la $t3, healthTrack
	sw $t0, 0($t3)
	
	beq $t7, 0, firstAlienCollided   # the first alien is blue and has collided with the bomb
	beq $t7, 1, secondAlienCollided  # the second alien is blue and has collided with the bomb
	beq $t7, 2, thirdAlienCollided   # the third alien is blue and has collided with the bomb
	
