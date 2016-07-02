
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'**********DIM A AS BYTE******************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM ONE AS BYTE
DIM I AS BYTE
DIM J AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM 보행순서 AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE


'**** 기울기센서포트 설정
ONE = 1
'GOSUB GYRO_INIT
'GOSUB GYRO_ON
'GOSUB GYRO_ST

CONST 앞뒤기울기AD포트 = 2
CONST 좌우기울기AD포트 = 3

'*****  2012년 이전 센서 ****
'CONST 기울기확인시간 = 10  'ms
'CONST min = 100			'뒤로넘어졌을때
'CONST max = 160			'앞으로넘어졌을때
'CONST COUNT_MAX = 30
'

'**** 2012년 사용 센서 *****
CONST 기울기확인시간 = 5  'ms
CONST MIN = 61			'뒤로넘어졌을때
CONST MAX = 107			'앞으로넘어졌을때
CONST COUNT_MAX = 20

'*******************




'*******모터동시제어설정****************
PTP SETON 		'단위그룹별 점대점동작 설정
PTP ALLON		'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,0,0		'모터12~17번
DIR G6D,0,1,1,0,1,0		'모터18~23번


'*******모터사용설정********************
GOSUB MOTOR_ON

'*******피에조소리내기******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** 초기자세로 **********************
SPEED 5
GOSUB 기본자세


보행순서 = 0

'***** 메인 반복루틴 **************
MAIN:

    IF ONE=1 THEN
        'GOTO 오른쪽턴45
        'GOTO 내려가기직전종종걸음
        'GOTO 외각선내려가기
        'GOTO 외각선올라가기
        'GOTO 앞으로덤블링
        'GOTO 기어가기
        'GOTO 계단오른발오르기1cm
        'GOTO 기어서올라가기
        'GOTO 허들넘기

        'GOTO 전진종종걸음

        'GOTO 판위에서전진종종2걸음
        'GOTO 판위에서전진보행50
        DELAY 6000
        'GOTO 전진보행50
        'GOTO 계단왼발내리기2cm
        'GOTO 고개90도전진보행
        'GOTO 전진보행10걸음
        'GOTO 판위에서전진보행50
        'GOTO 왼쪽덤블링
        'GOTO 외각선오른쪽턴20
        'GOTO 외각선왼쪽턴20
        'GOTO 집고달리기
        'GOTO 전진종종걸음
        'GOTO 외각선오른쪽턴20
        'GOTO 전진종종비비기
        'GOTO 전진앉아보행
        GOTO 앞으로덤블링
        'GOTO 허들넘기
        'GOTO 전진종종4걸

        'GOTO 왼쪽턴45
        'GOTO 오른쪽턴10
        'GOTO 오른쪽옆으로10
        'GOTO 왼쪽옆으로70
        'GOTO 계단오른발오르기2cm
        'GOTO 계단왼발내리기2cm
    ENDIF


    GOTO MAIN
    '************************************************
    '******************************************
    '국민체조_6: '옆꾸리운동
    '    GOSUB All_motor_mode3'
    '
    '            SPEED 10
    '            MOVE G6D,96,  116, 62,  146, 130, 100
    '            MOVE G6A,75,  86, 125,  110, 85, 100
    '            MOVE G6C,100,  45,  90,,122
    '            MOVE G6B,100,  28,  81,, , 190
    '            WAIT
    '	DELAY 1000
    '    GOSUB 기본자세
    '    ONE = 0
    '    GOTO MAIN




전진앉아보행:
    GOSUB All_motor_mode3
    SPEED 4

전진앉아보행_1:
    FOR I = 0 TO 5
        MOVE G6A,114, 143,  28, 142,  96, 100
        MOVE G6D, 87, 135,  28, 155, 110, 100
        WAIT


        MOVE G6D,98, 126,  28, 160, 102, 100
        MOVE G6A,98, 160,  28, 125, 102, 100
        WAIT

        '    ERX 4800, A, 전진앉아보행_2
        '    SPEED 6
        '    IF  물건집은상태 = 0 THEN
        '        GOSUB 앉은자세
        '    ELSE
        '        MOVE G6A,100, 140,  28, 142, 100, 100
        '        MOVE G6D,100, 140,  28, 142, 100, 100
        '        WAIT
        '        자세 = 1
        '    ENDIF
        '    GOSUB All_motor_Reset
        '    GOTO RX_EXIT

전진앉아보행_2:
        MOVE G6D,113, 143,  28, 142,  96, 100
        MOVE G6A, 87, 135,  28, 155, 110, 100
        WAIT

        MOVE G6A,98, 126,  28, 160, 102, 100
        MOVE G6D,98, 160,  28, 125, 102, 100
        WAIT

        '    ERX 4800, A, 전진앉아보행_1
        '    SPEED 6
        '    IF  물건집은상태 = 0 THEN
        '        GOSUB 앉은자세
        '    ELSE
        '        MOVE G6A,100, 140,  28, 142, 100, 100
        '        MOVE G6D,100, 140,  28, 142, 100, 100
        '        WAIT
        '        자세 = 1
        '    ENDIF
    NEXT I
    GOSUB 앉은자세

    GOSUB All_motor_Reset

    GOTO RX_EXIT



계단왼발내리기2cm: ' GREEN USE
    GOSUB 기본자세
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,106,  77, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,115,  76, 145,  93,  93
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 6
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,112,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 5
    MOVE G6A,93, 45, 175, 148, 114,
    MOVE G6D,112,  115, 65,  138,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,92,12, 165, 150, 105
    MOVE G6D,110,  155, 45,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,104, 30, 150, 150, 104
    MOVE G6D,85,  154, 80,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6A,111, 68, 128, 143, 94
    MOVE G6D,75,  125, 140,  86,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6A,111, 68, 128, 148, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 2
    MOVE G6A,111, 70, 133, 130, 94
    MOVE G6D,93,  125, 40,  150,114
    WAIT


    GOSUB Leg_motor_mode2
    SPEED 3
    MOVE G6A,111, 75, 128, 117, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 4
    MOVE G6A,111, 80, 128, 113, 94
    MOVE G6D,80,  75,130,  118,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6D, 98, 80, 130, 110,101,
    MOVE G6A,98,  80, 130,  110, 101
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB 기본자세
    GOSUB All_motor_Reset
    '    GOSUB 앞뒤기울기측정



    GOTO RX_EXIT
    '**********************************************
집고달리기:
    '넘어진확인 = 0
    'GOSUB SOUND_Walk_Ready
    SPEED 15
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  85, 101
        MOVE G6D,101,  77, 145,  85, 98
        WAIT

        GOTO 집고달리기_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  85, 101
        MOVE G6A,101,  77, 145,  85, 98
        WAIT

        GOTO 집고달리기2_4
    ENDIF


    '**********************

집고달리기_1:
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6D,104,  77, 145,  87,  102
    WAIT
    DELAY 5

집고달리기_2:
    MOVE G6D,104,  79, 145,  82,  100
    MOVE G6A,95,  85, 130, 95, 104
    WAIT
    DELAY 5
집고달리기_3:
    MOVE G6A,103,   85, 130, 95,  100
    MOVE G6D, 97,  79, 145,  82, 102
    WAIT
    DELAY 5
    '    GOSUB SOUND_REPLAY
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF

    '    ERX 4800,A, 집고달리기_4
    '    IF A <> A_old THEN  GOTO 집고달리기_멈춤

    '*********************************

