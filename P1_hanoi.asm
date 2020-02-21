#Tower of haanoi assembly solution
#Made by: Luis Ricardo Diaz Flores, Omar Pérez Cano

.text
  		  addi $s0, $zero, 8 		           #Number of disks
  		  addi $a1, $zero, 0x1001		       #Destination address of tower #1
 		    sll $a1, $a1, 16 		             #Left shift 4 bytes for 1st position
 		
 		    add $t0, $zero, $s0 		         #Number of disks auxiliary variable for placing in first tower
  
placeDisk: 	sw $t0, 0($a1)       		     #Place disk in first destination
	  	      addi $a1, $a1, 4		         #Add 4 bytes for the next position in origin tower
	      	  addi $t0, $t0, -1 		       #Auxiliary number of disks -1
	  	      bne $t0, $zero, placeDisk 	 #Do this until number of disks is zero
	   
		        addi $a1, $zero, 0x1001 	  #Load first position of the first(origin) tower again
		        sll  $a1, $a1, 16		        #Left shift 4 bytes for 1st position
            addi $a2, $a2, 0x00		      #Load origin address for disks

            addi $a2, $zero, 0x1001  	  #Load first position of the auxiliary tower
            sll  $a2, $a2, 16		        #Left shift 4 bytes for 1st position
            addi $a2, $a2, 0x20		      #Load auxiliary address for disks

            addi $a3, $zero, 0x1001     #Load first position of the destination tower
            sll  $a3, $a3, 16		        #Left shift 4 bytes for 1st position
            addi $a3, $a3, 0x40		      #Load destination address for disks

            jal push			              #Start pushing disks into towers
            j end				                #End program after loop
		
push:		    addi $sp, $sp, -20		      #Allocate stack space for 5 registers
            sw $s0, 0($sp)		        	#Push number of disks into stack
            sw $a1, 4($sp)		        	#Push origin tower address position into stack
            sw $a2, 8($sp)		        	#Push auxiliary tower address position into stack
            sw $a3, 12($sp)		        	#Push destination tower address position into stack
            sw $ra, 16($sp)		        	#Push return value into stack

            bne $s0, 1, loop	        	#Loop while number of disks is different than 1
                                        #If numbers of disks = 1...
            sw $s0, 0($a3) 		        	#Store single disk in destination tower
            sw $zero, 0($a1)		        #Remove disk from origin tower position

            j pop
		
loop: 		addi $s0, $s0, -1		          #Reduce number of disks by 1
		      addi $a1, $a1, 4			        #Add 4 to origin tower for next position
		
          lw $a2, 12($sp)			          #Swap positions: destination to auxiliary
          lw $a3, 8($sp)		          	#Swap positions: auxiliary to destination

          jal push			                #Loads current values in stack

          lw $a3, 12($sp)			          #Store former destination address
          addi $a1, $a1, -4		          #Shift origin tower for next disk position
          addi $s0, $s0, 1		          #Number of disks + 1
          sw $s0, 0($a3)			          #Put current disk in current destination
          sw $zero, 0($a1)		          #Remove disk from origin tower position

          addi $a3, $a3, 4			        #Shift position of destination tower to recieve disk
          addi $s0, $s0, -1		          #Reduce number of disks by 1

          lw $a1, 8($sp)		          	#Swap positions: auxiliary to origin
          lw $a2, 4($sp)			          #Swap positions: origin to auxiliary

          jal push
		
 pop:	  	lw $s0, 0($sp)			          #Pop number of disks value
          lw $a1, 4($sp)			          #Pop origin tower address position
          lw $a2, 8($sp)			          #Pop auxiliary tower address position
          lw $a3, 12($sp)			          #Pop destination tower address position
          lw $ra, 16($sp)			          #Pop return value
          addi $sp, $sp, 20		          #Return stack pointer to original position
          jr $ra
		
end:
