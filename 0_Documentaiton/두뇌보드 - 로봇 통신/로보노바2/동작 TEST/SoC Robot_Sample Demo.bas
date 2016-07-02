'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 보행순서 AS BYTE


PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번 그룹사용 설정
DIR G6B,1,1,1,1,1,1		'모터6~11번 그룹사용 설정
DIR G6C,0,0,0,0,0,0		'모터12~17번 그룹사용 설정
DIR G6D,0,1,1,0,1,0		'모터18~23번 그룹사용 설정

'************************************************
'ZERO G6A, 100,100,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,100,100,100,100
'ZERO G6D, 100,100,100,100,100,100

'****** 로봇1 ***********************************
'ZERO G6A, 101, 100, 97,102,99,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C,  98, 98, 95,100,100,100
'ZERO G6D,  97, 98,101,101,102,100
'
'****** 로봇2 ***********************************
'ZERO G6A, 100, 99, 97,102,101,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C,  98, 98, 95,100,100,100
'ZERO G6D,  97, 98,101,100,102,100
'****** 로봇3 ***********************************
'ZERO G6A,  99, 98,100,101,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  97, 99,100,100,102,100
'****** 로봇4 ***********************************
'ZERO G6A,  99, 99, 98,102,102,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,97,100,100,100
'ZERO G6D,  99,100,100,100,102,100

'****** 로봇5 ***********************************
'ZERO G6A,  99, 98,100,102,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  98, 99,102,100,101,100
'****** 로봇6 ***********************************
'ZERO G6A,  99, 98,100,102,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  97, 98,103,100,102,100
'****** 로봇7 ***********************************
'ZERO G6A, 100, 98,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  96,101,102, 97,102,100
'****** 로봇8 ***********************************
'ZERO G6A, 100,100, 99,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  99,99,102,100,103,100
'****** 로봇9 ***********************************
'ZERO G6A, 100, 98,100,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,96,100,100,100
'ZERO G6D,  98, 99,100,100,102,100
'****** 로봇10 **********************************
'ZERO G6A, 101, 98,101,100,100,100
'ZERO G6B, 100,100,100,100,100,100
'ZERO G6C, 100,100,95,100,100,100
'ZERO G6D,  97, 96,104,100,102,100
'************************************************



'***** 변수 선언*******************************************

보행순서 = 0
'****초기위치 피드백*****************************

'GETMOTORSET G6A,1,1,1,1,1,0
'GETMOTORSET G6B,1,1,1,0,0,0
'GETMOTORSET G6C,1,1,1,0,0,0
'GETMOTORSET G6D,1,1,1,1,1,0


SPEED 5
GOSUB MOTOR_ON
GOSUB MOTOR_READ

GOSUB 기본자세

'GOSUB 세레모니1

'1
'GOSUB 기본자세
'STOP
'GOSUB 앉은자세
'GOSUB 앉은오른쪽턴
'STOP
'GOTO 1

'GOTO 정면팔올리기
GOTO MAIN	'시리얼 수신 루틴으로 가기

'************************************************
MOTOR_READ:
FOR I = 1 TO 15
b=MOTORIN(2)
NEXT I
RETURN
'************************************************

MOTOR_ON:
MOTOR G6A				'모터0~7번 그룹사용 설정
MOTOR G6B				'모터8~15번 그룹사용 설정
MOTOR G6C				'모터16~23번 그룹사용 설정
MOTOR G6D				'모터24~31번 그룹사용 설정
RETURN
'************************************************
자세100:
	MOVE G6A,100,  100,  100, 100, 100, 100
	MOVE G6D,100,  100,  100, 100, 100, 100
	MOVE G6B,100,  100,  100, 100, 100, 100
	MOVE G6C,100,  100,  100, 100, 100, 100
	WAIT
	RETURN

차렷자세:
	MOVE G6A,100,  56, 182,  78, 100, 100
	MOVE G6D,100,  56, 182,  78, 100, 100
	MOVE G6B,100,  20,  90, 100, 100, 100
	MOVE G6C,100,  20,  90, 100, 100, 100
	WAIT
	mode = 2
	RETURN
기본자세1:
	MOVE G6A,100,  82, 145,  90, 100, 100
	MOVE G6D,100,  82, 145,  90, 100, 100
	MOVE G6B,100,  30,  80, 100, 100, 100
	MOVE G6C,100,  30,  80, 100, 100, 100
	WAIT
	mode = 0
	ETX 9600,30
	RETURN
기본자세:
	MOVE G6A,100,  82, 145,  90, 100, 100
	MOVE G6D,100,  82, 145,  90, 100, 100
	MOVE G6B,100,  30,  80, 	, 100, 100
	MOVE G6C,100,  30,  80, 100, 100, 100
	WAIT
	mode = 0
	ETX 9600,30
	RETURN

앉은자세:
	SPEED 10
	MOVE G6A,100, 151,  27, 145, 100, 100
	MOVE G6D,100, 151,  27, 147, 100, 100
	MOVE G6B,120,  30,  80, , , 
	MOVE G6C,120,  30,  80, , , 
	WAIT
	
	MOVE G6A,100, 151,  23, 145, 101, 100
	MOVE G6D,100, 151,  23, 147, 101, 100
	MOVE G6B,120,  30,  80, , , 
	MOVE G6C,120,  30,  80, , , 
	WAIT
	mode = 1
	ETX 9600,32
	RETURN

기본100:
	MOVE G6A,100, 100, 100, 100, 100, 100
	MOVE G6B,100, 100, 100, 100, 100, 100
	MOVE G6C,100, 100, 100, 100, 100, 100
	MOVE G6D,100, 100, 100, 100, 100, 100
	WAIT
	RETURN

'**********************************************
첫왼발들기10:
	MOVE G6A, 90, 107, 105, 105, 113, 70
	MOVE G6D,114,  82, 148,  90,  88, 70
	MOVE G6B, 90,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	RETURN
첫왼발들기2:
	MOVE G6A, 90, 107, 105, 105, 113, 70
	MOVE G6D,110,  80, 148,  90,  100, 70

	WAIT
	RETURN
왼쪽기울기3:
	MOVE G6D, 88,  82, 148,  88, 113, 70
	MOVE G6A,115,  82, 145,  90,  88, 70
	WAIT
	RETURN

오른쪽기울기2:
	MOVE G6A, 88,  82, 148,  88, 113, 70
	MOVE G6D,110,  82, 145,  90,  88, 70
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	RETURN
오른쪽기울기3:
	MOVE G6A, 88,  82, 148,  88, 113, 70
	MOVE G6D,108,  82, 145,  90,  88, 70
	WAIT
	RETURN

왼발들기10:
	MOVE G6A, 90, 107, 105, 105, 113, 70
	MOVE G6D,113,  82, 148,  90,  88, 70
	MOVE G6B, 90,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	RETURN

왼발뻣어착지전:
	MOVE G6A, 90,  56, 150, 115, 113,  70
	MOVE G6D,114,  82, 145,  90,  88,  70
	MOVE G6B, 80,  40,  80, , , 
	MOVE G6C,105,  40,  80, , , 
	WAIT
	RETURN

왼발뻣어착지:
	MOVE G6A, 90,  46, 163, 112, 113,  70
	MOVE G6D,112,  82, 145,  90,  88,  70
	MOVE G6B, 80,  40,  80, , , 
	MOVE G6C,105,  40,  80, , , 
	WAIT
	RETURN