집고달리기_4:
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6A,104,  77, 145,  87,  102
    WAIT


집고달리기_5:
    MOVE G6D,95,  85, 130, 95, 104
    MOVE G6A,104,  79, 145,  82,  100
    WAIT

집고달리기_6:
    MOVE G6D,103,   85, 130, 95,  100
    MOVE G6A, 97,  79, 145,  82, 102
    WAIT
    '    GOSUB SOUND_REPLAY
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF''
    '
    '    ERX 4800,A, 집고달리기_1
    '    IF A <> A_old THEN  GOTO 집고달리기_멈춤
    GOTO 집고달리기_멈춤
    '
    '    GOTO 집고달리기_1
집고달리기2_4:
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6A,104,  77, 145,  87,  102
    WAIT


집고달리기2_5:
    MOVE G6D,95,  85, 130, 95, 104
    MOVE G6A,104,  79, 145,  82,  100
    WAIT

집고달리기2_6:
    MOVE G6D,103,   85, 130, 95,  100
    MOVE G6A, 97,  79, 145,  82, 102
    WAIT
집고달리기2_1:
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6D,104,  77, 145,  87,  102
    WAIT
    DELAY 5

집고달리기2_2:
    MOVE G6D,104,  79, 145,  82,  100
    MOVE G6A,95,  85, 130, 95, 104
    WAIT
    DELAY 5
집고달리기2_3:
    MOVE G6A,103,   85, 130, 95,  100
    MOVE G6D, 97,  79, 145,  82, 102
    WAIT
    DELAY 5


집고달리기_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO MAIN


기본자세0:
    '자이로 꺼진 고개 90도(TH)
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  85, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT
    RETURN


고개90도전진보행: 'COMPLETE GREEN

    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB 기본자세0
    GOSUB Leg_motor_mode3


    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,106,  76, 146,  93,  96
    MOVE G6B,100,37
    MOVE G6C,100,35,,,
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,112,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO 전진보행50_1



고개90도전진보행_1:
    FOR I = 0 TO 1

        SPEED 보행속도
        '왼발뻣어착지
        MOVE G6A, 85,  44, 163, 113, 117
        MOVE G6D,108,  77, 146,  93,  92
        WAIT



        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '왼발중심이동
        MOVE G6A,108,  76, 144, 100,  93
        MOVE G6D,86, 93, 155,  71, 112
        WAIT



        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '오른발들기10
        MOVE G6A,110,  77, 146,  93, 94
        MOVE G6D,90, 100, 105, 110, 114
        MOVE G6B,110
        MOVE G6C,90
        WAIT



고개90도전진보행_2:


        SPEED 보행속도
        '오른발뻣어착지
        MOVE G6D,87,  44, 163, 113, 117
        MOVE G6A,108,  77, 147,  94,  92
        WAIT

        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '오른발중심이동
        MOVE G6D,108,  76, 144, 100,  93
        MOVE G6A, 85, 93, 155,  71, 112
        WAIT


        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '왼발들기10
        MOVE G6A, 90, 100, 105, 110, 114
        MOVE G6D,112,  77, 146,  93,  94
        MOVE G6B, 90
        MOVE G6C,110
        WAIT



    NEXT I





    'GOSUB 안정화자세2
    GOSUB 기본자세0
    GOTO main
전진종종걸음:
    '    넘어진확인 = 0
    '    GOSUB SOUND_Walk_Ready

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종걸음2_4
    ENDIF


    '**********************

전진종종걸음_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


전진종종걸음_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

전진종종걸음_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
    'GOSUB SOUND_REPLAY
    'GOSUB 앞뒤기울기측정
    'IF 넘어진확인 = 1 THEN
    '   넘어진확인 = 0
    '   GOTO MAIN
    'ENDIF

    'ERX 4800,A, 전진종종걸음_4
    'IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

    '*********************************

전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


전진종종걸음_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

전진종종걸음_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
    '전진종종걸음_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    '전진종종걸음_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

    '전진종종걸음_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT


    '    GOSUB SOUND_REPLAY
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    GOTO 전진종종걸음_멈춤
    '    ENDIF

    '    ERX 4800,A, 전진종종걸음_1

전진종종걸음2_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


전진종종걸음2_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

전진종종걸음2_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
전진종종걸음2_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


전진종종걸음2_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

전진종종걸음2_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
    '전진종종걸음2_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    '전진종종걸음2_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

    '전진종종걸음2_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT

    GOTO 전진종종걸음_멈춤

전진종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


전진종종4걸음:
    GOSUB 기본자세

    SPEED 15
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,97,  76, 145,  93, 101
        MOVE G6D,100,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종4걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,97,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종4걸음_4
    ENDIF



    '**********************
전진종종4걸음_1:
    FOR I = 0 TO 2
        '전진종종걸음최종_1:
        MOVE G6A,97,  95, 120, 102, 103
        MOVE G6D,102, 78, 146,  91,  101
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음최종_2:
        MOVE G6A,97,  83, 130, 103, 103
        MOVE G6D,102,  79, 146, 90, 100
        WAIT

        '전진종종걸음최종_3:
        MOVE G6A,101,  84, 130, 103,  101
        MOVE G6D, 96,  81, 147,  90, 102
        WAIT

        '전진종종걸음최종_4:
        MOVE G6D,97,  97, 120,  101, 103
        MOVE G6A,103, 78, 146,  92,  101
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '전진종종걸음최종_5:
        MOVE G6D,97,  85, 130, 103, 103
        MOVE G6A,102, 79, 147, 90, 100
        WAIT

        '전진종종걸음최종_6:
        MOVE G6D,101,   86, 130, 103, 101
        MOVE G6A, 96,   81, 144,  91, 102
        WAIT
    NEXT I
    GOTO 전진종종4걸음멈춤


전진종종4걸음_4:
    FOR I = 0 TO 2
        '전진종종걸음최종_4:
        MOVE G6D,97,  97, 120,  101, 103
        MOVE G6A,103, 78, 146,  92,  101
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '전진종종걸음최종_5:
        MOVE G6D,97,  85, 130, 103, 103
        MOVE G6A,102, 79, 147, 90, 100
        WAIT

        '전진종종걸음최종_6:
        MOVE G6D,101,   86, 130, 103, 101
        MOVE G6A, 96,   81, 144,  91, 102
        WAIT

        '전진종종걸음최종_1:
        MOVE G6A,97,  95, 120, 102, 103
        MOVE G6D,102, 78, 146,  91,  101
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음최종_2:
        MOVE G6A,97,  83, 130, 103, 103
        MOVE G6D,102,  79, 146, 90, 100
        WAIT

        '전진종종걸음최종_3:
        MOVE G6A,101,  84, 130, 103,  101
        MOVE G6D, 96,  81, 147,  90, 102
        WAIT


    NEXT I
    GOTO 전진종종4걸음멈춤

전진종종4걸음멈춤:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세


    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO MAIN



