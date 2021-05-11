.data
  nums: .word 10
  elems: .word 9, 2, 15, 5, 13, 6, 7, 8, 12, 1
  request: .asciiz "Input an integer number: "
  result: .asciiz "The position of the number: "
  n_exist: .asciiz "The number doesnt exit"
  
.text
  main: 
    la $t0, elems
    add $s0, $0, $t0  # address of array
    
    li $s1, 0 # low = 0 (first index)
    
    lw $t0, nums
    addi $s2, $t0, -1 # high = (last index)
    
    jal quickSort
    
    jal input
    jal binarySearch
    bltz $v1, NA
    jal output
    li $v0, 10
    syscall
    
   #--------------------------------------------------------------------------------------------#
    
    quickSort:
    addi $sp, $sp, -16 # make room for 4 variables
    
    sw $s0, 0($sp) # address of array
    sw $s1, 4($sp) # low 
    sw $s2, 8($sp) # high
    sw $ra, 12($sp) # return address
    
    addi $t2, $s2, 0
    
    bge $s1, $t2, end_condition  # low >= high, jump to endcondition
    
    jal partition
    addi $s7, $v1, 0  # move pivot to s7
    
    lw $s1, 4($sp)     # low
    addi $s2, $s7, -1  # pivot - 1
    jal quickSort
    
    addi $s1, $s7, 1  # pivot + 1
    lw $s2, 8($sp)    # high
    jal quickSort
  
  end_condition:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra
  
  partition:
    addi $sp, $sp, -16
    
    sw $s0, 0($sp) 
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $ra, 12($sp)
    
    add $t8, $s1, $0  # low
    add $t9, $s2, $0  # high
    
    sll $s7, $t9, 2
    add $s7, $s7, $s0
    lw $s7, 0($s7)    # arr[high] = pivot
    
    addi $t6, $t8, -1 # i = low - 1
    addi $t7, $t9, -1 # high - 1
    addi $t5, $t8, 0  # j = low
    
  loop_sort:
    bgt $t5, $t7, end_loop  # j > high - 1, jump to end_loop 
    
    sll $t4, $t5, 2
    add $t4, $t4, $s0
    lw $s6, 0($t4)     # arr[j]
    
    bge $s6, $s7, condition_partition  # arr[j] >= pivot
    jal increase_i
    jal swap
    
    addi $t5, $t5, 1 # ++j
    
    j loop_sort
    
  condition_partition:
    addi $t5, $t5, 1  # ++j
    j loop_sort
    
  increase_i:
    addi $t6, $t6, 1
    jr $ra
    
  swap: 
    sll $t3, $t6, 2
    add $t3, $t3, $s0
    lw $s5, 0($t3)    # arr[i]
    
    sw $s5, 0($t4)
    sw $s6, 0($t3)
    jr $ra
    
  end_loop:
    addi $t6, $t6, 1  # i = i + 1
    add $t5, $t9, $0  # high
    sll $t4, $t5, 2
    add $t4, $t4, $s0
    lw $s6, 0($t4)    # arr[high]
    add $v1, $0, $t6
    jal swap
    
    lw $ra, 12($sp)
    addi $sp, $sp, 16
    jr $ra  
    
  #--------------------------------------------------------------------------------------#  
    
  input: 
    la $a0, request
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    addi $s5, $v0, 0
    
    jr $ra
    
  binarySearch:
    addi $t3, $s1, 0  # low 
    addi $t4, $s2, 0  # high
    
  loop_search:
    bgt $t3, $t4, not_exist
    
    add $t0, $t3, $t4    # left index + right index
    div $s7, $t0, 2   # mid = (left + right) / 2
    
    sll $t0, $s7, 2
    add $t0, $t0, $s0
    lw $t1, 0($t0)  # arr[mid]
    beq $t1, $s5, finish  # arr[mid] = num, jump to finish
    bgt $t1, $s5, half_left  # arr[mid] > num
    blt $t1, $s5, half_right # arr[mid] < num
    
  half_left:
    addi $t4, $s7, -1  # high = mid - 1
    j loop_search
    
  half_right:
    addi $t3, $s7, 1  # low  = mid + 1
    j loop_search
    
  finish:
    addi $v1, $s7, 0
    jr $ra
    
  not_exist:
    addi $v1, $0, -1
    jr $ra
    
  NA:
    la $a0, n_exist
    li $v0, 4
    syscall
    li $v0, 10
    syscall
    
  output:
    la $a0, result
    li $v0, 4
    syscall
    
    li $v0, 1
    addi $a0, $v1, 0
    syscall
    jr $ra
    
    
    
    