왼발중립:
	MOVE G6A,100,  68, 141, 113, 101, 100
	MOVE G6D,100,  85, 156,  80, 101, 100
	MOVE G6B, 90,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	RETURN

왼발중심이동:
	MOVE G6A,112,  80, 142, 105,  88, 70
	MOVE G6D, 90, 102, 136,  85, 113, 70
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	RETURN

'**********************************************
첫오른발들기10:
	MOVE G6A,114,  82, 148,  90,  88,  70
	MOVE G6D, 90, 107, 105, 105, 113,  70
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C, 90,  40,  80, , , 
	WAIT
	RETURN
첫오른발들기2:
	MOVE G6D, 90, 107, 105, 105, 113, 70
	MOVE G6A,112,  80, 148,  90,  100, 70
	WAIT
	RETURN

왼쪽기울기2:
	MOVE G6A,112,  82, 145,  90,  88,  70
	MOVE G6D, 88,  82, 148,  88, 113,  70
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	RETURN

오른발들기10:
	MOVE G6A,113,  82, 148,  90,  88,  70
	MOVE G6D, 90, 107, 105, 105, 113,  70
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C, 90,  40,  80, , , 
	WAIT
	RETURN

오른발뻣어착지전:
	MOVE G6A,114,  80, 145,  90,  88,  70
	MOVE G6D, 90,  56, 150, 115, 113,  70
	MOVE G6B,105,  40,  80, , , 
	MOVE G6C, 80,  40,  80, , , 
	WAIT
	RETURN

오른발뻣어착지:
	MOVE G6A,112,  82, 145,  90,  88,  70
	MOVE G6D, 90,  46, 163, 112, 113,  70
	MOVE G6B,105,  40,  80, , , 
	MOVE G6C, 80,  40,  80, , , 
	WAIT
	RETURN

오른발중립:
	MOVE G6A,100,  85, 156,  80, 101, 100
	MOVE G6D,100,  68, 141, 113, 101, 100
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C, 90,  40,  80, , , 
	WAIT
	RETURN

오른발중심이동:
	MOVE G6A, 90,102, 136,  85, 113,  70
	MOVE G6D,113, 80, 140, 105,  88,  70
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	RETURN

	
'**********************************************

연속전진:

	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	
	SPEED 보행속도 
	GOSUB 첫왼발들기10
	
	'*******************************
	FOR i=0 TO 10
		
 	
		GOSUB 왼발뻣어착지전
		SPEED 좌우속도
		GOSUB 왼발뻣어착지
		
		GOSUB 왼발중립
		GOSUB 왼발중심이동
		
			ETX  9600,5	'연속보행 
		SPEED 보행속도
		GOSUB 오른발들기10
		
			ERX  9600, A, 연속전진_1
 				SPEED 5
				GOSUB 왼쪽기울기2
				SPEED 4
				GOSUB 기본자세
				GOTO MAIN	
		'**********
		
		연속전진_1:
		
		GOSUB 오른발뻣어착지전
		SPEED 좌우속도
		GOSUB 오른발뻣어착지
		
		GOSUB 오른발중립
		GOSUB 오른발중심이동
		
			ETX  9600,5	'연속보행 
		SPEED 보행속도
		GOSUB 왼발들기10
		
			ERX  9600, A, 연속전진_2
 				SPEED 5
				GOSUB 오른쪽기울기2
				SPEED 4
				GOSUB 기본자세
				GOTO MAIN	
		연속전진_2:
	NEXT i
	'*******************************
	SPEED 5
	
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN

'************************************************
연속후진:
	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 보행속도
	GOSUB 왼발들기10
	
	FOR i=0 TO 10
	
		GOSUB 오른발중심이동
			SPEED 좌우속도
		GOSUB 오른발중립
		GOSUB 오른발뻣어착지
			ETX 9600,10
			SPEED 보행속도
		GOSUB 오른발들기10
			ERX 9600,A,연속후진_1
				SPEED 5
				GOSUB 왼쪽기울기2
				SPEED 4
				GOSUB 기본자세
				GOTO MAIN
		'**********
		연속후진_1:
		
		GOSUB 왼발중심이동
			SPEED 좌우속도
		GOSUB 왼발중립
		GOSUB 왼발뻣어착지
			ETX 9600,10
			SPEED 보행속도
		GOSUB 왼발들기10
			ERX 9600,A,연속후진_2
				SPEED 5
				GOSUB 오른쪽기울기2
				SPEED 4
				GOSUB 기본자세
				GOTO MAIN
		
		연속후진_2:	
	NEXT i
	
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	GOTO MAIN


'**********************************************

반보전진:

	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	
	IF 보행순서 = 0 THEN
		보행순서 = 1
		GOSUB 오른쪽기울기2
		
		SPEED 보행속도 
		GOSUB 첫왼발들기10
		GOSUB 왼발뻣어착지전
		
		SPEED 좌우속도
		GOSUB 왼발뻣어착지
		
		GOSUB 왼발중립
		GOSUB 왼발중심이동
		
		SPEED 보행속도
		GOSUB 오른발들기10
		
		SPEED 5
		GOSUB 왼쪽기울기2
		SPEED 4
		GOSUB 기본자세
		
	ELSE
		보행순서 = 0
		GOSUB 왼쪽기울기2
		
		SPEED 보행속도 
		GOSUB 첫오른발들기10
		GOSUB 오른발뻣어착지전
		
		SPEED 좌우속도
		GOSUB 오른발뻣어착지
		
		GOSUB 오른발중립
		GOSUB 오른발중심이동
		
		SPEED 보행속도
		GOSUB 왼발들기10
		
		SPEED 5
		GOSUB 오른쪽기울기2
		SPEED 4
		GOSUB 기본자세
	
	ENDIF
	
	GOTO MAIN
'**********************************************

한보전진:

	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	
	SPEED 보행속도 
	GOSUB 첫왼발들기10
	
	'*******************************
	FOR i=0 TO 0
	
		GOSUB 왼발뻣어착지전
			SPEED 좌우속도
		GOSUB 왼발뻣어착지
		
		GOSUB 왼발중립
		GOSUB 왼발중심이동
			SPEED 보행속도
		GOSUB 오른발들기10
		
		
		GOSUB 오른발뻣어착지전
			SPEED 좌우속도
		GOSUB 오른발뻣어착지
		
		GOSUB 오른발중립
		GOSUB 오른발중심이동
			SPEED 보행속도
		GOSUB 왼발들기10
	
	NEXT i
	'*******************************
	SPEED 5
	
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN
'**********************************************

한보반전진:

	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	
	SPEED 보행속도 
	GOSUB 첫왼발들기10
	
	'*******************************
	FOR i=0 TO 1
	
		GOSUB 왼발뻣어착지전
			SPEED 좌우속도
		GOSUB 왼발뻣어착지
		
		GOSUB 왼발중립
		GOSUB 왼발중심이동
			SPEED 보행속도
		GOSUB 오른발들기10
		
		IF I = 1 THEN
			SPEED 5
			GOSUB 왼쪽기울기2
			SPEED 4
			GOSUB 기본자세	
			GOTO MAIN
		ENDIF
		
		GOSUB 오른발뻣어착지전
			SPEED 좌우속도
		GOSUB 오른발뻣어착지
		
		GOSUB 오른발중립
		GOSUB 오른발중심이동
			SPEED 보행속도
		GOSUB 왼발들기10
	
	NEXT i
	'*******************************
	SPEED 5
	
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN
'**********************************************

