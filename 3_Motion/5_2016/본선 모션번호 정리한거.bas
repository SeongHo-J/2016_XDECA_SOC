
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
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM 기울기확인횟수 AS BYTE
DIM 넘어진확인 AS BYTE
DIM 기울기센서측정여부 AS BYTE
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
CONST min = 61			'뒤로넘어졌을때
CONST max = 107			'앞으로넘어졌을때
CONST COUNT_MAX = 20


기울기확인횟수 = 0
넘어진확인 = 0
기울기센서측정여부 = 1




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
    GYROSENSE G6A,120,50,40,30,100
    GYROSENSE G6D,120,50,40,30,100
    RETURN
GYRO_STT:
    GYROSENSE G6A,5,,,5,
    GYROSENSE G6D,5,,,5,
    RETURN


RX_EXIT:
    'GOSUB SOUND_STOP
    ERX 9600, A, MAIN

    GOTO RX_EXIT

    '************************************************
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
골프공자세:
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 145, 100
    WAIT
    RETURN




안정화자세:
    MOVE G6A,98,  77, 145,  93, 101, 100
    MOVE G6D,99,  75, 145,  93, 101, 100
    MOVE G6B,100,  25,  80, 100, 100, 100
    MOVE G6C,102,  31,  80, 100, 135, 100
    WAIT
    RETURN


앉은자세:

    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    RETURN
    '***************************************
전진달리기최종:
    GOSUB 기본자세3
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

    GOSUB 기본자세3

    GOSUB Leg_motor_mode1
    'ONE=0


    'GOTO 전진종종걸음최종

    GOTO RX_EXIT
전진보행: 'COMPLETE

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



전진보행_1:
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



전진보행_2:


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




    'GOSUB 안정화자세2
    GOSUB 기본자세
    GOSUB GYRO_OFF

    'GOTO MAIN
    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정

    GOTO RX_EXIT

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
    FOR I = 0 TO 2

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

    GOTO RX_EXIT

    'GOTO MAIN
    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정
전진보행4걸음: 'COMPLETE GREEN

    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST

    'GOSUB SOUND_Walk_Ready
    보행속도 = 10'5
    좌우속도 = 5'8'3
    좌우속도2 = 4'5'2
    '넘어진확인 = 0
    GOSUB 기본자세
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



전진보행4걸음_1:
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



전진보행4걸음_2:


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




    'GOSUB 안정화자세2
    GOSUB 기본자세

    GOTO RX_EXIT



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
    GOTO RX_EXIT



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
    GOTO RX_EXIT
왼쪽턴45: ' COMPLETE
    GOSUB 기본자세
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 12
    MOVE G6A,93,  116, 145,  53, 105, 100
    MOVE G6D,93,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************************************************
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
        MOVE G6A,97,  95, 120, 102, 101
        MOVE G6D,104, 78, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음최종_2:
        MOVE G6A,97,  85, 130, 102, 101
        MOVE G6D,104, 79, 146, 90, 101
        WAIT

        '전진종종걸음최종_3:
        MOVE G6A,102,  82, 130, 103,  101
        MOVE G6D, 96,  79, 147,  90, 102
        WAIT

        '전진종종걸음최종_4:
        MOVE G6D,98,  98, 117,  104, 103
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
        MOVE G6D,98,  98, 117,  104, 103
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
        MOVE G6A,97,  95, 120, 102, 101
        MOVE G6D,104, 78, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음최종_2:
        MOVE G6A,97,  85, 130, 102, 101
        MOVE G6D,104, 79, 146, 90, 101
        WAIT

        '전진종종걸음최종_3:
        MOVE G6A,102,  82, 130, 103,  101
        MOVE G6D, 96,  79, 147,  90, 102
        WAIT


    NEXT I
    GOTO 전진종종10걸음멈춤

전진종종10걸음멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO RX_EXIT


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
    GOTO RX_EXIT
초록색전진보행50:


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


초록색전진보행50_1:
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

    GOTO RX_EXIT


고개90도종종걸음3걸음:
    GOSUB 기본자세0
    SPEED 13
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    MOVE G6D,97,  76, 145,  93, 101
    MOVE G6A,101,  77, 145,  93, 98
    MOVE G6B,100,  35
    MOVE G6C,100 , 35,,,190,
    WAIT

    GOTO 고개90도종종걸음3걸음_1
    'ENDIF

