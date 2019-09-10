--������Ϣ����ģ��ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--������Ϣ����ģ��Ľӿ����
ENTITY buttonProcessor IS
	PORT(
		CLK_BTNP:IN STD_LOGIC;--ϵͳʱ��
		BTN0_IN:IN STD_LOGIC;--BTN0�İ�����Ϣ
		BTN1_IN:IN STD_LOGIC;--BTN1�İ�����Ϣ
		BTN6_IN:IN STD_LOGIC;--BTN6�İ�����Ϣ
		BTN7_IN:IN STD_LOGIC;--BTN7�İ�����Ϣ
		BTN_RESUME:OUT STD_LOGIC;--������BTN0�İ�����Ϣ
		BTN_SHOOT:OUT STD_LOGIC;--������BTN1�İ�����Ϣ
		BTN_SPEED_DOWN:OUT STD_LOGIC;--������BTN6�İ�����Ϣ
		BTN_SPEED_UP:OUT STD_LOGIC--������BTN7�İ�����Ϣ
	);
END ENTITY;

ARCHITECTURE buttonProcess OF buttonProcessor IS
	SIGNAL clkCnt:INTEGER RANGE 0 TO 999999:=0;
BEGIN
	
	PROCESS(CLK_BTNP)
	BEGIN
		IF CLK_BTNP'EVENT AND CLK_BTNP='1' THEN
			IF clkCnt=999999 THEN--ÿ��20���룬���һ�ΰ�����Ϣ��������ÿ�ΰ�����Ϣ���������ʱ��Ϊ20����ĸߵ�ƽ�����ź�
				clkCnt<=0;
				BTN_RESUME<=BTN0_IN;
				BTN_SHOOT<=BTN1_IN;
				BTN_SPEED_DOWN<=BTN6_IN;
				BTN_SPEED_UP<=BTN7_IN;
			ELSE
				clkCnt<=clkCnt+1;
			END IF;
		END IF;
	END PROCESS;
	
END buttonProcess;