이보전진:

	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	
	SPEED 보행속도 
	GOSUB 첫왼발들기10
	
	'*******************************
	FOR i=0 TO 1
	
		GOSUB 왼발뻣어착지전
			SPEED 좌우속도
		GOSUB 왼발뻣어착지
		
		GOSUB 왼발중립
		GOSUB 왼발중심이동
			SPEED 보행속도
		GOSUB 오른발들기10
		
		
		GOSUB 오른발뻣어착지전
			SPEED 좌우속도
		GOSUB 오른발뻣어착지
		
		GOSUB 오른발중립
		GOSUB 오른발중심이동
			SPEED 보행속도
		GOSUB 왼발들기10
	
	NEXT i
	'*******************************
	SPEED 5
	
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN
'**********************************************

반보후진:

	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	IF 보행순서 = 0 THEN
		GOSUB 오른쪽기울기2
		SPEED 보행속도
		GOSUB 왼발들기10
		
		GOSUB 오른발중심이동
			SPEED 좌우속도
		GOSUB 오른발중립
		GOSUB 오른발뻣어착지
			SPEED 보행속도
		GOSUB 오른발들기10
		
		SPEED 5
		GOSUB 왼쪽기울기2
		SPEED 4
		GOSUB 기본자세
		
	ELSE
		GOSUB 왼쪽기울기2
		SPEED 보행속도
		GOSUB 오른발들기10
		
		
		GOSUB 왼발중심이동
			SPEED 좌우속도
		GOSUB 왼발중립
		GOSUB 왼발뻣어착지
			SPEED 보행속도
		GOSUB 왼발들기10
	
		SPEED 5
		GOSUB 오른쪽기울기2
		SPEED 4
		GOSUB 기본자세
	ENDIF
	
	GOTO MAIN

'************************************************
한보후진:
	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 보행속도
	GOSUB 왼발들기10
	
	GOSUB 오른발중심이동
		SPEED 좌우속도
	GOSUB 오른발중립
	GOSUB 오른발뻣어착지
		SPEED 보행속도
	GOSUB 오른발들기10
	
	
	GOSUB 왼발중심이동
		SPEED 좌우속도
	GOSUB 왼발중립
	GOSUB 왼발뻣어착지
		SPEED 보행속도
	GOSUB 왼발들기10
	
	
		SPEED 5
	GOSUB 오른쪽기울기2
		SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN
'************************************************
한보반후진:
	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 보행속도
	GOSUB 왼발들기10
	
	FOR i=0 TO 1
	
		GOSUB 오른발중심이동
			SPEED 좌우속도
		GOSUB 오른발중립
		GOSUB 오른발뻣어착지
			SPEED 보행속도
		GOSUB 오른발들기10
		
		IF I = 1 THEN
			SPEED 5
			GOSUB 왼쪽기울기2
			SPEED 4
			GOSUB 기본자세
			GOTO MAIN
		ENDIF
		
		GOSUB 왼발중심이동
			SPEED 좌우속도
		GOSUB 왼발중립
		GOSUB 왼발뻣어착지
			SPEED 보행속도
		GOSUB 왼발들기10
	
	NEXT i
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	GOTO MAIN
'**********************************************

이보후진:
	보행속도 = 12
	좌우속도 = 6
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 보행속도
	GOSUB 왼발들기10
	
	FOR i=0 TO 1
	
		GOSUB 오른발중심이동
			SPEED 좌우속도
		GOSUB 오른발중립
		GOSUB 오른발뻣어착지
			SPEED 보행속도
		GOSUB 오른발들기10
		
		
		GOSUB 왼발중심이동
			SPEED 좌우속도
		GOSUB 왼발중립
		GOSUB 왼발뻣어착지
			SPEED 보행속도
		GOSUB 왼발들기10
	
	NEXT i
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	GOTO MAIN
'************************************************
왼쪽옆으로:

	SPEED 5
	GOSUB 왼쪽기울기2
	
	SPEED 9
	GOSUB 오른발옆뻣어착지
	
	GOSUB 옆으로중앙
	GOSUB 왼발옆뻣어착지
	
	
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN
	
'**********************************************
오른쪽옆으로:

	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 9
	GOSUB 왼발옆뻣어착지
	
	GOSUB 옆으로중앙
	GOSUB 오른발옆뻣어착지
	
	
	GOSUB 왼쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN

'*********************************************

오른발옆뻣어착지:
	MOVE G6A,110,  98, 124,  97,  93,  70
	MOVE G6D, 76,  78, 160,  78, 128,  70
	MOVE G6B,100,  35,  90, , , 
	MOVE G6C,100,  35,  90, , , 
	WAIT
	RETURN

옆으로중앙:
	MOVE G6A, 93,  80, 145,  94, 109, 100
	MOVE G6D, 93,  80, 145,  94, 109, 100
	MOVE G6B,100,  35,  90, , , 
	MOVE G6C,100,  35,  90, , , 
	WAIT
	RETURN
'*********************************************

왼발옆뻣어착지:
	MOVE G6A, 76,  78, 160,  78, 128,  70
	MOVE G6D,110,  98, 124,  97,  93,  70
	MOVE G6B,100,  35,  90, , , 
	MOVE G6C,100,  35,  90, , , 
	WAIT
	RETURN

'**********************************************
오른발앞들기10:
	MOVE G6A,112,  78, 145,  97,  93,  60
	MOVE G6D, 90,  50, 157, 115, 112,  60
	MOVE G6B,105,  40,  70, , , 
	MOVE G6C, 90,  40,  70, , , 
	WAIT
	RETURN	

오른발턴착지:
	MOVE G6A,108,  82, 145,  98,  93,  60
	MOVE G6D, 95,  43, 169, 110, 110,  60
	MOVE G6B,105,  40,  70, , , 
	MOVE G6C, 80,  40,  70, , , 
	WAIT
	RETURN


왼발앞들기10:
	MOVE G6D,112,  78, 145,  97,  93,  60
	MOVE G6A, 90,  50, 157, 115, 112,  60
	MOVE G6C,105,  40,  70, , , 
	MOVE G6B, 90,  40,  70, , , 
	WAIT 
	RETURN	

왼발턴착지:
	MOVE G6D,108,  82, 145,  98,  93,  60
	MOVE G6A, 95,  43, 169, 110, 110,  60
	MOVE G6C,105,  40,  70, , , 
	MOVE G6B, 80,  40,  70, , , 
	WAIT
	RETURN	

'************************************************
왼쪽턴:
	SPEED 6
	GOSUB 왼쪽기울기2
	SPEED 7
	GOSUB 오른발앞들기10
	GOSUB 오른발턴착지
	GOSUB 기본자세
	GOTO MAIN
왼쪽턴2:
'GOSUB 기본자세
	SPEED 5
	GOSUB 왼쪽기울기3

	WAIT	
	SPEED 10
	GOSUB 첫오른발들기2
'	HIGHSPEED SETON
	MOVE G6B,120,  56,  79,    ,    ,    

	MOVE G6D,104,  89,  74, 161, 110,    
	SPEED 15
	MOVE G6A,94, 147, 104,  72,  97,    
	WAIT
'	HIGHSPEED SETOFF
	WAIT
	SPEED 8

'	MOVE G6D, 83, 147, 104,  82, 105,  70
'MOVE G6D, 95, 134,  67, 113, 100,  70
	WAIT
	GOSUB 기본자세
	GOTO MAIN