고개90도종종걸음3걸음_1:
    '4
    MOVE G6D,96, 82, 128, 105,  101
    MOVE G6A,104, 76, 146,  92,  100
    MOVE G6C,80,,,,190,
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,96,  74, 132, 107, 101
    MOVE G6A,104, 79, 146,  88,  100
    WAIT

    '6:
    MOVE G6D, 100,  84, 131,  103, 102
    MOVE G6A, 97,  73, 146,  98, 101
    WAIT
    '--------------------------------------
    '1:
    MOVE G6A,96,  88, 128, 105, 101
    MOVE G6D,102, 80, 146,  95,  100
    MOVE G6B, 80
    MOVE G6C,120,,,,190,
    WAIT

    '2:
    MOVE G6A,96,   78, 126, 114, 101
    MOVE G6D,102,  79, 146,  91, 100
    WAIT

    '3:
    MOVE G6A,100,  78, 135,  107, 101
    MOVE G6D,100,  77, 146,  93, 100
    WAIT
    '--------------------------------------
    '4
    MOVE G6D,96, 82, 128, 105,  101
    MOVE G6A,104, 76, 146,  92,  100
    MOVE G6C, 80,,,,190,
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,96,  74, 132, 107, 101
    MOVE G6A,104, 79, 146,  88,  100
    WAIT

    '6:
    MOVE G6D, 100,  84, 131,  103, 102
    MOVE G6A, 97,  73, 146,  98, 101
    WAIT


    GOTO 고개90도종종걸음3걸음멈춤

고개90도종종걸음3걸음멈춤:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세0



    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO RX_EXIT
고개90도나무종종:
    '*************        ***************     멀쩡!       ***************
    GOSUB 기본자세0
    GOSUB GYRO_OFF
    SPEED 12
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    MOVE G6A,97,  76, 145,  93, 100
    MOVE G6D,99,  77, 145,  93, 100
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 190
    WAIT
    GOTO 고개90도나무종종_1
    'IF 보행순서 = 0 THEN

고개90도나무종종_1:

    ''나무 - 99,,,,,102
    '4
    MOVE G6D,97,  83, 135, 100,  99
    MOVE G6A,104, 77, 146,  92,  102
    MOVE G6C,80
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,98,  68, 150,  100, 99
    MOVE G6A,104, 75, 146,  95,  102
    WAIT

    '6
    MOVE G6A,103,  80, 130, 102, 99
    MOVE G6D, 99,  79, 144,  88, 102
    WAIT
    'MOVE G6D, 100,  80, 141,  97, 102
    'MOVE G6A, 100,  73, 146,  98, 99
    'WAIT
    '--------------------------------------
    '1:
    MOVE G6A,97,  75, 136,  102,  99
    MOVE G6D,104, 77, 146,  87,  102
    MOVE G6C,80
    MOVE G6B,120
    WAIT

    '2:
    MOVE G6A,97,  65, 150,   98,  99
    MOVE G6D,104, 77, 146,  87,  102
    WAIT

    '3:
    MOVE G6D, 99,  72, 142, 103, 102
    MOVE G6A, 102,  75, 146,  94, 97
    WAIT
    '--------------------------------------
    '4
    MOVE G6D,97,  83, 135, 100,  99
    MOVE G6A,104, 77, 146,  92,  102
    MOVE G6C,80
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,98,  68, 150,  100, 99
    MOVE G6A,104, 75, 146,  95,  102
    WAIT

    '6
    MOVE G6A,103,  80, 130, 102, 99
    MOVE G6D, 99,  79, 144,  88, 102
    WAIT
    '--------------------------------------

    GOTO 고개90도나무종종멈춤


고개90도나무종종멈춤:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세0
    GOTO RX_EXIT

    '**********************************************************************************
고개45도종종걸음3걸음:
    GOSUB 골프공자세
    SPEED 13
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    MOVE G6D,97,  76, 145,  93, 101
    MOVE G6A,101,  77, 145,  93, 98
    MOVE G6B,100,  35
    MOVE G6C,100 , 35,,,145
    WAIT

    GOTO 고개45도종종걸음3걸음_1
    'ENDIF

