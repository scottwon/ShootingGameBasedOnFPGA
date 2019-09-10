--��Ϸ������ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--��Ϸ������Ľӿ����
ENTITY mainGame IS
	PORT(
		CLK_GAME:IN STD_LOGIC;--ϵͳʱ��
		EN_GAME:IN STD_LOGIC;--ʹ���ź�
		RST_GAME:IN STD_LOGIC;--�����ź�
		RESUME_GAME:IN STD_LOGIC;--��Ϸ���¿�ʼ
		BTN_SHOOT:IN STD_LOGIC;--�������
		BTN_SPEED_DOWN:IN STD_LOGIC;--�м��ٰ���
		BTN_SPEED_UP:IN STD_LOGIC;--�м��ٰ���
		CMP_GAME:OUT STD_LOGIC:='0';--��Ϸ�����������ɱ��
		STATE_GAME_TARGET:OUT INTEGER RANGE 0 TO 9:=0;--�е�λ����Ϣ
		STATE_GAME_BULLET:OUT INTEGER RANGE 0 TO 6:=0;--�ӵ���λ����Ϣ
		STATE_GAME_TIME_LEFT:OUT INTEGER RANGE 0 TO 40:=40;--����ʱ��Ϣ
		STATE_GAME_SCORE:OUT INTEGER RANGE 0 TO 19:=0;--������Ϣ
		STATE_GAME_SHOOT:OUT STD_LOGIC:='0';--�ӵ��Ƿ����ڷ���
		FLG_BULLET_MISS:OUT STD_LOGIC:='0';--δ����
		FLG_BULLET_GET:OUT STD_LOGIC:='0'--����
	);
END ENTITY;

ARCHITECTURE game OF mainGame IS

	SIGNAL clkSecondsCnt:INTEGER RANGE 0 TO 49999999:=0;--����ʱ��Ƶ������
	SIGNAL clkTargetCnt:INTEGER RANGE 0 TO 49999999:=0;--���ư��ƶ��ķ�Ƶ������
	SIGNAL clkBulletCnt:INTEGER RANGE 0 TO 4999999:=0;--�����ӵ����е�0.1���Ƶ������
	SIGNAL clkButtonCheckCnt:INTEGER RANGE 0 TO 999999:=0;--����ÿ��20�������һ�ΰ������
	SIGNAL targetSpeed:INTEGER RANGE 0 TO 49999999:=4999999;--���ư��ƶ��ٶȵı������������ƶ���Ƶ���ķ�Ƶ��ֵ
	SIGNAL targetPosition:INTEGER RANGE 0 TO 9:=0;--�е�λ����Ϣ
	SIGNAL bulletPosition:INTEGER RANGE 0 TO 6:=0;--�ӵ���λ����Ϣ
	SIGNAL timeLeft:INTEGER RANGE 0 TO 40:=40;--����ʱ��Ϣ
	SIGNAL score:INTEGER RANGE 0 TO 19:=0;--������Ϣ
	SIGNAL flagBullet:STD_LOGIC:='0';--�ӵ��Ƿ��ڷ���״̬

BEGIN
	
	PROCESS(CLK_GAME)
	BEGIN
		IF CLK_GAME'EVENT AND CLK_GAME='1' THEN
			IF RST_GAME='0' THEN
				CMP_GAME<='0';
				clkSecondsCnt<=0;
				clkTargetCnt<=0;
				clkBulletCnt<=0;
				clkButtonCheckCnt<=0;
				targetSpeed<=4999999;
				targetPosition<=0;
				bulletPosition<=0;
				timeLeft<=40;
				score<=0;
				flagBullet<='0';
			ELSIF RESUME_GAME='1' THEN
				CMP_GAME<='0';
				clkSecondsCnt<=0;
				clkTargetCnt<=0;
				clkBulletCnt<=0;
				clkButtonCheckCnt<=0;
				targetSpeed<=4999999;
				targetPosition<=0;
				bulletPosition<=0;
				timeLeft<=40;
				score<=0;
				flagBullet<='0';
			--���뿪�عرջ���BTN0����ʱ�����ڲ��ź����ã���ɱ��CMP_GAME����
			ELSIF EN_GAME='0' THEN
				clkSecondsCnt<=0;
				clkTargetCnt<=0;
				clkBulletCnt<=0;
				clkButtonCheckCnt<=0;
				STATE_GAME_TARGET<=targetPosition;
				STATE_GAME_BULLET<=bulletPosition;
				STATE_GAME_TIME_LEFT<=timeLeft;
				STATE_GAME_SCORE<=score;
			--��������Ϸ�����У������Ϸ������ģ��ʧ�ܣ�˵���ý�����δ��ʼ�����Ѿ���������ʱ�����ڲ��źţ������ı���ɱ��CMP_GAME
			ELSE
				IF clkSecondsCnt=49999999 THEN--����ʱ
					clkSecondsCnt<=0;
					IF timeLeft>0 THEN
						timeLeft<=timeLeft-1;
					END IF;
				ELSE
					clkSecondsCnt<=clkSecondsCnt+1;
				END IF;
				IF clkTargetCnt=targetSpeed THEN--���ưе�λ���ƶ�����targetSpeed�����е��ƶ�Ƶ�ʣ�Ҳ���ǰе��ƶ��ٶ�
					clkTargetCnt<=0;
					IF targetPosition=9 THEN--��λ�õ�ѭ������
						targetPosition<=0;
					ELSE
						targetPosition<=targetPosition+1;
					END IF;
				ELSE
					clkTargetCnt<=clkTargetCnt+1;
				END IF;
				IF flagBullet='1' THEN--���ӵ����ڷ���״̬ʱ
					IF clkBulletCnt=4999999 THEN--ÿ��0.1�����һ���ӵ�λ��
						clkBulletCnt<=0;
						IF bulletPosition<5 THEN
							bulletPosition<=bulletPosition+1;
						ELSIF bulletPosition=5 THEN
							bulletPosition<=6;--�ӵ��������ʱ
							IF targetPosition=3 OR targetPosition=5 THEN--����ӵ����аб�Ե
								score<=score+2;--��2��
								FLG_BULLET_GET<='1';--���б���ź���1
								FLG_BULLET_MISS<='0';
							ELSIF targetPosition=4 THEN--����ӵ����а�����
								score<=score+3;--��3��
								FLG_BULLET_GET<='1';--���б���ź���1
								FLG_BULLET_MISS<='0';
							ELSE--����ӵ�δ����
								FLG_BULLET_GET<='0';
								FLG_BULLET_MISS<='1';--δ���б���ź���1
							END IF;
						ELSE--�ӵ�������ߺ��پ���0.1�룬�ӵ�λ�����㣬����flagBulletΪ0���������ӵ��Ļ��ƣ�����������ܰ���BTN1���ź�
							flagBullet<='0';
							bulletPosition<=0;
						END IF;
					ELSE
						clkBulletCnt<=clkBulletCnt+1;
					END IF;
				ELSE--�ӵ�δ��������ӵ����н����󣬽������ӵ����еķ�Ƶ���������㣬���ơ����С��롰δ���С���Ч���ź�����
					clkBulletCnt<=0;
					FLG_BULLET_GET<='0';
					FLG_BULLET_MISS<='0';
				END IF;
				IF clkButtonCheckCnt=999999 THEN--ÿ��20������һ��BTN1��BTN6��BTN7�İ�����Ϣ
--һ����ԣ�����������ʱ����20�������ڡ�ͨ��buttonProcessorģ�飬ÿ�ΰ���������źŶ���ת��Ϊʱ��20����ĸߵ�ƽ�����źš������ÿ��20������һ�ΰ�����Ϣ��ǡ�ñ�֤��ÿ�ΰ�����Ϣ������⵽����ÿ��������Ϣֻ����⵽һ�Σ���ʹﵽ�˰���������Ŀ��
					clkButtonCheckCnt<=0;
					IF BTN_SPEED_UP='1' THEN--����BTN7ʱ���޸�targetSpeedʹ�ð��ƶ�Ƶ�����ߣ����м���
						IF targetSpeed>100000 THEN
							targetSpeed<=targetSpeed-100000;
						END IF;
					ELSIF BTN_SPEED_DOWN='1' THEN--����BTN6ʱ�����ƶ�Ƶ�ʽ��ͣ����м���
						IF targetSpeed<24899999 THEN
							targetSpeed<=targetSpeed+100000;
						END IF;
					ELSIF flagBullet='0' AND BTN_SHOOT='1' THEN--������û���ӵ�ʱ����ӦBTN1���������ӵ�����״̬���Ϊ1����ʾ�ӵ����ڷ���
						flagBullet<='1';
					END IF;
				ELSE
					clkButtonCheckCnt<=clkButtonCheckCnt+1;
				END IF;
				IF timeLeft=0 OR score>=15 THEN--�ﵽ15�ֻ��߳���ʱ��ʱ������ɱ�־��1��������Ϸ���������
					CMP_GAME<='1';
				END IF;
				--���ڲ��źŸ�ֵ���ӿ�
				STATE_GAME_TARGET<=targetPosition;
				STATE_GAME_BULLET<=bulletPosition;
				STATE_GAME_TIME_LEFT<=timeLeft;
				STATE_GAME_SCORE<=score;
				STATE_GAME_SHOOT<=flagBullet;
			END IF;
		END IF;
	END PROCESS;
	
END game;