오른쪽턴:
	SPEED 6
	GOSUB 오른쪽기울기2
	SPEED 7
	GOSUB 왼발앞들기10
	GOSUB 왼발턴착지
	GOSUB 기본자세
	GOTO MAIN
오른쪽턴2:
'	GOSUB 기본자세
	SPEED 5
	GOSUB 오른쪽기울기3

	WAIT	
	SPEED 10
	GOSUB 첫왼발들기2
'	HIGHSPEED SETON
	MOVE G6C,120,  56,  79,    ,    ,    

	MOVE G6A,104,  89,  74, 161, 110,    
	SPEED 15
	MOVE G6D,94, 147, 104,  72,  97,    
	WAIT
'	HIGHSPEED SETOFF
	WAIT
	SPEED 8

'	MOVE G6D, 83, 147, 104,  82, 105,  70
'MOVE G6D, 95, 134,  67, 113, 100,  70
	WAIT
	GOSUB 기본자세
	GOTO MAIN

앉은왼쪽턴:

	GOSUB 앉은자세
	SPEED 10
	MOVE G6D, 92, 150,  37, 139,  87, 100
	MOVE G6A,105, 158,  24, 140, 110, 100
	WAIT
	SPEED 11
	MOVE G6D, 92, 134,  49, 108,  95,    


	'MOVE G6A,90, 131,  33, 164, 100, 100
	'MOVE G6C,145,  40,  70, , , 
	MOVE G6C, 50,  40,  70, , , 
	'MOVE G6D,110, 158,  44, 123, 110, 100
	GOSUB 방어자세
	RETURN

앉은오른쪽턴:
	GOSUB 앉은자세
	
	SPEED 10
	MOVE G6A, 92, 150,  37, 139,  87, 100
	MOVE G6D,105, 158,  24, 140, 110, 100
	WAIT
	SPEED 11
	MOVE G6A, 92, 134,  49, 108,  95,    


	'MOVE G6A,90, 131,  33, 164, 100, 100
	'MOVE G6C,165,  40,  70, , , 
	MOVE G6B, 50,  40,  70, , , 
	'MOVE G6D,110, 158,  44, 123, 110, 100
	GOSUB 방어자세2
	RETURN

'************************************************

머리왼쪽30도:
	SERVO 9,70
	ETX 9600,17
	GOTO MAIN
	
머리왼쪽60도:
	SERVO 9,40
	ETX 9600,18
	GOTO MAIN
	
머리왼쪽90도:
	SPEED 15
	MOVE G6B,   ,    ,    , 10,    ,    
	WAIT
	'SERVO 9,10
	ETX 9600,19
	GOTO MAIN
	
머리오른쪽30도:
	SERVO 9,130
	ETX 9600,20
	GOTO MAIN
	
머리오른쪽60도:
	SERVO 9,160
	ETX 9600,21
	GOTO MAIN
	
머리오른쪽90도:
	SPEED 15
	MOVE G6B,   ,    ,    , 190,    ,    
	'SERVO 9,190
	WAIT
	ETX 9600,22
GOTO MAIN
	
머리좌우중앙:
	SPEED 15
	MOVE G6B,   ,    ,    , 100,    ,    
	WAIT
	'SERVO 9,100
	ETX 9600,23
	WAIT
	GOTO MAIN
	
머리아래30도:
	SPEED 5
	MOVE G6A,100,  60, 145, 140, 100, 100
	MOVE G6D,100,  60, 145, 140, 100, 100
	MOVE G6B,100,  30,  80, , , 
	MOVE G6C,100,  30,  80, , , 
	WAIT	
	ETX 9600,24
	GOTO MAIN	

머리상하정면:
	SPEED 5
	GOSUB 기본자세
	GOTO MAIN

'************************************************
인사:
	SPEED 8
	MOVE G6A,100,  58, 135, 160, 100, 100
	MOVE G6D,100,  58, 135, 160, 100, 100
	WAIT
	DELAY 1000
	SPEED 6
	GOSUB 기본자세
	GOTO MAIN
'************************************************
뒤로일어나기:
	
	SPEED 10
	'GOSUB 기본자세
	
	MOVE G6A,100, 130, 120,  80, 110, 100
	MOVE G6D,100, 130, 120,  80, 110, 100
	MOVE G6B,150, 160,  10, 100, 100, 100
	MOVE G6C,150, 160,  10, 100, 100, 100
	WAIT
	
	MOVE G6A, 80, 155,  85, 150, 150, 100
	MOVE G6D, 80, 155,  85, 150, 150, 100
	MOVE G6B,185,  40, 60,  100, 100, 100
	MOVE G6C,185,  40, 60,  100, 100, 100
	WAIT
	
	MOVE G6A, 75, 165,  55, 165, 155, 100
	MOVE G6D, 75, 165,  55, 165, 155, 100
	MOVE G6B,185,  10, 100, 100, 100, 100
	MOVE G6C,185,  10, 100, 100, 100, 100
	WAIT
	
	MOVE G6A, 60, 165,  30, 165, 155, 100
	MOVE G6D, 60, 165,  30, 165, 155, 100
	MOVE G6B,170,  10, 100, 100, 100, 100
	MOVE G6C,170,  10, 100, 100, 100, 100
	WAIT
	
	MOVE G6A, 60, 165,  25, 160, 145, 100
	MOVE G6D, 60, 165,  25, 160, 145, 100
	MOVE G6B,150,  60,  90, 100, 100, 100
	MOVE G6C,150,  60,  90, 100, 100, 100
	WAIT
	
	MOVE G6A,100, 155,  25, 140, 100, 100
	MOVE G6D,100, 155,  25, 140, 100, 100
	MOVE G6B,130,  50,  85, 100, 100, 100
	MOVE G6C,130,  50,  85, 100, 100, 100
	WAIT
	'DELAY 100
	
	GOSUB 기본자세
	
	GOTO MAIN





'**********************************************
앞으로일어나기:
	SPEED 10
	GOSUB 기본자세
	
	MOVE G6A,100, 10,  100, 115, 100, 100
	MOVE G6D,100, 10,  100, 115, 100, 100
	MOVE G6B,100,  130,  10, 100, 100, 100
	MOVE G6C,100,  130,  10, 100, 100, 100
	WAIT

	MOVE G6A,100, 10,  83, 140, 100, 100
	MOVE G6D,100, 10,  83, 140, 100, 100
	MOVE G6B,20,  130,  10, 100, 100, 100
	MOVE G6C,20,  130,  10, 100, 100, 100
	WAIT

	MOVE G6A,100, 126,  60, 50, 100, 100
	MOVE G6D,100, 126,  60, 50, 100, 100
	MOVE G6B,20,  30,  90, 100, 100, 100
	MOVE G6C,20,  30,  90, 100, 100, 100
	WAIT
	
	MOVE G6A,100, 165,  70, 15, 100, 100
	MOVE G6D,100, 165,  70, 15, 100, 100
	MOVE G6B,30,  20,  95, 100, 100, 100
	MOVE G6C,30,  20,  95, 100, 100, 100
	WAIT
	
	MOVE G6A,100, 165,  40, 100, 100, 100
	MOVE G6D,100, 165,  40, 100, 100, 100
	MOVE G6B,110,  70,  50, 100, 100, 100
	MOVE G6C,110,  70,  50, 100, 100, 100
	WAIT
	
	GOSUB 기본자세
	
	
	GOTO MAIN

