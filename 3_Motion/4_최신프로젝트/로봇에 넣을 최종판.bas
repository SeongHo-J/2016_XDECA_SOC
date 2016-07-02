'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행순서 AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE



PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번 그룹사용 설정
DIR G6B,1,1,1,1,1,1		'모터6~11번 그룹사용 설정
DIR G6C,0,0,0,0,0,0		'모터12~17번 그룹사용 설정
DIR G6D,0,1,1,0,1,0		'모터18~23번 그룹사용 설정


'*****************변수선언******************

보행순서 = 0

'*****************초기동작******************

'GETMOTORSET G6A,1,1,1,1,1,0
'GETMOTORSET G6B,1,1,1,0,0,0
'GETMOTORSET G6C,1,1,1,0,0,0
'GETMOTORSET G6D,1,1,1,1,1,0

SPEED 5
GOSUB MOTOR_ON
GOSUB MOTOR_READ
TEMPO 220
MUSIC "O23EAB7EA>3#C"
GOSUB 기본자세
GOTO MAIN

'*****************피에조소리내기******************



MOTOR_READ:
    FOR I = 1 TO 15
        b=MOTORIN(2)
    NEXT I
    RETURN


MOTOR_ON:
    MOTOR G6A				'모터0~7번 그룹사용 설정
    MOTOR G6B				'모터8~15번 그룹사용 설정
    MOTOR G6C				'모터16~23번 그룹사용 설정
    MOTOR G6D				'모터24~31번 그룹사용 설정
    RETURN

    '*****************피에조소리내기******************

기본자세:
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  82, 145,  86, 100, 100
    MOVE G6B,100,  25,  80, 	, 100, 100
    MOVE G6C,102 ,  30,  80, 100, 135, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN

    '************************************************

기본자세2:
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  82, 145,  86, 100, 100
    MOVE G6B,100,  25,  80, 	, 100, 100
    MOVE G6C,102 ,  30,  80, 100, 148, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN

    '************************************************
올려보기:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,100,  30,  80, 100, 100, 100
    MOVE G6C,100,  30,  80, 100, 60, 100
    WAIT
    GOTO MAIN

    '************************************************




전진달리기최종:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST
    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    'IF 보행순서 = 0 THEN
    '    보행순서 = 1
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,100,  78, 145,  93, 98
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
전진달리기최종_1:
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,101, 78, 146,  91, 100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

전진달리기최종_2:
        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,101, 80, 146,  89, 100
        WAIT

전진달리기최종_3:
        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 96, 88, 160,  68, 100
        WAIT

        'ERX 4800,A, 전진달리기50_4
        'IF A <> A_old THEN  GOTO 전진달리기50_멈춤

        '*********************************

전진달리기최종_4:
        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

전진달리기최종_5:
        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT

전진달리기최종_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
    NEXT I



전진달리기최종_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    '보행순서=0
    GOSUB GYRO_OFF
    GOTO MAIN


전진달리기양발50:
    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT
        GOTO 전진달리기양발50_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT
        GOTO 전진달리기양발50_4
    ENDIF


전진달리기양발50_1:

    FOR I = 0 TO 2
        '   GOTO 전진달리기50_1
        '전진달리기50_1:
        MOVE G6A,95,  95, 100, 120, 101
        MOVE G6D,106, 88, 136,  91, 105
        MOVE G6B, 80
        MOVE G6C,120
        WAIT
        '   GOTO 전진달리기50_2
        '전진달리기50_2:
        MOVE G6A,95,  75, 122, 120, 101
        MOVE G6D,106, 78, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_3
        '전진달리기50_3:
        MOVE G6A,103, 70, 145, 103, 100
        MOVE G6D, 97, 88, 160,  68, 102
        WAIT
        '   GOTO 전진달리기50_4
        '전진달리기50_4:
        MOVE G6D,95,  88, 100, 120, 101
        MOVE G6A,108, 78, 146,  91, 105
        MOVE G6C, 80
        MOVE G6B,120
        WAIT
        '   GOTO 전진달리기50_5
        '전진달리기50_5:
        MOVE G6D,95,  75, 122, 120, 101
        MOVE G6A,108, 80, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_6
        '전진달리기50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT

    NEXT I

    GOTO 전진달리기양발50_멈춤

