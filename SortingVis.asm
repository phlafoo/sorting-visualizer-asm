INCLUDE Irvine32.inc

; AUTHOR: Shuval de Villiers
; CS2290
; LAB 9
;------------------------
; PURPOSE:
;	Visualize these sorting algorithms:
;		- bubble sort
;		- cocktail shaker sort
;		- comb sort
;		- selection sort
;		- insertion sort
;		- shell sort
;		- quick sort
;		- merge sort
;		- heap sort
;		- radix sort
;		- pigeon hole sort
;		- BOGO sort
; Sorting algorithms start at line ~1815
;------------------------


CONSOLE_WIDTH 		= 119	; default = 119   minimum = 65  (odd number pls)
CONSOLE_HEIGHT		= (CONSOLE_WIDTH + 1) / 2

BOX_WIDTH			= CONSOLE_WIDTH - (CONSOLE_WIDTH / 6)
BOX_HEIGHT 			= BOX_WIDTH / 2
ARRAY_SIZE			= BOX_HEIGHT	; 50 elements for CONSOLE_WIDTH of 119

BOX_TOP_MARGIN 		= (CONSOLE_WIDTH / 36) + 2
BOX_LEFT_MARGIN 	= (CONSOLE_WIDTH - BOX_WIDTH) / 2

BAR_CHAR		 	= 219 ; 178 looks good too
SPACE				= 32

; These are stored in AH after calling ReadKey
UP_ARROW			= 048h
DOWN_ARROW			= 050h
LEFT_ARROW			= 04Bh
RIGHT_ARROW			= 04Dh
SPACE_BAR			= 039h
ENTER_KEY			= 01Ch
ESCAPE_KEY			= 01h

; these delays are used when RUN ALL is selected
CHECK_DELAY			= 10
DEFAULT_DELAY		= 15
SLOW_DELAY			= 20
SLOWER_DELAY		= 30
SLOWEST_DELAY		= 500
SHUFFLE_DELAY		= 8
PAUSE_DELAY			= 1000

BACK_COLOR			= gray
FORE_COLOR			= black
CHECK_COLOR			= lightGreen	; color for checking order
CURRENT_COLOR		= lightRed		; elements are being compared or swapped
PIVOT_COLOR			= lightBlue		; used in merge/quick/selection sorts
SELECT_COLOR		= lightCyan		; used in menu
PADDING_COLOR		= lightGray
MSG_COLOR			= white

SORT_MSG_LOC		= 0101h			; where the algorithm type is printed
CMP_LOC				= 0121h			; where # of comparisons is printed
ACCESSES_LOC		= 0137h			; where # of accesses is printed
OPTIONS_LOC			= 0500h			; offsets where menu items are displayed

.data

; goto DX = 03704h for debug_msg
debug_msg BYTE "      0 1 2 3 4 5 6 7 8 9 101 2 3 4 5 6 7 8 9 201 2 3 4 5 6 7 8 9",
" 301 2 3 4 5 6 7 8 9 401 2 3 4 5 6 7 8 9",0

;*** MENU ITEMS ***
menu_header_msg	BYTE 39 DUP (SPACE), 13,10,
					" SHUVAL'S SUPER SORTING SIMULATOR 2019 ",13,10,
					 39 DUP (SPACE),0
; choose sort
run_all_opt		BYTE "    RUN ALL          ",0
insertion_opt	BYTE "    Insertion Sort   ",0
bubble_opt		BYTE "    Bubble Sort      ",0
comb_opt		BYTE "    Comb Sort        ",0
shell_opt		BYTE "    Shell Sort       ",0
cocktail_opt	BYTE "    Cocktail Sort    ",0
selection_opt	BYTE "    Selection Sort   ",0
quick_opt		BYTE "    Quick Sort       ",0
merge_opt		BYTE "    Merge Sort       ",0
heap_opt		BYTE "    Heap Sort        ",0
radix_opt		BYTE "    Radix Sort       ",0
pigeon_opt		BYTE "    Pigeonhole Sort  ",0
bogo_opt		BYTE "    BogoSort         ",0

run_all_info	BYTE	"                                         ",0
INFO_SIZE		= ($ - run_all_info)
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
INFO_ROWS		= ($ - run_all_info) / INFO_SIZE

bubble_info		BYTE 	"Worst case performance: O(n^2)           ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE 	"Bubble sort is a simple sorting algorithm",0
				BYTE	"that works by repeatedly swapping        ",0
				BYTE	"adjacent elements if they are in the     ",0
				BYTE 	"wrong order.                             ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Easy to conceptualize and implement",0
				BYTE	"    - Stable and in-place                ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Much slower than other O(n^2)      ",0
				BYTE	"      sorting algorithms                 ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

shaker_info		BYTE 	"Worst case performance: O(n^2)           ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE 	"Cocktail shaker sort is a variation on   ",0
				BYTE	"bubble sort where the list is traversed  ",0
				BYTE	"in both directions alternatively.        ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Easy to conceptualize and implement",0
				BYTE	"    - Stable and in-place                ",0
				BYTE	"    - Slightly faster than bubble sort   ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Still much slower than other O(n^2)",0
				BYTE	"      sorting algorithms                 ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

comb_info		BYTE 	"Worst case performance: O(n^2)           ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE 	"Comb sort is a generalization of bubble  ",0
				BYTE	"sort. Instead of swapping adjacent       ",0
				BYTE	"elements it swaps elements at an         ",0
				BYTE	"interval that decreases by a factor of   ",0
				BYTE	"1.3 on each pass.                        ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - In-place                           ",0
				BYTE	"    - Improves on bubble sort            ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Still slower than other O(n^2)     ",0
				BYTE	"      sorting algorithms                 ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

selection_info	BYTE 	"Worst case performance: O(n^2)           ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE 	"Selection sort repeatedly finds the      ",0
				BYTE	"maximum element in the unsorted portion  ",0
				BYTE	"of the array then moves it to the        ",0
				BYTE	"beginning of the sorted portion until the",0
				BYTE	"whole array is sorted.                   ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Easy to conceptualize and implement",0
				BYTE	"    - In-place                           ",0
				BYTE	"    - Stable depending on implementation ",0
				BYTE	"    - At most performs O(n) swaps        ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Usually usurped by insertion sort  ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

insertion_info	BYTE 	"Worst case performance: O(n^2)           ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE 	"Insertion sort sorts an array the same   ",0
				BYTE	"way that you would sort playing cards in ",0
				BYTE	"your hands. At each iteration, insertion ",0
				BYTE	"sort removes one element from the        ",0
				BYTE	"unsorted portion of the array, then finds",0
				BYTE	"the location it belongs within the sorted",0
				BYTE	"portion, and inserts it there.           ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Usually the O(n^2) sorting algoritm",0
				BYTE	"      of choice                          ",0
				BYTE	"    - Stable and in place                ",0
				BYTE	"    - Online (can sort a list as it      ",0
				BYTE	"      receives it)                       ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Usually only useful with small data",0
				BYTE	"      sets                               ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

shell_info		BYTE 	"Worst case performance: O(n^2)           ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE 	"Shell sort is a generalizatin of         ",0
				BYTE	"insertion sort. It uses insertion sort to",0
				BYTE	"sort elements on an interval that        ",0
				BYTE	"decreases with each pass. The interval is",0
				BYTE	"divided in half for this implementation. ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Twice as fast as insertion sort    ",0
				BYTE	"    - In-place                           ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Not stable                         ",0
				BYTE	"    - Usually usurped by quicksort unless",0
				BYTE	"      you cannot use the call stack      ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

quick_info		BYTE 	"Worst case performance: O(n^2)           ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE 	"Quick sort uses a divide and conquer     ",0
				BYTE	"strategy. It selects a pivot, then puts  ",0
				BYTE	"all elements smaller than the pivot on   ",0
				BYTE	"left of the pivot and all elements       ",0
				BYTE	"greater on the right. My implementation  ",0
				BYTE	"uses the rightmost element as the pivot. ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Takes O(nlogn) time on average     ",0
				BYTE	"    - Generally performs 2-3 times faster",0
				BYTE	"      than heap sort and merge sort      ",0
				BYTE	"    - In-place                           ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Difficult to make stable while     ",0
				BYTE	"      maintaining its speed advantage    ",0
				BYTE	"    - Relies on the call stack unless    ",0
				BYTE	"      implemented iteratively            ",0
				BYTE	"    - Outperformed by merge sort when    ",0
				BYTE	"      sorting linked lists               ",0

merge_info		BYTE 	"Worst case performance: O(nlogn)         ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE	"Merge sort is a divide and conquer       ",0
				BYTE	"algorithm. It divides the array into two ",0
				BYTE	"sub-arrays until each half contains one  ",0
				BYTE	"element. It then repeatedly merges the   ",0
				BYTE	"two sorted halves until all sub-arrays   ",0
				BYTE	"are merged.                              ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Stable                             ",0
				BYTE	"    - Very effective for linked lists    ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Uses O(n) auxiliary space with     ",0
				BYTE	"      RAM-based data                     ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

heap_info		BYTE 	"Worst case performance: O(nlogn)         ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE	"Heap sort is similar to selection sort   ",0
				BYTE	"but organizes the data into a max heap   ",0
				BYTE	"data structure to extract the maximums.  ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - In-place                           ",0
				BYTE	"    - Looks cool                         ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Outperformed by quicksort and merge",0
				BYTE	"      sort for most applications         ",0
				BYTE	"    - Typically not stable               ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

radix_info		BYTE 	"Worst case performance: O(n*(key size))  ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE	"Radix sort is a non-comparative sorting  ",0
				BYTE	"algorithm. It works by distributing      ",0
				BYTE	"elements into buckets according to their ",0
				BYTE	"radix. The array is re-bucketed for every",0
				BYTE	"digit in the largest element while       ",0
				BYTE	"preserving the ordering of the previous  ",0
				BYTE	"pass. My version works in base 10.       ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Faster than comparative sorts for a",0
				BYTE	"      wide range of input numbers        ",0
				BYTE	"    - Stable                             ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Not in-place                       ",0
				BYTE	"    - Constrained to lexicographic data  ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0