'******************************************
세레모니1:
	SPEED 10
	MOVE G6A,107, 160,  40, 123, 105, 100
	MOVE G6D, 76,  92,  71, 165, 117, 100
	MOVE G6B,130,  22,  84, 100, 100, 100
	MOVE G6C, 46,  11, 137, 100, 100, 100
	WAIT
	MOVE G6A, 76, 155,  22, 150, 159, 100
	MOVE G6B,116,  69,  93, 100, 100, 100
	MOVE G6C, 40,  11, 135, 100, 100, 100
	MOVE G6D, 63,  35, 145, 152, 105, 100
	WAIT

	HIGHSPEED SETON

	MOVE G6B, 190,10, 50, , , 
	MOVE G6C, ,  190,190 , , ,
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,100, 166,  83, 108, 102, 100
	MOVE G6B,189,  11,  31, 100, 100, 100
	MOVE G6C, 54, 189, 127, 100, 100, 100
	MOVE G6D, 59,  42, 189, 161, 187, 100

	MOVE G6B, 190,10, 50, , , 
	MOVE G6C, ,  190,190 , , ,
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,100, 166,  83, 108, 102, 100
	MOVE G6B,189,  11,  31, 100, 100, 100
	MOVE G6C, 54, 189, 127, 100, 100, 100
	MOVE G6D, 59,  42, 189, 161, 187, 100
	
	MOVE G6B, 190,10, 50, , , 
	MOVE G6C, ,  190,190 , , ,
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,100, 166,  83, 108, 102, 100
	MOVE G6B,189,  11,  31, 100, 100, 100
	MOVE G6C, 54, 189, 127, 100, 100, 100
	MOVE G6D, 59,  42, 189, 161, 187, 100
	
		MOVE G6B, 190,10, 50, , , 
	MOVE G6C, ,  190,190 , , ,
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,100, 166,  83, 108, 102, 100
	MOVE G6B,189,  11,  31, 100, 100, 100
	MOVE G6C, 54, 189, 127, 100, 100, 100
	MOVE G6D, 59,  42, 189, 161, 187, 100

		MOVE G6B, 190,10, 50, , , 
	MOVE G6C, ,  190,190 , , ,
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,100, 166,  83, 108, 102, 100
	MOVE G6B,189,  11,  31, 100, 100, 100
	MOVE G6C, 54, 189, 127, 100, 100, 100
	MOVE G6D, 59,  42, 189, 161, 187, 100

		MOVE G6B, 190,10, 50, , , 
	MOVE G6C, ,  190,190 , , ,
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,100, 166,  83, 108, 102, 100
	MOVE G6B,189,  11,  31, 100, 100, 100
	MOVE G6C, 54, 189, 127, 100, 100, 100
	MOVE G6D, 59,  42, 189, 161, 187, 100

	
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,101, 166,  72, 104,  91, 100
	MOVE G6B,189,  11,  82, 100, 100, 100
	MOVE G6C, 45, 189, 115, 100, 100, 100
	MOVE G6D, 59,  11, 189, 161, 160, 100

	SPEED 5
	MOVE G6A,101, 167,  24, 152,  91, 100
	MOVE G6A,113, 166,  34, 126,  90, 100
MOVE G6B,104,  25,  92, 100, 100, 100
MOVE G6C, 68,  46,  94, 100, 100, 100
MOVE G6D, 54,  46, 138, 147, 149, 100

GOSUB 방어자세




	
	'HIGHSPEED SETOFF
	'MOVE G6A, 95, 141,  74, 110, 103, 100
	'MOVE G6D, 77,  41, 128, 161, 130, 100


	'MOVE G6A,102, 151,  60, 116, 103, 100
	'MOVE G6D, 82,  11, 161, 161, 112, 100


'	GOSUB 기본자세
	'WAIT
	'DELAY 100
	'HIGHSPEED SETOFF

	'MOVE G6A,102, 151,  60, 116, 103, 100
	'MOVE G6D, 82,  11, 161, 161, 112, 100
	WAIT


	'GOSUB 방어자세
	GOTO MAIN

'******************************************
방어자세:
	SPEED 8
	HIGHSPEED SETON
	MOVE G6A,90, 150,  25, 145, 110, 100
	MOVE G6D,90, 150,  25, 147, 110, 100
	MOVE G6B,120,  35,  80, , , 
	MOVE G6C,120,  35,  80, , , 
	WAIT
	HIGHSPEED SETOFF
	mode = 1
	SPEED 10
	DELAY 500

	ETX 9600,33

	GOTO MAIN	
'******************************************
방어자세2:
	SPEED 8
	HIGHSPEED SETON
	MOVE G6D,90, 150,  25, 145, 110, 100
	MOVE G6A,90, 150,  25, 147, 110, 100
	MOVE G6C,120,  35,  80, , , 
	MOVE G6B,120,  35,  80, , , 
	WAIT
	HIGHSPEED SETOFF
	mode = 1
	SPEED 10
	DELAY 500

	ETX 9600,33

	GOTO MAIN	
'******************************************
오른쪽옆찌르기:
	SPEED 5
	GOSUB 왼쪽기울기2
	SPEED 12
	HIGHSPEED SETON
	MOVE G6A, 53,  91, 138, 101, 144, 100
	MOVE G6D,106, 172,  24, 130, 100, 100
	MOVE G6B,112,  92,  99, , , , 
	MOVE G6C,107, 137, 108, , , , 

	WAIT
	DELAY 1000
	HIGHSPEED SETOFF
	SPEED 8
	GOSUB 앉은자세

	GOTO MAIN	
'******************************************
	
	
왼쪽옆찌르기:
	SPEED 5
	GOSUB 오른쪽기울기2
	
	SPEED 12
	HIGHSPEED SETON
	MOVE G6A,106, 172,  24, 130, 100, 100	
	MOVE G6D, 53,  91, 138, 101, 144, 100
	MOVE G6B,107, 137, 108, , , , 
	MOVE G6C,112,  92,  99, , , , 

	
	DELAY 1000
	HIGHSPEED SETOFF
	SPEED 8
	GOSUB 앉은자세
	GOTO MAIN	
'******************************************

정면양펀치:
	SPEED 15
	MOVE G6A,95,  83, 145,  90, 105, 100
	MOVE G6D,95,  83, 145,  90, 105, 100
	'MOVE G6A, 96, 149,  57, 104, 105,    
	'MOVE G6D, 91, 150,  58, 106, 112,    

	MOVE G6B,190, 150,  10, , , , 
	MOVE G6C,190, 150,  10, , , , 
	WAIT
	SPEED 15
	HIGHSPEED SETON
	FOR I = 0 TO 1
		MOVE G6B,190,  10, 75, , , , 
		MOVE G6C,190, 140, 10, , , , 
		WAIT
		DELAY 150
		MOVE G6B,190, 140, 10, , , , 
		MOVE G6C,190,  10, 75, , , , 
		WAIT
		DELAY 150
	
	NEXT I
	HIGHSPEED SETOFF
	SPEED 15
	MOVE G6A,100,  83, 145,  90, 98, 100
	MOVE G6D,100,  83, 145,  90, 98, 100
	MOVE G6B,190, 150,  10, , , , 
	MOVE G6C,190, 150,  10, , , , 
	WAIT
	GOSUB 기본자세
	
	GOTO MAIN	
'******************************************

