.text
start:
	addi	$2, $0, 1	# $2: bottom_floor=1
	addi	$3, $0, 11	# $3: top_floor=11
	addi	$4, $0, 8	# $4: enough_value=8
	sll	$0, $0, 0
	add	$8, $0, $0	# time=0
loop:	addi	$5, $2, 1	# bottom_floor+1
	sll	$0, $0, 0
	slt	$6, $5, $3	# bottom_floor+1>=top_floor
	beq	$6, $0, over
	addi	$8, $8, 1	# time+=1
	sll	$0, $0, 0
	add	$5, $2, $3
	sra	$6, $5, 1	# $6: mid=(bottom_floor+top_floor)/2
	slt	$7, $4, $6	# mid>enough_value
	beq	$7, $0, br1
	add	$3, $0, $6	#top_floor=mid
	j	loop
br1:	add	$2, $0, $6	#bottom_floor=mid
	j	loop

over:	add	$11, $0, $2	# $11: enough_value
	add	$12, $8, $0	# $12: times
end:	j	end