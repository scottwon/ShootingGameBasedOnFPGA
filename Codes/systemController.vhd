--�������ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--�������Ľӿ����
ENTITY systemController IS
	PORT(
		CLK_SYS:IN STD_LOGIC;--ϵͳʱ��
		SW_PWR:IN STD_LOGIC;--���뿪��
		BTN_RESUME:IN STD_LOGIC;--BTN0�Ƿ���

		--���ո�ģ������Ƿ���ɵķ�����Ϣ���жϵ�ǰӦ��ʹ���ĸ�ģ��
		CMP_CHK:IN STD_LOGIC;
		CMP_WT:IN STD_LOGIC;
		CMP_INIT:IN STD_LOGIC;
		CMP_GAME:IN STD_LOGIC;

		--��ģ���������еı�־�źţ�����ʹ�ܸ�ģ��
		FLG_CHK:OUT STD_LOGIC:='0';
		FLG_WT:OUT STD_LOGIC:='0';
		FLG_INIT:OUT STD_LOGIC:='0';
		FLG_GAME:OUT STD_LOGIC:='0';
		FLG_RESULT:OUT STD_LOGIC:='0';

		--�����뿪�ص�״̬��BTN0�İ���״̬��������ڿ��Ƹ�ģ���Ƿ�����
		FLG_PWR:OUT STD_LOGIC:='0';
		FLG_RESUME:OUT STD_LOGIC:='0'
	);
END ENTITY;

ARCHITECTURE systemControl OF systemController IS	
BEGIN

	PROCESS(CLK_SYS)--��Ӧ���뿪�ص�״̬��BTN0��״̬������������Ϸ����ģ�飻ͨ������Ϸ����ģ�鷴����CMP�źţ��жϵ�ǰ��Ϸ���̣����Ƹ���Ϸ����ģ�鰴��˳��ʹ����ʧ��
	BEGIN
		IF SW_PWR='0' THEN--���뿪�عر�ʱ
			FLG_CHK<='0';
			FLG_WT<='0';
			FLG_INIT<='0';
			FLG_GAME<='0';
			FLG_RESULT<='0';--������ģ��ʧ��
			FLG_PWR<='0';--������ģ�����õ���ʼ״̬
			FLG_RESUME<='0';
		ELSIF SW_PWR='1' AND CMP_WT='1' AND BTN_RESUME='1' THEN
		--������뿪�ش򿪣�����Ϸ���ڽ�����ʾ����Ϸ�����桢�����ʾ��������֮һʱ���ɿ�������ӦBTN0�İ�����Ϣ
			FLG_GAME<='0';
			FLG_RESULT<='0';--����BTN0ʱ������Ϸ�����桢�����ʾ����ģ��ʧ��
			FLG_PWR<='1';
			FLG_RESUME<='1';--ͬʱ�����ʾ����Ϸ�����桢�����ʾ����ģ�����õ���ʼ״̬
		ELSE--������뿪�ش򿪣���û��BTN0���ڷ��������¿�ʼ��Ϸ��������
			--���ݸ�ģ�鷴������Ϣ�ж���Ϸ����
			IF CMP_CHK='0' THEN--�Լ�δ���ʱ���Լ�ģ��ʹ�ܣ�����ģ��ʧ��
				FLG_CHK<='1';
				FLG_WT<='0';
				FLG_INIT<='0';
				FLG_GAME<='0';
				FLG_RESULT<='0';
				FLG_PWR<='1';
				FLG_RESUME<='0';
			ELSIF CMP_WT='0' THEN--�Լ���ɶ�����δ���ʱ������ģ��ʹ�ܣ�����ģ��ʧ��
				FLG_CHK<='0';
				FLG_WT<='1';
				FLG_INIT<='0';
				FLG_GAME<='0';
				FLG_RESULT<='0';
				FLG_PWR<='1';
				FLG_RESUME<='0';
			ELSIF CMP_INIT='0' THEN--������ɶ�������ʾδ���ʱ��������ʾģ��ʹ�ܣ�����ģ��ʧ��
				FLG_CHK<='0';
				FLG_WT<='0';
				FLG_INIT<='1';
				FLG_GAME<='0';
				FLG_RESULT<='0';
				FLG_PWR<='1';
				FLG_RESUME<='0';
			ELSIF CMP_GAME='0' THEN--������ʾ��ɶ���Ϸ������δ���ʱ����Ϸ������ģ��ʹ�ܣ�����ģ��ʧ��
				FLG_CHK<='0';
				FLG_WT<='0';
				FLG_INIT<='0';
				FLG_GAME<='1';
				FLG_RESULT<='0';
				FLG_PWR<='1';
				FLG_RESUME<='0';
			ELSE--���򣬽����ʾģ��ʹ�ܣ�����ģ��ʧ��
				FLG_CHK<='0';
				FLG_WT<='0';
				FLG_INIT<='0';
				FLG_GAME<='0';
				FLG_RESULT<='1';
				FLG_PWR<='1';
				FLG_RESUME<='0';
			END IF;
		END IF;
	END PROCESS;
	
END systemControl;