
'****************************************
'***** 메탈파이터 기초 프로그램 *******
'****************************************

'******* 변수선언 ***********************
DIM A AS BYTE
DIM I AS BYTE
DIM A_old AS BYTE
DIM X AS BYTE
DIM Y AS BYTE
DIM 보행순서 AS BYTE
DIM ONE AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE

'**** 기울기센서포트 설정

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
보행순서 = 0

'*******모터방향설정*********************
DIR G6A,1,0,0,1,0,0	'왼쪽다리:모터0~5번
DIR G6D,0,1,1,0,1,0	'오른쪽다리:모터18~23번
DIR G6B,1,1,1,1,1,1	'왼쪽팔:모터6~11번
DIR G6C,0,0,0,0,0,0	'오른쪽팔:모터12~17번


'*******모터동시제어설정****************
PTP SETON 		'단위그룹별 점대점동작 설정
PTP ALLON		'전체모터 점대점 동작 설정

'*******모터위치값피드백****************
GOSUB MOTOR_GET

'*******모터사용설정********************
GOSUB MOTOR_ON

'*******피에조소리내기******************
TEMPO 220
MUSIC "O23EAB7EA>3#C"
'***** 초기자세로 **********************
'GOSUB GYRO_INIT
'GOSUB GYRO_ON
'GOSUB GYRO_ST
SPEED 5
GOSUB 기본자세


ONE = 1

'***** 메인 반복루틴 **************
MAIN:

    IF ONE=1 THEN
        'GOTO 왼쪽옆으로상5
        'GOTO 왼쪽옆으로중2
        'GOTO 오른쪽옆으로상5
        'GOTO 오른쪽옆으로중2
        ' GOTO 오른쪽옆으로20
        ' GOTO 오른쪽옆으로20
        'GOTO 앞으로덤블링
        ' GOTO 계단오른발오르기2cm
        'GOTO 외각선오른쪽옆으로70
        'GOTO 앞으로덤블링2
        'GOTO 희영오르기
        'GOTO 계단왼발내리기2cm
        GOTO 전진종종비비기
    ENDIF


    GOTO MAIN
    '************************************************
    '******************************************

기본자세0:
    '자이로 꺼진 고개 90도(TH)
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
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

외각선자세2:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    SPEED 15
    MOVE G6A,100,  85, 137,  94, 100, 100
    MOVE G6D,100,  86, 137,  94, 100, 100
    MOVE G6B,10,  15,  51, 100, 100, 190
    MOVE G6C,10 ,  13,  55, 100, 135, 100' 153
    WAIT

    RETURN

안정화자세:
    MOVE G6A,98,  77, 145,  93, 101, 100
    MOVE G6D,99,  75, 145,  93, 101, 100
    MOVE G6B,100,  25,  80, 100, 100, 100
    MOVE G6C,102,  31,  80, 100, 135, 100
    WAIT
    RETURN

앞으로덤블링3:

    SPEED 4
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,160,  50,  85,,,
    MOVE G6C,160,  50,  85,,
    WAIT


    SPEED 4	
    MOVE G6A, 100, 165,  55, 165, 100, 100
    MOVE G6D, 100, 165,  55, 165, 100, 100
    MOVE G6B,185,  30, 97
    MOVE G6C,185,  30, 100
    WAIT

    'SPEED 4
    'MOVE G6A,100, 165, 110, 140, 100, 100
    'MOVE G6D,100, 165, 110, 140, 100, 100
    'MOVE G6B,140,  80,  40,,,
    'MOVE G6C,140,  80,  40,,190
    'WAIT

    SPEED 4
    MOVE G6A,100, 108, 140, 147, 100, 100
    MOVE G6D,100, 108, 140, 147, 100, 100
    MOVE G6B,160,  70,  40
    MOVE G6C,160,  70,  40,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,170,  50,  70
    MOVE G6C,170,  50,  70,,175
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,169,  51,  68
    MOVE G6C,171,  50,  70
    WAIT

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
    ' GOSUB 앞뒤기울기측정

    DELAY 3000
    GOTO rx_exit


앞으로덤블링:

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
    MOVE G6C,185,  10, 100
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
    MOVE G6B,130,  70,  20,,,
    MOVE G6C,130,  80,  20,,190
    WAIT

    SPEED 15
    MOVE G6A,100, 128, 140, 147, 100, 100
    MOVE G6D,100, 128, 140, 147, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  80,  20,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,155,  40,  70
    MOVE G6C,150,  40,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,155,  40,  70
    MOVE G6C,153,  40,  70,,
    WAIT

    SPEED 20
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6A,100,  60, 110, 15, 100, 100
    MOVE G6C,179,  41,  68
    MOVE G6B,175,  40,  70
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70,,190
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

    DELAY 3000
    GOTO RX_EXIT