전진종종비비기:
    '    넘어진확인 = 0

    GOSUB 기본자세
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 135
    WAIT

    '        GOTO 전진종종걸음_1
    '    ELSE
    '        보행순서 = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        MOVE G6B,100,  35
    '        MOVE G6C,100,  35
    '        WAIT

    '       GOTO 전진종종걸음_4
    '    ENDIF


    '**********************
    FOR I = 0 TO 3
전진종종비비기_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


전진종종비비기_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

전진종종비비기_3:
        MOVE G6A,103,   85, 130, 103,  100
        MOVE G6D, 95,  79, 146,  89, 102
        WAIT

        '    GOSUB 앞뒤기울기측정
        '    IF 넘어진확인 = 1 THEN
        '        넘어진확인 = 0
        '        GOTO MAIN
        '    ENDIF
        '
        '    ERX 4800,A, 전진종종걸음_4
        '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

        '*********************************

전진종종비비기_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


전진종종비비기_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

전진종종비비기_6:
        MOVE G6D,103,   85, 130, 103,  100
        MOVE G6A, 95,  79, 146,  89, 102
        WAIT
    NEXT I
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_1
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

전진종종비비기_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세



    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'보행순서=0
    GOTO MAIN




계단오른발오르기2cm: 'UPSTAIR GREEN

    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,107,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,112,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,112,  71, 155,  90,  94
    WAIT


    SPEED 8
    MOVE G6D,  80, 55, 120, 160, 114,
    MOVE G6A,110,  70, 155,  90,  94
    WAIT

    SPEED 8
    MOVE G6D,  90, 55, 120, 150, 114,
    MOVE G6A,110,  70, 160,  85,  94
    WAIT




    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6D, 106, 75, 100, 150, 100,
    MOVE G6A,95,  90, 165,  65, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 8
    MOVE G6D, 111, 87, 90, 153,100,
    MOVE G6A,95,  100, 165,  62, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 113, 87, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 8
    MOVE G6D, 113, 87, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 8
    MOVE G6D, 113, 90, 110, 128,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 8
    MOVE G6D, 110, 90, 110, 127,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 8
    MOVE G6D, 110, 90, 110, 127,103,
    MOVE G6A,80,  70, 160,  100, 103
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    MOVE G6A, 97, 90, 110, 125,102,
    MOVE G6D,97,  90, 110,  125, 102
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    'SPEED 8
    'MOVE G6A,100,  77, 145,  93, 100, 100
    'MOVE G6D,100,  77, 145,  93, 100, 100
    'MOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    'WAIT
    GOSUB All_motor_Reset

    GOSUB 기본자세
    GOTO MAIN

qwer계단왼발내리기2cm: ' GREEN USE
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 89,  71, 152,  91, 110
    MOVE G6D,108,  77, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,112,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 8
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,112,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,112,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 45,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,104, 30, 150, 150, 104
    MOVE G6D,85,  155, 80,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,75,  125, 140,  88,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A,111, 75, 128, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 4
    MOVE G6A,111, 80, 128, 113, 94
    MOVE G6D,80,  75,130,  118,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6D, 98, 80, 130, 110,101,
    MOVE G6A,98,  80, 130,  110, 101
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB 기본자세
    GOSUB All_motor_Reset
    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정

    GOTO MAIN


오른쪽옆으로10:


    SPEED 12
    MOVE G6D, 95,  90, 120, 105, 104, 100
    MOVE G6A,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,92,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세
    GOTO MAIN

왼쪽옆으로10:


    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 105,  77, 145, 93, 98, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세
    GOTO MAIN

왼쪽턴10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 기본자세
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6A,97,  86, 146,  85, 102, 100
    MOVE G6D,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,92,  86, 146,  85, 101, 100
    MOVE G6D,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT


    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO MAIN



왼쪽턴20: ' COMPLETE
    GOSUB 기본자세
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  100, 145,  68, 105, 100
    MOVE G6D,95,  50, 145,  118, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 15
    MOVE G6A,93,  100, 145,  68, 105, 100
    MOVE G6D,93,  50, 145,  118, 105, 100
    WAIT
    SPEED 8
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO MAIN
왼쪽턴45: ' COMPLETE
    GOSUB 기본자세
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  112, 145,  55, 105, 100
    MOVE G6D,95,  38, 145,  129, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 12
    MOVE G6A,93,  112, 145,  56, 105, 100
    MOVE G6D,93,  38, 145,  127, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO MAIN




오른쪽턴10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 기본자세
    GOSUB Leg_motor_mode2
    SPEED 12
    MOVE G6D,97,  86, 146,  85, 102, 100
    MOVE G6A,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6D,92,  86, 146,  85, 101, 100
    MOVE G6A,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT


    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO MAIN


오른쪽턴20: ' COMPLETE


    GOSUB 기본자세
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6D,95,  90, 145,  78, 105, 100
    MOVE G6A,95,  60, 145,  108, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 10
    MOVE G6D,93,  100, 145,  68, 105, 100
    MOVE G6A,93,  50, 145,  118, 105, 100

    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 100, 100
    MOVE G6A,101,  76, 146,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1


    GOTO MAIN

오른쪽턴30: ' COMPLETE
    GOSUB 기본자세
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6A,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO MAIN


오른쪽턴45: ' COMPLETE

    GOSUB 기본자세
    SPEED 12
    MOVE G6D,95,  116, 145,  53, 105, 100
    MOVE G6A,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 12
    MOVE G6D,90,  116, 145,  53, 105, 100
    MOVE G6A,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOTO MAIN



판위에서전진보행50: 'COMPLETE

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB Leg_motor_mode3


    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,106,  76, 146,  93,  96
    MOVE G6B,100,37
    MOVE G6C,100,35,,,
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,109,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO 전진보행50_1



판위에서전진보행50_1:
    FOR I = 0 TO 9

        SPEED 보행속도
        '왼발뻣어착지
        MOVE G6A, 85,  44, 163, 113, 117
        MOVE G6D,108,  77, 146,  93,  92
        WAIT



        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '왼발중심이동
        MOVE G6A,108,  76, 144, 100,  93
        MOVE G6D,86, 93, 155,  71, 112
        WAIT



        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '오른발들기10
        MOVE G6A,110,  77, 146,  93, 94
        MOVE G6D,90, 100, 105, 110, 114
        MOVE G6B,110
        MOVE G6C,90
        WAIT



판위에서전진보행50_2:


        SPEED 보행속도
        '오른발뻣어착지
        MOVE G6D,87,  44, 163, 113, 117
        MOVE G6A,108,  77, 147,  94,  92
        WAIT

        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '오른발중심이동
        MOVE G6D,108,  76, 144, 100,  93
        MOVE G6A, 85, 93, 155,  71, 112
        WAIT


        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '왼발들기10
        MOVE G6A, 90, 100, 105, 110, 114
        MOVE G6D,110,  77, 146,  93,  94
        MOVE G6B, 90
        MOVE G6C,110
        WAIT



    NEXT I

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 113, 117
    MOVE G6D,108,  77, 146,  93,  92
    WAIT



    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,108,  76, 144, 100,  93
    MOVE G6D,86, 93, 155,  71, 112
    WAIT



    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '오른발들기10
    MOVE G6A,110,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT




    GOSUB 안정화자세2
    'GOSUB 기본자세
    GOSUB GYRO_OFF

    'GOTO MAIN
    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정

    GOTO main



