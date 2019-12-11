//The Ladder Game, Raspberry Hardware Final
//Rafael Figueroa


.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ FRST_PIN, 26	// wiringPi 23
.equ SCND_PIN, 27	// wiringPi 24
.equ THRD_PIN, 28	// wiringPi 25
.equ BUTTN_PIN, 29

.text
.global main

main:
	push {lr}
	bl wiringPiSetup
	
	//Setup Individual Pins
	mov r0, #FRST_PIN
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #SCND_PIN
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #THRD_PIN
	mov r1, #OUTPUT
	bl pinMode
	mov r0, #BUTTN_PIN
	mov r1, #INPUT
	bl pinMode
	
	b initilize_counter1
	
initilize_counter1:
	mov r5, #0
	
light1:
	
	//Turn Light On
	mov r0, #FRST_PIN
	mov r1, #HIGH
	bl digitalWrite
	mov r6, #0
//Check for Button, Looping for continous checks , and delaying.
	
button_checkON1:
	mov r0, #BUTTN_PIN
	bl digitalRead
	cmp r0, #HIGH
	beq initilize_counter2
	
	//Delay to keep light on.
	ldr r0, =#1
	bl delay
	
	cmp r6, #800
	add r6, #1
	blt button_checkON1
	
//Turn light off
	mov r0, #FRST_PIN
	mov r1, #LOW
	bl digitalWrite
	
	//Set Loop Counter for delay
	mov r6, #0
	
button_checkOFF1:
	mov r0, #BUTTN_PIN
	bl digitalRead
	
	//Exit Game if Button is on
	cmp r0, #HIGH
	beq game_over
	
	//Delay to keep light on.
	ldr r0, =#1
	bl delay
	
	cmp r6, #800
	add r6, #1
	blt button_checkOFF1
	
	//Limit the Number light Blinks	
	cmp r5, #8
	bge game_over
	add r5, #1
	b light1

initilize_counter2:
	mov r5, #0
	mov r6, #0
	
//Give time for second light to turn on and dont let button hold
	ldr r0, =#1200
	bl delay
	mov r0, #BUTTN_PIN
	bl digitalRead
	cmp r0, #HIGH
	beq game_over
	
light2:

	mov r0, #SCND_PIN
	mov r1, #HIGH
	bl digitalWrite
	mov r6, #0
	
button_checkON2:
	mov r0, #BUTTN_PIN
	bl digitalRead
	cmp r0, #HIGH
	beq initilize_counter3
	
	//Delay to keep light on.
	ldr r0, =#1
	bl delay
	
	cmp r6, #400
	add r6, #1
	blt button_checkON2
	
//Turn Second Light off

	mov r0, #SCND_PIN
	mov r1, #LOW
	bl digitalWrite
	
//Set Loop Counter for delay
	mov r6, #0
	
button_checkOFF2:
	mov r0, #BUTTN_PIN
	bl digitalRead
	
	//Exit Game if Button is on
	cmp r0, #HIGH
	beq game_over
	
	//Delay to keep light on.
	ldr r0, =#1
	bl delay
	
	cmp r6, #400
	add r6, #1
	
	blt button_checkOFF2
	
	cmp r5, #8
	bge game_over
	add r5, #1
	b light2
	
initilize_counter3:
	mov r5, #0
	mov r6, #0
	
	ldr r0, =#1000
	bl delay
	mov r0, #BUTTN_PIN
	bl digitalRead
	cmp r0, #HIGH
	beq game_over
	
light3:

	mov r0, #THRD_PIN
	mov r1, #HIGH
	bl digitalWrite
	mov r6, #0
	
//Check Third Light Loop
button_checkON3:
	mov r0, #BUTTN_PIN
	bl digitalRead
	cmp r0, #HIGH
	beq light_show
	
//Delay to keep light on.
	ldr r0, =#1
	bl delay
	
//Loop Counter
	cmp r6, #200
	add r6, #1
	blt button_checkON3
	
//3rd Light OFF

	mov r0, #THRD_PIN
	mov r1, #LOW
	bl digitalWrite

//Button Check Loop
	mov r6, #0
	
button_checkOFF3:

	mov r0, #BUTTN_PIN
	bl digitalRead
	
	//Exit Game if Button is on
	cmp r0, #HIGH
	beq game_over
	
	//Delay to keep light on.
	ldr r0, =#1
	bl delay
	
	cmp r6, #200
	add r6, #1
	
	blt button_checkOFF3
	
//Limit Light Flashing
	cmp r5, #8
	bge game_over
	add r5, #1
	b light3


//Light Show for the Winners
light_show:
	mov r5, #0
light_loop:
	mov r0, #FRST_PIN
	mov r1, #LOW
	bl digitalWrite
		
	ldr r0, =#25
	bl delay
	
	mov r0, #SCND_PIN
	mov r1, #LOW
	bl digitalWrite
	
	ldr r0, =#25
	bl delay
	
	mov r0, #THRD_PIN
	mov r1, #LOW
	bl digitalWrite
	
	ldr r0, =#25
	bl delay
	
	mov r0, #FRST_PIN
	mov r1, #HIGH
	bl digitalWrite
	
	ldr r0, =#25
	bl delay
	
	mov r0, #SCND_PIN
	mov r1, #HIGH
	bl digitalWrite
	
	ldr r0, =#25
	bl delay
	
	mov r0, #THRD_PIN
	mov r1, #HIGH
	bl digitalWrite
	
	ldr r0, =#25
	bl delay
	
	add r5, #1
	cmp r5, #50
	bge game_over
	b light_loop

// Close Program Shut lIghts off
game_over:
	mov r0, #FRST_PIN
	mov r1, #LOW
	bl digitalWrite
	mov r0, #SCND_PIN
	mov r1, #LOW
	bl digitalWrite
	mov r0, #THRD_PIN
	mov r1, #LOW
	bl digitalWrite

	mov r0, #0
	pop {pc}
