
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM 보행순서 AS BYTE
'**** 기울기센서포트 설정

CONST 앞뒤기울기AD포트 = 2
CONST 좌우기울기AD포트 = 3

'*****  2012년 이전 센서 ****
'CONST 기울기확인시간 = 10  'ms
'CONST min = 100         '뒤로넘어졌을때
'CONST max = 160         '앞으로넘어졌을때
'CONST COUNT_MAX = 30
'

'**** 2012년 사용 센서 *****
CONST 기울기확인시간 = 5  'ms
CONST MIN = 61         '뒤로넘어졌을때
CONST MAX = 107         '앞으로넘어졌을때
CONST COUNT_MAX = 20

'*******************

'*******모터방향설정*********************
DIR G6A,1,0,0,1,0,0   '왼쪽다리:모터0~5번
DIR G6D,0,1,1,0,1,0   '오른쪽다리:모터18~23번
DIR G6B,1,1,1,1,1,1   '왼쪽팔:모터6~11번
DIR G6C,0,0,0,0,0,0   '오른쪽팔:모터12~17번


'*******모터동시제어설정****************
PTP SETON       '단위그룹별 점대점동작 설정
PTP ALLON      '전체모터 점대점 동작 설정

'*******모터위치값피드백****************
GOSUB MOTOR_GET

'*******모터사용설정********************
GOSUB MOTOR_ON

'*******피에조소리내기******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** 초기자세로 **********************
SPEED 5
GOSUB 기본자세


보행순서 = 1
'***** 메인 반복루틴 **************
MAIN:

    ERX 4800,A,MAIN
    A_old = A

    IF A = 1 THEN
        GOTO 전진달리기30
    ELSEIF A = 2 THEN
        GOTO 전진달리기50
    ELSEIF A = 3 THEN
        GOTO 전진보행50
    ELSEIF A = 4 THEN
        GOTO 기어가다일어나기
    ELSEIF A = 5 THEN
        GOTO 기어가기
    ELSE
        MUSIC "F"   
    ENDIF


    GOTO MAIN
    '************************************************
    '******************************************

전진달리기30: '보폭이 짧게
    '넘어진확인 = 0

    SPEED 6
    HIGHSPEED SETON

    IF 보행순서 = 0 THEN
        MOVE G6A,100,  80, 121, 118, 104
        MOVE G6D,102,  75, 150,  93,  102
        MOVE G6B, 80,  30,  80
        MOVE G6C,120,  30,  80

        보행순서 = 1
        GOTO 전진달리기30_2
    ELSE
        MOVE G6D,100,  80, 121, 118, 104
        MOVE G6A,102,  75, 150,  93,  102
        MOVE G6C, 80,  30,  80
        MOVE G6B,120,  30,  80

        보행순서 = 0
        GOTO 전진달리기30_4

    ENDIF



    '********************************************
전진달리기30_1:

    '왼발들기10:
    MOVE G6A,100,  80, 121, 118, 104
    MOVE G6D,100,  75, 150,  93, 102  ''''
    MOVE G6B, 80,  30,  80
    MOVE G6C,120,  30,  80


    ERX 4800, A, 전진달리기30_2
    GOSUB 기본자세
    HIGHSPEED SETOFF
    GOTO RX_EXIT


전진달리기30_2:

    '왼발중심이동1:
    MOVE G6A,101,  74, 140, 106, 102
    MOVE G6D, 95, 105, 124,  93, 104
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80

    'GOSUB 앞뒤기울기측정
    'IF 넘어진확인 = 1 THEN
    '    넘어진확인 = 0
    '    GOTO MAIN
    'ENDIF

전진달리기30_3:
    '오른발들기10:
    MOVE G6D,100,  80, 121, 118, 104
    MOVE G6A,100,  75, 150,  93, 102   '''''
    MOVE G6C, 80,  30,  80
    MOVE G6B,120,  30,  80




    ERX 4800, A, 전진달리기30_4
    GOSUB 기본자세
    HIGHSPEED SETOFF
    GOTO RX_EXIT

전진달리기30_4:
    '오른발중심이동1:
    MOVE G6D,101,  74, 140, 106, 102
    MOVE G6A, 95, 105, 124,  93, 104
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80



    'GOSUB 앞뒤기울기측정
    'IF 넘어진확인 = 1 THEN
    '    넘어진확인 = 0
    '    GOTO MAIN
    'ENDIF

    '************************************************


    GOTO 전진달리기30_1


    GOTO RX_EXIT

    '*********************************************
    '******************************************
전진달리기50:

    SPEED 12
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기50_4
    ENDIF


    '**********************

전진달리기50_1:
    'MOVE G6A,95,  95, 100, 120, 104
    'MOVE G6D,104, 78, 146,  91, 102
    'MOVE G6B, 80
    'MOVE G6C,120
    'WAIT
    
    MOVE G6A ,95,  95, 100, 120, 103
    MOVE G6D ,107, 76, 146,  91, 103
    MOVE G6B , 80
    MOVE G6C ,120
    WAIT


전진달리기50_2:
'    MOVE G6A,95,  75, 122, 120, 104
'    MOVE G6D,104, 80, 146,  89, 100
'    WAIT
	
	MOVE G6A,95,  75, 122, 120, 103
    MOVE G6D,107, 86, 137,  91, 102
    WAIT