전진보행10걸음:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB Leg_motor_mode3


    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,35
    MOVE G6C,100,35,,,135
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,110,  78, 146,  93,  93
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    '        GOTO 전진보행50_1



전진보행10걸음_1:
    FOR I = 0 TO 9
        SPEED 보행속도
        '왼발뻣어착지
        MOVE G6A, 85,  44, 163, 113, 117
        MOVE G6D,109,  77, 146,  93,  92
        WAIT



        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '왼발중심이동
        MOVE G6A,109,  76, 144, 100,  93
        MOVE G6D,86, 93, 155,  71, 112
        WAIT



        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '오른발들기10
        MOVE G6A,110,  77, 146,  93, 94
        MOVE G6D,90, 100, 105, 110, 114
        MOVE G6B,110
        MOVE G6C,90
        WAIT



전진보행10걸음_2:


        SPEED 보행속도
        '오른발뻣어착지
        MOVE G6D,85,  44, 163, 113, 117
        MOVE G6A,110,  77, 146,  93,  94
        WAIT

        SPEED 좌우속도
        'GOSUB Leg_motor_mode3
        '오른발중심이동
        MOVE G6D,109,  76, 144, 100,  93
        MOVE G6A, 85, 93, 155,  71, 112
        WAIT


        SPEED 보행속도
        'GOSUB Leg_motor_mode2
        '왼발들기10
        MOVE G6A, 90, 100, 105, 110, 114
        MOVE G6D,110,  77, 146,  93,  94
        MOVE G6B, 90
        MOVE G6C,110
        WAIT
    NEXT I

    MOVE G6A,87,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B,100,  25,  80, 100, 100, 100
    MOVE G6C,100 ,  31,  80, 100, 100, 100
    WAIT
    GOSUB 기본자세
    'GOSUB GYRO_OFF
    '    ONE=0

    'DELAY 400

    GOSUB GYRO_OFF
    ONE = 0
    GOTO MAIN
앞으로덤블링:

    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,
    MOVE G6C,160,  30,  85,,190
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 97
    MOVE G6C,185,  10, 100
    WAIT


    SPEED 8
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,130,  80,  20,,,
    MOVE G6C,130,  80,  20,,190
    WAIT

    SPEED 15
    MOVE G6A,100, 128, 140, 147, 100, 100
    MOVE G6D,100, 128, 140, 147, 100, 100
    MOVE G6B,140,  80,  20
    MOVE G6C,140,  80,  20,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,155,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,169,  50,  68
    MOVE G6C,171,  50,  70
    WAIT
    DELAY 200
    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  50,  70
    MOVE G6C,190,  50,  70,,190
    WAIT

	DELAY 50
    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT
    DELAY 200
    SPEED 13
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 180, 100
    MOVE G6C,190, 180, 100
    WAIT
    DELAY 200
    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT
    DELAY 200
    SPEED 13
    GOSUB 앉은자세

    SPEED 10
    GOSUB 기본자세
    GOTO rx_exit



앞으로덤블링4:

    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,
    MOVE G6C,160,  30,  85,,
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 97
    MOVE G6C,189,  10, 100
    WAIT

    SPEED 8	
    MOVE G6A, 100, 145,  55, 165, 100, 100
    MOVE G6D, 100, 145,  55, 165, 100, 100
    MOVE G6B,185,  10, 97
    MOVE G6C,189,  10, 100
    WAIT

    SPEED 8
    MOVE G6A,100, 152, 110, 140, 100, 100
    MOVE G6D,100, 152, 110, 140, 100, 100
    MOVE G6B,130,  80,  20,,,
    MOVE G6C,130,  80,  20,,180
    WAIT

    SPEED 15
    MOVE G6A,100, 128, 140, 147, 100, 100
    MOVE G6D,100, 128, 140, 147, 100, 100
    MOVE G6B,140,  80,  20
    MOVE G6C,140,  80,  20,,180
    WAIT



    DELAY 1000
    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  40,  70
    MOVE G6C,150,  40,  70,,180
    WAIT
    'DELAY 1000

    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  40,  70
    MOVE G6C,150,  40,  70,,
    WAIT
    'ELAY 1000
    SPEED 20
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6A,100,  60, 110, 15, 100, 100
    MOVE G6C,150,  41,  68
    MOVE G6B,150,  40,  70
    WAIT
    SPEED 20
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6A,100,  60, 110, 15, 100, 100
    MOVE G6C,152,  40,  68
    MOVE G6B,151,  40,  65
    WAIT
    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,172,  40,  68
    MOVE G6C,173,  40,  65,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  10
    MOVE G6C,190,  40,  10,,190
    WAIT


    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 10
    MOVE G6C,190, 165, 10
    WAIT


    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT
    SPEED 20
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 160, 120
    MOVE G6C,190, 160, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB 앉은자세

    SPEED 10
    GOSUB 기본자세

    GOTO MAIN

    'goto main

앞으로덤블링2:


    'DELAY 3000
    SPEED 8
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85
    MOVE G6C,130,  30,  85
    WAIT

    SPEED 8	
    MOVE G6A, 100, 155,  60, 165, 100, 100
    MOVE G6D, 100, 157,  55, 165, 100, 100
    MOVE G6B,185,  20, 70
    MOVE G6C,185,  20, 70
    WAIT



    SPEED 12
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20,,190
    WAIT




    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 162, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70,
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,173,  41,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70,,
    WAIT
    DELAY 50

    SPEED 15
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT

    SPEED 15
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 160, 120
    MOVE G6C,190, 160, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB 앉은자세

    SPEED 10
    GOSUB 기본자세
    GOSUB 앞뒤기울기측정


    GOTO main


앞으로덤블링3:

    SPEED 6
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  30,  85,,,
    MOVE G6C,160,  30,  85,,
    WAIT


    SPEED 6
    MOVE G6A, 100, 165,  55, 165, 100, 100
    MOVE G6D, 100, 165,  55, 165, 100, 100
    MOVE G6B,185,  43, 97
    MOVE G6C,185,  43, 100
    WAIT

    'SPEED 4
    'MOVE G6A,100, 165, 110, 140, 100, 100
    'MOVE G6D,100, 165, 110, 140, 100, 100
    'MOVE G6B,140,  80,  40,,,
    'MOVE G6C,140,  80,  40,,190
    'WAIT

    SPEED 6
    MOVE G6A,100, 78, 140, 147, 100, 100
    MOVE G6D,100, 78, 140, 147, 100, 100
    MOVE G6B,150,  80,  40
    MOVE G6C,150,  90,  40,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  55,  70
    MOVE G6C,150,  55,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,150,  55,  70
    MOVE G6C,150,  55,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,169,  55,  68
    MOVE G6C,171,  55,  70
    WAIT
    DELAY 200
    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  55,  70
    MOVE G6C,190,  55,  70,,190
    WAIT
    DELAY 200

    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT

    SPEED 13
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 160, 120
    MOVE G6C,190, 160, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB 앉은자세

    SPEED 10
    GOSUB 기본자세
    DELAY 3000
    GOTO 앞으로덤블링2
    ' GOSUB 앞뒤기울기측정


    'GOTO main