고개45도종종걸음3걸음_1:
    '4
    MOVE G6D,96, 82, 128, 105,  101
    MOVE G6A,104, 76, 146,  92,  100
    MOVE G6C,80
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,96,  74, 132, 107, 101
    MOVE G6A,104, 79, 146,  88,  100
    WAIT

    '6:
    MOVE G6D, 100,  84, 131,  103, 101
    MOVE G6A, 100,  73, 146,  98, 100
    WAIT
    '--------------------------------------
    '1:
    MOVE G6A,96,  88, 128, 105, 101
    MOVE G6D,102, 80, 146,  95,  100
    MOVE G6B, 80
    MOVE G6C,120
    WAIT

    '2:
    MOVE G6A,96,   78, 126, 114, 101
    MOVE G6D,102,  79, 146,  91, 100
    WAIT

    '3:
    MOVE G6A,100,  78, 135,  107, 101
    MOVE G6D,100,  77, 146,  93, 100
    WAIT
    '--------------------------------------
    '4
    MOVE G6D,96, 82, 128, 105,  101
    MOVE G6A,104, 76, 146,  92,  100
    MOVE G6C, 80,
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,96,  74, 132, 107, 101
    MOVE G6A,104, 79, 146,  88,  100
    WAIT

    '6:
    MOVE G6D, 100,  84, 131,  103, 101
    MOVE G6A, 100,  73, 146,  98, 100
    WAIT


    GOTO 고개45도종종걸음3걸음멈춤

고개45도종종걸음3걸음멈춤:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 골프공자세



    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF
    GOTO RX_EXIT




오른쪽턴10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 턴자세
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


    GOSUB 턴자세
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


오른쪽턴20: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 턴자세
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

    GOSUB 턴자세
    GOSUB Leg_motor_mode1


    GOTO RX_EXIT

오른쪽턴30: ' COMPLETE
    GOSUB GYRO_OFF
    GOSUB 턴자세
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
    GOSUB 턴자세
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


오른쪽턴45: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 턴자세
    SPEED 12
    MOVE G6D,95,  116, 145,  53, 105, 100
    MOVE G6A,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 12
    MOVE G6D,90,  116, 145,  53, 105, 100
    MOVE G6A,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 턴자세
    GOTO RX_EXIT
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
    GOTO RX_EXIT


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
    GOSUB GYRO_OFF
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



오른쪽옆으로10:
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

    GOTO RX_EXIT
오른쪽옆으로20:

    GOSUB 기본자세
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 106, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세

    GOTO RX_EXIT
골프공오른쪽옆으로20:

    GOSUB 골프공자세
    SPEED 15
    MOVE G6D, 93,  90, 120, 105, 100, 100
    MOVE G6A,103,  76, 145,  93, 103, 100
    WAIT

    SPEED 15
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,89,  80, 140,  95, 106, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 골프공자세

    GOTO RX_EXIT

왼쪽옆으로10:

    GOSUB 외각선자세2
    SPEED 15
    MOVE G6A, 92,  94, 123, 102, 102, 100
    MOVE G6D,103,  79, 148,  91, 104, 100
    WAIT

    SPEED 15
    MOVE G6A, 102,  80, 147, 91, 100, 100
    MOVE G6D,90,  82, 142,  92, 104, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  79, 145,  93, 100, 100
    MOVE G6D,98,  79, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 외각선자세2
    GOSUB GYRO_OFF

    GOTO RX_EXIT

    '*************

왼쪽옆으로20:

    GOSUB 기본자세
    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 106, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세

    GOTO RX_EXIT
    '*************
골프공왼쪽옆으로20:

    GOSUB 골프공자세
    SPEED 15
    MOVE G6A, 93,  90, 120, 105, 100, 100
    MOVE G6D,103,  76, 145,  93, 103, 100
    WAIT

    SPEED 15
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,89,  80, 140,  95, 106, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOTO RX_EXIT

오른쪽옆으로70:

    GOSUB 기본자세
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 110, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세

    GOTO RX_EXIT
    '*************

왼쪽옆으로70:

    GOSUB 기본자세
    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 110, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세

    GOTO RX_EXIT

    'DELAY 5000

    GOTO RX_EXIT