사이드공격:
	SPEED 10
	MOVE G6A, 92, 120,  95, 105, 107, 100
	MOVE G6D, 92, 120,  95, 105, 107, 100
	MOVE G6B, 10,  30,  80, , , , 
	MOVE G6C, 10,  30,  80, , , , 
	WAIT
	SPEED 15
	HIGHSPEED SETON
	MOVE G6B, 10, 185, 120, , , , 
	MOVE G6C, 10, 185, 120, , , , 
	MOVE G6A, 92, 114,  95, 105, 107, 100
	MOVE G6D, 92, 114,  95, 105, 107, 100
	WAIT
	HIGHSPEED SETOFF
	DELAY 500
	MOVE G6A, 100, 114,  95, 105, 98, 100
	MOVE G6D, 100, 114,  95, 105, 98, 100
	WAIT
	SPEED 10
	GOSUB 기본자세
	
	GOTO MAIN
'******************************************
정면팔올리기:
GOSUB 기본자세
SPEED 10
MOVE G6A,101,  99,  85, 138, 100,    
MOVE G6D,101,  99,  85, 138, 100,    

MOVE G6B,140, , , , ,
MOVE G6C,140, , , , ,
WAIT
MOVE G6B,137,  11,  57,    ,    ,    
MOVE G6C,137,  10,  53,    ,    ,    '팔모으기
WAIT
SPEED 10
GOSUB 오른쪽기울기3

WAIT	
GOSUB 첫왼발들기2
SPEED 15
HIGHSPEED SETON

MOVE G6B,190,  11,  70,    ,    ,    
MOVE G6C,190,  10,  73,    ,    ,    '팔들기
'MOVE G6A,105,  89,  64, 161, 110,    
'MOVE G6D,97, 167, 54,  112,  95,    
'MOVE G6B,185, 54,  83,    ,    ,    
'MOVE G6C,181, 57,  83,    ,    ,    

MOVE G6A,101,  38, 122, 162, 100,    
MOVE G6D,101, 145, 107,  79,  100,    

HIGHSPEED SETOFF
WAIT
SPEED 12
MOVE G6C,113,  57,  63,    ,    ,    
MOVE G6B,118,  54,  61,    ,    ,    

'MOVE G6D, 73, 147, 104,  72, 112,  70
'MOVE G6D, 75, 144,  57, 113, 110,  70
WAIT
SPEED 8
'GOSUB 기본자세
GOSUB 앉은자세
GOSUB 방어자세
GOTO MAIN
'******************************************
발차기왼발들기10:
	MOVE G6A, 90, 107, 105, 105, 113, 70
	MOVE G6D,114,  80, 148,  90,  88, 70
	MOVE G6B, 90,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
RETURN
발차기오른발들기10:
	MOVE G6A,114,  78, 148,  90,  88, 70
	MOVE G6D, 90, 107, 105, 105, 113, 70
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C, 90,  40,  80, , , 
	WAIT
RETURN
'******************************************
정면왼발차기:

	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 12
	GOSUB 첫왼발들기10
	
	HIGHSPEED SETON
	
	MOVE G6A, 90,  28, 170, 161, 113,  70
	MOVE G6D,113,  74, 148,  88,  88,  70
	WAIT
	
	HIGHSPEED SETOFF
	DELAY 500
	GOSUB 발차기왼발들기10
	
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN
'******************************************
정면오른발차기:

	SPEED 5
	GOSUB 왼쪽기울기2
	SPEED 12
	GOSUB 첫오른발들기10
	
	HIGHSPEED SETON
	MOVE G6A,113,  74, 148,  88,  88,  70
	MOVE G6D, 90,  28, 170, 161, 113,  70
	WAIT
	
	HIGHSPEED SETOFF
	DELAY 500
	GOSUB 발차기오른발들기10
	
	SPEED 5
	GOSUB 왼쪽기울기2
	SPEED 4
	GOSUB 기본자세
	
	GOTO MAIN
'******************************************
왼팔내지르기:

	SPEED 5
	GOSUB 왼쪽기울기2
	SPEED 12
	GOSUB 첫오른발들기10
	SPEED 15
	MOVE G6B, 44,  120, 177, 100, 100, 100
	MOVE G6C, 77,  40,  80, 100, 100, 100
	WAIT
	SPEED 10
	HIGHSPEED SETON
	MOVE G6A,100, 123, 120,  96,  99,  70
	MOVE G6D,100,  62, 116, 161, 104,  70
	MOVE G6B, 34, 180, 114, 100, 100, 100
	MOVE G6C, 75,  61,  86, 100, 100, 100
	WAIT
	
	HIGHSPEED SETOFF
	
	DELAY 500
	MOVE G6B, 90,  40,  80, , , 
	MOVE G6C,100,  40,  80, , , 
	WAIT
	GOSUB 첫왼발들기10
	
	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 4
	GOSUB 기본자세	
	GOTO MAIN
	
'******************************************
오른팔내지르기:

	SPEED 5
	GOSUB 오른쪽기울기2
	SPEED 12
	GOSUB 첫왼발들기10
	SPEED 15
	MOVE G6B, 77,  40,  80, 100, 100, 100
	MOVE G6C, 44,  120, 177, 100, 100, 100
	WAIT
	SPEED 10
	HIGHSPEED SETON
	MOVE G6A,100,  62, 116, 161, 104,  70
	MOVE G6D,100, 123, 120,  96,  99,  70
	MOVE G6B, 75,  61,  86, 100, 100, 100
	MOVE G6C, 34, 180, 114, 100, 100, 100
	WAIT
	
	HIGHSPEED SETOFF
		
	DELAY 500
	MOVE G6B,100,  40,  80, , , 
	MOVE G6C, 90,  40,  80, , , 
	WAIT
	GOSUB 첫오른발들기10
	
	SPEED 5
	GOSUB 왼쪽기울기2
	SPEED 4
	GOSUB 기본자세	
	GOTO MAIN
'******************************************
앉아오른팔뻗기:
	GOSUB 앉은자세
	SPEED 18
	MOVE G6B,114,  61,  81,		, 	, 
	MOVE G6D, 92, 150,  37, 139,  77, 100
	WAIT
	HIGHSPEED SETON
	SPEED 15
	MOVE G6A,116, 158,  24, 138, 120, 100
	MOVE G6C,111, 112,  97, 100, 100, 100
	HIGHSPEED SETOFF
	SPEED 10
	'MOVE G6D, 92, 150,  37, 139,  97, 100
	'다리 기울이고 왼팔 짚고 오른팔뻗기
	MOVE G6D, 51, 144,  24, 152, 158, 100
	WAIT
	'DELAY 50
	HIGHSPEED SETON
	MOVE G6A, 68, 160,  25, 139, 119, 100
	'다리 뻗고 다리 모으기
	
	DELAY 500
	WAIT
	
	
	SPEED 10
	WAIT
	MOVE G6D, 92, 150,  37, 139,  97, 100
	MOVE G6A,86, 128,  54, 148, 120, 100
	HIGHSPEED SETOFF
	GOSUB 앉은자세
	GOTO MAIN
'******************************************
앉아왼팔뻗기:
	GOSUB 앉은자세
	SPEED 18
	MOVE G6C,114,  61,  81,		, 	, 
	MOVE G6A, 92, 150,  37, 139,  77, 100
	WAIT
	HIGHSPEED SETON
	SPEED 15
	MOVE G6D,116, 158,  24, 138, 120, 100
	MOVE G6B,111, 112,  97,   , 100, 100
	HIGHSPEED SETOFF
	SPEED 10
	'MOVE G6D, 92, 150,  37, 139,  97, 100
	'다리 기울이고 왼팔 짚고 오른팔뻗기
	MOVE G6A, 51, 144,  24, 152, 158, 100
	WAIT
	'DELAY 50
	HIGHSPEED SETON
	MOVE G6D, 68, 160,  25, 139, 119, 100
	'다리 뻗고 다리 모으기
	
	DELAY 500
	WAIT
	
	
	SPEED 10
	WAIT
	MOVE G6A, 92, 150,  37, 139,  97, 100
	MOVE G6D,86, 128,  54, 148, 120, 100
	HIGHSPEED SETOFF
	GOSUB 앉은자세
	GOTO MAIN
'******************************************
앉아우로:
	GOSUB 앉은자세
	SPEED 8
	WAIT
	MOVE G6A,100, 158,  24, 138, 120, 100
	SPEED 10
	MOVE G6D, 91, 144,  24, 152, 108, 100
	WAIT
	MOVE G6A, 68, 160,  25, 139, 119, 100
	
	DELAY 500
	WAIT
	
	
	GOSUB 앉은자세
	GOTO MAIN
'******************************************
앉아좌로:
	GOSUB 앉은자세
	SPEED 8
	WAIT
	MOVE G6D,100, 158,  24, 138, 120, 100
	SPEED 10
	MOVE G6A, 91, 144,  24, 152, 108, 100
	WAIT
	MOVE G6D, 68, 160,  25, 139, 119, 100
	
	DELAY 500
	WAIT
	
	
	GOSUB 앉은자세
	GOTO MAIN

'****************************************** 
앉아정면공격:
	SPEED 8
	HIGHSPEED SETON
	MOVE G6A,90, 150,  25, 145, 110, 100
	MOVE G6D,90, 150,  25, 147, 110, 100
	MOVE G6B,120,  35,  80, , , 
	MOVE G6C,120,  35,  80, , , 
	WAIT
	HIGHSPEED SETOFF
	mode = 1
	SPEED 10
	DELAY 500
SPEED 8
MOVE G6B,140, , , , ,
MOVE G6C,140, , , , ,
MOVE G6B,140,  11,  57,    ,    ,    
MOVE G6C,140,  10,  53,    ,    ,    '팔모으기
SPEED 13
HIGHSPEED SETON
FOR i = 1 TO 3
MOVE G6B,185,  11,  10,    ,    ,    
WAIT
MOVE G6B,185, 74,  80,    ,    ,    

MOVE G6C,181,  10,  13,    ,    ,    '팔들기
WAIT
MOVE G6C,181, 74,  83,    ,    ,    
NEXT i
HIGHSPEED SETOFF
WAIT
SPEED 12
MOVE G6C,113,  57,  63,    ,    ,    
MOVE G6B,118,  54,  61,    ,    ,    

WAIT
SPEED 8
GOSUB 방어자세
GOTO MAIN

오른팔젓기:
	SPEED 10
	MOVE G6A,107, 160,  40, 123, 105, 100
	MOVE G6D, 76,  92,  71, 165, 117, 100
	MOVE G6B,130,  22,  84, 100, 100, 100
	MOVE G6C, 46,  11, 137, 100, 100, 100
	WAIT
	MOVE G6A, 76, 155,  22, 150, 159, 100
	MOVE G6B,116,  69,  93, 100, 100, 100
	MOVE G6C, 40,  11, 135, 100, 100, 100
	MOVE G6D, 63,  35, 145, 152, 105, 100
	WAIT

	HIGHSPEED SETON

	MOVE G6B, 190,10, 50, , , 
	MOVE G6C, ,  190,190 , , ,
	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100

	MOVE G6A,110, 166,  22, 162,  91, 100
	MOVE G6D, 53,  53, 189, 161, 187, 100


	GOSUB 방어자세 
	WAIT

	GOTO MAIN
	
왼팔젓기:
	SPEED 10
	MOVE G6D,107, 160,  40, 123, 105, 100
	MOVE G6A, 76,  92,  71, 165, 117, 100
	MOVE G6C,130,  22,  84, 100, 100, 100
	MOVE G6B, 46,  11, 137, 100, 100, 100
	WAIT
	MOVE G6D, 76, 155,  22, 150, 159, 100
	MOVE G6C,116,  69,  93, 100, 100, 100
	MOVE G6B, 40,  11, 135, 100, 100, 100
	MOVE G6A, 63,  35, 145, 152, 105, 100
	WAIT

	HIGHSPEED SETON

	MOVE G6C, 190,10, 50, , , 
	MOVE G6B, ,  190,190 , , ,
	MOVE G6D,110, 166,  22, 162,  91, 100
	MOVE G6A, 53,  53, 189, 161, 187, 100

	MOVE G6D,110, 166,  22, 162,  91, 100
	MOVE G6A, 53,  53, 189, 161, 187, 100

	GOSUB 방어자세 
	WAIT

	GOTO MAIN

'******************************************
'******************************************	
MAIN:    	'라벨설정
ETX 9600,48

'GOSUB 앉은자세
'**** 입력된 A값이 0 이면 MAIN 라벨로 가고
'**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
MAIN1:
'GOTO KEY1
'A=A+1
'IF A=44 THEN
'A=0
ERX 9600,A, MAIN1
'GOTO 오른쪽턴2


ON A GOTO MAIN1,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY47,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32,KEY33,KEY34,KEY35,KEY36,KEY37,KEY38 ,KEY39,KEY40,KEY41,KEY42,KEY43,KEY44,KEY45,KEY46
'GOTO KEY34
'DELAY 500

'GOTO 앉아오른팔뻗기

GOTO MAIN1	
'*******************************************
'		MAIN 라벨로 가기
'*******************************************
 
KEY1:   			
	
	ETX  9600,1
	GOTO 반보전진
	GOTO MAIN

KEY2:   
	ETX  9600,2
	GOTO 한보전진	 	
	GOTO MAIN

KEY3: 
	ETX  9600,3
	GOTO 한보반전진

		
	GOTO MAIN

KEY4:  
	ETX  9600,4
	GOTO 이보전진

		
	GOTO MAIN
	
KEY5:   
	ETX  9600,5
	GOTO 왼팔젓기

		
	GOTO MAIN

KEY6: 
	ETX  9600,6
	GOTO 반보후진

		
	GOTO MAIN

KEY7:   
	ETX  9600,7
	GOTO 한보후진

		
	GOTO MAIN

KEY8:   
	ETX  9600,8
	GOTO 한보반후진

		
	GOTO MAIN
	
KEY9:   
	ETX  9600,9
	GOTO 이보후진

		
	GOTO MAIN

KEY10:   
	ETX  9600,10
	GOTO 오른팔젓기

		
	GOTO MAIN

KEY11:  
	ETX  9600,11
	GOTO 왼쪽옆으로

		
	GOTO MAIN

KEY12:   
	ETX  9600,12
	GOTO 오른쪽옆으로

		
	GOTO MAIN

KEY13:  			
	ETX  9600,13
	GOTO 왼쪽턴

		
	GOTO MAIN
	
KEY14:   
	ETX  9600,14
	GOTO 오른쪽턴

		
	GOTO MAIN

KEY15:   
	ETX  9600,15
	GOTO 앞으로일어나기

		
	GOTO MAIN

KEY16:   
	ETX  9600,16
	GOTO 뒤로일어나기

	

	GOTO MAIN

KEY17:
	ETX  9600,17
	GOTO 머리왼쪽30도

	 	
	GOTO MAIN