앉은자세:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    RETURN


전진종종10걸음:
    GOSUB GYRO_OFF
    GOSUB 기본자세
    SPEED 15
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,98,  76, 145,  93, 101
        MOVE G6D,102,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종10걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,98,  76, 145,  93, 101
        MOVE G6A,102,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종10걸음_4
    ENDIF



    '**********************
전진종종10걸음_1:
    FOR I = 0 TO 9
        '전진종종걸음최종_1:
        MOVE G6A,97,  95, 120, 102, 103
        MOVE G6D,102, 78, 146,  91,  101
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음최종_2:
        MOVE G6A,97,  85, 130, 102, 103
        MOVE G6D,102, 79, 146, 90, 100
        WAIT

        '전진종종걸음최종_3:
        MOVE G6A,101,  84, 130, 103,  101
        MOVE G6D, 96,  79, 147,  90, 102
        WAIT

        '전진종종걸음최종_4:
        MOVE G6D,98,  95, 120,  103, 103
        MOVE G6A,102, 78, 146,  91,  101
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '전진종종걸음최종_5:
        MOVE G6D,97,  88, 130, 103, 103
        MOVE G6A,102, 78, 148, 89, 100
        WAIT

        '전진종종걸음최종_6:
        MOVE G6D,101,   86, 130, 103, 101
        MOVE G6A, 96,   78, 148,  89, 102
        WAIT
    NEXT I
    GOTO 전진종종10걸음멈춤


전진종종10걸음_4:
    FOR I = 0 TO 9
        '전진종종걸음최종_4:
        MOVE G6D,98,  95, 120,  103, 103
        MOVE G6A,102, 78, 146,  91,  101
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '전진종종걸음최종_5:
        MOVE G6D,97,  88, 130, 103, 103
        MOVE G6A,102, 78, 148, 89, 100
        WAIT

        '전진종종걸음최종_6:
        MOVE G6D,101,   86, 130, 103, 101
        MOVE G6A, 96,   78, 148,  89, 102
        WAIT

        '전진종종걸음최종_1:
        MOVE G6A,97,  95, 120, 102, 103
        MOVE G6D,102, 78, 146,  91,  101
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음최종_2:
        MOVE G6A,97,  85, 130, 102, 103
        MOVE G6D,102, 79, 146, 90, 100
        WAIT

        '전진종종걸음최종_3:
        MOVE G6A,101,  84, 130, 103,  101
        MOVE G6D, 96,  79, 147,  90, 102
        WAIT


    NEXT I
    GOTO 전진종종10걸음멈춤

전진종종10걸음멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    'GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF

    DELAY 3000
    GOTO RX_EXIT

외각선오른쪽옆으로70:

    GOSUB 외각선자세2
    SPEED 15
    MOVE G6D, 92,  94, 123, 102, 102, 100
    MOVE G6A,103,  79, 148,  91, 104, 100
    WAIT

    SPEED 15
    MOVE G6D, 102,  80, 147, 91, 100, 100
    MOVE G6A,90,  82, 142,  92, 104, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  79, 145,  93, 100, 100
    MOVE G6A,98,  79, 145,  93, 100, 100
    WAIT

    SPEED 8
    GOSUB 외각선자세2
    GOSUB GYRO_OFF

    DELAY 3000

    GOTO RX_EXIT


오른쪽옆으로20:

    GOSUB 기본자세
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 102, 100
    MOVE G6A,103,  76, 145,  93, 103, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,89,  80, 140,  95, 102, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세

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

    'GOSUB 앞뒤기울기측정
    DELAY 3000

    GOTO RX_EXIT

전진종종비비기:
    '    넘어진확인 = 0

    GOSUB 기본자세
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST
    SPEED 15
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
    FOR I = 0 TO 2
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
    DELAY 3000
    GOTO RX_EXIT



old오른쪽옆으로20:


    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 104, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세2

    GOTO RX_EXIT

고개90도오른쪽옆으로70:

    GOSUB 기본자세2
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 106, 100
    MOVE G6A,100,  76, 146,  93, 102, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 15
    MOVE G6D, 100,  77, 147, 93, 98, 100
    MOVE G6A,83,  78, 140,  96, 111, 100
    WAIT


    SPEED 15
    MOVE G6D,102,  76, 146,  93, 98, 100
    MOVE G6A,90,  76, 140,  93, 107, 100

    SPEED 8
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB 기본자세2

    DELAY 5000

    GOTO RX_EXIT

고개90도오른쪽옆으로20:

    GOSUB 기본자세2
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 104, 100
    MOVE G6A,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 109, 100
    WAIT


    SPEED 12
    MOVE G6D,100,  76, 146,  93, 100, 100
    MOVE G6A,90,  76, 143,  93, 102, 100

    SPEED 5
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB 기본자세2

    DELAY 3000


    GOTO RX_EXIT


오른쪽옆으로020:

    GOSUB 기본자세2
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 104, 100
    MOVE G6A,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 109, 100
    WAIT


    SPEED 12
    MOVE G6D,100,  76, 146,  93, 100, 100
    MOVE G6A,90,  76, 143,  93, 102, 100

    SPEED 5
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB 기본자세2

    DELAY 3000

    GOTO RX_EXIT

전진달리기최종:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST
    SPEED 10
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    MOVE G6A,95,  80, 145,  93, 101
    MOVE G6D,100,  80, 145,  93, 98
    WAIT
    '**********************

전진달리기최종_1:
    FOR I = 0 TO 5
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,101, 78, 146,  91, 100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,101, 80, 146,  89, 100
        WAIT


        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 96, 88, 160,  68, 100
        WAIT

        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT


        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT

    NEXT I
    MOVE G6A,96,  95, 100, 120, 104
    MOVE G6D,101, 78, 146,  91, 100
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    MOVE G6A,96,  75, 122, 120, 104
    MOVE G6D,101, 80, 146,  89, 100
    WAIT

    SPEED 3
    MOVE G6A,105, 85, 100, 139, 105
    MOVE G6D, 98, 108, 168,  39, 101
    WAIT


    DELAY 1000



    SPEED 2
    MOVE G6A,102,  78, 140,  98, 100, 101
    MOVE G6D,98,  84, 145,  85, 100, 100
    WAIT

    GOTO 전진달리기최종_멈춤
    ' ***************************************************************8



전진달리기최종_멈춤:

    HIGHSPEED SETOFF
    SPEED 15

    GOSUB GYRO_OFF

    GOSUB 기본자세


    GOSUB Leg_motor_mode1
    'ONE=0


    'GOTO 전진종종걸음최종
    DELAY 3000

    GOTO RX_EXIT

    '*************************************************************************************

오른쪽옆으로760:

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT


    SPEED 12
    MOVE G6D,100,  76, 146,  93, 100, 100
    MOVE G6A,90,  76, 143,  93, 107, 100

    SPEED 5
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB 기본자세2

    DELAY 5000

    GOTO RX_EXIT
    '*************

왼쪽옆으로70:
    DELAY 3000
    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100
    MOVE G6D,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT


    SPEED 12
    MOVE G6A,100,  76, 146,  93, 100, 100
    MOVE G6D,90,  76, 143,  93, 107, 100

    SPEED 5
    MOVE G6A,99,  76, 146,  93, 100, 100
    MOVE G6D,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB 기본자세2

    DELAY 3000

    GOTO RX_EXIT
    '*************




오른쪽옆으로상5:

    'FOR I = 0 TO 1
    'GOSUB 기본자세
    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT


    SPEED 8
    MOVE G6D, 101,  80, 148, 92, 100, 100
    MOVE G6A,83,  78, 140,  95, 115, 100
    WAIT


    SPEED 8
    MOVE G6D,100,  78, 146,  93, 100, 100
    MOVE G6A,92,  76, 143,  93, 102, 100
    WAIT

    SPEED 5
    MOVE G6D,99,  76, 146,  93, 100, 100
    MOVE G6A,99,  76, 146,  93, 100, 100
    WAIT

    SPEED 10
    MOVE G6A,99,  80, 140,  94, 100, 100
    MOVE G6D,99,  81, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15
    GOSUB 기본자세2


    DELAY 5000

    'NEXT I

    'GOTO MAIN
    GOTO RX_EXIT


    '**********************************************************************************************8
왼쪽옆으로상5:

    'GOSUB 기본자세
    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT

    SPEED 8
    MOVE G6A, 102,  80, 147, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 8
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,92,  76, 146,  93, 100, 100
    WAIT

    SPEED 5
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,99,  81, 140,  94, 100, 100
    MOVE G6D,99,  80, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15	
    GOSUB 기본자세2

    DELAY 5000

    'GOTO MAIN
    GOTO RX_EXIT

    '**********************************************************************************************8
오른쪽옆으로중2:

    'FOR I = 0 TO 1
    'GOSUB 기본자세
    SPEED 12
    MOVE G6D, 90,  90, 120, 105, 104, 100
    MOVE G6A,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT


    SPEED 12
    MOVE G6D, 101,  78, 148, 92, 100, 100
    MOVE G6A,83,  78, 140,  95, 109, 100
    WAIT


    SPEED 10
    MOVE G6D,100,  78, 146,  93, 100, 100
    MOVE G6A,92,  76, 143,  93, 102, 100
    WAIT

    SPEED 5
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,99,  80, 140,  94, 100, 100
    MOVE G6D,99,  81, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15
    GOSUB 기본자세2


    DELAY 5000

    'NEXT I

    'GOTO MAIN
    GOTO RX_EXIT
    '****************************************************************************************
왼쪽옆으로중2:

    'FOR I = 0 TO 1
    'GOSUB 기본자세
    SPEED 12
    MOVE G6A, 90,  90, 120, 105, 104, 100
    MOVE G6D,100,  76, 146,  93, 101, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT


    SPEED 12
    MOVE G6A, 101,  78, 148, 92, 100, 100
    MOVE G6D,83,  78, 140,  95, 109, 100
    WAIT


    SPEED 10
    MOVE G6A,100,  78, 146,  93, 100, 100
    MOVE G6D,92,  76, 143,  93, 102, 100
    WAIT

    SPEED 5
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,99,  80, 140,  94, 100, 100
    MOVE G6D,99,  81, 140,  94, 100, 100
    MOVE G6B,99,  30,  81, 100, 100, 100
    MOVE G6C,100 ,  34,  80, 100, 135, 100
    WAIT


    SPEED 15
    GOSUB 기본자세2


    DELAY 5000

    'NEXT I

    'GOTO MAIN
    GOTO RX_EXIT
    '****************************************************************************************


계단오른발오르기2cm: 'UPSTAIR GREEN

    GOSUB 기본자세2
    DELAY 3000
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 111
    MOVE G6A,108,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,112,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 6
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 6
    MOVE G6D,  80, 55, 120, 160, 114,
    MOVE G6A,110,  70, 155,  90,  94
    WAIT

    SPEED 6
    MOVE G6D,  90, 55, 120, 150, 114,
    MOVE G6A,111,  70, 160,  85,  94
    WAIT




    GOSUB Leg_motor_mode3

    SPEED 6
    MOVE G6D, 105, 73, 100, 150, 103,
    MOVE G6A,95,  90, 165,  65, 101
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 4
    MOVE G6D, 110, 85, 90, 153,101,
    MOVE G6A,95,  100, 165,  62, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2
    SPEED 6
    MOVE G6D, 113, 85, 100, 150,97,
    MOVE G6A,95,  90, 165,  70, 107
    WAIT

    SPEED 6
    MOVE G6D, 113, 87, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 110, 128,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 4
    MOVE G6D, 110, 90, 110, 127,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 2
    MOVE G6A, 98, 90, 110, 125,102,
    MOVE G6D,98,  90, 110,  125, 102
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 2
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세2
    DELAY 3000
    GOTO RX_EXIT

    '****************************************************************************************


계단왼발내리기20cm: ' GREEN USE
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  77, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,112,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 4
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,112,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 4
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,112,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 4
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 45,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 4
    MOVE G6A,104, 30, 150, 150, 104
    MOVE G6D,85,  155, 80,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,75,  125, 140,  88,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'GOSUB Leg_motor_mode2	
    SPEED 4
    MOVE G6A,111, 68, 128, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT
    GOSUB Leg_motor_mode2	
    SPEED 4
    MOVE G6A,111, 75, 128, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 2
    MOVE G6A,111, 80, 128, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 2
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 2
    GOSUB 기본자세2
    GOSUB All_motor_Reset


    GOTO RX_EXIT

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


    DELAY 3000
    GOTO RX_EXIT




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





    '*************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 20, 90, 100, 100, 100
    MOVE G6C,100, 20, 90, 100, 100, 100
    WAIT
    RETURN
    '**************************************
    '앉은자세:

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
GYRO_STT:
    GYROSENSE G6A,5,,,5,
    GYROSENSE G6D,5,,,5,
    RETURN

GYRO_ST:
    GYROSENSE G6A,120,50,40,30,100
    GYROSENSE G6D,120,50,40,30,100
    RETURN


희영오르기:

    DELAY 3000
    GOSUB GYRO_OFF

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

    GOSUB 기본자세2
    DELAY 3000
    GOTO RX_EXIT




