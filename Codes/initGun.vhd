--������ʾģ��ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--������ʾģ��Ľӿ����
ENTITY initGun IS
	PORT(
		CLK_INIT:IN STD_LOGIC;--ϵͳʱ��
		EN_INIT:IN STD_LOGIC;--ʹ���ź�
		RST_INIT:IN STD_LOGIC;--�����ź�
		RESUME_INIT:IN STD_LOGIC;--��Ϸ���¿�ʼ�ź�
		CMP_INIT:OUT STD_LOGIC:='0';--������ʾģ����ɱ��
		STATE_INIT:OUT INTEGER RANGE 0 TO 7:=0--������ʾģ��ĵ�ǰ����״̬�����Ƶ���ѡͨ�źŵ�ռ�ձ�
	);
END ENTITY;

ARCHITECTURE initializer OF initGun IS
	
	SIGNAL clkCnt:INTEGER RANGE 0 TO 18749999;
	--��3��ʱ��ֳ�8���׶Σ�ÿ��ʱ�����Ȳ�ͬ��Ϊ����Ʒ�Ƶ������clkCnt
	SIGNAL stateCnt:INTEGER RANGE 0 TO 7;
	--��¼������ʾģ��ĵ�ǰ״̬
	
BEGIN

	PROCESS(CLK_INIT)
	BEGIN
		IF CLK_INIT'EVENT AND CLK_INIT='1' THEN
			IF RST_INIT='0' THEN
				CMP_INIT<='0';
				clkCnt<=0;
				stateCnt<=0;
				STATE_INIT<=stateCnt;
			ELSIF RESUME_INIT='1' THEN
				CMP_INIT<='0';
				clkCnt<=0;
				stateCnt<=0;
				STATE_INIT<=stateCnt;
			--���뿪�عرգ�����BTN0����ʱ�����ý�����ʾģ�飬���ڲ��ź����㣬����ɱ��CMP_INIT����
			ELSIF EN_INIT='0' THEN
				clkCnt<=0;
				stateCnt<=0;
				STATE_INIT<=stateCnt;
			--��������Ϸ�����У����������ʾģ��ʧ�ܣ�˵��������ʾ����δ��ʼ�����Ѿ���������ʱ��������ʾģ����ڲ��ź�����Ϊ0��ͬʱ������ɱ��CMP_INIT��ֵ������������
			ELSIF EN_INIT='1' THEN--������ʾ��������ִ��ʱ
				IF clkCnt=18749999 THEN--ÿ��0.375��
					clkCnt<=0;
					IF stateCnt<7 THEN--���½�����ʾģ����ڲ�״̬
						stateCnt<=stateCnt+1;
					ELSE
						CMP_INIT<='1';
					END IF;
				ELSE
					clkCnt<=clkCnt+1;
				END IF;
				STATE_INIT<=stateCnt;--���ڲ�״̬��������Ƶ���ɨ��ռ�ձ�
			END IF;		
		END IF;
	END PROCESS;

END initializer;