pigeon_info		BYTE 	"Worst case performance: O(n + range)     ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE	"Pigeonhole sort works by creating an     ",0
				BYTE	'auxiliary array of empty "pigeonholes",  ',0
				BYTE	"one for each possible element in the     ",0
				BYTE	"range of the orginial array. It then does",0
				BYTE	"one scan of the original array, placing  ",0
				BYTE	"each element in its corresponding        ",0
				BYTE	"pigeonhole. Then it iterates over the    ",0
				BYTE	"pigeonhole array, placing the elements   ",0
				BYTE	"back into the original array in the      ",0
				BYTE	"correct order.                           ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - Faster than comparative sorts when ",0
				BYTE	"      the number of elements is about the",0
				BYTE	"      same as the range                  ",0
				BYTE	"    - Stable                             ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Not in-place                       ",0
				BYTE	"    - Usually usurped by radix sort      ",0

bogo_info		BYTE 	"Average case performance: O(n*n!)        ",0
				BYTE 	(INFO_SIZE - 1) DUP ('~'),0
				BYTE	"Bogosort works by repeatedly generating a",0
				BYTE	"random permutation of its input and      ",0
				BYTE	"checking if it's sorted.                 ",0
				BYTE	"                                         ",0
				BYTE	"  PROS:                                  ",0
				BYTE	"    - May be useful for educational      ",0
				BYTE	"      purposes                           ",0
				BYTE	"    - In-place                           ",0
				BYTE	"    - Best-case performance is O(n)      ",0
				BYTE	"                                         ",0
				BYTE	"  CONS:                                  ",0
				BYTE	"    - Ridiculous                         ",0
				BYTE	"    - No upper bound for worst case      ",0
				BYTE	"    - Not stable                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0
				BYTE	"                                         ",0


; choose speed
choose_speed_msg BYTE " SELECT A SPEED ",0
speed_padding	BYTE (LENGTHOF choose_speed_msg)-1 DUP (SPACE),0
vfast_opt		BYTE "   0 ms (very fast) ",0
fast_opt		BYTE "  15 ms      (fast) ",0
normal_opt		BYTE "  30 ms    (normal) ",0
slow_opt		BYTE "  60 ms      (slow) ",0
vslow_opt		BYTE " 350 ms (very slow) ",0

; Available speeds
speedArray		WORD 0, 15, 30, 60, 350

; this switch is used in menu for printing the sorting algos
caseTable	BYTE -1
			DWORD printRunAll
entrySize = ($ - caseTable)
			BYTE 0
			DWORD printBubble
			BYTE 1
			DWORD printShaker
			BYTE 2
			DWORD printComb
			BYTE 3
			DWORD printSelection
			BYTE 4
			DWORD printInsertion
			BYTE 5
			DWORD printShell
			BYTE 6
			DWORD printQuick
			BYTE 7
			DWORD printMerge
			BYTE 8
			DWORD printHeap
			BYTE 9
			DWORD printRadix
			BYTE 10
			DWORD printPigeon
			BYTE 11
			DWORD printBogo
tableSize = ($ - caseTable) / entrySize

; this switch is used in menu for printing the speed options
speedTable	BYTE 0
			DWORD printVFast
speedEntry = ($ - speedTable)
			BYTE 1
			DWORD printFast
			BYTE 2
			DWORD printNormal
			BYTE 3
			DWORD printSlow
			BYTE 4
			DWORD printVSlow
speedSize = ($ - speedTable) / speedEntry

; Controls
back_msg		BYTE "[Esc] - Go back   ",0
quit_msg		BYTE "[Esc] - Quit      ",0
navig_msg		BYTE '[',24,25,27,26, "] - Navigation",0

insertion_msg	BYTE "Insertion Sort   - comparisons:       array accesses:",0
bubble_msg		BYTE "Bubble Sort      - comparisons:       array accesses:",0
comb_msg		BYTE "Comb Sort        - comparisons:       array accesses:",0
shell_msg		BYTE "Shell Sort       - comparisons:       array accesses:",0
cocktail_msg	BYTE "Cocktail Sort    - comparisons:       array accesses:",0
selection_msg	BYTE "Selection Sort   - comparisons:       array accesses:",0
quick_msg		BYTE "Quick Sort       - comparisons:       array accesses:",0
merge_msg		BYTE "Merge Sort       - comparisons:       array accesses:",0
heap_msg		BYTE "Heap Sort        - comparisons:       array accesses:",0
radix_msg		BYTE "Radix Sort       - comparisons:       array accesses:",0
pigeon_msg		BYTE "Pigeonhole Sort  - comparisons:       array accesses:",0
bogo_msg		BYTE "Bogosort         - comparisons:       array accesses:",0
shuffle_msg		BYTE "Shuffling...",0
clear_msg		BYTE 60  DUP (SPACE),0	; clears previous msg

array 		BYTE ARRAY_SIZE DUP (?)	; stores base array values
garbage		BYTE ARRAY_SIZE			; checkSort goes one byte out of bounds

.data?

speed_loc	WORD ?		; where speed option get printed

tmpArray 	BYTE ARRAY_SIZE DUP (?)	; used for merge and radix sort
pigeonArray BYTE ARRAY_SIZE DUP (?)	; used for pigeon sort
countArray	BYTE 10 DUP (?)			; used for radix sort
mid			DWORD ?					; used in merge sort

; indices for drawSwap()
index2		BYTE ?
index1		BYTE ?

comparisons DWORD ?		; tracks # of comparisons
accesses	DWORD ?		; tracks # of array accesses

sort_delay	DWORD ?		; delay during sorts

; lazy way to make sure things work
saveEBX		DWORD ?
saveStack	DWORD ?
print_bool	BYTE ?


.code

main PROC
;;;;;;;;; Driver function
	
	call Randomize
	
	; start at 'RUN ALL' option
	mov EBX, -1
	mov saveEBX, EBX
	
	; with MENU_LOOP being global, stack slowly grows if program is used
	; for a while. So I reset it when a jump to the menu is made
	mov saveStack, ESP
	
	; call getOutOfJailFreeCard
	MENU_LOOP::
	
		mov ESP, saveStack
		
		; clear buffer incase Libero was pressing too many buttons
		call readKey
		
		; must be reset at start of menu
		mov speed_loc, OPTIONS_LOC + 01Bh
		
		mov EBX, saveEBX
		call chooseSort	; returns EBX = -1 to +11
		mov saveEBX, EBX
		
		; all sorts take EDX and EAX as parameters
		mov EDX, OFFSET array
		mov EAX, ARRAY_SIZE
		
		; initialize array with values 1 to n
		call initArray
		
		; if RUN ALL
		cmp EBX, -1
		jg NOT_ALL
			call runAll
			jmp CONT
		NOT_ALL:
		
		; else...
		call chooseSpeed
		call shuffle
		call pauseDelay
		
		; if...
		cmp EBX, 0
		jg NO_BUBBLE
			call bubbleSort
			jmp CONT
		NO_BUBBLE:
		
		cmp EBX, 1
		jg NO_SHAKER
			call cocktailSort
			jmp CONT
		NO_SHAKER:
		
		cmp EBX, 2
		jg NO_COMB
			call combSort
			jmp CONT
		NO_COMB:
		
		cmp EBX, 3
		jg NO_SELECTION
			call selectionSort
			jmp CONT
		NO_SELECTION:
		
		cmp EBX, 4
		jg NO_INSERTION
			call insertionSort
			jmp CONT
		NO_INSERTION:
		
		cmp EBX, 5
		jg NO_SHELL
			call shellSort
			jmp CONT
		NO_SHELL:
		
		cmp EBX, 6
		jg NO_QUICK
			call quickSort
			jmp CONT
		NO_QUICK:
		
		cmp EBX, 7
		jg NO_MERGE
			call mergeSort
			jmp CONT
		NO_MERGE:
		
		cmp EBX, 8
		jg NO_HEAP
			call heapSort
			jmp CONT
		NO_HEAP:
		
		cmp EBX, 9
		jg NO_RADIX
			call radixSort
			jmp CONT
		NO_RADIX:
		
		cmp EBX, 10
		jg NO_PIGEON
			call pigeonholeSort
			jmp CONT
		NO_PIGEON:
		
		cmp EBX, 11
		jg NO_BOGO
			call bogoSort
			jmp CONT
		NO_BOGO:
		; ENDIF
		
		
		CONT:
		call checkSort
		
		; wait for [Esc] to return to menu
		WAIT_LOOP:
			mov EAX, 50
			call delay
			call readKey
			cmp AH, ESCAPE_KEY
			je RETURN
			cmp AH, LEFT_ARROW
			je RETURN
		jmp WAIT_LOOP
		RETURN:
		
	jmp MENU_LOOP
	
exit
main ENDP

;------------------------
runAll PROC USES EAX ECX EDX
;	runs through all sorts
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	call clrscr
	call shuffle
	call pauseDelay
	mov sort_delay, DEFAULT_DELAY

		call bubbleSort

	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, DEFAULT_DELAY
	
		call cocktailSort

	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, DEFAULT_DELAY

		call combSort

	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, DEFAULT_DELAY
	
		call selectionSort
	
	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, DEFAULT_DELAY
	
		call insertionSort
		
	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, SLOW_DELAY
	
		call shellSort
		
	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, SLOWER_DELAY
	
		call quickSort
	
	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, SLOW_DELAY
	
		call mergeSort
	
	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay	
	mov sort_delay, SLOWER_DELAY
	
		call heapSort

	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, SLOWER_DELAY

		call radixSort

	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, SLOW_DELAY
	
		call pigeonholeSort
		
	call checkSort
	call pauseDelay
	call shuffle
	call pauseDelay
	mov sort_delay, SLOWEST_DELAY
	
		; bogo usually doesn't end so it returns when the user hits [esc]
		call bogoSort
