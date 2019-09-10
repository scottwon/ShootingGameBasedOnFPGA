--�����ʾģ��ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--�����ʾģ��Ľӿ����
ENTITY result IS
	PORT(
		CLK_RESULT:IN STD_LOGIC;--ϵͳʱ��
		EN_RESULT:IN STD_LOGIC;--ʹ���ź�
		STATE_GAME_TIME_LEFT:IN INTEGER RANGE 0 TO 40;--����Ϸ������ģ����յ���ʱ��Ϣ
		STATE_GAME_SCORE:IN INTEGER RANGE 0 TO 19;--����Ϸ������ģ����շ�����Ϣ
		FLG_WIN:OUT STD_LOGIC;--�ж�ʤ�������Ƶ�����ʾ
		RESULT_TIME_LEFT:OUT INTEGER RANGE 0 TO 40;--�����Ϸ����ʱ��ʣ��ʱ�䣬�����������ʾ
		RESULT_SCORE:OUT INTEGER RANGE 0 TO 19--�����Ϸ����ʱ�ĵ÷���Ϣ�������������ʾ
	);
END ENTITY;

ARCHITECTURE resultScreen OF result IS

BEGIN
	
	PROCESS(CLK_RESULT)
	BEGIN
		IF CLK_RESULT'EVENT AND CLK_RESULT='1' THEN
			IF EN_RESULT='1' THEN
				IF STATE_GAME_SCORE>=15 THEN--���ݵ÷���Ϣ�ж���Ӯ
					FLG_WIN<='1';
				ELSE
					FLG_WIN<='0';
				END IF;
				RESULT_TIME_LEFT<=STATE_GAME_TIME_LEFT;--������Ϸ������ģ���õķ�����ʱ����Ϣ���
				RESULT_SCORE<=STATE_GAME_SCORE;
			END IF;
		END IF;
	END PROCESS;

END resultScreen;