외각선오른쪽옆으로70:

    GOSUB 외각선자세2
    SPEED 8
    MOVE G6D, 92,  94, 123, 102, 110, 100
    MOVE G6A,103,  79, 148,  91, 104, 100
    WAIT

    SPEED 8
    MOVE G6D, 102,  80, 147, 91, 100, 100
    MOVE G6A,89,  82, 142,  92, 107, 100
    WAIT

    SPEED 8
    MOVE G6D,98,  79, 145,  93, 100, 100
    MOVE G6A,98,  79, 145,  93, 100, 100
    WAIT

    SPEED 8
    GOSUB 외각선자세2
    GOSUB GYRO_OFF

    GOTO RX_EXIT

외각선왼쪽옆으로70:

    GOSUB 외각선자세2
    SPEED 8
    MOVE G6A, 92,  94, 123, 102, 110, 100
    MOVE G6D,103,  79, 148,  91, 104, 100
    WAIT

    SPEED 8
    MOVE G6A, 102,  80, 147, 91, 100, 100
    MOVE G6D,89,  82, 142,  92, 107, 100
    WAIT

    SPEED 8
    MOVE G6A,98,  79, 145,  93, 100, 100
    MOVE G6D,98,  79, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 외각선자세2
    GOSUB GYRO_OFF
    GOTO RX_EXIT

    'DELAY 5000

    GOTO RX_EXIT
    '*************
    '*************
    '*******************************************************************************************************************************
    '고개90도턴,옆으로
고개90도왼쪽턴10: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 턴자세2


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


    GOSUB 턴자세2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT



고개90도왼쪽턴20: ' COMPLETE
    GOSUB GYRO_OFF
    GOSUB 턴자세2
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

    GOSUB 턴자세2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
고개90도왼쪽턴45: ' COMPLETE
    GOSUB GYRO_OFF
    GOSUB 턴자세2
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 12
    MOVE G6A,93,  116, 145,  53, 105, 100
    MOVE G6D,93,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 턴자세2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT




고개90도오른쪽턴10: ' COMPLETE


    GOSUB GYRO_OFF
    GOSUB 턴자세2
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


    GOSUB 턴자세2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


고개90도오른쪽턴20: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 턴자세2
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

    GOSUB 턴자세2
    GOSUB Leg_motor_mode1


    GOTO RX_EXIT

고개90도오른쪽턴30: ' COMPLETE
    GOSUB GYRO_OFF
    GOSUB 턴자세2
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
    GOSUB 턴자세2
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT


고개90도오른쪽턴45: ' COMPLETE

    GOSUB GYRO_OFF
    GOSUB 턴자세2
    SPEED 12
    MOVE G6D,95,  126, 145,  43, 105, 100
    MOVE G6A,95,  26, 145,  143, 105, 100
    WAIT

    SPEED 12
    MOVE G6D,90,  126, 145,  43, 105, 100
    MOVE G6A,90,  26, 145,  143, 105, 100
    WAIT

    SPEED 10
    GOSUB 턴자세2
    GOTO RX_EXIT

고개90도오른쪽옆으로20:


    GOSUB 기본자세0
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 106, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세0

    GOTO RX_EXIT
    '*************

고개90도왼쪽옆으로20:

    GOSUB 기본자세0
    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 106, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세0

    GOTO RX_EXIT
    '*************
고개90도오른쪽옆으로70:

    GOSUB 기본자세0
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 104, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세0

    GOTO RX_EXIT
    '*************

고개90도왼쪽옆으로70:

    GOSUB 기본자세0
    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,89,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세0

    GOTO RX_EXIT
    '*************


    '*******************************************************************************************************************************



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
    MOVE G6B,130,  80,  20,,,
    MOVE G6C,130,  80,  20,,180
    WAIT

    SPEED 15
    MOVE G6A,100, 128, 140, 147, 100, 100
    MOVE G6D,100, 128, 140, 147, 100, 100
    MOVE G6B,140,  80,  20
    MOVE G6C,140,  80,  20,,180
    WAIT




    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  40,  70
    MOVE G6C,150,  40,  70,,180
    WAIT

    SPEED 20
    MOVE G6A,100,  128, 150, 147, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  40,  70
    MOVE G6C,150,  40,  70,,180
    WAIT

    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  40,  70
    MOVE G6C,150,  40,  70,,
    WAIT

    SPEED 20
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6A,100,  60, 110, 15, 100, 100
    MOVE G6C,170,  41,  68
    MOVE G6B,170,  40,  70
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70,,190
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
    GOSUB 앞뒤기울기측정


    GOTO RX_EXIT


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
    MOVE G6C,150,  80,  40,,190
    WAIT




    SPEED 20
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100,  128, 150, 147, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,150,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,150,  50,  70
    MOVE G6C,150,  50,  70,,190
    WAIT

    SPEED 20
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110, 15, 100, 100
    MOVE G6B,169,  51,  68
    MOVE G6C,171,  50,  70
    WAIT
    DELAY 200
    SPEED 20
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  50,  70
    MOVE G6C,190,  50,  70,,190
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
    '
    GOSUB 앞뒤기울기측정
    GOTO rx_exit