왼쪽덤블링:
    GOSUB Leg_motor_mode1
    SPEED 15
    GOSUB 기본자세


    SPEED 15
    MOVE G6D,100, 125,  62, 132, 100, 100
    MOVE G6A,100, 125,  62, 132, 100, 100
    MOVE G6B,105, 150, 140
    MOVE G6C,105, 150, 140
    WAIT

    SPEED 7
    MOVE G6D,83 , 108,  85, 125, 105, 100
    MOVE G6A,108, 125,  62, 132, 110, 100
    MOVE G6B,105, 155, 145
    MOVE G6C,105, 155, 145
    WAIT


    SPEED 10
    MOVE G6D,89,  125,  62, 130, 110, 100
    MOVE G6A,110, 125,  62, 130, 122, 100
    WAIT
    SPEED 8
    MOVE G6D, 89, 125,  62, 130, 150, 100
    MOVE G6A,106, 125,  62, 130, 150, 100
    MOVE G6B,105, 167, 190
    MOVE G6C,105, 167, 190
    WAIT

    SPEED 6
    MOVE G6D,120, 125,  62, 130, 170, 100
    MOVE G6A,104, 125,  62, 130, 170, 100
    WAIT

    SPEED 12
    MOVE G6D,120, 125,  62, 130, 183, 100
    MOVE G6A,110, 125,  62, 130, 185, 100
    WAIT

    DELAY 400

    SPEED 14
    MOVE G6D,120, 125,  62, 130, 168, 100
    MOVE G6A,120, 125  62, 130, 185, 100
    MOVE G6B,105, 120, 145
    MOVE G6C,105, 120, 145
    WAIT

    SPEED 12
    MOVE G6D,105, 125,  62, 130, 183, 100
    MOVE G6A, 86, 112,  73, 127, 100, 100
    MOVE G6B,105, 120, 135
    MOVE G6C,105, 120, 135
    WAIT

    SPEED 8
    MOVE G6D,107, 125,  62, 132, 113, 100
    MOVE G6A, 82, 110,  90, 120,  100, 100
    MOVE G6B,105, 50, 80
    MOVE G6C,105, 50, 80
    WAIT

    SPEED 6
    MOVE G6A,97, 125,  62, 132, 102, 100
    MOVE G6D,97, 125,  62, 132, 102, 100
    MOVE G6B,100, 50, 80
    MOVE G6C,100, 50, 80
    WAIT

    SPEED 10
    GOSUB 기본자세

    ONE = 0
    GOTO MAIN




외각선내려가기: '옆꾸리운동
    GOSUB All_motor_mode3


    SPEED 12
    MOVE G6D,96,  116, 67,  135, 130, 100
    MOVE G6A,80,  86, 125,  108, 85, 100
    MOVE G6C,100,  45,  90,,123
    MOVE G6B,100,  180,  140,, , 190
    WAIT

    ONE = 0
    GOTO MAIN

외각선올라가기:
    GOSUB All_motor_mode3	
    SPEED 8
    MOVE G6D,96,  86, 125,  103, 110, 100
    MOVE G6A,95,  76, 145,  93, 100, 100
    MOVE G6C,100,  35,  80,
    MOVE G6B,100,  35,  80,
    WAIT



    SPEED 5
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT

    'SPEED 5
    'MOVE G6A,100,  84, 137,  94, 100, 100
    'MOVE G6D,100,  84, 137,  94, 100, 100
    'MOVE G6B,100,  28,  81, 100, 100, 190
    'MOVE G6C,100 ,  32,  80, 100, 135, 100
    'WAIT
    SPEED 5
    MOVE G6A,100,  84, 132,  101, 100, 100
    MOVE G6D,100,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 190
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT


    SPEED 5
    MOVE G6A,100,  84, 137,  94, 100, 100
    MOVE G6D,100,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 190
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT


    '**********************************************
    ONE = 0
    GOTO MAIN


외각선자세:

    SPEED 15
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    RETURN
외각선자세2:

    SPEED 15
    MOVE G6A,100,  85, 137,  92, 100, 100
    MOVE G6D,100,  86, 137,  92, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    RETURN


턴자세:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  92, 100, 100
    MOVE G6D,101,  85, 137,  92, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN

턴자세2:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  92, 100, 100
    MOVE G6D,101,  85, 137,  92, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT
    RETURN


외각선오른쪽턴10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT


    SPEED 12
    MOVE G6D,97,  86, 146,  85, 102, 100
    MOVE G6A,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6D,92,  86, 146,  85, 101, 100
    MOVE G6A,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 99, 100
    MOVE G6A,101,  76, 146,  93, 99, 100
    'mOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    WAIT

    SPEED 8
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT


    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


외각선오른쪽턴20: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6A,100,  85, 137,  92, 100, 100
    MOVE G6D,100,  86, 137,  92, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    SPEED 6
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6A,95,  46, 145,  126, 105, 100
    'MOVE G6C,115
    'MOVE G6B,85
    WAIT

    SPEED 6
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6A,95,  46, 145,  126, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  85, 137,  92, 100, 100
    MOVE G6D,100,  86, 137,  92, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    GOSUB Leg_motor_mode1
    GOTO MAIN


외각선왼쪽턴10: ' COMPLETE

    GOSUB GYRO_OFF

    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT


    SPEED 12
    MOVE G6A,97,  86, 146,  85, 102, 100
    MOVE G6D,97,  66, 145,  104, 102, 100
    WAIT

    SPEED 12
    MOVE G6A,92,  86, 146,  85, 101, 100
    MOVE G6D,94,  66, 145,  104, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 99, 100
    MOVE G6D,101,  76, 146,  93, 99, 100
    'MOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT



외각선왼쪽턴20: ' COMPLETE
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    SPEED 8
    MOVE G6A,95,  100, 145,  68, 105, 100
    MOVE G6D,95,  50, 145,  118, 105, 100
    'MOVE G6B,110
    'MOVE G6C,90
    WAIT

    SPEED 8
    MOVE G6A,93,  100, 145,  68, 105, 100
    MOVE G6D,93,  50, 145,  118, 105, 100
    WAIT
    SPEED 8
    MOVE G6A,102,  76, 146,  93, 100, 100
    MOVE G6D,102,  76, 146,  93, 100, 100
    'MOVE G6B,100,  30,  80
    'MOVE G6C,100,  30,  80
    WAIT

    SPEED 10
    MOVE G6A,100,  85, 137,  91, 100, 100
    MOVE G6D,100,  86, 137,  91, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT




뒤로일어나기:

    '    IF 모터ONOFF = 1 THEN
    '        GOSUB MOTOR_ON
    '    ENDIF
    HIGHSPEED SETOFF
    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, 120,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
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

    '    넘어진확인 = 1
    RETURN






판위에서전진종종2걸음:
    '    넘어진확인 = 0
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    SPEED 15
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    '    IF 보행순서 = 0 THEN
    '        보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35,,,
    MOVE G6C,100,  35,,190
    WAIT

    '        GOTO 전진종종걸음_1
    '    ELSE
    '        보행순서 = 0
    '        MOVE G6D,95,  76, 145,  93, 101
    '        MOVE G6A,101,  77, 145,  93, 98
    '        MOVE G6B,100,  35
    '        MOVE G6C,100,  35
    '        WAIT

    '       GOTO 전진종종걸음_4
    '    ENDIF


    '**********************