전진달리기양발50_4:

    FOR I = 0 TO 2

        '   GOTO 전진달리기50_4
        '전진달리기50_4:
        MOVE G6D,95,  88, 100, 120, 101
        MOVE G6A,108, 78, 146,  91, 105
        MOVE G6C, 80
        MOVE G6B,120
        WAIT
        '   GOTO 전진달리기50_5
        '전진달리기50_5:
        MOVE G6D,95,  75, 122, 120, 101
        MOVE G6A,108, 80, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_6
        '전진달리기50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
        '   GOTO 전진달리기50_1
        '전진달리기50_1:
        MOVE G6A,95,  95, 100, 120, 101
        MOVE G6D,106, 88, 136,  91, 105
        MOVE G6B, 80
        MOVE G6C,120
        WAIT
        '   GOTO 전진달리기50_2
        '전진달리기50_2:
        MOVE G6A,95,  75, 122, 120, 101
        MOVE G6D,106, 78, 146,  91, 105
        WAIT
        '    GOTO 전진달리기50_3
        '전진달리기50_3:
        MOVE G6A,103, 70, 145, 103, 100
        MOVE G6D, 97, 88, 160,  68, 102
        WAIT

    NEXT I

    GOTO 전진달리기양발50_멈춤


전진달리기양발50_멈춤:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 안정화자세
    SPEED 6
    GOSUB 기본자세

    DELAY 500


    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO MAIN

RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 9600, A, MAIN

    GOTO RX_EXIT
    '************************************************

    '******************************************

왼쪽옆으로70:

    '
    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
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
    GOTO MAIN

오른쪽옆으로70:

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,100,  40
    MOVE G6C,100,  40, , , 135
    WAIT

    SPEED 12
    MOVE G6D, 102,  76, 147, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    SPEED 15
    GOSUB 기본자세
    GOTO MAIN

왼쪽턴20:
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  90, 150,  73, 105, 100
    MOVE G6D,95,  53, 150, 110, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


    SPEED 10
    MOVE G6A,93,  90, 150,  73, 105, 100
    MOVE G6D,93,  53, 150, 110, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    DELAY 500
    GOTO MAIN

왼쪽턴45:

    '--------------수정완료(태훈)-----------------
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,94,  104, 177,  22, 105, 100
    MOVE G6D,94,  38,  135,  135, 105, 100
    MOVE G6B,120
    MOVE G6C,80
    WAIT


    SPEED 10
    MOVE G6A,92,  104, 177,  22, 105, 100
    MOVE G6D,92,  38,  135,  135, 105, 100

    MOVE G6B,120
    MOVE G6C,80
    WAIT

    '---------------------------------------------
    SPEED 8
    GOSUB 외각선확인
    GOSUB Leg_motor_mode1
    GOTO MAIN

오른쪽턴45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    MOVE G6C,115
    MOVE G6B,85

    WAIT

    SPEED 8
    GOSUB 외각선확인
    GOSUB Leg_motor_mode1

    GOTO MAIN


오른쪽턴20:
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6D,95,  90, 150,  73, 105, 100
    MOVE G6A,95,  53, 150, 110, 105, 100
    MOVE G6C,110
    MOVE G6B,90
    WAIT


    SPEED 10
    MOVE G6D,93,  90, 150,  73, 105, 100
    MOVE G6A,93,  53, 150, 110, 105, 100
    WAIT

    SPEED 6
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6C,100,  30,  80
    MOVE G6B,100,  30,  80
    WAIT

    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    DELAY 500
    GOTO MAIN




전진종종10걸음:
    '    넘어진확인 = 0

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
    FOR I = 0 TO 9
전진종종10걸음_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


전진종종10걸음_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

전진종종10걸음_3:
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

전진종종10걸음_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


전진종종10걸음_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

전진종종10걸음_6:
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

전진종종10걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF    '보행순서=0
    GOTO MAIN



    '*****************************************************


전진종종2걸음:
    '    넘어진확인 = 0
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
    FOR I = 0 TO 1
전진종종2걸음_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


전진종종2걸음_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

전진종종2걸음_3:
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

전진종종2걸음_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


전진종종2걸음_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

전진종종2걸음_6:
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

전진종종2걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'보행순서=0
    GOTO MAIN


    '*****************************************************

안정화자세:
    MOVE G6A,98,  77, 145,  93, 101, 100
    MOVE G6D,99,  75, 145,  93, 101, 100
    MOVE G6B,100,  25,  80, 100, 100, 100
    MOVE G6C,102,  31,  80, 100, 135, 100
    WAIT
    RETURN