외각선자세:

    SPEED 15
    MOVE G6A,100,  85, 137,  94, 100, 100
    MOVE G6D,100,  86, 137,  94, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    RETURN

외각선자세2:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_STT

    SPEED 15
    MOVE G6A,100,  85, 137,  94, 100, 100
    MOVE G6D,100,  86, 137,  94, 100, 100
    MOVE G6B,10,  10,  51, 100, 100, 190
    MOVE G6C,10 ,  15,  55, 100, 135, 100' 153
    WAIT

    RETURN

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

    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정


    GOTO RX_EXIT


계단오른발오르기2cm: 'UPSTAIR GREEN

    GOSUB 기본자세3

    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  77, 146,  93,  94
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

    SPEED 4
    MOVE G6A, 98, 90, 110, 125,102,
    MOVE G6D,98,  90, 110,  125, 102
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 8
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT
    GOSUB All_motor_Reset

    GOSUB 기본자세3
    GOTO RX_EXIT
    '********************************************************

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

    GOSUB 앞뒤기울기측정


    GOTO RX_EXIT


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

    SPEED 10
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

    'GOTO MAIN
    GOTO RX_EXIT

    '********************************************************************************************************************************************
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
좌우기울기측정:
    '  IF 기울기센서측정여부 = 0 THEN
    '        RETURN
    '    ENDIF
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
        RETURN

    ENDIF
    RETURN
    '**************************************************
    '**************************************************
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
    넘어진확인 = 1
    RETURN


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

    넘어진확인 = 1
    RETURN
    '**************************************************************
전진종종2걸음:
    '    넘어진확인 = 0
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    GOSUB GYRO_OFF
    GOSUB 기본자세
    SPEED 10

    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,98,  76, 145,  93, 101
        MOVE G6D,102,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종2걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,98,  76, 145,  93, 101
        MOVE G6A,102,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 전진종종2걸음_4
    ENDIF


    'MOVE G6A,101,  76, 145,  94, 100
    'MOVE G6D,101,  77, 145,  94, 100
    'MOVE G6B,100,  35,,,,100
    'MOVE G6C,100,  35,, 100, 135
    'WAIT

    '**********************
전진종종2걸음_1:

    FOR I = 0 TO 1
        '전진종종걸음_1:
        MOVE G6A,95,  95, 127, 100, 101
        MOVE G6D,106,  77, 146, 92,  100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음_2:
        MOVE G6A,95,   71, 146,  97, 101
        MOVE G6D,106,  79, 146,  87,  100
        WAIT

        '전진종종걸음_3:
        MOVE G6A,103,  80, 130, 102, 99
        MOVE G6D, 99,  79, 144,  88, 102
        WAIT

        '*********************************

        '전진종종걸음_4:
        MOVE G6D,95,  95, 127, 100, 102
        MOVE G6A,106, 79, 146, 90,  98
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        '전진종종걸음_5:
        MOVE G6D,97,   62, 148, 104, 102
        MOVE G6A,100,  74, 146,  87,  100
        WAIT

        '전진종종걸음_6:
        MOVE G6D, 99,  72, 142, 103, 104
        MOVE G6A, 102,  75, 146,  94, 97
        WAIT

    NEXT I
    GOTO 전진종종2걸음_멈춤