판위에서전진종종2걸음_1:
    'FOR I = 0 TO 1
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80,,,,,100
    MOVE G6C,120,,
    WAIT


판위에서전진종종2걸음_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

판위에서전진종종2걸음_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT
판위에서전진종종2걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80,,,
    MOVE G6B,120,,,
    WAIT


판위에서전진종종2걸음_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

판위에서전진종종2걸음_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_4
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

    '*********************************

    'NEXT I
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_1
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

판위에서전진종종2걸음_멈춤:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB 안정화자세2
    SPEED 10
    GOSUB 기본자세3

    DELAY 400

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'보행순서=0
    'GOTO MAIN
    ONE = 0
    GOTO MAIN

내려가기직전전진보행50:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB Leg_motor_mode3


    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,106,  76, 146,  93,  96
    MOVE G6B,100,37
    MOVE G6C,100,35,,,190
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,109,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO 전진보행50_1



내려가기직전전진보행50_1:
    'FOR I = 0 TO 10
    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 113, 117
    MOVE G6D,108,  77, 146,  93,  92
    WAIT



    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,108,  76, 144, 100,  93
    MOVE G6D,86, 93, 155,  71, 112
    WAIT



    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '오른발들기10
    MOVE G6A,110,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT



    GOSUB 기본자세3
    GOSUB GYRO_OFF
    ONE=0
    'GOTO MAIN
    '    GOSUB 앞뒤기울기측정
    '    GOSUB 좌우기울기측정

    GOTO main



내려가기직전종종걸음:
    '    넘어진확인 = 0

    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35,,,190
        WAIT

        GOTO 내려가기직전종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 내려가기직전종종걸음_4
    ENDIF


    '**********************
    'FOR I = 0 TO 10
내려가기직전종종걸음_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    '내려가기직전종종걸음_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

    '내려가기직전종종걸음_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT

    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_4
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

    '*********************************

    '내려가기직전종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    '내려가기직전종종걸음_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

    '내려가기직전종종걸음_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT


    GOTO 내려가기직전종종걸음_멈춤

내려가기직전종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    '내려가기직전종종걸음_5:
    MOVE G6D,95,  85, 130, 103, 104
    MOVE G6A,104,  79, 146,  89,  100
    WAIT

    '내려가기직전종종걸음_6:
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  79, 146,  89, 102
    WAIT
    '내려가기직전종종걸음_1:
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    '내려가기직전종종걸음_2:
    MOVE G6A,95,  85, 130, 103, 104
    MOVE G6D,104,  79, 146,  89,  100
    WAIT

    '내려가기직전종종걸음_3:
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  79, 146,  89, 102
    WAIT



    GOTO 내려가기직전종종걸음_멈춤
    'NEXT I
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO MAIN
    '    ENDIF
    '
    '    ERX 4800,A, 전진종종걸음_1
    '    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

내려가기직전종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세2
    SPEED 10
    GOSUB 기본자세3

    DELAY 1600

    GOSUB Leg_motor_mode1
    'ONE=0
    'GOTO RX_EXIT

    GOTO MAIN

    '******************************************
왼쪽옆으로20:


    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세
    보행순서=0
    GOTO MAIN

왼쪽옆으로70: 'USE


    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15	
    GOSUB 기본자세
    보행순서=0
    GOTO MAIN

전진달리기50:

    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    'IF 보행순서 = 0 THEN
    '    보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  78, 145,  93, 98
    WAIT

    '    GOTO 전진달리기50_1
    'ELSE
    '    보행순서 = 0
    '    MOVE G6D,95,  76, 145,  93, 101
    '    MOVE G6A,101,  78, 145,  93, 98
    '    WAIT

    '    GOTO 전진달리기50_4
    'ENDIF


    '**********************
    FOR I = 0 TO 5
전진달리기50_1:
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,103, 78, 146,  91, 102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

전진달리기50_2:
        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,103, 80, 146,  89, 100
        WAIT

전진달리기50_3:
        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 94, 88, 160,  68, 102
        WAIT

        'ERX 4800,A, 전진달리기50_4
        'IF A <> A_old THEN  GOTO 전진달리기50_멈춤

        '*********************************

전진달리기50_4:
        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

전진달리기50_5:
        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT

전진달리기50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
    NEXT I



전진달리기50_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    보행순서=0
    GOTO 전진달리기50

허들넘기2: 'USE




    SPEED 13
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B,100,  100,  80, 100, 100, 100
    MOVE G6C,102 , 100,  80, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B, 185, 10, 100
    MOVE G6C, 190, 14, 100
    WAIT

    SPEED 10
    MOVE G6A,90,  82, 145,  86, 110, 100
    MOVE G6D,90,  83, 145,  86, 110, 100
    MOVE G6B, 185, 10, 100
    MOVE G6C, 190, 14, 100
    WAIT



    SPEED 10
    MOVE G6A, 90,  76, 145,  93, 110, 100
    MOVE G6D, 90,  76, 145,  93, 110, 100
    MOVE G6B, 185,  10,  100
    MOVE G6C, 190,  14,  100
    WAIT

    SPEED 6
    MOVE G6A, 90,  75, 145,  140, 110, 100
    MOVE G6D, 90,  76, 145,  140, 110, 100
    MOVE G6B, 185,  10,  80 , 100, 100
    MOVE G6C, 190,  14,  80 , 100, 190
    WAIT
    '=------------------------------------------
    SPEED 6
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 152,  35,  85
    MOVE G6C, 155,  35,  85
    WAIT

    SPEED 6
    MOVE G6A,100,  100, 95,  10, 100, 100
    MOVE G6D,100,  100, 95,  10, 100, 100
    MOVE G6B, 152,  20,  85
    MOVE G6C, 155,  24,  85
    WAIT


    '-------------------------------------
    SPEED 6
    MOVE G6A,100,  15, 55,  139, 100, 100
    MOVE G6D,100,  11, 51,  140, 100, 100
    MOVE G6B, 97,  26,  80
    MOVE G6C, 100,  30,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  10, 55,  140, 100, 100
    MOVE G6D,100,  10, 55,  140, 100, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  10, 55,  140, 190, 100
    MOVE G6D,100,  10, 55,  140, 190, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  60, 55,  140, 190, 100
    MOVE G6D,100,  60, 55,  140, 190, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  60, 55,  140, 100, 100
    MOVE G6D,100,  60, 55,  140, 100, 100
    MOVE G6B, 100,  100,  80
    MOVE G6C, 100,  100,  80, 100, 100
    WAIT



    '--------------------------------------------
    SPEED 10
    MOVE G6A,100, 150, 170,  40, 100
    MOVE G6D,100, 150, 170,  40, 100
    MOVE G6B, 150, 150,  45
    MOVE G6C, 150, 150,  45
    WAIT

    SPEED 10
    MOVE G6A,  100, 155,  110, 120, 100
    MOVE G6D,  100, 155,  110, 120, 100
    MOVE G6B, 190, 80,  15
    MOVE G6C, 190, 80,  15
    WAIT

    SPEED 10
    MOVE G6A,  100, 165,  25, 162, 100
    MOVE G6D,  100, 165,  25, 162, 100
    MOVE G6B,  155, 15, 90
    MOVE G6C,  155, 15, 90
    WAIT

    '-------------- 일어나기 -----------------
    SPEED 9
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,160,  32, 70, 100, 100, 100
    MOVE G6C,160,  32, 70, 100, 100, 100
    WAIT


    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT
    '''''''''''''''''''''''''=

    '---------------'추가분'-----------------
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    SPEED 9
    MOVE G6A,100, 130,  48, 136, 100, 100
    MOVE G6D,100, 130,  48, 136, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT


    '---------------------------------------




    SPEED 10
    GOSUB 기본자세
    '******************************************
    GOTO MAIN