ret
runAll ENDP

;------------------------
chooseSort PROC USES EAX ECX EDX
;	menu to choose the sorting algorithm
; RETURNS:
;	EBX		--> number representing which sorting algo to run
;------------------------
	
	; reset color
	mov EAX, PADDING_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	call clrscr
	
	; print controls...
	mov DH, CONSOLE_HEIGHT - 2
	mov DL, 1
	call GotoXY
	mov EDX, OFFSET quit_msg
	call WriteString
	mov EDX, OFFSET navig_msg
	call WriteString

	
	mov EAX, MSG_COLOR + (FORE_COLOR * 16)
	call setTextColor
	
	; printing header
	mov DX, OPTIONS_LOC - 0400h
	call GotoXY
	mov EDX, OFFSET menu_header_msg
	call writeString
	
	
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call setTextColor
	
	; printing menu options
	mov print_bool, 0
	push EBX
	mov ECX, tableSize
	PRINTING:
		mov EBX, ECX
		sub EBX, 2
		call switch
	LOOP PRINTING
	pop EBX
	
	
	mov EAX, FORE_COLOR + (SELECT_COLOR * 16)
	call setTextColor
	
	; print highlighted option
	mov print_bool, 1
	call switch
	
	; allows user to navigate menu
	WAIT_LOOP:
	
		mov EAX, 50
		call delay
		
		push EBX
		call readKey
		pop EBX
		
		; if [Esc] is hit, quit program
		cmp AH, ESCAPE_KEY
		jne GOOD
			exit
		GOOD:
		
		; user makes selection
		cmp AH, SPACE_BAR
		je RETURN
		cmp AH, ENTER_KEY
		je RETURN
		cmp AH, RIGHT_ARROW
		je RETURN
		jmp NO_RET
		RETURN:
			; erases info
			push EBX
			mov EBX, OFFSET run_all_info
			call printInfo
			pop EBX
			
			mov EAX, FORE_COLOR + (BACK_COLOR * 16)
			call setTextColor
			
			; determine where to draw speed options
			mov ECX, EDI
			shl ECX, 8
			add speed_loc, CX
			ret
		NO_RET:
		
		; moving up or down
		cmp AH, UP_ARROW
		jne NOT_UP
			call moveUp
			jmp NOT_DOWN
		NOT_UP:
		
		cmp AH, DOWN_ARROW
		jne NOT_DOWN
			call moveDown
		NOT_DOWN:
		
	jmp WAIT_LOOP
	
ret
chooseSort ENDP

;------------------------
moveUp PROC
;	moves cursor up
; RETURNS:
;	EBX			--> new selection
; PARAMETERS:
;	EBX			--> current selection
;------------------------
	; don't go to high!
	cmp BL, -1
	je RETURN
	
	; erase prev selection
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call setTextColor
	call switch
	dec BL
	
	; print new selection
	mov EAX, FORE_COLOR + (SELECT_COLOR * 16)
	call setTextColor
	call switch
	
	RETURN:
ret
moveUp ENDP

;------------------------
moveDown PROC
;	moves cursor down
; RETURNS:
;	EBX			--> new selection
; PARAMETERS:
;	EBX			--> current selection
;------------------------
	; don't go to low!
	cmp BL, 11
	je RETURN

	; erase prev selection
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call setTextColor
	call switch
	inc BL
	
	; print new selection
	mov EAX, FORE_COLOR + (SELECT_COLOR * 16)
	call setTextColor
	call switch
	
	RETURN:
ret
moveDown ENDP

;------------------------
switch PROC USES ECX ESI
;	Prints the appropriate algo option
; PARAMETERS:
;	EBX			--> option to print (-1 to 11)
;------------------------
	mov ESI, OFFSET caseTable
	mov ECX, tableSize
	
	SWITCH_LOOP:
		cmp BL, [ESI]
		jne CONT
		; prints the appropriate option
		call NEAR PTR [ESI + 1]
		jmp BREAK
	CONT:
		add ESI, entrySize
	LOOP SWITCH_LOOP
	
	BREAK: 
ret
switch ENDP

;------------------------
printInfo PROC USES EAX EBX ECX EDX
;	Prints the appropriate info box
; PARAMETERS:
;	EBX			--> offset of the info box to print
;------------------------
	
	; only prints if print_bool is true
	cmp print_bool, 0
	je NO_INFO
	
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call setTextColor
	
	; EAX stores the location
	mov EAX, OPTIONS_LOC
	add EAX, 0217h
	
	; prime loop
	mov ECX, INFO_ROWS
	L1:
		mov EDX, EAX
		call GotoXY
		
		mov EDX, EBX
		call writeString
		
		; move to next line
		add EBX, INFO_SIZE
		add EAX, 0100h
	LOOP L1
	
	NO_INFO:
	
ret
printInfo ENDP


; ******   SORT OPTIONS   ******
; these print an option then adjust EBX and EDI
; EDI is used to determine where the speed menu gets printed
printRunAll PROC USES EDX
	mov DX, OPTIONS_LOC
	call GotoXY
	mov EDX, OFFSET run_all_opt
	call writeString
	mov EBX, OFFSET run_all_info
	call printInfo
	mov EBX, -1
ret
printRunAll ENDP
printBubble PROC USES EDX
	mov DX, OPTIONS_LOC + 0200h
	call GotoXY
	mov EDX, OFFSET bubble_opt
	call writeString
	mov EBX, OFFSET bubble_info
	call printInfo
	mov EBX, 0
	mov EDI, 0
ret
printBubble ENDP
printShaker PROC USES EDX
	mov DX, OPTIONS_LOC + 0400h
	call GotoXY
	mov EDX, OFFSET cocktail_opt
	call writeString
	mov EBX, OFFSET shaker_info
	call printInfo
	mov EBX, 1
	mov EDI, 0
ret
printShaker ENDP
printComb PROC USES EDX
	mov DX, OPTIONS_LOC + 0600h
	call GotoXY
	mov EDX, OFFSET comb_opt
	call writeString
	mov EBX, OFFSET comb_info
	call printInfo
	mov EBX, 2
	mov EDI, 0
ret
printComb ENDP
printSelection PROC USES EDX
	mov DX, OPTIONS_LOC + 0800h
	call GotoXY
	mov EDX, OFFSET selection_opt
	call writeString
	mov EBX, OFFSET selection_info
	call printInfo
	mov EBX, 3
	mov EDI, 0
ret
printSelection ENDP
printInsertion PROC USES EDX
	mov DX, OPTIONS_LOC + 0A00h
	call GotoXY
	mov EDX, OFFSET insertion_opt
	call writeString
	mov EBX, OFFSET insertion_info
	call printInfo
	mov EBX, 4
	mov EDI, 2
ret
printInsertion ENDP
printShell PROC USES EDX
	mov DX, OPTIONS_LOC + 0C00h
	call GotoXY
	mov EDX, OFFSET shell_opt
	call writeString
	mov EBX, OFFSET shell_info
	call printInfo
	mov EBX, 5
	mov EDI, 4
ret
printShell ENDP
printQuick PROC USES EDX
	mov DX, OPTIONS_LOC + 0E00h
	call GotoXY
	mov EDX, OFFSET quick_opt
	call writeString
	mov EBX, OFFSET quick_info
	call printInfo
	mov EBX, 6
	mov EDI, 6
ret
printQuick ENDP
printMerge PROC USES EDX
	mov DX, OPTIONS_LOC + 1000h
	call GotoXY
	mov EDX, OFFSET merge_opt
	call writeString
	mov EBX, OFFSET merge_info
	call printInfo
	mov EBX, 7
	mov EDI, 8
ret
printMerge ENDP
printHeap PROC USES EDX
	mov DX, OPTIONS_LOC + 1200h
	call GotoXY
	mov EDX, OFFSET heap_opt
	call writeString
	mov EBX, OFFSET heap_info
	call printInfo
	mov EBX, 8
	mov EDI, 10
ret
printHeap ENDP
printRadix PROC USES EDX
	mov DX, OPTIONS_LOC + 1400h
	call GotoXY
	mov EDX, OFFSET radix_opt
	call writeString
	mov EBX, OFFSET radix_info
	call printInfo
	mov EBX, 9
	mov EDI, 12
ret
printRadix ENDP
printPigeon PROC USES EDX
	mov DX, OPTIONS_LOC + 1600h
	call GotoXY
	mov EDX, OFFSET pigeon_opt
	call writeString
	mov EBX, OFFSET pigeon_info
	call printInfo
	mov EBX, 10
	mov EDI, 14
ret
printPigeon ENDP
printBogo PROC USES EDX
	mov DX, OPTIONS_LOC + 1800h
	call GotoXY
	mov EDX, OFFSET bogo_opt
	call writeString
	mov EBX, OFFSET bogo_info
	call printInfo
	mov EBX, 11
	mov EDI, 14
ret
printBogo ENDP

;------------------------
chooseSpeed PROC USES EAX EBX ECX EDX
;	menu to set the speed
;------------------------
	
	mov EAX, PADDING_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	; print controls...
	mov DH, CONSOLE_HEIGHT - 2
	mov DL, 1
	call GotoXY
	mov EDX, OFFSET back_msg
	call WriteString
	mov EDX, OFFSET navig_msg
	call WriteString
	
	mov EAX, FORE_COLOR + (PADDING_COLOR * 16)
	call setTextColor
	
	; Printing header...
	mov DX, speed_loc
	add DX, 02h
	call GotoXY
	mov EDX, OFFSET speed_padding
	call writeString
	
	mov DX, speed_loc
	add DX, 0102h
	call GotoXY
	mov EDX, OFFSET choose_speed_msg
	call writeString
	
	mov DX, speed_loc
	add DX, 0202h
	call GotoXY
	mov EDX, OFFSET speed_padding
	call writeString
	
	
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call setTextColor
	
	; listing options...
	call printFast
	call printNormal
	call printSlow
	call printVSlow
	
	; start at first option
	mov EAX, FORE_COLOR + (SELECT_COLOR * 16)
	call setTextColor
	call printVFast
	
	; allows user to make selection
	WAIT_LOOP:
	
		mov EAX, 50
		call delay
		
		push EBX
		call readKey
		pop EBX
		
		; go back if [Esc] or left arrow hit
		cmp AH, ESCAPE_KEY
		je BACK
		cmp AH, LEFT_ARROW
		je BACK
		jmp GOOD
		BACK:
			; stack is 'fixed' in MENU_LOOP
			jmp MENU_LOOP
		GOOD:
		
		; set speed and return if selection is made
		cmp AH, SPACE_BAR
		je RETURN
		cmp AH, ENTER_KEY
		je RETURN
		cmp AH, RIGHT_ARROW
		je RETURN
		jmp NO_RET
		RETURN:
			shl EBX, 1
			movzx ECX, WORD PTR [speedArray + EBX]
			mov sort_delay, ECX
			mov EAX, FORE_COLOR + (BACK_COLOR * 16)
			call setTextColor
			call clrscr
			ret
		NO_RET:
		
		; moving up or down
		cmp AH, UP_ARROW
		jne NOT_UP
			call moveUpSpeed
			jmp NOT_DOWN
		NOT_UP:
		
		cmp AH, DOWN_ARROW
		jne NOT_DOWN
			call moveDownSpeed
		NOT_DOWN:
		
	jmp WAIT_LOOP
	
ret
chooseSpeed ENDP

;------------------------
moveUpSpeed PROC USES EAX
;	moves cursor up
; RETURNS:
;	EBX			--> new selection
; PARAMETERS:
;	EBX			--> current selection
;------------------------
	; don't go too high!
	cmp BL, 0
	je RETURN
	
	; erase prev selection
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call setTextColor
	call speedSwitch
	dec BL
	
	; print new selection
	mov EAX, FORE_COLOR + (SELECT_COLOR * 16)
	call setTextColor
	call speedSwitch
	
	RETURN:
ret
moveUpSpeed ENDP

;------------------------
moveDownSpeed PROC USES EAX
;	moves cursor down
; RETURNS:
;	EBX			--> new selection
; PARAMETERS:
;	EBX			--> current selection
;------------------------
	; don't go too far down!
	cmp BL, 4
	je RETURN
	
	; erase prev selection
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call setTextColor
	call speedSwitch
	inc BL
	
	; print new selection
	mov EAX, FORE_COLOR + (SELECT_COLOR * 16)
	call setTextColor
	call speedSwitch
	
	RETURN:
ret
moveDownSpeed ENDP

;------------------------
speedSwitch PROC USES ECX ESI
;	Prints the appropriate speed option
; PARAMETERS:
;	EBX			--> option to print (0-4)
;------------------------
	; get offset of case table
	mov ESI, OFFSET speedTable
	mov ECX, speedSize
	
	SWITCH_LOOP:
		cmp BL, [ESI]
		jne CONT
		; execute appropriate print proc
		call NEAR PTR [ESI + 1]
		jmp BREAK
	CONT:
		add ESI, speedEntry
	LOOP SWITCH_LOOP
	
	BREAK:
ret
speedSwitch ENDP

; ******   SPEED OPTIONS   ******
; these print an option then adjust EBX
printVFast PROC USES EDX
	mov DX, speed_loc
	add DX, 0400h
	call GotoXY
	mov EDX, OFFSET vfast_opt
	call writeString
	mov EBX, 0
ret
printVFast ENDP
printFast PROC USES EDX
	mov DX, speed_loc
	add DX, 0600h
	call GotoXY
	mov EDX, OFFSET fast_opt
	call writeString
	mov EBX, 1
ret
printFast ENDP
printNormal PROC USES EDX
	mov DX, speed_loc
	add DX, 0800h
	call GotoXY
	mov EDX, OFFSET normal_opt
	call writeString
	mov EBX, 2
ret
printNormal ENDP
printSlow PROC USES EDX
	mov DX, speed_loc
	add DX, 0A00h
	call GotoXY
	mov EDX, OFFSET slow_opt
	call writeString
	mov EBX, 3
ret
printSlow ENDP
printVSlow PROC USES EDX
	mov DX, speed_loc
	add DX, 0C00h
	call GotoXY
	mov EDX, OFFSET vslow_opt
	call writeString
	mov EBX, 4
ret
printVSlow ENDP

;------------------------
endSort PROC USES EAX EBX EDX
;	If [Esc] or left arrow was hit, returns to menu.
;	Called in checkSort(), drawSwap(), and bogoDisplay()
;------------------------
	
	call readKey
	cmp AH, ESCAPE_KEY
	je RETURN
	cmp AH, LEFT_ARROW
	je RETURN
	jmp GOOD
	RETURN:
		; I tried different ways to balance the stack but ended
		; up just saving ESP in a global variable. See main()
		jmp MENU_LOOP
	GOOD:
	
ret
endSort ENDP

;------------------------
initArray PROC USES EAX ECX EDX
;	initialize byte array with values from 1 to n, n is the size of array
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	; prime loop
	mov ECX, EAX
	mov EAX, 1
	dec EDX
	
	INIT:
		mov BYTE PTR[EDX + EAX], AL
		inc EAX
	LOOP INIT

ret
initArray ENDP

;------------------------
shuffle PROC USES EAX EBX ECX EDX EDI ESI
;	Shuffles byte array
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	push sort_delay
	
	; printing [Esc] msg
	push EDX
	push EAX
	mov EAX, PADDING_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	mov DL, 1
	mov DH, CONSOLE_HEIGHT - 2
	call GotoXY
	mov EDX, OFFSET back_msg
	call WriteString
	pop EAX
	pop EDX
	
	mov EBX, OFFSET shuffle_msg
	call printMsg
	
	mov sort_delay, SHUFFLE_DELAY
	
	; EDI saves the size of the array
	mov EDI, EAX
	
	mov ECX, EAX	; prime loop
					; ECX - 1 will be used as one of the indices for swapping
	L1:
		; generate random index for swapping
		mov EAX, EDI
		call RandomRange
		mov ESI, EAX	; ESI holds index
		
		; if indices for swapping are the same, try again
		inc ESI
		cmp ESI, ECX
		je L1
		dec ESI
		
		; swapping...
		mov BL, [EDX + ECX - 1]
		mov AL, [EDX + ESI]
		mov [EDX + ECX - 1], AL
		mov [EDX + ESI], BL
		
		; draw values that were swapped
		mov index1, CL
		dec index1
		mov BX, SI
		mov index2, BL
		call drawSwap
		
	LOOP L1
	
	pop sort_delay
ret
shuffle ENDP

;------------------------
checkSort PROC USES EAX EBX ECX EDX EDI
;	Prints the entire array in green if it is in ascending order
; RETURNS:
;	ESI = 0, if array is sorted
;	ESI > 0, if array is not sorted
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	; prime loop
	mov ECX, EAX
	
	; index of bar to draw
	mov EDI, 0
	
	; ESI will stay 0 as long as the array is sorted
	mov ESI, 0
	
	; BL saves x-axis location for printing
	mov BL, BOX_LEFT_MARGIN + 1
	
	mov EAX, CHECK_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	OUTER:
		push ECX
		push EDX
		
		; prime inner loop
		movzx ECX, BYTE PTR[EDX + EDI]
		
		; if next element is smaller, ESI = ECX and ECX = 1 (not in order)
		cmp CL, BYTE PTR[EDX + EDI + 1]
		jle IN_ORDER
			
			pop EDX 	; get array offset
			pop ESI		; set ESI to the loop counter, (>0)
			
			push 1		; leave 1 one the stack for ECX so loop ends early
			push EDX
			
		IN_ORDER:
		
		; print bottom up
		mov DL, BL
		mov DH, BOX_TOP_MARGIN + BOX_HEIGHT - 1
		
		INNER:
		
			call GotoXY
			mov AL, BAR_CHAR
			call WriteChar
			
			dec DH	; move up
		LOOP INNER
		
		; move to next val
		inc EDI
		
		; skip one space between bars
		add EBX, 2
		
		mov EAX, CHECK_DELAY
		call delay
		
		pop EDX
		pop ECX
		
		; check if escape key was hit
		call endSort
	LOOP OUTER
	
ret
checkSort ENDP

;------------------------
pauseDelay PROC USES EAX
;	delay for PAUSE_DELAY milliseconds
;------------------------

	mov EAX, PAUSE_DELAY
	call delay
	
ret
pauseDelay ENDP

;------------------------
printMsg PROC USES EAX EBX EDX
;	Print info in top left corner
; PARAMETERS:
;	EBX		--> offset of string
;------------------------
	
	mov EAX, MSG_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	mov DX, SORT_MSG_LOC
	call GotoXY
	mov EDX, OFFSET clear_msg
	call WriteString
	
	mov DX, SORT_MSG_LOC
	call GotoXY
	mov EDX, EBX
	call WriteString
	
	; reset color
	mov EAX, FORE_COLOR + (BACK_COLOR * 16)
	call SetTextColor

ret
printMsg ENDP

;------------------------
printStats PROC USES EAX EDX
;	print number of comparisons and array accesses
;------------------------
	
	mov DX, CMP_LOC
	call GotoXY
	mov EAX, comparisons
	call WriteDec
	
	mov DX, ACCESSES_LOC
	call GotoXY
	mov EAX, accesses
	call WriteDec
	
ret
printStats ENDP

;------------------------
PrintArray PROC USES EAX ECX EDX EDI
;	Prints out signed byte array.
;	Elements separated by a space.
;	Used for debugging.
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------

	mov ECX, EAX	; prime loop
	mov EDI, 0		; tracks current index
	
	PRINTING:
		movsx EAX, BYTE PTR [EDX + EDI]
		call WriteInt
		
		mov AL, SPACE
		call WriteChar
		
		inc EDI
	LOOP PRINTING
	
ret
PrintArray ENDP

;------------------------
drawSwap PROC USES EAX EBX ECX EDX EDI
;	Draws values being swapped/compared
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;------------------------
	
	; if index1 == index2, return
	mov AL, index1
	cmp AL, index2
	je SKIP
	
	
; first draw in red
	mov EAX, CURRENT_COLOR + (BACK_COLOR * 16)
	call SetTextColor

	; if index2 >= ARRAY_SIZE, don't draw
	cmp index2, ARRAY_SIZE
	jge NO_INDEX2
		; draw index2
		movzx EBX, index2
		call drawBar
	NO_INDEX2:
	
	; if index1 >= ARRAY_SIZE, don't draw
	cmp index1, ARRAY_SIZE
	jge DONT_DRAW1
		; draw index2
		movzx EBX, index1
		call drawBar
	DONT_DRAW1:
	
	
; second draw in black
	mov EAX, FORE_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	; let red bar persist on screen for short time
	mov EAX, sort_delay
	call delay
	
	; if index2 >= ARRAY_SIZE, don't redraw
	cmp index2, ARRAY_SIZE
	jge SKIP_REDRAW2
		movzx EBX, index2
		call drawBar
	SKIP_REDRAW2:
	
	; if index1 >= ARRAY_SIZE, don't redraw
	cmp index1, ARRAY_SIZE
	jge SKIP_REDRAW1
		movzx EBX, index1
		call drawBar
	SKIP_REDRAW1:
	
	SKIP:
	
	; check if [Esc] was hit
	call endSort
	
ret
drawSwap ENDP

;------------------------
drawBar PROC USES EAX EBX ECX EDX
;	Draws a bar, erases anything above the bar.
;	Called by drawSwap.
; PARAMETERS:
;	EBX		--> index of bar
;------------------------
	
	; prime draw loop
	movzx ECX, BYTE PTR [EDX + EBX]
	
	mov EAX, ARRAY_SIZE
	
	; (ARRAY_SIZE - current value) = # of spaces to draw
	sub AL, CL
	jnz DONT_ERASE
		; ensures that erase loop has ECX > 0
		inc EAX
	DONT_ERASE:
	
	; EAX will be popped into ECX for erase loop
	push EAX
	
	; find x loc
	mov DL, BL
	shl DL, 1 ; DL * 2
	add DL, BOX_LEFT_MARGIN + 1
	
	; draw bottom up
	mov DH, BOX_TOP_MARGIN + BOX_HEIGHT - 1
	
	DRAWLINE:
	
		call GotoXY
		mov AL, BAR_CHAR
		call WriteChar
		
		dec DH	; move up one
	LOOP DRAWLINE
	
	; prime erase loop
	pop ECX
	
	DRAWSPACE:
	
		call GotoXY
		mov AL, SPACE
		call WriteChar
		
		dec DH	; move up one
	LOOP DRAWSPACE
	
ret
drawBar ENDP

;------------------------
drawPivot PROC USES EAX ECX EDX
;	Draws the pivot for quicksort / max for selection sort
; PARAMETERS:
;	EAX		--> index of bar
;------------------------
	
	; prime loop
	movzx ECX, BYTE PTR [EDX + EAX]
	
	; calculate x loc
	mov DL, AL
	shl DL, 1	; DL * 2
	add DL, BOX_LEFT_MARGIN + 1
	
	; draw bottom up
	mov DH, BOX_TOP_MARGIN + BOX_HEIGHT - 1
	
	mov EAX, PIVOT_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	DRAWLINE:
	
		call GotoXY
		mov AL, BAR_CHAR
		call WriteChar
		
		dec DH	; move up one
	LOOP DRAWLINE
	
	; reset color
	mov EAX, FORE_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
ret
drawPivot ENDP

;------------------------
erasePivot PROC USES EAX EBX ECX EDX
;	Redraws (in black) the pivot for quicksort / max for selection sort
; PARAMETERS:
;	EAX		--> index of pivot
;------------------------
	
	; prime loop
	movzx ECX, BYTE PTR [EDX + EAX]
	
	; calculate x loc
	mov DL, AL
	shl DL, 1	; DL * 2
	add DL, BOX_LEFT_MARGIN + 1
	
	; draw bottom up
	mov DH, BOX_TOP_MARGIN + BOX_HEIGHT - 1
	
	mov EAX, FORE_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	DRAWLINE:
	
		call GotoXY
		mov AL, BAR_CHAR
		call WriteChar
		
		dec DH
	LOOP DRAWLINE
	
ret
erasePivot ENDP

;------------------------
bubbleSort PROC USES EAX EDX
;	Sorts byte array via bubble sort
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------

	mov EBX, OFFSET bubble_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses,    0
	
	; loop runs n times
	mov ECX, EAX
	
	OUTER:
		push ECX
		
		mov ESI, 0	; ESI = j
		
		; prime inner loop
		; if ECX == 0 inner loop won't work
		cmp ECX, 1
		je GOOD
			dec ECX
		GOOD:
		
		INNER:
			
			; print comparisons and array accesses
			call printStats
			
			; if (array[j] <= array[j+1]), don't swap
			inc comparisons
			add accesses, 2
			mov BL, [EDX + ESI]
			cmp BL, [EDX + ESI + 1]
			jle NO_SWAP
			
				add accesses, 3
				mov AL, [EDX + ESI + 1]
				mov [EDX + ESI], AL
				mov [EDX + ESI + 1], BL
				
				; draw values being swapped
				mov BX, SI
				mov index1, BL
				mov index2, BL
				inc index2
				call drawSwap

			NO_SWAP:
			
			inc ESI	; j++
			
		LOOP INNER
		
		pop ECX
	LOOP OUTER
	
	; print comparisons and array accesses
	call printStats
	
ret
bubbleSort ENDP

;------------------------
cocktailSort PROC USES EAX EBX ECX EDX EDI
;	Sort byte array via cocktail shaker sort
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------

	mov EBX, OFFSET cocktail_msg
	call printMsg
	
	dec EAX		; EAX = right
	mov EDI, 0	; EDI = left
	
	; reset variables
	mov comparisons, 0
	mov accesses,    0
	
	
	OUTER:
		; Loops until (left >= right)
		inc comparisons
		cmp EDI, EAX
		jge BREAK
		
		; inner loop runs (left - right) times
		mov ECX, EAX
		sub ECX, EDI
		
		push EDI
		push EAX
		push ECX
		; right pass moves the larger values to the right
		PASS_RIGHT:
			
			; print comparisons and array accesses
			call printStats
			
			; if next element is smaller, swap
			inc comparisons
			add accesses, 2
			mov BL, [EDX + EDI]
			cmp BL, [EDX + EDI + 1]
			jle NO_SWAP_RIGHT
			
				add accesses, 3
				mov AL, [EDX + EDI + 1]
				mov [EDX + EDI], AL
				mov [EDX + EDI + 1], BL
				
				; draw values being swapped
				mov BX, DI
				mov index1, BL
				mov index2, BL
				inc index2
				call drawSwap
				
			NO_SWAP_RIGHT:
			
			inc EDI
		LOOP PASS_RIGHT
		
		
		; prime next loop
		pop ECX
		; left pass moves smaller values left
		PASS_LEFT:
			
			; print comparisons and array accesses
			call printStats
			
			; if next element is larger, swap
			inc comparisons
			add accesses, 2
			mov BL, [EDX + EDI]
			cmp BL, [EDX + EDI - 1]
			jge NO_SWAP_LEFT
			
				add accesses, 3
				mov AL, [EDX + EDI - 1]
				mov [EDX + EDI], AL
				mov [EDX + EDI - 1], BL
				
				; draw values being swapped
				mov BX, DI
				mov index1, BL
				mov index2, BL
				dec index2
				call drawSwap
				
			NO_SWAP_LEFT:
			
			dec EDI
		LOOP PASS_LEFT
		
		pop EAX
		pop EDI
		
		dec EAX	; right++
		inc EDI	; left--

	jmp OUTER
	
	
	BREAK:
	
	; print comparisons and array accesses
	call printStats
	
ret
cocktailSort ENDP

;------------------------
combSort PROC USES EAX EBX ECX EDX EDI ESI
;	sort array via comb sort.
;	reduces interval size by a factor of 1.3 each iteration
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------

	mov EBX, OFFSET comb_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses, 0
	
	; EBX = i
	; EDI = sorted (bool)
	; ESI = gap

	mov ESI, EAX ; gap = size
	mov EDI, 0 ; sorted = false
	
	; while (gap != 1 || !sorted)
	OUTER:
		; if (gap != 1), loop runs
		inc comparisons
		cmp ESI, 1
		jne GOOD
		
		; if (sorted == true), break
		inc comparisons
		cmp EDI, 1
		je BREAK
		
		; if gap == 1, don't reduce gap
		jmp SAME_GAP
		GOOD:
			push EDX
			push EAX
			
			; the following amounts to floor(gap /= 1.3)
			mov EAX, ESI
			shl ESI, 3
			shl EAX, 1
			add EAX, ESI	; gap = gap * 10	
			
			xor EDX, EDX ; reset EDX
			mov ECX, 13
			div ECX		; gap = gap / 13
			mov ESI, EAX
			
			pop EAX
			pop EDX
		SAME_GAP:
		
		; sorted = true
		mov EDI, 1
		
		; i = 0
		mov EBX, 0
		
		; inner loop runs (size - gap) times
		mov ECX, EAX
		sub ECX, ESI
		
		push EAX
		
		INNER:
			push ECX
			
			; print comparisons and array accesses
			call printStats
			
			; if (array[i] > array[i+gap]), swap
			inc comparisons
			add accesses, 2
			mov EAX, EBX
			add EAX, ESI
			mov CL, [EDX + EAX]
			mov CH, [EDX + EBX]
			cmp CH, CL
			jle NO_SWAP
				; swapping...
				add accesses, 2
				mov [EDX + EAX], CH
				mov [EDX + EBX], CL
				
				; sorted = false
				mov EDI, 0
			NO_SWAP:
			
			; draw values being compared/swapped
			mov index1, AL
			mov index2, BL
			call drawSwap
			
			inc EBX	; i++
			
			pop ECX
		LOOP INNER
		
		pop EAX
		
		; print comparisons and array accesses
		call printStats
		
	jmp OUTER
	
	BREAK:

ret
combSort ENDP

;------------------------
selectionSort PROC USES EAX EBX ECX EDX EDI ESI
;	sort byte array via selection sort (find max)
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	mov EBX, OFFSET selection_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses,    0
	mov index1, 	 ARRAY_SIZE
	mov index2, 	 ARRAY_SIZE
	
	; EBX = current max
	mov EBX, 0
	
	; outer loops executes n - 1 times
	mov ECX, EAX
	dec ECX
	
	; makes sure array has 2 or more elements
	cmp ECX, 0
	jg GOOD
	ret
	GOOD:
	
	OUTER:
		; inner loop uses same ECX
		push ECX
		
		mov EDI, 1		; EDI = j
		mov ESI, 0		; ESI = index of current max
		
		add accesses, 4
		mov BL, [EDX]	; BL = current max
		mov EAX, 0
		call drawPivot
		
		INNER:
			push ECX
			
			; print comparisons and array accesses
			call printStats
			
			; draw bar being compared to current max
			mov ECX, EDI
			mov index1, CL
			call drawSwap
			
			; if (max >= array[j]), don't change the max
			inc accesses
			inc comparisons
			mov CL, [EDX + EDI]
			cmp BL, CL
			jge SAME_MAX
				; max changes:
				call erasePivot
				
				; EAX tracks index of pivot for erasing and drawing
				mov EAX, EDI
				
				; update max and index of max
				mov BL, CL
				mov ESI, EDI
				call drawPivot
				
			SAME_MAX:
			
			;call drawPivot
			
			inc EDI	; j++
			
			pop ECX
		LOOP INNER
		
		; retrieve counter for outer loop
		pop ECX
		
		call erasePivot
		
		; swap (array[ECX], array[ESI])
		mov AL, [EDX + ECX]
		mov [EDX + ECX], BL
		mov [EDX + ESI], AL
		
		; draw values being compared/accessed
		mov index1, CL
		mov BX, SI
		mov index2, BL
		call drawSwap
		
		; reset
		mov index1, ARRAY_SIZE
		mov index2, ARRAY_SIZE
	
	; jump is too big for LOOP keyword
	dec ECX
	jnz OUTER

	; print comparisons and array accesses
	call printStats
	
ret
selectionSort ENDP

;------------------------
InsertionSort PROC USES EAX EBX ECX EDX EDI ESI
;	Uses insertion sort (with sequential search) to sort a byte array
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------

	mov EBX, OFFSET insertion_msg
	call printMsg
	
	; reset variables
	mov index2, 	 ARRAY_SIZE
	mov comparisons, 0
	mov accesses,    0
	
	; outer loops executes n - 1 times
	mov ECX, EAX
	dec ECX
	
	; make sure there is at least 2 elements
	cmp ECX, 0
	jg GOOD
	ret
	GOOD:
	
	; EDI tracks the rightmost index of the sorted portion
	mov EDI, 1
	
	; OUTER loops n - 1 times
	OUTER:
		push ECX
		
		; BL acts as temp storage to save the key
		inc accesses
		mov BL, [EDX + EDI]
		
		; ESI will iterate through the sorted portion of the array in INNER
		mov ESI, EDI
		
		; prime loop counter starting at the right end of the sorted portion
		mov ECX, EDI
		INNER:
			
			; print comparisons and array accesses
			call printStats
			
			; value to compare with key
			inc accesses
			mov AL, [EDX + ESI - 1]
			
			; if key is larger or equal, break
			inc comparisons
			cmp AL, BL
			jle BREAK
			
			; otherwise, move value right by 1
			inc accesses
			mov [EDX + ESI], AL
			
			; draw value being compared to key
			push EBX
			mov EBX, ESI
			mov index1, BL
			call drawSwap
			pop EBX
			
			dec ESI
			
		LOOP INNER
		
		
		BREAK:
		
		; if INNER broke on first iteration, ESI == EDI so key doesn't move
		inc comparisons
		cmp ESI, EDI
		je NO_SWAP
			; move key into new location
			inc accesses
			mov [EDX + ESI], BL
		NO_SWAP:
		
		; draw key
		mov EBX, ESI
		mov index1, BL
		call drawSwap
		
		; reset
		mov index1, ARRAY_SIZE
		
		; increase the size of the sorted portion
		inc EDI
		
		pop ECX
	LOOP OUTER
	
	; print comparisons and array accesses
	call printStats
	
ret
InsertionSort ENDP

;------------------------
shellSort PROC USES EAX EBX ECX EDX EDI ESI
;	sort array via shell sort (insertion method)
;	reduces interval size by half each iteration
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	mov EBX, OFFSET shell_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses, 0
	mov index1, ARRAY_SIZE
	mov index2, ARRAY_SIZE
	
	; EBX = i
	; EDI = gap
	; ESI = temp
	
	mov EDI, EAX ; gap = size
	
	
	OUTER:
		inc comparisons
		shr EDI, 1 ; gap /= 2
		cmp EDI, 0 ; if (gap <= 0), break
		jle SORTED
		
		; inner loop runs (size - gap) times
		mov ECX, EAX
		sub ECX, EDI
		
		; i = gap
		mov EBX, EDI
		
		; EAX = j hereafter
		push EAX
		
		INNER:
			call printStats
			
			; preserve (i) and loop counter
			push ECX
			push EBX
			
			; temp = array[i]
			inc accesses
			movzx ESI, BYTE PTR[EDX + EBX]
			
			; j = i
			mov EAX, EBX
			
			INSERT_LOOP:
				; prints comparisons and array accesses
				call printStats
				
				; draw values being accessed (setup lower down)
				call drawSwap
				
				; if (j < gap), break
				inc comparisons
				cmp EAX, EDI
				jl INSERT_BREAK
				
				; if (array[j-gap] <= temp), break
				inc comparisons
				inc accesses
				mov ECX, ESI
				mov EBX, EAX
				sub EBX, EDI
				cmp [EDX + EBX], CL
				jle INSERT_BREAK
				
				; array[j] = array[j - gap]
				add accesses, 2
				mov CL, [EDX + EBX]
				mov [EDX + EAX], CL
				
				; setup for drawSwap proc
				mov index1, BL
				mov index2, AL
				
				sub EAX, EDI ; j -= gap
				
			jmp INSERT_LOOP
			INSERT_BREAK:
			
			; array[j] = temp
			inc accesses
			mov ECX, ESI
			mov [EDX + EAX], CL
			
			
			pop EBX
			
			; draw values being accessed
			mov index1, BL
			mov index2, AL
			call drawSwap

			inc EBX
			pop ECX
			
		LOOP INNER
		pop EAX
	jmp OUTER
	
	SORTED:
	call printStats
ret
shellSort ENDP

;------------------------
quickSort PROC USES EAX EBX ECX EDX EDI ESI
;	This proc simply sets up arguments for quickSortHelp.
;	Call this proc from main.
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	mov EBX, OFFSET quick_msg
	call printMsg
	
	mov comparisons, 0
	mov accesses, 0
	
	dec EAX		; EAX = high
	mov EBX, 0	; EBX = low
	
	; call recursive helper
	call quickSortHelp
	
ret
quickSort ENDP

;------------------------
quickSortHelp PROC
;	sort byte array via quick sort
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> high
;	EBX		--> low
;------------------------
	
	; if (high <= low) then return
	inc comparisons
	cmp EAX, EBX
	jle RETURN
		
		; this proc returns ESI -> partition index
		call partition
		
		; EAX will be popped from the stack on the way back up
		push EAX
		
		; arguments for 1st recursive call: (low, pi - 1)
		; ESI -> partition index, returned by partition proc
		mov EAX, ESI
		dec EAX
		
		call quickSortHelp
		
		
		; arguments for 2nd recursive call: (pi + 1, high)
		mov EBX, ESI
		inc EBX

		pop EAX	; retrieve high from the stack
		
		call quickSortHelp
		
		; print comparisons and array accesses
		call printStats
		
	RETURN:
	
ret
quickSortHelp ENDP

;------------------------
partition PROC USES EAX EBX ECX EDX
;	Partitions array based on the pivot.
;	Pivot is always the last element in the subarray
;	Returns the index where all elements to the left are smaller than the
;	pivot, and all elements to the right are larger.
;
;	Called by quickSortHelp
; RETURNS:
;	ESI		--> partition index
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> high
;	EBX		--> low
;------------------------
	; EDI = j , iterates from (low) to (high - 1)
	; ESI = i , index of the rightmost element in the left subarray (smaller side)
	; EAX = high
	; EBX = low
	
	; loop runs (high - low) times
	mov ECX, EAX
	sub ECX, EBX
	
	; from here on EAX will be the value of the pivot
	push EAX
	
	; pivot = array[high]
	call drawPivot
	inc accesses
	mov AL, [EDX + EAX]
	
	; j = low
	mov EDI, EBX
	
	; i = (low - 1)
	mov ESI, EBX
	dec ESI
	
	L1:
		; CL is used as temp storage for swapping
		push ECX
		
		; print comparisons and array accesses
		call printStats
		
		; if (pivot <= array[j]), don't swap
		inc accesses
		inc comparisons
		mov CL, [EDX + EDI]
		cmp AL, CL
		jle NO_SWAP
		
			inc ESI	; i++
			
			; swap(array[j], array[i])
			add accesses, 3
			mov BL, [EDX + ESI]
			mov [EDX + ESI], CL
			mov [EDX + EDI], BL
			
		NO_SWAP:
		
		; working with byte values...
		mov ECX, EDI
		mov index1, CL
		mov ECX, ESI
		mov index2, CL
		
		; if CL was -1, don't draw index2
		cmp index2, 0FFh
		jne DRAW_INDEX2
			mov index2, ARRAY_SIZE
		DRAW_INDEX2:
		
		; draw values being accessed/compared
		call drawSwap
		
		inc EDI	; j++
		
		pop ECX
	LOOP L1
	
	; EAX = high
	pop EAX
	call erasePivot
	
	inc ESI	; i++
	
	; skip swap if EAX == ESI
	inc comparisons
	cmp ESI,EAX
	jge DONT_SWAP
		
		; swap(array[i], array[high])
		add accesses, 4
		mov CL, [EDX + EAX]
		mov BL, [EDX + ESI]
		mov [EDX + EAX], BL
		mov [EDX + ESI], CL
	DONT_SWAP:
	
	; draw values being accessed/compared
	mov index1, AL
	mov ECX, ESI
	mov index2, CL
	call drawSwap
	
ret
partition ENDP

;------------------------
mergeSort PROC USES EAX EBX ECX EDX EDI ESI
;	Sets up mergeSortHelp
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of byte array
;------------------------
	
	mov EBX, OFFSET merge_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses, 0
	
	mov EBX, EAX
	dec EBX
	mov EAX, 0
	
	; mergeSortHelp(array, 0, size-1)
	call mergeSortHelp
	
ret
mergeSort ENDP

;------------------------
mergeSortHelp PROC
;	Recursive function. Keeps splitting the array into halves until it can't.
;	Then it merges neighbouring subarrays together with the merge proc.
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> left
;	EBX		--> right
;------------------------
	
	; if (right <= left), return
	cmp EBX, EAX
	jle RETURN
	; else
		; mid = (left + right) / 2
		push EAX
		add EAX, EBX
		shr EAX, 1
		mov mid, EAX
		pop EAX
		
		push mid
		push EBX
		mov EBX, mid
			; mergeSortHelp(array, left, mid)
			call mergeSortHelp
		pop EBX
		pop mid
		
		push mid
		push EAX
		mov EAX, mid
		inc EAX
			; mergeSortHelp(array, mid+1, right)
			call mergeSortHelp
		pop EAX
		pop mid
		
		; merge(array, left, right, mid)
		call merge
		
	RETURN:
ret
mergeSortHelp ENDP

;------------------------
merge PROC USES EAX EBX
;	Merges two sub arrays
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> left
;	EBX		--> right
;------------------------
	
	; draw mid
	push EAX
	mov EAX, mid
	call drawPivot
	pop EAX
	
	
	; ESI = j, EDI = i
	
	mov EDI, EAX	; i = left
	mov ESI, mid	; j = mid + 1
	inc ESI
	
	; EAX = k	until after merge
	push EAX
	
	; while (i <= mid && j <= right)
	L1:
		call printStats
		
	; if (i > mid or j > right), break
		add comparisons, 2
		cmp EDI, mid
		jg BREAK
		cmp ESI, EBX
		jg BREAK
		
	; if (array[i] <= array[j])
		add accesses, 2
		inc comparisons
		mov CL, [EDX + EDI]
		cmp CL, [EDX + ESI]
		jg GOTO_ELSE
			; tmpArray[k] = array[i]
			inc accesses
			mov [tmpArray + EAX], CL
			inc EDI	; i++
			jmp GOTO_END
	; else
		GOTO_ELSE:
			; tmpArray[k] = array[j]
			add accesses, 2
			mov CL, [EDX + ESI]
			mov [tmpArray + EAX], CL
			inc ESI	; j++
		GOTO_END:
		
		inc EAX	; k++
		
		; draw values being moved
		push EBX
		mov EBX, EDI
		mov index2, BL
		mov EBX, ESI
		mov index1, BL
		call drawSwap
		pop EBX
		
	jmp L1
	
	BREAK:
	
	; while (i <= mid)
	APPEND_LEFT:
		; if (i > mid), break
		inc comparisons
		cmp EDI, mid
		jg BREAK_LEFT
		
		; tmpArray[k] = array[i]
		add accesses, 2
		mov CL, [EDX + EDI]
		mov [tmpArray + EAX], CL
		
		inc EDI	; i++
		inc EAX	; k++
		
	jmp APPEND_LEFT
	BREAK_LEFT:
	
	
	; while (j <= right)
	APPEND_RIGHT:
		; if (j > right), break
		inc comparisons
		cmp ESI, EBX
		jg BREAK_RIGHT
		
		; tmpArray[k] = array[j];
		add accesses, 2
		mov CL, [EDX + ESI]
		mov [tmpArray + EAX], CL
		
		inc ESI	; j++
		inc EAX	; k++
		
	jmp APPEND_RIGHT
	BREAK_RIGHT:
	
	; dont draw index2 anymore
	mov index2, ARRAY_SIZE
	
	; next loop runs (k - left) times
	mov ECX, EAX
	
	mov EAX, mid
	call erasePivot
	
	pop EAX
	sub ECX, EAX
	
	; copys portion of tmpArray to array
	COPY_L:
	
		add accesses, 2
		mov BL, [tmpArray + EAX]
		mov [EDX + EAX], BL
		
		mov index1, AL
		call drawSwap
		
		inc EAX
		
		; print comparisons and array accesses
		call printStats
		
	LOOP COPY_L
	
ret
merge ENDP

;------------------------
heapSort PROC USES EAX EBX ECX EDX EDI
;	Sort byte array via heap sort
;	Uses heapify and siftDown procs
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	mov EBX, OFFSET heap_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses, 0

	; convert array to max heap, takes O(n) time
	call heapify

	; ECX = i
	; EAX = start
	; EDI = end
	; EBX used as temp storage
	
	; loop runs (n-1) times
	mov ECX, EAX
	dec ECX
	
	L1:
		push ECX
		
		; swap(array[0], array[i])
		add accesses, 4
		mov BL, [EDX]
		mov BH, [EDX + ECX]
		mov [EDX], BH
		mov [EDX + ECX], BL
		
		; draw values being swapped
		mov index1, 0
		mov index2, CL
		call drawSwap
		
		pop ECX
		
		; siftDown(array, 0, i-1)
		mov EAX, 0
		mov EDI, ECX
		dec EDI
		call siftDown
		
		; print comparisons and array accesses
		call printStats
		
	LOOP L1
	
ret
heapSort ENDP

;------------------------
heapify PROC USES EAX EDI
;	transforms byte array into max heap
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	; EDI = end
	; EAX = start
	
	; end = n-1
	dec EAX
	mov EDI, EAX
	
	; start = (end-1)/2
	shr EAX, 1
	
	; while (start >= 0)
	HEAPING:
	
		; if (start < 0), break
		inc comparisons
		cmp EAX, 0
		jl BREAK
		
		; siftDown(array, start, end)
		call siftDown
		
		dec EAX ; start--

	jmp HEAPING
	
	BREAK:

ret
heapify ENDP

;------------------------
siftDown PROC USES EAX EBX ECX EDX
;	Called by heapify and heapSort procs
;	Moves element down the tree to satisfy max heap property
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> root (element to sift)
;	EDI		--> end (end of array to sift through)
;------------------------
	
	; EAX = root
	; ECX = child
	; EDI = end
	; EBX used as temp storage

	SIFT:
	
		; child = (2*root) + 1
		mov ECX, EAX
		shl ECX, 1		
		inc ECX
		
		; if (child > end), break
		inc comparisons
		cmp ECX, EDI
		jg BREAK
		
		; if (child+1 <= end && array[child] < array[child+1]), child = child + 1
		inc comparisons
		inc accesses
		mov BL, [EDX + ECX]
		inc ECX
		cmp ECX, EDI	; if (child+1 > end), there is no right child
		jg LEFT_CHILD
		
		inc comparisons
		inc accesses
		cmp BL, [EDX + ECX]	; if (array[child] >= array[child+1]), keep left child
		jge LEFT_CHILD
			inc accesses
			mov BL, [EDX + ECX]
			jmp RIGHT_CHILD
		LEFT_CHILD:
		dec ECX
		RIGHT_CHILD:
		
		; if (array[root] >= array[child]), don't swap
		inc comparisons
		inc accesses
		mov BH, [EDX + EAX]
		cmp BH, BL
		jge NO_SWAP
			; swapping...
			add accesses, 2
			mov [EDX + EAX], BL
			mov [EDX + ECX], BH
			
			; draw values being swapped
			mov index1, AL
			mov index2, CL
			call drawSwap
			
			; root = child
			mov EAX, ECX
			jmp NO_RET
		NO_SWAP:
		
		; else return
		ret
		
		NO_RET:
		
		; print comparisons and array accesses
		call printStats
		
	jmp SIFT
	
	BREAK:
	
ret
siftDown ENDP

;------------------------
radixSort PROC USES EAX ECX EDX EDI ESI
;	Sorts byte array via radixSort
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	mov EBX, OFFSET radix_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses, 0
	mov index2, ARRAY_SIZE
	
	; returns EDI = max value
	call getMax
	
	; ESI = exp
	mov ESI, 1
	
	; for (exp = 1; m/exp > 0; exp *= 10)
	L1:
		push EAX
		push EDX
		
		; if (m/exp == 0), break
		xor EDX, EDX ; reset remainder
		mov EAX, EDI
		div ESI
		cmp EAX, 0
		jle BREAK
		
		pop EDX
		pop EAX
		
		; countSort(array, n, exp)
		call countSort
		
		push EAX
		push EDX
		
		; exp *= 10
		mov EAX, ESI
		shl EAX, 3
		shl ESI, 1
		add ESI, EAX
		
		pop EDX
		pop EAX
		
	jmp L1
	
	BREAK:
	
	; balance stack
	pop EDX
	pop EAX

ret
radixSort ENDP

;------------------------
countSort PROC USES EAX EBX ECX EDX EDI ESI
;	called by radixSort proc
;	counting sort based on a given digit
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;	ESI		--> exp
;------------------------
	
	; EBX = i
	mov EBX, 0
	
	; reset loop sets all values in countArray[] to 0
	mov ECX, 10
	RESET_LOOP:
		inc accesses
		mov [countArray + EBX], 0
		inc EBX ; i++
	LOOP RESET_LOOP
	
	; EDI = offset of base array
	mov EDI, EDX
	
	; EBX = i
	mov EBX, 0
	
	; count loop runs (n) times
	mov ECX, EAX
	push ECX
	COUNT_LOOP:
		push ECX
		add accesses, 2
		
		; countArray[ (array[i] / exp) % 10 ]++ {
			xor EDX, EDX ; reset remainder
			movzx EAX, BYTE PTR[EDI + EBX]
			div ESI
			
			xor EDX, EDX
			mov ECX, 10
			div ECX ; now EDX contains remainder
			inc [countArray + EDX]
		; }
		
		inc EBX ; i++
		
		pop ECX
	LOOP COUNT_LOOP
	
	; EBX = i
	mov EBX, 1
	
	; ACCUMULATE_LOOP adjusts countArray[i] so it contains the position of the
	; digit i for tmpArray[]
	mov ECX, 9
	ACCUMULATE_LOOP:
		
		add accesses, 2
		
		; countArray[i] += countArray[i - 1] {
			dec EBX
			mov AL, [countArray + EBX]
			inc EBX
			add [countArray + EBX], AL
		; }
		
		inc EBX
	LOOP ACCUMULATE_LOOP
	
	; ECX = n
	pop ECX
	push ECX
	; for (int i = n-1; i >= 0; i--)
	BUILD_LOOP:
		push ECX
		add accesses, 4
		
		; ECX = i
		dec ECX
		
		; tmpArray[ countArray[ (array[i]/exp) % 10 ] - 1 ] = array[i] {
			xor EDX, EDX ; reset remainder
			movzx EAX, BYTE PTR[EDI + ECX]
			div ESI
			
			xor EDX, EDX
			mov EBX, 10
			div EBX ; now EDX contains remainder
			movzx EAX, BYTE PTR[countArray + EDX]
			dec EAX
			
			movzx EBX, BYTE PTR[EDI + ECX]
			mov [tmpArray + EAX], BL
		; }
		
		; countArray[ (array[i]/exp) % 10 ]--
		dec [countArray + EDX]
		
		pop ECX
	LOOP BUILD_LOOP
	
	
	; i = 0
	mov EBX, 0
	
	; ECX = n
	pop ECX
	
	; Copy tmpArray into base array
	COPY_LOOP:
		add accesses, 2
		mov AL, [tmpArray + EBX]
		mov [EDI + EBX], AL
		
		; draw value being inserted
		mov EDX, EDI
		mov index1, BL
		call drawSwap
		
		; print comparisons and array accesses
		call printStats
		
		inc EBX ; i++
	LOOP COPY_LOOP
	
ret
countSort ENDP

;------------------------
getMax PROC USES EAX EBX ECX
;	called by radixSort proc
;	get max value in array
; RETURNS:
;	EDI = max value
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------

	; EDI = max
	inc accesses
	movzx EDI, BYTE PTR[EDX]
	
	; loop runs (size - 1) times
	mov ECX, EAX
	dec ECX
	
	; EBX is index
	mov EBX, 1

	FIND_MAX:
		inc accesses
		inc comparisons
		
		movzx EAX, BYTE PTR[EDX + EBX]
		cmp EAX, EDI
		jle SAME_MAX
			; new max
			movzx EDI, AL
		SAME_MAX:
		
		inc EBX
	LOOP FIND_MAX
	
ret
getMax ENDP

;------------------------
pigeonholeSort PROC USES EAX EBX ECX EDX EDI
;	sorts byte array via pigeon hole sort
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	mov EBX, OFFSET pigeon_msg
	call printMsg
	
	; reset variables
	mov comparisons, 0
	mov accesses, 0
	mov index2, ARRAY_SIZE
	
	; RESET_PIGEON initializes all values in pigeonArray[] to 0
	mov EBX, 0
	mov ECX, ARRAY_SIZE
	RESET_PIGEON:
		mov [pigeonArray + EBX], 0
		inc EBX
	LOOP RESET_PIGEON
	
	
	; EBX = index of base array
	; EDI = index of aux array
	
	mov EBX, 0
	
	; loop runs (n) times
	mov ECX, EAX
	
	COUNTING:
		add accesses, 2
		
		movzx EDI, BYTE PTR[EDX + EBX]
		dec EDI
		
		; draw value being inserted into aux array
		mov index1, BL
		call drawSwap
		
		inc [pigeonArray + EDI]
		
		inc EBX
		
		; print comparisons and array accesses
		call printStats
		
	LOOP COUNTING
	
	
	; EBX = index of base array
	; EAX = index of aux array
	; EDI = size of array
	
	mov EBX, 0
	mov EDI, EAX
	mov EAX, 0
	
	; while(x < n)
	OUTER:
		; if (x >= n), break
		cmp EBX, EDI
		jge BREAK
		
		inc accesses
		movzx ECX, BYTE PTR[pigeonArray + EAX]
		
		INNER:
			inc accesses
			inc EAX
			mov [EDX + EBX], EAX
			dec EAX
			
			; draw value being inserted into base array
			mov index1, BL
			call drawSwap
			
			inc EBX
			
		LOOP INNER
		
		inc EAX
		
		; print comparisons and array accesses
		call printStats
		
	jmp OUTER
	
	BREAK:
	
ret
pigeonholeSort ENDP

;------------------------
bogoSort PROC USES EAX EBX ECX EDX EDI ESI
;	Sorts byte array via BOGO sort
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	; Reset variables
	mov comparisons, 0
	mov accesses,    0
	
	mov EDI, EAX	; EDI stores size of array from here on
	
	; BOGO loops until the sorted array is generated
	BOGO:
		
		; clear screen and reprint bogo_msg
		call CLRSCR
		mov EBX, OFFSET bogo_msg
		call printMsg
		
		; printing [Esc] msg
		push EDX
		push EAX
		mov EAX, PADDING_COLOR + (BACK_COLOR * 16)
		call SetTextColor
		mov DL, 1
		mov DH, CONSOLE_HEIGHT - 2
		call GotoXY
		mov EDX, OFFSET back_msg
		call WriteString
		; fix color
		mov EAX, FORE_COLOR + (BACK_COLOR * 16)
		call SetTextColor
		pop EAX
		pop EDX
		
		mov ECX, EDI	; prime loop
						; ECX - 1 will be used as one of the indices for swapping
		L1:
			; generate random index for swapping
			mov EAX, EDI
			call RandomRange
			mov ESI, EAX
			
			; swapping...
			add accesses, 4
			mov BL, [EDX + ECX - 1]
			mov AL, [EDX + ESI]
			mov [EDX + ECX - 1], AL
			mov [EDX + ESI], BL
			
			; prints comparisons and array accesses
			call printStats
			
		LOOP L1
		
		; next 2 function calls take EAX as array size parameter
		mov EAX, EDI
		call bogoDisplay	; draw bar graph
		call checkSort		; check if sorted
		
		; checkSort returns ESI = 0 if array is sorted
		cmp ESI, 0
		je SORTED
		
		; add some delay between each permutation
		mov EAX, sort_delay
		call delay
		
	jmp BOGO
	
	SORTED:
	; BOGO sort has an average time complexity of O(n*n!).
	; The probably of generating the sorted sequence with one permutation is 1/n!.
	; For 50 elements that is 1 in 3.04e+64 chance for each permutation
ret
bogoSort ENDP

;------------------------
bogoDisplay PROC USES EAX EBX ECX EDX EDI
;	Draws the array in red then black.
;	Called by bogoSort.
; PARAMETERS:
;	EDX		--> offset of first element in byte array
;	EAX		--> size of array
;------------------------
	
	mov ECX, EAX	; prime ECX for outer loops
	push ECX		; save ECX for printing in black
	mov EDI, 0		; EDI stores current index to draw
	
	; BL tracks where to print bar in X-axis
	mov BL, BOX_LEFT_MARGIN + 1
	
	; first draw in red
	mov EAX, CURRENT_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	OUTER_RED:
		push ECX	; save loop counter
		push EDX	; save array offset
		
		; prime inner loop
		movzx ECX, BYTE PTR[EDX + EDI]

		; draw from the bottom up
		mov DL, BL
		mov DH, BOX_TOP_MARGIN + BOX_HEIGHT - 1
		
		INNER_RED:
		
			call GotoXY
			mov AL, BAR_CHAR
			call WriteChar
			
			dec DH	; move up one
			
		LOOP INNER_RED
		
		inc EDI		; move to next element
		add EBX, 2	; move right 2 spaces
		
		pop EDX		; retrieve array offset
		pop ECX
		
		; check if escape was hit
		call endSort
	LOOP OUTER_RED
	
	
	pop ECX			; prime next loop
	mov EDI, 0		; EDI stores current index to draw
	
	; BL tracks where to print bar in X-axis
	mov BL, BOX_LEFT_MARGIN + 1
	
	; draw in black
	mov EAX, FORE_COLOR + (BACK_COLOR * 16)
	call SetTextColor
	
	OUTER_BLACK:
		push ECX	; save loop counter
		push EDX	; save array offset
		
		; prime inner loop
		movzx ECX, BYTE PTR[EDX + EDI]

		; draw from the bottom up
		mov DL, BL
		mov DH, BOX_TOP_MARGIN + BOX_HEIGHT - 1
		
		INNER_BLACK:
		
			call GotoXY
			mov AL, BAR_CHAR
			call WriteChar
			
			dec DH	; move up one
			
		LOOP INNER_BLACK
		
		inc EDI		; move to next element
		add EBX, 2	; move right 2 spaces
		
		pop EDX		; retrieve array offset
		pop ECX
	LOOP OUTER_BLACK

ret
bogoDisplay ENDP
END main