전진종종2걸음_4:

    FOR I = 0 TO 1

        '전진종종걸음_4:
        MOVE G6D,95,  95, 127, 100, 102
        MOVE G6A,106, 79, 146, 90,  98
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        '전진종종걸음_5:
        MOVE G6D,97,   62, 148, 104, 102
        MOVE G6A,100,  74, 146,  87,  100
        WAIT

        '전진종종걸음_6:
        MOVE G6D, 99,  72, 142, 103, 104
        MOVE G6A, 102,  75, 146,  94, 97
        WAIT

        '******************************************88

        '전진종종걸음_1:
        MOVE G6A,95,  95, 127, 100, 101
        MOVE G6D,106,  77, 146, 92,  100
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종걸음_2:
        MOVE G6A,95,   71, 146,  97, 101
        MOVE G6D,106,  79, 146,  87,  100
        WAIT

        '전진종종걸음_3:
        MOVE G6A,103,  78, 130, 102, 101
        MOVE G6D, 97,  79, 144,  88, 99
        WAIT

        '*********************************

    NEXT I
    GOTO 전진종종2걸음_멈춤
전진종종2걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세



    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'보행순서=0
    'GOTO MAIN
    GOTO RX_EXIT

    '*****************************************************

고개90도오른쪽옆으로10:

    GOSUB 기본자세0
    SPEED 15
    MOVE G6D, 93,  90, 120, 103, 99, 100
    MOVE G6A,103,  76, 145,  91, 103, 100
    WAIT

    SPEED 15
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,89,  80, 140,  95, 102, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세0

    GOTO RX_EXIT

    '*************

고개90도왼쪽옆으로10:

    GOSUB 기본자세0
    SPEED 15
    MOVE G6A, 93,  90, 120, 103, 99, 100
    MOVE G6D,103,  76, 145,  91, 103, 100
    WAIT

    SPEED 15
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,89,  80, 140,  95, 102, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세0

    GOTO RX_EXIT

    '***************************************************************
전진종종고개90도3걸음:

    GOSUB 기본자세0
    GOSUB GYRO_OFF
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    MOVE G6A,97,  76, 145,  93, 100
    MOVE G6D,99,  77, 145,  93, 100
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 190
    WAIT

    '**********************
    FOR I = 0 TO 2
        '전진종종4걸음_1:
        MOVE G6A,96,  96, 120, 101, 102
        MOVE G6D,105, 79, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        '전진종종4걸음_2:
        MOVE G6A,95,  85, 130, 103, 103
        MOVE G6D,103,  79, 146,  89,  100
        WAIT

        '전진종종4걸음_3:
        MOVE G6A,103,  83, 130, 104,  100
        MOVE G6D, 99,  79, 146,  89, 100
        WAIT

        '*********************************

        '전진종종4걸음_4:
        MOVE G6D,95,  94, 122, 100, 102
        MOVE G6A,104,  80, 146,  92,  102
        MOVE G6C, 80,,,100
        MOVE G6B,120,,,,,100
        WAIT


        '전진종종4걸음_5:
        MOVE G6D,96,  87, 130, 103, 102
        MOVE G6A,104,  79, 146,  88,  100
        WAIT

        '전진종종4걸음_6:
        MOVE G6D,102,  84, 131, 104,  100
        MOVE G6A, 95,  77, 148,  88, 101
        WAIT

    NEXT I
    GOTO 전진종종고개90도3걸음_멈춤

전진종종고개90도3걸음_멈춤:
    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세0

    DELAY 2500

    GOSUB Leg_motor_mode1
    GOSUB GYRO_OFF'보행순서=0
    GOTO RX_EXIT    '***************************************************************
    
고개90도포맥스종종:
    '*************        ***************     멀쩡!       ***************
    DELAY 2500
    GOSUB 기본자세0
    GOSUB GYRO_OFF
    SPEED 12
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    MOVE G6A,97,  76, 145,  93, 100
    MOVE G6D,99,  77, 145,  93, 100
    MOVE G6B,100,  35,,,,100
    MOVE G6C,100,  35,, 100, 190
    WAIT
    GOTO 고개90도포맥스종종_1
    'IF 보행순서 = 0 THEN