허들넘기: 'USE
    GOSUB GYRO_OFF
    GOSUB 기본자세


    SPEED 13
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B,100,  100,  80, 100, 100, 100
    MOVE G6C,102 , 100,  80, 100, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B, 185, 10, 100
    MOVE G6C, 190, 14, 100
    WAIT


    SPEED 15
    MOVE G6A, 100,  75, 145,  140, 100, 100
    MOVE G6D, 100,  76, 145,  140, 100, 100
    MOVE G6B, 175,  50,  80 , 100, 100
    MOVE G6C, 180,  54,  80 , 100, 185
    WAIT
    '=------------------------------------------
    DELAY 500



    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  71, 177, 152, 100, 100
    MOVE G6B,180,  50,  70
    MOVE G6C,180,  54,  70,
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,180,  40,  70
    MOVE G6C,180,  42,  70
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  37,  70
    MOVE G6C,190,  40,  70,,190
    WAIT
    DELAY 50

    SPEED 20
    MOVE G6A,100, 110, 74,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 165, 115
    MOVE G6C,190, 165, 115
    WAIT

    SPEED 20
    MOVE G6A,100, 171,  73,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 160, 120
    MOVE G6C,190, 160, 120
    WAIT

    SPEED 10
    MOVE G6A,100, 171,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB 앉은자세

    SPEED 10
    GOSUB 기본자세
    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정



    GOTO MAIN

기어가기:

    GOSUB Leg_motor_mode3
    SPEED 15
    MOVE G6A,100, 155,  28, 140, 100, 100
    MOVE G6D,100, 155,  28, 140, 100, 100
    MOVE G6B,180,  40,  85
    MOVE G6C,180,  40,  85
    WAIT

    SPEED 5	
    MOVE G6A, 100, 155,  57, 160, 100, 100'
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,186,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 6
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
    '    ERX 4800, A, 기어가기_1
    '    IF A = 8 THEN GOTO 기어가기_1
    '   IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    '  IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    'GOTO 기어가다일어나기

기어가기_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 100
    MOVE G6B, 160,  25,  70
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  55, 160, 100
    MOVE G6A, 100, 145,  75, 160, 100
    MOVE G6C, 180,  25,  70
    MOVE G6B, 190,  50,  40
    WAIT

    'ERX 4800, A, 기어가기_2
    ' IF A = 8 THEN GOTO 기어가기_2
    'IF A = 9 THEN GOTO 기어가기오른쪽턴_LOOP
    'IF A = 7 THEN GOTO 기어가기왼쪽턴_LOOP

    'GOTO 기어가다일어나기

기어가기_2:
    MOVE G6D, 100, 140,  80, 160, 100
    MOVE G6A, 100, 140, 120, 120, 100
    MOVE G6C, 170,  25,  70
    MOVE G6B, 190,  25,  70
    WAIT

    GOTO 기어가기_LOOP

계단오른발오르기1cm: 'UPSTAIR GREEN
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,105,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 93, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 75, 100, 155, 105,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB 기본자세
    보행순서=0
    GOTO MAIN

기어서올라가기: 'UPSTAIR RED

    SPEED 15
    MOVE G6B, 190, 100, 100
    MOVE G6C, 190, 100, 100
    WAIT

    SPEED 12
    MOVE G6B, 190, 10, 100
    MOVE G6C, 190, 10, 100
    WAIT

    SPEED 12
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 190,  10,  100
    MOVE G6C, 190,  10,  100
    WAIT

    SPEED 5
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 90,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT


    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  141, 90,  130, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  76, 90,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  141, 90,  130, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    SPEED 8
    MOVE G6A, 100,  141, 90,  155, 100, 100
    MOVE G6D, 100,  141, 90,  155, 100, 100
    MOVE G6B, 170,  30,  90 , 100, 100
    MOVE G6C, 170,  30,  90 , 100, 100
    WAIT

    '기어가기
    GOSUB Leg_motor_mode3


    SPEED 5	
    MOVE G6A, 100, 155,  53, 160, 100, 100
    MOVE G6D, 100, 155,  53, 160, 100, 100
    MOVE G6B,190,  30, 80
    MOVE G6C,190,  30, 80
    WAIT	

    GOSUB All_motor_mode2

    DELAY 300

    SPEED 6
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETON
    '기어가기_LOOP

    FOR I = 0 TO 5
        MOVE G6D, 100, 160,  55, 160, 100
        MOVE G6A, 100, 145,  75, 160, 100
        MOVE G6C, 175,  25,  70
        MOVE G6B, 190,  50,  40
        WAIT

        '기어가기_2

        MOVE G6D, 100, 140,  80, 160, 100
        MOVE G6A, 100, 140, 120, 120, 100
        MOVE G6C, 160,  25,  70
        MOVE G6B, 190,  25,  70
        WAIT

        MOVE G6A, 100, 160,  55, 160, 100
        MOVE G6D, 100, 145,  75, 160, 100
        MOVE G6B, 175,  25,  70
        MOVE G6C, 190,  50,  40
        WAIT
        '기어가기_1
        MOVE G6A, 100, 150,  70, 160, 100
        MOVE G6D, 100, 140, 120, 120, 100
        MOVE G6B, 160,  25,  70
        MOVE G6C, 190,  25,  70
        WAIT


    NEXT I
    '	기어가다일어나기:

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
    보행순서=0
    GOTO MAIN




안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  30,  80, 100, 100
    MOVE G6C,100,  30,  80, 100, 135
    WAIT
    RETURN
    '************************************************
    '************************************************
    '******************************************
    '***************************************

전진보행50:


    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB Leg_motor_mode3

    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 116
    MOVE G6D,107,  76, 146,  93,  94
    MOVE G6B,100,35
    MOVE G6C,100,35,,,190
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 116
    MOVE G6D,111,  78, 146,  93,  92
    MOVE G6B,90
    MOVE G6C,110
    WAIT



    '*******************************


전진보행50_1:
    'FOR I = 0 TO 1
    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 95,  64, 143, 103, 110
    MOVE G6D,108,  77, 146,  93,  94
    WAIT



    SPEED 4
    'GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,106,  76, 144, 90,  93
    MOVE G6D,88, 93, 155,  71, 112
    WAIT


    'GOSUB 앞뒤기울기측정
    'IF 넘어진확인 = 1 THEN
    '    넘어진확인 = 0
    '    GOTO MAIN
    'ENDIF


    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '오른발들기10
    MOVE G6A,107,  77, 146,  93, 94
    MOVE G6D,85, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    MOVE G6A,104,  83, 136,  93, 102
    MOVE G6D,100, 80, 143, 90, 103
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    MOVE G6A,99,  83, 137,  94, 98, 100
    MOVE G6D,99,  84, 137,  94, 98, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT



    GOSUB 기본자세
    보행순서=0
    GOTO MAIN
판위에서전진보행3걸음:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB Leg_motor_mode3


    SPEED 4
    '오른쪽기울기
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,106,  76, 146,  93,  96
    MOVE G6B,100,37
    MOVE G6C,100,35,,,190
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,110,  78, 146,  93,  96
    MOVE G6B,90
    MOVE G6C,110
    WAIT


    '        GOTO 전진보행50_1



판위에서전진보행3걸음_1:
    'FOR I = 0 TO 10
    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 90,  44, 163, 115, 117
    MOVE G6D,108,  77, 146,  95,  90
    WAIT



    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,108,  76, 144, 100,  93
    MOVE G6D,86, 93, 155,  71, 112
    WAIT



    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '오른발들기10
    MOVE G6A,110,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT



판위에서전진보행3걸음_2:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,87,  44, 163, 113, 117
    MOVE G6A,109,  77, 146,  93,  94
    WAIT

    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '오른발중심이동
    MOVE G6D,108,  76, 144, 101,  93
    MOVE G6A, 85, 93, 155,  71, 112
    WAIT


    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114
    MOVE G6D,110,  77, 146,  93,  94
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 90,  44, 163, 115, 117
    MOVE G6D,108,  77, 146,  95,  92
    WAIT



    SPEED 좌우속도
    'GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,108,  76, 144, 100,  93
    MOVE G6D,86, 93, 155,  71, 112
    WAIT



    SPEED 보행속도
    'GOSUB Leg_motor_mode2
    '오른발들기10
    MOVE G6A,110,  77, 146,  93, 94
    MOVE G6D,90, 100, 105, 110, 114
    MOVE G6B,110
    MOVE G6C,90
    WAIT
    'NEXT I

    GOSUB 기본자세4
    GOSUB GYRO_OFF
    'ONE=0
    'GOTO MAIN
    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정
    'ONE = 0

    'DELAY 2000
    GOTO MAIN


    '************************************************
    '************************************************



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
안정화자세2:
    '    MOVE G6A,98,  77, 145,  93, 101, 100
    '    MOVE G6D,99,  75, 145,  93, 101, 100
    '    MOVE G6B,100,  25,  80, 100, 100, 100
    '    MOVE G6C,102,  31,  80, 100, 190, 100
    '    WAIT
    MOVE G6A,99,  83, 137,  94, 101, 100
    MOVE G6D,99,  84, 137,  94, 101, 100
    MOVE G6B,100,  28,  81, 100, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN


기본자세:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN

    'GOSUB GYRO_OFF


기본자세2:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT
    RETURN

기본자세3:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    RETURN
기본자세4:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
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
GYRO_INIT:
    GYRODIR G6A, 0, 0, 0, 0, 1
    GYRODIR G6D, 1, 0, 0, 0, 0
    RETURN
GYRO_ON:
    GYROSET G6A, 2, 1, 1, 1,
    GYROSET G6D, 2, 1, 1, 1,
    RETURN
GYRO_OFF:
    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0
    RETURN
GYRO_MAX:
    GYROSENSE G6A,255,255,255,255
    GYROSENSE G6D,255,255,255,255
    RETURN
GYRO_MID:
    GYROSENSE G6A,255,100,100,100
    GYROSENSE G6D,255,100,100,100
    RETURN
GYRO_MIN:
    GYROSENSE G6A,100,50,50,50,50
    GYROSENSE G6D,100,50,50,50,50
    RETURN
GYRO_ST:
    GYROSENSE G6A,100,30,20,10,
    GYROSENSE G6D,100,30,20,10 ,
    RETURN


    '내려가기:
내려가기:

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  100, 142, 100, 100
    MOVE G6D,100, 143,  100, 142, 100, 100
    MOVE G6B,180,  30,  80
    MOVE G6C,180,  30,  80
    WAIT


    SPEED 5
    MOVE G6A,100, 143,  100, 142, 100, 100
    MOVE G6D,100, 143,  100, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 123,  100, 102, 100, 100
    MOVE G6D,100, 123,  100, 102, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT


    GOSUB 기본자세
    GOSUB 뒤로일어나기
    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정


    ONE = 0
    GOTO MAIN
내려가기2:

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,190,  30,  80
    MOVE G6C,190,  30,  80
    WAIT

    SPEED 5
    MOVE G6A,100, 143,  100, 142, 100, 100
    MOVE G6D,100, 143,  100, 142, 100, 100
    MOVE G6B,180,  30,  80
    MOVE G6C,180,  30,  80
    WAIT

    SPEED 5
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT

    SPEED 5
    MOVE G6A, 80, 135,  115, 150, 180, 100
    MOVE G6D, 80, 135,  115, 150, 180, 100
    MOVE G6B,185,  50, 70,  100, 100, 100
    MOVE G6C,185,  50, 70,  100, 100, 100
    WAIT

    SPEED 5
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

    SPEED 5
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
    '    SPEED 10

    GOSUB 기본자세
    ONE=0
    GOTO MAIN
앞으로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB All_motor_Reset


    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 10
    GOSUB 기본자세
    '넘어진확인 = 1
    RETURN



후진종종걸음:
    '넘어진확인 = 0

    SPEED 8
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  77, 145,  93, 98
    MOVE G6B,100,  35
    MOVE G6C,100,  35
    WAIT





    '**********************

후진종종걸음_1:
    FOR I = 0 TO 1
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6B,115
        MOVE G6C,85
        WAIT


후진종종걸음_2:
        MOVE G6A,95,  90, 135, 90, 104
        MOVE G6D,104,  77, 146,  91,  100
        WAIT

후진종종걸음_3:
        MOVE G6A, 103,  79, 146,  89, 100
        MOVE G6D,95,   65, 146, 103,  102
        WAIT

        ' GOSUB 앞뒤기울기측정
        'IF 넘어진확인 = 1 THEN
        '    넘어진확인 = 0
        '    GOTO MAIN
        'ENDIF

        'ERX 4800,A, 후진종종걸음_4
        'IF A <> A_old THEN  GOTO 후진종종걸음_멈춤

        '*********************************

후진종종걸음_4:
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6C,115
        MOVE G6B,85
        WAIT


후진종종걸음_5:
        MOVE G6A,104,  77, 146,  91,  100
        MOVE G6D,95,  90, 135, 90, 104
        WAIT

후진종종걸음_6:
        MOVE G6D, 103,  79, 146,  89, 100
        MOVE G6A,95,   65, 146, 103,  102
        WAIT
    NEXT I
    'GOSUB 앞뒤기울기측정
    'IF 넘어진확인 = 1 THEN
    '    넘어진확인 = 0
    '    GOTO MAIN
    'ENDIF

    'ERX 4800,A, 후진종종걸음_1
    'IF A <> A_old THEN  GOTO 후진종종걸음_멈춤




후진종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

앞뒤기울기측정:
    '  IF 기울기센서측정여부 = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN GOSUB 기울기앞

    IF A > MAX THEN GOSUB 기울기뒤

    '    GOSUB GOSUB_RX_EXIT

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN  GOSUB 뒤로일어나기
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN GOSUB 앞으로일어나기
    RETURN
    '**************************************************