안정화자세2:
    MOVE G6A,98,  77, 145,  93, 101, 100
    MOVE G6D,99,  75, 145,  93, 101, 100
    MOVE G6B,100,  25,  80, 100, 100, 100
    MOVE G6C,102,  31,  80, 100, 148, 100
    WAIT
    RETURN

    '********************************************************

계단오른발오르기2cm: 'UPSTAIR GREEN
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
    MOVE G6D, 105, 75, 100, 152, 102,
    MOVE G6A,95,  93, 160,  70, 102
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 110, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 102
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 110, 90, 100, 150,95,
    MOVE G6A,93,  90, 165,  70, 107
    WAIT

    SPEED 12
    MOVE G6D, 110, 90, 100, 150,95,
    MOVE G6A,88,  120, 40,  140, 110
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,88,  95, 90,  145, 110
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 110
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,102,
    MOVE G6A,90,  85, 110,  135, 104
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,101,
    MOVE G6D,98,  90, 110,  125,101,
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
    '보행순서=0
    GOTO MAIN

    '********************************************************

계단왼발내리기2cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,111,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,111,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,111,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    SPEED 5 ' add
    MOVE G6A,90, 20, 150, 150, 105
    MOVE G6D,110,  155, 55,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT
    '****************************

    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A,108, 64, 132, 137, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,110, 68, 130, 147, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6A,110, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6A,110, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, , 80, 130, 105,99,
    MOVE G6A,100,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4

    GOSUB 기본자세
    GOTO MAIN

    '********************************************************

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

    SPEED 15
    PTP SETOFF
    PTP ALLOFF
    HIGHSPEED SETOFF

    'GOTO 기어가기왼쪽턴_LOOP

기어가기_LOOP:


    MOVE G6A, 100, 160,  55, 160, 100
    MOVE G6D, 102, 145,  75, 160, 99
    MOVE G6B, 170,  25,  70
    MOVE G6C, 187,  50,  40
    WAIT

기어가기_1:
    MOVE G6A, 100, 150,  70, 160, 100
    MOVE G6D, 100, 140, 120, 120, 99
    MOVE G6B, 160,  28,  73
    MOVE G6C, 190,  25,  70
    WAIT

    MOVE G6D, 100, 160,  50, 160, 100
    MOVE G6A, 102, 146,  78, 160, 101
    MOVE G6C, 175,  30,  65
    MOVE G6B, 187,  50,  40
    WAIT


기어가기_2:
    MOVE G6D, 100, 150,  70, 160, 100
    MOVE G6A, 101, 140, 123, 120, 99
    MOVE G6C, 161,  30,  65
    MOVE G6B, 187,  25,  72
    WAIT

    GOTO 기어가기_LOOP

    '********************************************************

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
    GOTO MAIN

    '********************************************************

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
    보행순서=0
    GOTO MAIN


    '*********************************************
왼발공차기:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_MIN

    GOSUB Leg_motor_mode3
    SPEED 3

    MOVE G6D,110,  77, 145,  93,  92, 100	
    MOVE G6A, 85,  71, 152,  91, 114, 100
    MOVE G6C,100,  40,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    SPEED 3
    MOVE G6D,106,  75, 145,  100,  98
    MOVE G6A, 83,  85, 122,  105, 108
    MOVE G6C,100,  48,  80, , , ,
    MOVE G6B,100,  40,  80, , , ,	
    WAIT

    GOSUB Leg_motor_mode2
    HIGHSPEED SETON

    SPEED 5
    MOVE G6D,111,  81, 141,  87,  95
    MOVE G6A, 83,  20, 172,  135, 110
    MOVE G6B,50
    MOVE G6C,150
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


    SPEED 4
    MOVE G6D,111,  72, 145,  97,  95
    MOVE G6A, 83,  58, 122,  130, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,	
    WAIT	

    SPEED 4
    MOVE G6D,111,  77, 145,  95,  93	
    MOVE G6A, 80,  80, 142,  95, 114
    MOVE G6B,100,  40,  80, , , ,
    MOVE G6C,100,  40,  80, , , ,
    WAIT	

    SPEED 4
    MOVE G6D,106,  77, 145,  93,  93, 100	
    MOVE G6A, 83,  71, 152,  91, 110, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    DELAY 1500

    GOTO MAIN

    '*********************************************

전진달리기희영50:

    SPEED 30
    HIGHSPEED SETON
    GOSUB Leg_motor_mode4

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기희영50_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  78, 145,  93, 98
        WAIT

        GOTO 전진달리기희영50_4
    ENDIF


    '**********************