고개90도포맥스종종_1:

    ''나무 - 99,,,,,102
    '4
    MOVE G6D,97,  76, 144,  96,  98
    MOVE G6A,104, 77, 146,  92,  102
    MOVE G6C,80
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,98,  76, 145,  98, 98
    MOVE G6A,104, 79, 146,  93,  102
    WAIT

    '6
    MOVE G6A,103,  80, 130, 102, 98
    MOVE G6D, 99,  79, 144,  88, 102
    WAIT
    'MOVE G6D, 100,  80, 141,  97, 102
    'MOVE G6A, 100,  73, 146,  98, 99
    'WAIT
    '--------------------------------------
    '1:
    MOVE G6A,97,  78, 142,  92, 100
    MOVE G6D,104, 77, 146,  87,  101
    MOVE G6C,80
    MOVE G6B,120
    WAIT

    '2:
    MOVE G6A,97,  70, 148,  93,  100
    MOVE G6D,104, 77, 146,  87,  101
    WAIT

    '3:
    MOVE G6D, 99,  73, 142, 103,  102
    MOVE G6A, 105,  77, 146,  94, 98
    WAIT
    '--------------------------------------
    '4
    MOVE G6D,97,  76, 144,  96,  98
    MOVE G6A,104, 77, 146,  92,  102
    MOVE G6C,80
    MOVE G6B,120
    WAIT

    '5:
    MOVE G6D,98,  76, 145,  98, 98
    MOVE G6A,104, 79, 146,  93,  102
    WAIT

    '6
    MOVE G6A,103,  80, 130, 102, 98
    MOVE G6D, 99,  79, 144,  88, 102
    WAIT
    '--------------------------------------

    GOTO 고개90도포맥스종종멈춤


고개90도포맥스종종멈춤:

    HIGHSPEED SETOFF
    'SPEED 15
    'GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세0
    GOTO RX_EXIT




MAIN:


    ERX 9600,A, MAIN



    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28,KEY29,KEY30,KEY31,KEY32,KEY33,KEY34,KEY35,KEY36,KEY37,KEY38,KEY39,KEY40,KEY41,KEY42,KEY43,KEY44,KEY45,KEY46,KEY47,KEY48, KEY49, KEY50, KEY51, KEY52, KEY53, KEY54, KEY55, KEY56, KEY57, KEY58, KEY59, KEY60, KEY61, KEY62, KEY63, KEY64, KEY65, KEY66
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

    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    SPEED 12
    MOVE G6A,100,  83, 137,  95, 100, 100
    MOVE G6D,100,  84, 137,  95, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 135, 100
    WAIT
    GOTO MAIN
KEY2:
    'GOSUB GYRO_INIT
    'GOSUB GYRO_ON
    'GOSUB GYRO_ST
    SPEED 12
    MOVE G6A,100,  83, 137,  95, 100, 100
    MOVE G6D,100,  84, 137,  95, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 190, 100
    WAIT
    GOTO MAIN
KEY3:
    GOTO 전진보행
    GOTO MAIN
KEY4: '기본걷기
    GOTO 고개90도전진보행
    GOTO MAIN
KEY5: '기본걷기
KEY6: '기본걷기
KEY7: '기본걷기
KEY8: '종종걸음
    GOTO 고개90도종종걸음3걸음
    'GOTO 초록색전진보행50
    GOTO MAIN
KEY9: '종종걸음
    GOTO 전진종종10걸음
    GOTO MAIN
KEY10: '종종걸음2
    GOTO 전진종종2걸음
    GOTO MAIN
KEY11: '종종걸음
    GOTO 전진종종비비기
    GOTO MAIN
KEY12: '종종걸음
    GOTO 전진종종고개90도3걸음
    GOTO MAIN
KEY13:
    GOTO 전진달리기최종
    GOTO MAIN
    '달리기
KEY14: '달리기
KEY15: '달리기
KEY16: '달리기
KEY17: '달리기
KEY18: '턴
    GOTO 오른쪽턴10
    GOTO MAIN
KEY19: '턴
    GOTO 오른쪽턴20
    GOTO MAIN
KEY20: '턴
    GOTO 오른쪽턴45
    GOTO MAIN
KEY21: '턴
    GOTO 왼쪽턴10
    GOTO MAIN
KEY22: '턴
    GOTO 왼쪽턴20
    GOTO MAIN
KEY23: '
    GOTO 왼쪽턴45
    GOTO MAIN
KEY24: '옆으로가기
    GOTO 오른쪽옆으로20
    GOTO MAIN	
KEY25: '옆으로가기
    GOTO 오른쪽옆으로70
    GOTO MAIN
KEY26: '옆으로가기
    GOTO 왼쪽옆으로20
    GOTO MAIN
KEY27: '옆으로가기
    GOTO 왼쪽옆으로70
    GOTO MAIN
