--����ģ��ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--����ģ��Ľӿ����
ENTITY waitGame IS
	PORT(
		CLK_WT:IN STD_LOGIC;--ϵͳʱ��
		EN_WT:IN STD_LOGIC;--ʹ���ź�
		RST_WT:IN STD_LOGIC;--�����ź�
		BTN_START:IN STD_LOGIC;--��ӦBTN0���µ�״̬����������״̬
		CMP_WT:OUT STD_LOGIC:='0'--������������ɱ��
	);
END ENTITY;

ARCHITECTURE waiting OF waitGame IS
BEGIN
	
	PROCESS(CLK_WT)
	BEGIN
		IF CLK_WT'EVENT AND CLK_WT='1' THEN
			IF RST_WT='0' THEN--���뿪�عر�ʱ��������ģ�����ɱ������
				CMP_WT<='0';
			ELSIF EN_WT='1' AND BTN_START='1' THEN--���뿪�ش�ʱ����ӦBTN0�İ�����Ϣ
				CMP_WT<='1';--BTN0����ʱ����������������ɱ����1�����������������Ӷ�������������
			END IF;
		END IF;
	END PROCESS;
	
END waiting;