전진달리기희영50_1:
    FOR I = 0 TO 2
        '전진달리기50_1:
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,101, 78, 146,  91, 100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

        '전진달리기50_2:
        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,101, 80, 146,  89, 100
        WAIT

        '전진달리기50_3:
        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 96, 88, 160,  68, 100
        WAIT

        'ERX 4800,A, 전진달리기50_4
        'IF A <> A_old THEN  GOTO 전진달리기50_멈춤

        '*********************************

        '전진달리기50_4:
        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '전진달리기50_5:
        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT

        '전진달리기50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT
    NEXT I

    GOTO 전진달리기희영50_멈춤

    'ERX 4800,A, 전진달리기50_4
    'IF A <> A_old THEN  GOTO 전진달리기50_멈춤

    '*********************************

전진달리기희영50_4:

    FOR I = 0 TO 2
        '전진달리기50_4:
        MOVE G6D,96,  95, 100, 120, 104
        MOVE G6A,103, 78, 146,  91, 102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT

        '전진달리기50_5:
        MOVE G6D,96,  75, 122, 120, 104
        MOVE G6A,103, 80, 146,  89, 100
        WAIT

        '전진달리기50_6:
        MOVE G6D,104, 70, 145, 103, 100
        MOVE G6A, 94, 88, 160,  68, 102
        WAIT

        '전진달리기50_1:
        MOVE G6A,96,  95, 100, 120, 104
        MOVE G6D,101, 78, 146,  91, 100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT

        '전진달리기50_2:
        MOVE G6A,96,  75, 122, 120, 104
        MOVE G6D,101, 80, 146,  89, 100
        WAIT

        '전진달리기50_3:
        MOVE G6A,104, 70, 145, 103, 100
        MOVE G6D, 96, 88, 160,  68, 100
        WAIT
    NEXT I


    GOTO 전진달리기희영50_멈춤


전진달리기희영50_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세


    DELAY 400

    GOSUB Leg_motor_mode1
    '보행순서=0
    GOTO MAIN


허들넘기: 'USE

    SPEED 13
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  83, 145,  86, 100, 100
    MOVE G6B,100,  100,  80, 100, 100, 100
    MOVE G6C,102 , 100,  80, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6B, 185, 10, 100
    MOVE G6C, 190, 14, 100
    WAIT

    SPEED 10
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 185,  10,  100
    MOVE G6C, 190,  14,  100
    WAIT

    SPEED 6
    MOVE G6A, 100,  75, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 185,  10,  80 , 100, 100
    MOVE G6C, 190,  14,  80 , 100, 190
    WAIT
    '=------------------------------------------
    SPEED 6
    MOVE G6A, 100,  76, 145,  130, 100, 100
    MOVE G6D, 100,  76, 145,  130, 100, 100
    MOVE G6B, 152,  20,  85
    MOVE G6C, 155,  24,  85
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
    '''''''''''''''''''''''''

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
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세
    '보행순서=0
    GOTO MAIN

    '*****************************************************

외각선확인:
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,106,  44,  50, 100, 100, 184
    MOVE G6C,108,  47,  50, 100, 128, 100
    WAIT
    mode = 0
    ETX 9600,30
    RETURN

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


판위에서전진종종2걸음:
    '    넘어진확인 = 0
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
    MOVE G6C,100,  35,, 100, 148
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
    FOR I = 0 TO 1
판위에서전진종종2걸음_1:
        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80,,,,,100
        MOVE G6C,120,,,100
        WAIT


판위에서전진종종2걸음_2:
        MOVE G6A,95,  85, 130, 103, 104
        MOVE G6D,104,  79, 146,  89,  100
        WAIT

판위에서전진종종2걸음_3:
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

판위에서전진종종2걸음_4:
        MOVE G6D,95,  95, 120, 100, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


판위에서전진종종2걸음_5:
        MOVE G6D,95,  85, 130, 103, 104
        MOVE G6A,104,  79, 146,  89,  100
        WAIT

판위에서전진종종2걸음_6:
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

판위에서전진종종2걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세2
    SPEED 10
    GOSUB 기본자세2

    DELAY 400

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'보행순서=0
    GOTO MAIN


    '*****************************************************

전진보행50:

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
    MOVE G6C,100,35
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,111,  78, 146,  93,  95
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    '        GOTO 전진보행50_1



전진보행50_1:
    FOR I = 0 TO 10
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



전진보행50_2:


        SPEED 보행속도
        '오른발뻣어착지
        MOVE G6D,85,  44, 163, 113, 117
        MOVE G6A,110,  77, 146,  93,  94
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

    GOSUB 기본자세
    GOSUB GYRO_OFF
    'ONE=0
    GOTO MAIN





    'MAIN: '라벨설정
    'ETX 9600,48

    'GOSUB 앉은자세
    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
MAIN:
    'GOTO KEY1
    'A=A+1
    'IF A=44 THEN
    'A=0
    ERX 9600,A, MAIN
    'GOTO 오른쪽턴2
    A_old = A

    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18
    'GOTO KEY34
    'DELAY 500

    'GOTO 앉아오른팔뻗기

    GOTO MAIN
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************
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


KEY1:
    'ETX  9600,1
    MOVE G6A,100,  82, 145,  86, 100, 100
    MOVE G6D,100,  82, 145,  86, 100, 100
    MOVE G6B,100,  25,  80, 	, 100, 100
    MOVE G6C,102 ,  30,  80, 100, 135, 100
    WAIT
    'DELAY 1000

    GOTO MAIN
KEY2:
    ' ETX  9600,2
    GOTO 전진달리기최종
    'DELAY 1000

    GOTO MAIN
KEY3: 'LEFT SIDE
    'ETX  9600,3
    'MOVE G6A,100,  79, 148,  86, 102, 100
    'MOVE G6D,100,  79, 148,  86, 102, 100
    'MOVE G6B,100,  18,  88, 100, 100, 10
    'MOVE G6C,100,  18,  88, 100, 135, 100
    'WAIT
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,108  18,  88, 100, 100, 10
    MOVE G6C,108,  18,  88, 100, 135, 100
    WAIT
    'DELAY 1000
    GOTO MAIN

KEY4: 'RIGHT SIDE
    'ETX  9600,4
    'MOVE G6A,100,  74, 148,  95, 102, 100
    'MOVE G6D,100,  74, 148,  95, 102, 100
    'MOVE G6B,100,  18,  88, 100, 100, 190
    'MOVE G6C,100,  18,  88, 100, 135, 100
    'WAIT
    MOVE G6A,100,  74, 148,  91, 102, 100
    MOVE G6D,100,  74, 148,  91, 102, 100
    MOVE G6B,108  18,  88, 100, 100, 190
    MOVE G6C,108,  18,  88, 100, 135, 100
    WAIT
    GOTO MAIN
KEY5:
    'ETX 9600,5
    GOTO 왼쪽옆으로70
    'DELAY 1000
    GOTO MAIN
KEY6:
    ' ETX 9600,6
    GOTO 오른쪽옆으로70
    'DELAY 1000
    GOTO MAIN
KEY7:
    ' ETX 9600,7
    GOTO 왼쪽턴45
    'DELAY 1000
    GOTO MAIN
KEY8:
    'ETX 9600,8
    GOTO 오른쪽턴45
    'DELAY 1000
    GOTO MAIN
KEY9:
    ' ETX 9600,9
    GOTO 왼쪽턴20
    'DELAY 1000
    GOTO MAIN
KEY10:
    ' ETX 9600,10
    GOTO 오른쪽턴20
    'DELAY 1000
    GOTO MAIN
KEY11:
    'ETX 9600,11
    GOTO 전진종종10걸음
    'DELAY 1000
    GOTO MAIN
KEY12:
    'ETX 9600,12
    GOTO 전진종종2걸음
    'DELAY 1000
    GOTO MAIN
KEY13:
    'ETX 9600,13
    GOTO 올려보기
    DELAY 1000
    GOTO MAIN
KEY14:
    'ETX 9600,14
    GOTO 계단오른발오르기2cm
    'DELAY 1000
    GOTO MAIN
KEY15:
    'ETX 9600,15
    GOTO 계단왼발내리기2cm
    'DELAY 1000
    GOTO MAIN
KEY16:
    'ETX 9600,16
    GOTO 허들넘기
    'DELAY 1000
    GOTO MAIN
    END
KEY17:
    'ETX 9600,17
    GOTO 왼발공차기
    'DELAY 1000
    GOTO MAIN
    END
KEY18:
    'ETX 9600,18
    GOTO 판위에서전진종종2걸음
    'DELAY 1000
    GOTO MAIN
    <<<<<<< HEAD
KEY19:
    GOTO 기어서올라가기
    GOTO MAIN
KEY20:
    GOTO 내려가기
    GOTO MAIN

KEY21:
    GOTO 전진보행50
    GOTO MAIN
    END
=======
    END

    >>>>>>> 014a22056b59f56ff07378014ac5b9847acb9f59