KEY28: '고개90도턴
    GOTO 고개90도오른쪽턴10
    GOTO MAIN
KEY29: '고개90도턴
    GOTO 고개90도오른쪽턴20
    GOTO MAIN
KEY30: '고개90도턴
    GOTO 고개90도오른쪽턴45
    GOTO MAIN
KEY31: '고개90도턴
    GOTO 고개90도왼쪽턴10
    GOTO MAIN
KEY32: '고개90도턴
    GOTO 고개90도왼쪽턴20
    GOTO MAIN
KEY33: '고개90도옆으로가기
    GOTO 고개90도왼쪽턴45
    GOTO MAIN
KEY34: '고개90도옆으로가기
    GOTO 고개90도오른쪽옆으로20
    GOTO MAIN
KEY35: '고개90도옆으로가기
    GOTO 고개90도오른쪽옆으로70
    GOTO MAIN
KEY36: '고개90도옆으로가기
    GOTO 고개90도왼쪽옆으로20
    GOTO MAIN
KEY37: '고개90도옆으로가기
    GOTO 고개90도왼쪽옆으로70
    GOTO MAIN
KEY38: '빨간색장애물앞구르기로올라가기

    GOTO 앞으로덤블링
    GOTO MAIN
KEY39:

    GOSUB 외각선자세
    GOTO MAIN

KEY40: '빨간색장애물앞구르기로내려가기

    GOTO 앞으로덤블링2
    GOTO MAIN

KEY41:

    GOTO 허들넘기
    GOTO MAIN
KEY42:

    GOTO 계단오른발오르기2cm
    GOTO MAIN
KEY43:

    GOTO 계단왼발내리기2cm
    GOTO MAIN
KEY44:

    GOTO 왼발공차기
    GOTO MAIN
KEY45: '함정장애물올라가기
KEY46: '함정장애물내려가기
KEY47:

    GOTO 고개90도오른쪽옆으로10
    GOTO MAIN
KEY48:

    GOTO 고개90도왼쪽옆으로10
    GOTO MAIN
KEY49:

    GOSUB GYRO_INIT
    GOSUB GYRO_ON
    GOSUB GYRO_ST

    MOVE G6A,100,  83, 137,  95, 100, 100
    MOVE G6D,100,  84, 137,  95, 100, 100
    MOVE G6B,100,  28,  81, 100, 100, 100
    MOVE G6C,100,  32,  80, 100, 75, 100
    WAIT

    GOTO MAIN

KEY50:
    GOTO 내려가기
    GOTO MAIN
KEY51:
    GOTO 앞으로덤블링3
    GOTO MAIN
KEY52:
    GOTO 왼쪽옆으로10
    GOTO MAIN
KEY53:
    GOTO 오른쪽옆으로10
    GOTO MAIN
KEY54:
    GOTO 전진보행4걸음
    GOTO MAIN
KEY55:
    GOTO 외각선왼쪽옆으로70
    GOTO MAIN
KEY56:
    GOTO 외각선오른쪽옆으로70
    GOTO MAIN
KEY57:
    GOTO 외각선왼쪽턴10
    GOTO MAIN
KEY58:
    GOTO 외각선왼쪽턴20
    GOTO MAIN
KEY59:
    GOTO 외각선오른쪽턴10
    GOTO MAIN
KEY60:
    GOTO 외각선오른쪽턴20
    GOTO MAIN
KEY61:
    '골프공자세:
    GOSUB GYRO_OFF
    MOVE G6A,101,  83, 137,  94, 100, 100
    MOVE G6D,101,  84, 137,  94, 100, 100
    MOVE G6B,100,  28,  81, 100	, 100, 100
    MOVE G6C,100 ,  32,  80, 100, 145, 100
    WAIT
    GOTO MAIN
KEY62:
    GOTO 골프공왼쪽옆으로20
    GOTO MAIN
KEY63:
    GOTO 골프공오른쪽옆으로20
    GOTO MAIN
KEY64:
    GOTO 고개45도종종걸음3걸음
    GOTO MAIN
KEY65:
    GOTO 고개90도나무종종
    GOTO MAIN
KEY66:
    GOTO 고개90도포맥스종종
    GOTO MAIN



    '*******************************************************

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
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정

    GOTO 내려가기_멈춤

내려가기_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT