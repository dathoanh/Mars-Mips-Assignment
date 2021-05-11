.data
  nums: .word 5
  elems: .word 10, 80, 30, 90, 40
  result: .asciiz "Array after sorting:"
  
.text
  main:
    la $s2, elems # address of array 
    
    la $s3, nums
    lw $s3, 0($s3) # number of elements in array
    
    li $s7, 0 # loop variable (j = 0)
    li $s6, -1 # i = low - 1 = -1
    addi $s1, $s3, -1 # high index
    
    sll $s1, $s1, 2
    add $s1, $s1, $s2 # address of arr[high]
    lw $t2, 0($s1) # value of pivot (arr[high])
    
  quickSort:
    sll $t1, $s7, 2
    add $t1, $t1, $s2
    lw $t4, 0($t1) # arr[j]
    addi $s7, $s7, 1
    blt $t4, $t2, quickSort
    jal swap
    bgt $s7, $s3, finish
    j quickSort
    
  swap:
    addi $s6, $s6, 1
    sll $t0, $s6, 2
    add $t0, $s2, $t0 # point to arr[i]
    lw $t3, 0($t0) # arr[i]
    sw $t3, 0($t1)
    sw $t4, 0($t0)
    
    
    jr $ra
    
  finish:
    addi $s6, $s6, 1
    sll $t0, $s6, 2
    add $t0, $s2, $t0
    lw $t3, 0($t0) # arr[i+1]
    sw $t3, 0($s1)
    sw $t2, 0($t0)
    j printArray
    
  printArray:
    li $v0, 4
    la $a0, result
    syscall
    
    lw $t9, 0($s2)
    addi $s2, $s2, 4
    addi $a0, $t9, 0
    li $v0, 1
    syscall
    addi $t8, $t8, 1
    blt $t8, $s3, printArray
    li $v0, 10
    syscall
    
    
    