KEY18:   
	ETX  9600,18
	GOTO 머리왼쪽60도

		
	GOTO MAIN

KEY19:   
	ETX  9600,19
	GOTO 머리왼쪽90도

	
	GOTO MAIN

KEY20:   
	ETX  9600,20
	GOTO 머리오른쪽30도

		
	GOTO MAIN

KEY21:   
	ETX  9600,21
	GOTO 머리오른쪽60도

	
	GOTO MAIN

KEY22:   
	ETX  9600,22
	GOTO 머리오른쪽90도

		
	GOTO MAIN

KEY23:   
	ETX  9600,23
	GOTO 머리아래30도

		
	
	GOTO MAIN

KEY24:   
	ETX  9600,24
	GOTO 머리좌우중앙

		
	GOTO MAIN

KEY25:   
	ETX  9600,25
	GOTO 머리상하정면

		
	GOTO MAIN

KEY26:   
	ETX  9600,26
	GOTO 세레모니1

		
	
	GOTO MAIN

KEY27:
	ETX  9600,27
	GOTO 인사

	GOTO MAIN
	
KEY28:
	ETX  9600,28
	GOTO 앉아좌로

	GOTO MAIN
	
KEY29:
	ETX  9600,29
	GOTO 앉아우로

	GOTO MAIN


KEY30:
	ETX  9600,30
	GOSUB 기본자세


	GOTO MAIN
	
KEY31:
	ETX  9600,31
	GOSUB 차렷자세


	GOTO MAIN
	

KEY32:
	ETX  9600,32
	GOSUB 앉은자세


	GOTO MAIN
	
KEY33:
	ETX  9600,33
	GOTO 방어자세


	GOTO MAIN
	
KEY34:
	ETX  9600,34
	GOTO 오른쪽턴2

	GOTO MAIN
	
KEY35:
	ETX  9600,35
	GOTO 오른쪽옆찌르기


	GOTO MAIN
	
KEY36:
	ETX  9600,36
	GOTO 왼쪽옆찌르기


	GOTO MAIN
	
KEY37:
	ETX  9600,37
	GOTO 정면양펀치


	GOTO MAIN
	
KEY38:
	ETX  9600,38
	GOTO 사이드공격


	GOTO MAIN
	
KEY39:
	ETX  9600,39
	GOTO 정면팔올리기


	GOTO MAIN
	
KEY40:
	ETX  9600,40
	GOTO 앉은왼쪽턴

	GOTO MAIN

KEY41:
	ETX  9600,41
	GOTO 앉은오른쪽턴

	GOTO MAIN


KEY42:
	ETX  9600,42
	'GOTO 왼팔내지르기
	GOTO 앉아왼팔뻗기
	GOTO MAIN

KEY43:
	ETX  9600,43
	'GOTO 오른팔내지르기
	GOTO 앉아오른팔뻗기
	GOTO MAIN
KEY44:
	ETX  9600,44
	GOTO 앉아정면공격
	GOTO MAIN
KEY45:
	ETX  9600,45
	GOSUB 앉은자세
	SPEED 15
	HIGHSPEED SETON
	MOVE G6A, 92, 150,  37, 139,  97, 100
	MOVE G6C,114,  61,  81, 100, 100, 100
	MOVE G6B, 125, 184,  90, , 100, 100
	MOVE G6A, 53,  86, 111, 123, 147, 100
	
	DELAY 50
	HIGHSPEED SETOFF
	SPEED 10
	MOVE G6C,118,  54,  80, 100, 100, 100
	MOVE G6A, 90, 119,  53, 149, 120, 100
	MOVE G6D, 55, 129,  95, 102, 141, 100
	MOVE G6A,108, 146,  24, 151,  95, 100
	SPEED 15
	HIGHSPEED SETON
	MOVE G6B,101, 24,  70, , 100, 100
	MOVE G6A,100, 151,  27, 145, 100, 100
	'MOVE G6D,100, 151,  27, 147, 100, 100
	MOVE G6B,120,  30,  80, , , 
	MOVE G6C,120,  30,  80, , , 
	WAIT
	
	MOVE G6A,100, 151,  23, 145, 101, 100
	'MOVE G6D,100, 151,  23, 147, 101, 100
	MOVE G6B,120,  30,  80, , , 
	MOVE G6C,120,  30,  80, , , 
	WAIT
	
	HIGHSPEED SETOFF
	'GOSUB 앉은자세
'	GOTO 앉아정면공격
	GOTO MAIN
KEY46:
	ETX  9600,46
	GOSUB 앉은자세
	SPEED 15
	HIGHSPEED SETON
	MOVE G6D, 92, 150,  37, 139,  97, 100
	MOVE G6B,114,  61,  81, , 100, 100
	MOVE G6C, 125, 184,  90, , 100, 100
	MOVE G6D, 53,  86, 111, 123, 147, 100
	
	DELAY 50
	HIGHSPEED SETOFF
	SPEED 10
	MOVE G6B,118,  54,  80, , 100, 100
	MOVE G6D, 90, 119,  53, 149, 120, 100
	MOVE G6A, 55, 129,  95, 102, 141, 100
	MOVE G6D,108, 146,  24, 151,  95, 100
	SPEED 15
	HIGHSPEED SETON
	MOVE G6C,101, 24,  70, , 100, 100
	MOVE G6D,100, 151,  27, 145, 100, 100
'	MOVE G6A,100, 151,  27, 147, 100, 100
	MOVE G6C,120,  30,  80, , , 
	MOVE G6B,120,  30,  80, , , 
	WAIT
	
	MOVE G6D,100, 151,  23, 145, 101, 100
'	MOVE G6A,100, 151,  23, 147, 101, 100
	MOVE G6C,120,  30,  80, , , 
	MOVE G6B,120,  30,  80, , , 
	WAIT
	
	HIGHSPEED SETOFF
	'GOSUB 앉은자세
'	GOTO key45
	GOTO MAIN
KEY47:
	ETX  9600,47
	SPEED 10
'	MOVE G6A, 97,  82, 144,  90, 105, 100
'	MOVE G6D, 97,  81, 143,  91, 105, 100
	FOR I = 1 TO 3
	SPEED 15
	HIGHSPEED SETON
	MOVE G6C, 39, 183, 190,    ,    ,    
	WAIT
	MOVE G6B, 43, 183,  75,    ,    ,    
	WAIT
	MOVE G6C, 39, 183,  75,    ,    ,    
	WAIT
	MOVE G6B, 43, 183, 190,    ,    ,    
	WAIT
	HIGHSPEED SETOFF
	NEXT I
	GOTO MAIN
KEY48:
	ETX  9600,50
'	GOTO 앉아오른뻗기
	GOSUB 앉은자세
	SPEED 12
	HIGHSPEED SETON
	MOVE G6D, 92, 150,  37, 139,  97, 100
	MOVE G6B,114,  61,  81, 	, 100, 100
	MOVE G6D, 53,  86, 111, 123, 147, 100
	MOVE G6C,121, 104,  96, 100, 100, 100
	DELAY 50
	HIGHSPEED SETOFF
	SPEED 5
	MOVE G6B,121,  54,  80,    , 100, 100
	MOVE G6D, 90, 119,  53, 149, 120, 100
	MOVE G6A, 55, 129,  95, 102, 141, 100
	MOVE G6D,108, 146,  24, 151,  95, 100
	GOSUB 앉은자세
	GOTO MAIN



END
