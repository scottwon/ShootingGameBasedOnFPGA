--�Լ�ģ��ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--�Լ�ģ��Ľӿ����
ENTITY autoCheck IS
	PORT(
		CLK_CHK:IN STD_LOGIC;--ϵͳʱ��
		EN_CHK:IN STD_LOGIC;--ʹ���ź�
		RST_CHK:IN STD_LOGIC;--�����ź�
		CMP_CHK:OUT STD_LOGIC:='0';--���Լ��Ƿ���ɵ���Ϣ������������
		STATE_CHK:OUT INTEGER RANGE 0 TO 7:=0;--���Ƶ���������ܵ�ɨ��
		STATE_CHK_SCAN:OUT INTEGER RANGE 0 TO 2:=0--ɨ��������������ж��Լ��Ƿ����
	);
END ENTITY;

ARCHITECTURE check OF autoCheck IS
	
	SIGNAL clkCnt:INTEGER RANGE 0 TO 9999999;--5Hz��Ƶ������
	SIGNAL rowCnt:INTEGER RANGE 0 TO 7;--���Ƶ�����ɨ���������ɨ��
	SIGNAL scanCnt:INTEGER RANGE 0 TO 3;--ɨ������ļ�����
	
BEGIN
	
	PROCESS(CLK_CHK)
	BEGIN
		IF CLK_CHK'EVENT AND CLK_CHK='1' THEN
			IF RST_CHK='0' THEN--������뿪�عرգ����Լ�ģ������
				CMP_CHK<='0';--���Լ���ɱ�־��Ϣ���㣬��������ͷ��ʼִ��
			ELSIF RST_CHK='1' AND scanCnt=3 THEN--������뿪�ش򿪣���ɨ������ﵽ3�Σ�˵���Լ����
				CMP_CHK<='1';
			END IF;
			IF EN_CHK='0' THEN--�Լ�ģ��ʧ�ܺ󣬽��ڲ��ź�����Ϊ0
				clkCnt<=0;
				rowCnt<=0;
				scanCnt<=0;
			--���ϣ��Լ��������ʱ���Լ�ģ��ʧ�ܵ������ã��Լ�ģ���ڲ��ź�����Ϊ0������ɱ��CMP_CHK����Ϊ1��
			--��ʱ�������ж��������������ʾ�Ⱥ����ģ������ʹ��ִ��
			--���뿪�عرգ���Ϸ���̱����ʱ���Լ�ģ��ʧ�������á��Լ�ģ���ڲ��ź�����Ϊ0����ɱ��CMP_CHKҲ����
			--�ٴδ򿪿���ʱ������CMP_CHK���㣬�������ж����Լ�ģ��ʹ�ܡ�
			--�����Լ�ģ���ڲ��ź��Ѿ�����Ϊ0������Լ�ģ��������¿�ʼɨ�����
			ELSE
				IF clkCnt=9999999 THEN--5Hz��Ƶ������ѭ������
					clkCnt<=0;
					IF rowCnt=7 THEN--ÿ��0.2�룬����rowCnt��rowCnt��0��7ѭ����������ʾ��ǰɨ�������һ��
						rowCnt<=0;
						IF scanCnt<3 THEN--rowCntÿ���һ��ѭ����������ɨ�����scanCnt��һ
							scanCnt<=scanCnt+1;
						END IF;
					ELSE
						rowCnt<=rowCnt+1;
					END IF;
				ELSE
					clkCnt<=clkCnt+1;
				END IF;
				STATE_CHK<=rowCnt;--��rowCnt��scanCnt�����������ʾģ������Чģ��
				IF scanCnt<3 THEN
					STATE_CHK_SCAN<=scanCnt;
				END IF;
			END IF;
		END IF;
	END PROCESS;
		
END check;