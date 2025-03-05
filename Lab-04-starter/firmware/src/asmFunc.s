/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Daniel Soto"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global balance,transaction,eat_out,stay_in,eat_ice_cream,we_have_a_problem
.type balance,%gnu_unique_object
.type transaction,%gnu_unique_object
.type eat_out,%gnu_unique_object
.type stay_in,%gnu_unique_object
.type eat_ice_cream,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
balance:           .word     0  /* input/output value */
transaction:       .word     0  /* output value */
eat_out:           .word     0  /* output value */
stay_in:           .word     0  /* output value */
eat_ice_cream:     .word     0  /* output value */
we_have_a_problem: .word     0  /* output value */

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align


    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: the integer value returned to the C function
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    MOV r1,0 
     /* Cleaning Leftovers from previous tests, also setting registers
    for all the flags and balance and transaction and stuff like that like*/
    LDR r7,=balance
    LDR r8,=eat_out
    LDR r9,=stay_in
    LDR r10,=transaction
    LDR r11,=eat_ice_cream
    LDR r12,=we_have_a_problem
    STR r1,[r8]
    STR r1,[r9]
    STR r1,[r10]
    STR r1,[r11]
    STR r1,[r12] /* Done cleaning leftovers */
    
    STR r0,[r10]
    /* Transaction amount is in r0, and in transaction (for future me)
     Logic part of lab to see if transaction is within range or overflow*/
    LDR r1,=0x3E8 /*1000*/
    CMP r0,r1
    BGT problem
    
    LDR r1, =0xFFFFFC18 /*-1000*/
    CMP r0,r1
    BLT problem
    
    LDR r4,=balance /*Overflow check*/
    LDR r1,[r4]
    ADDS r0,r1,r0
    BVS problem
    
    STR r0,[r4] /*At this point, r0 is temp balance and set balance*/
    /* wont need to update r0 from this point on so it is balance for the end*/
    
    MOV r1, 0 /* Branch Checks if balance is Positive, Negative, or zero*/
    CMP r0,r1
    BGT eating_out
    BLT eating_in
    
    LDR r10,=eat_ice_cream /* no need to branch if we need to eat ice cream*/
    MOV r1,1
    STR r1,[r10]
    BAL done 
    
    eating_in: /* set flags and done*/
    LDR r10,=stay_in
    MOV r1,1
    STR r1,[r10]
    BAL done
    
    eating_out: /* set flags and done*/
    LDR r10,=eat_out
    MOV r1,1
    STR r1,[r10]
    BAL done
    
    problem: /* if we have a problem then flags get set, self explainatory*/
    MOV r1,1
    LDR r12,=we_have_a_problem
    STR r1,[r12]
    MOV r1,0
    LDR r10,=transaction
    STR r1,[r10]
    LDR r7,=balance
    LDR r0,[r7]
    BAL done
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