전진달리기50_3:
    MOVE G6A,103, 70, 145, 103, 100
    MOVE G6D, 95, 88, 160,  68, 102
    WAIT

    ERX 4800,A, 전진달리기50_4
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤

    '*********************************

전진달리기50_4:
    'MOVE G6D,95,  95, 100, 120, 104
    'MOVE G6A,104, 78, 146,  91, 102
    'MOVE G6C, 80
    'MOVE G6B,120
    'WAIT
    
    MOVE G6D ,95,  95, 100, 120, 103
    MOVE G6A ,107, 76, 146,  91, 103
    MOVE G6C , 80
    MOVE G6B ,120
    WAIT

전진달리기50_5:
    'MOVE G6D,95,  75, 122, 120, 104
    'MOVE G6A,104, 80, 146,  89, 100
    'WAIT

	MOVE G6D,95,  75, 122, 120, 103
    MOVE G6A,107, 86, 137,  91, 102
    WAIT
전진달리기50_6:
    MOVE G6D,103, 70, 145, 103, 100
    MOVE G6A, 95, 88, 160,  68, 102
    WAIT

    ERX 4800,A, 전진달리기50_1
    IF A <> A_old THEN  GOTO 전진달리기50_멈춤

    GOTO 전진달리기50_1

    '*********************************
전진달리기50_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
전진보행50:
    GOSUB Leg_motor_mode3
    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  96
    MOVE G6B,100,35
    MOVE G6C,100,35
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,111,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


전진보행50_1:

    SPEED 10
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 113, 114
    MOVE G6D,110,  77, 146,  93,  94
    WAIT

    SPEED 4
    '왼발중심이동
    MOVE G6A,110,  76, 144, 100,  93
    MOVE G6D,85, 93, 155,  71, 112
    WAIT

    SPEED 10
    '오른발들기10
    MOVE G6A,111,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 전진보행50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        SPEED 5
        '왼쪽기울기2
        MOVE G6A, 106,  76, 146,  93,  96      
        MOVE G6D,  88,  71, 152,  91, 106
        MOVE G6B, 100,35
        MOVE G6C, 100,35
        WAIT   

        SPEED 3
        GOSUB 기본자세
        GOSUB Leg_motor_mode1

        GOTO MAIN
    ENDIF
    '**********


전진보행50_2:

    SPEED 10
    '오른발뻣어착지
    MOVE G6D,85,  44, 163, 113, 114
    MOVE G6A,110,  77, 146,  93,  94
    WAIT

    SPEED 4
    '오른발중심이동
    MOVE G6D,110,  76, 144, 100,  93
    MOVE G6A, 85, 93, 155,  71, 112
    WAIT

    SPEED 10
    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,111,  77, 146,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ERX 4800,A, 전진보행50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        SPEED 5
        '오른쪽기울기2
        MOVE G6D, 106,  76, 146,  93,  96      
        MOVE G6A,  88,  71, 152,  91, 106
        MOVE G6C, 100,35
        MOVE G6B, 100,35
        WAIT

        SPEED 3
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        GOTO MAIN
    ENDIF


    GOTO 전진보행50_1
    '************************************************
    '******************************************
    '***************************************
기어가다일어나기:

    PTP SETON      
    PTP ALLON
    SPEED 15
    HIGHSPEED SETOFF


    MOVE G6A, 100, 150,  80, 150, 100
    MOVE G6D, 100, 150,  80, 150, 100
    MOVE G6B,185,  40, 60
    MOVE G6C,185,  40, 60
    WAIT

    GOSUB Leg_motor_mode3
    DELAY 300


    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3   
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    GOSUB 기본자세

    GOTO RX_EXIT

    '******************************************************

기어가기:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5   
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT   

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 8
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON

    'GOTO 기어가기왼쪽턴_LOOP

기어가기_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 100, 145,  75, 160, 100
    MOVE G6B, 175,  25,  70
    MOVE G6C, 190,  50,  40
    WAIT
    ERX 4800, A, 기어가기_1
    '    IF A = 8 THEN GOTO 기어가기_1
    '   IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    '  IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 기어가다일어나기

기어가기_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 175,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    ERX 4800, A, 기어가기_2
    ' IF A = 8 THEN GOTO 기어가기_2
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    GOTO 기어가다일어나기

기어가기_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 160,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    GOTO 기어가기_LOOP





안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN
    '************************************************
    '************************************************
    '******************************************
    '***************************************
MOTOR_ON: '전포트서보모터사용설정
    MOTOR G24
    RETURN

    '***********************************
MOTOR_OFF: '전포트서보모터설정해제
    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    RETURN
    '***********************************
MOTOR_GET: '위치값피드백
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '*******기본자세관련*****************

기본자세:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 100, 100
    WAIT
    RETURN
    '*************************************   
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    RETURN
    '**************************************
앉은자세:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    RETURN
    '***************************************

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3
    MOTORMODE G6C,3,3,3
    RETURN

    '************************************************

RX_EXIT: '수신값을 버리는루틴   

    ERX 4800, A, MAIN

    GOTO RX_EXIT

    '************************************************