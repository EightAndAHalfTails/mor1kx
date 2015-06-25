	.global _start
	.org 0x100
reset:
	l.andi	r0, r0,	0
	l.movhi	r1, hi(_stack)
	l.ori	r1, r1, lo(_start)
	l.or	r2, r0, r1

/*	l.addi	r13, r0, 0
	l.ori	r15, r0, lo(hardr)
	l.movhi	r17, hi(_start)
	l.movhi	r19, 1
	l.ori	r17, r17, lo(_start)
hardr:	l.mtspr	r13, r0, 0
	l.addi	r13, r13, 1
	l.sfeq	r13, r19
	l.cmov	r15, r17, r15
	l.jr	r15
	l.nop
*/	
	l.j	_start
	l.nop

	.org 0x300

dpgflt: # add pte
	l.movhi	r15, 0xdead		#
	l.ori	r15, r15, 0xbeef	# r15 = 0xdeadbeef	
	l.j	dpgflt
	l.nop
	l.rfe

	.org 0x900
/*	
dtlbms:	# find pte and add to tlb
	l.mfspr r15, r0, 0x30 		# exception ea reg -> r15
	l.ori	r17, r0, 0x2000		# table base pointer -> r17
	
	l.srli	r19, r15, 13		# get vpn:set from ea (>>13 then <<2 to use as pointer)
	l.slli	r19, r19, 2
	l.add	r19, r19, r17		# offset into page table
	l.lwz	r19, 0(r19)		# page table entry -> r19

	l.movhi	r13, 0x0007
	l.ori	r13, r13, 0xe000
	l.and	r21, r15, r13		# extract bits 18-13 of ea
	l.srli	r21, r21, 13		# r21 <- tlb set reg num

	# dtlbw0mrX[31:13] <- ea[31:13]
	l.movhi	r13, 0xffff
	l.ori	r13, r13, 0xe000
	l.and	r23, r15, r13		# extract bits 31:13 of ea
	l.ori	r23, r23, 1		# set valid bit
	l.mtspr	r21, r23, 0x0a00	# move to tlb match reg

	# dtlbw0trX[31:13] <- pte[31:10]
	l.movhi	r13, 0xffff
	l.ori	r13, r13, 0xfc00
	l.and	r23, r19, r13		# extract bits 31:10 of pte
	l.slli	r23, r23, 3		# move to ppn location
	l.andi	r25, r19, 0x003f	# extract bits 5:0 of pte
	l.or	r23, r23, r25		# add to translate reg
	# todo: look up protection bits
	l.ori	r23, r23, 0x03c0	# add protection bits to reg
	l.mtspr	r21, r23, 0x0a80	# move to tlb translate reg
*/
# virt = phys
	l.mfspr	r23, r0, 0x30
	l.movhi	r25, 0xffff
	l.ori	r25, r25, 0xe000
	l.and	r25, r25, r23

	l.movhi	r27, 0x0007
	l.ori	r27, r27, 0xe000
	l.and	r27, r27, r23
	l.srli	r27, r27, 13

	l.ori	r29, r25, 0x0001
	l.mtspr	r27, r29, 0x0a00
	l.ori	r29, r25, 0x03c0
	l.mtspr	r27, r29, 0x0a80

	l.rfe				# return from exception
	
	.org 0x2000
	.org 0x3000
_start:
/*	# add base pointer to tlb
	#l.movhi r13, 0x0000		# ea = 0x2000 -> vpn = 0
	l.ori	r13, r0, 0x0001 	# reg = 0x0000 0001
	l.mtspr	r0, r13, 0x0a01		#  put in w0mr1
	l.movhi	r13, 0x0000		# pa = 0x2000 -> ppn = 0
	l.ori	r13, r13, 0x03c0 	# reg = 0x0000 03c0
	l.mtspr	r0, r13, 0x0a81		#  put in w0tr1
	
	# place test value in memory
	l.movhi	r13, 0xbabe
	l.ori	r13, r13, 0xface
	l.sw	0x4000(r0), r13		# mem(0x04000) <- 0xbabeface
		
	# put pte in page table
	#l.movhi r13, 0x0000		# vp 0 -> pp 2
	l.ori	r13, r0, 0x0a00		# 0x0000 0a00
	l.sw	0x2008(r0), r13		# pt[2] = 0x0000 0a00
	
	# activate mmu
	l.mfspr	r13, r0, 0x0011		# r13 <- sr
	l.ori	r13, r13, 0x20		# enable bit 5 (dmmu)
	l.mtspr	r0, r13, 0x0011		# r13 -> sr
	
	# do memory access
	l.lwz	r15, 0x4000(r0)*/

	# store test value in memory
	l.movhi	r13, 0xc0d1		#
	l.ori	r13, r13, 0xf1ed	# r13 = 0xcod1f1ed
	l.ori	r15, r0, 0x4000		# r15 = 0x4444
	
	l.sw	0(r15), r13
	
	# mark cache line as invalid in dmmu
	l.ori	r19, r0, 1
	l.andi	r17, r15, 0x1f		# r17 = bit no = EA[9:5]
	l.sll	r19, r19, r17		# r19 = one-hot(r17)

	l.movhi r17, 0x0007
	l.ori	r17, r17, 0xfb00
	l.and	r17, r15, r17
	l.srli	r17, r17, 10		# r17 = reg no = EA[18:10]

	l.mfspr	r21, r17, 0x0e00
	l.or	r21, r19, r21
	l.sw	4(r15), r21
	l.mtspr	r17, r21, 0x0e00	# set prot reg
#	l.mtspr	r17, r0, 0x0e00

	# activate mmu
	l.mfspr	r13, r0, 0x0011		# r13 <- sr
	l.ori	r13, r13, 0x20		# enable bit 5 (dmmu)
	l.mtspr	r0, r13, 0x0011		# r13 -> sr
	
	# try to load memory location
	l.lwz	r15, 0(r15)
	
	#l.jal	main		
	l.nop

end:	l.j	end
	l.nop
	
