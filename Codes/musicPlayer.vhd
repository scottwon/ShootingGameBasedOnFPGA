--��Ч����ģ��ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--��Ч����ģ��Ľӿ����
ENTITY musicPlayer IS
	PORT(
		CLK_BEEP:IN STD_LOGIC;--ϵͳʱ��
		FLG_PWR:IN STD_LOGIC;--���뿪��״̬
		FLG_RESUME:IN STD_LOGIC;--�Ƿ����¿�ʼ��Ϸ
		FLG_CHK:IN STD_LOGIC;
		STATE_CHK:IN INTEGER RANGE 0 TO 7;
		STATE_CHK_SCAN:IN INTEGER RANGE 0 TO 2;
		FLG_GAME:IN STD_LOGIC;
		FLG_BULLET_MISS:IN STD_LOGIC;
		FLG_BULLET_GET:IN STD_LOGIC;
		FLG_RESULT:IN STD_LOGIC;
		FLG_WIN:IN STD_LOGIC;
		--�ж���Ϸ�����ĸ��׶Σ�״̬�������
		TONE_OUT:OUT STD_LOGIC--��������ź�
	);
END musicPlayer;

ARCHITECTURE player OF musicPlayer IS
	
	SIGNAL toneFreq:INTEGER RANGE 0 TO 100000;
	SIGNAL toneCnt:INTEGER RANGE 0 TO 100000:=0;
	SIGNAL stateChk:INTEGER RANGE 0 TO 23;--�Լ�����״̬
	SIGNAL stateMiss:INTEGER RANGE 0 TO 4:=0;--δ������Ч״̬
	SIGNAL stateGet:INTEGER RANGE 0 TO 4:=0;--������Ч״̬
	SIGNAL soundCnt:INTEGER RANGE 0 TO 3124999:=0;--ʮ����֮һ������Ƶ������
	SIGNAL musicCnt:INTEGER RANGE 0 TO 12499999:=0;--�ķ�֮һ������Ƶ������
	SIGNAL gameMusicCnt:INTEGER RANGE 0 TO 23:=0;--��Ϸ����״̬
	SIGNAL winMusicCnt:INTEGER RANGE 0 TO 3:=0;--ʤ����Ч״̬
	SIGNAL loseMusicCnt:INTEGER RANGE 0 TO 3:=0;--ʧ����Ч״̬
	SIGNAL beep:STD_LOGIC;--�������
		
BEGIN
	
	PROCESS(CLK_BEEP)
	BEGIN
		IF CLK_BEEP'EVENT AND CLK_BEEP='1' THEN
			IF FLG_PWR='0' OR FLG_RESUME='1' THEN--�رղ��뿪�ػ�BTN0����ʱ��״̬���㣬�����ر�
				toneCnt<=0;
				stateMiss<=0;
				stateGet<=0;
				soundCnt<=0;
				musicCnt<=0;
				gameMusicCnt<=0;
				winMusicCnt<=0;
				loseMusicCnt<=0;
				beep<='0';
			ELSIF FLG_CHK='1' THEN--�Լ�ʱ�������Լ�ģ������״̬�����������������������������
				stateChk<=STATE_CHK_SCAN*8+STATE_CHK;
				CASE stateChk IS
					WHEN 0=>toneFreq<=95566;
					WHEN 1=>toneFreq<=85121;
					WHEN 2=>toneFreq<=75850;
					WHEN 3=>toneFreq<=71592;
					WHEN 4=>toneFreq<=63776;
					WHEN 5=>toneFreq<=56818;
					WHEN 6=>toneFreq<=50618;
					WHEN 7=>toneFreq<=47774;
					WHEN 8=>toneFreq<=47774;
					WHEN 9=>toneFreq<=42568;
					WHEN 10=>toneFreq<=37919;
					WHEN 11=>toneFreq<=35791;
					WHEN 12=>toneFreq<=31888;
					WHEN 13=>toneFreq<=28409;
					WHEN 14=>toneFreq<=25309;
					WHEN 15=>toneFreq<=23912;
					WHEN 16=>toneFreq<=23912;
					WHEN 17=>toneFreq<=21282;
					WHEN 18=>toneFreq<=18961;
					WHEN 19=>toneFreq<=17971;
					WHEN 20=>toneFreq<=15944;
					WHEN 21=>toneFreq<=14205;
					WHEN 22=>toneFreq<=12655;
					WHEN 23=>toneFreq<=11956;
				END CASE;
				IF toneCnt>=toneFreq THEN--�趨��������ƽ��ת��Ƶ�ʣ�����ʵ����Ӧ������
					toneCnt<=0;
					beep<=NOT beep;
				ELSE
					toneCnt<=toneCnt+1;
				END IF;
			ELSIF FLG_GAME='1' THEN--����Ϸ������
				IF FLG_BULLET_MISS='0' AND FLG_BULLET_GET='0' AND stateMiss=0 AND stateGet=0 THEN--������Ϸ��������
					IF musicCnt=12499999 THEN--ÿ�����������ķ�֮һ����
						musicCnt<=0;
						IF gameMusicCnt=22 THEN
							gameMusicCnt<=0;
						ELSE
							gameMusicCnt<=gameMusicCnt+1;
						END IF;
					ELSE
						musicCnt<=musicCnt+1;
					END IF;
					CASE gameMusicCnt IS
						WHEN 0=>toneFreq<=47774;
						WHEN 1=>toneFreq<=63776;
						WHEN 2=>toneFreq<=47774;
						WHEN 3=>toneFreq<=37919;
						WHEN 4=>toneFreq<=47774;
						WHEN 5=>toneFreq<=37919;
						WHEN 6=>toneFreq<=31888;
						WHEN 7=>toneFreq<=23912;
						WHEN 8=>toneFreq<=25309;
						WHEN 9=>toneFreq<=28409;
						WHEN 10=>toneFreq<=31888;
						WHEN 11=>toneFreq<=31888;
						WHEN 12=>toneFreq<=35791;
						WHEN 13=>toneFreq<=37919;
						WHEN 14=>toneFreq<=47774;
						WHEN 15=>toneFreq<=63776;
						WHEN 16=>toneFreq<=56818;
						WHEN 17=>toneFreq<=47774;
						WHEN 18=>toneFreq<=35791;
						WHEN 19=>toneFreq<=37919;
						WHEN 20=>toneFreq<=47774;
						WHEN 21=>toneFreq<=28409;
						WHEN 22=>toneFreq<=31888;
						WHEN 23=>toneFreq<=0;
					END CASE;
					IF gameMusicCnt<23 THEN
						IF toneCnt>=toneFreq THEN
							toneCnt<=0;
							beep<=NOT beep;
						ELSE
							toneCnt<=toneCnt+1;
						END IF;
					ELSE
						beep<='0';
					END IF;
				ELSIF FLG_BULLET_MISS='1' OR stateMiss>0 THEN
				--�ӵ����������δ����ʱ����Ϸ������ģ�齫FLG_BULLET_MISS��1����ʱstateMiss��ֵΪ0��δ������Ч��ʼ���ţ�
				--����Ϸ������ģ���У�0.1���FLG_BULLET_MISS�����㣬��ʱδ������Ч��δ������ϣ�����stateMissֵ����0�����δ������Ч�������ţ�
				--δ������Ч������Ϻ�stateMiss�����㡣δ������Ч�Ĳ���ʱ��Ϊ0.25�룬С����һ���ӵ��ӷ��䵽���������ߵ�ʱ��0.6�룬���stateMiss������ʱ��
				--FLG_BULLET_MISS��FLG_BULLET_GET��Ϊ0����ʱδ������Ч���Ž�������Ϸ������Ч�Ӷϵ㴦��ʼ��������
					IF soundCnt=3124999 THEN
						soundCnt<=0;
						IF stateMiss=4 THEN
							stateMiss<=0;
						ELSE
							stateMiss<=stateMiss+1;
						END IF;
					ELSE
						soundCnt<=soundCnt+1;
					END IF;
					CASE stateMiss IS
						WHEN 0=>toneFreq<=47774;
						WHEN 1=>toneFreq<=63776;
						WHEN 2=>toneFreq<=75850;
						WHEN 3=>toneFreq<=95566;
						WHEN 4=>toneFreq<=0;
					END CASE;
					IF stateMiss<4 THEN
						IF toneCnt>=toneFreq THEN
							toneCnt<=0;
							beep<=NOT beep;
						ELSE
							toneCnt<=toneCnt+1;
						END IF;
					ELSE
						beep<='0';
					END IF;
				ELSIF FLG_BULLET_GET='1' OR stateGet>0 THEN--����������Ч��ԭ����������ͬ
					IF soundCnt=3124999 THEN
						soundCnt<=0;
						IF stateGet=4 THEN
							stateGet<=0;
						ELSE
							stateGet<=stateGet+1;
						END IF;
					ELSE
						soundCnt<=soundCnt+1;
					END IF;
					CASE stateGet IS
						WHEN 0=>toneFreq<=95566;
						WHEN 1=>toneFreq<=75850;
						WHEN 2=>toneFreq<=63776;
						WHEN 3=>toneFreq<=47774;
						WHEN 4=>toneFreq<=0;
					END CASE;
					IF stateGet<4 THEN
						IF toneCnt>=toneFreq THEN
							toneCnt<=0;
							beep<=NOT beep;
						ELSE
							toneCnt<=toneCnt+1;
						END IF;
					ELSE
						beep<='0';
					END IF;
				END IF;
			ELSIF FLG_RESULT='1' THEN--�����ʾģ������ʱ
				IF FLG_WIN='1' THEN--�����Ϸʤ��
					IF musicCnt=12499999 THEN
						musicCnt<=0;
						IF winMusicCnt<3 THEN--����ʤ����Ч��3����������Ȼ��ֹͣ
							winMusicCnt<=winMusicCnt+1;
						END IF;
					ELSE
						musicCnt<=musicCnt+1;
					END IF;
					CASE winMusicCnt IS
						WHEN 0=>toneFreq<=47774;
						WHEN 1=>toneFreq<=31888;
						WHEN 2=>toneFreq<=23912;
						WHEN 3=>toneFreq<=0;
					END CASE;
					IF winMusicCnt<3 THEN
						IF toneCnt>=toneFreq THEN
							toneCnt<=0;
							beep<=NOT beep;
						ELSE
							toneCnt<=toneCnt+1;
						END IF;
					ELSE
						beep<='0';
					END IF;
				ELSIF FLG_WIN='0' THEN--�����Ϸʧ��
					IF musicCnt=12499999 THEN
						musicCnt<=0;
						IF loseMusicCnt<3 THEN--����ʧ����Ч��3����������Ȼ��ֹͣ
							loseMusicCnt<=loseMusicCnt+1;
						END IF;
					ELSE
						musicCnt<=musicCnt+1;
					END IF;
					CASE loseMusicCnt IS
						WHEN 0=>toneFreq<=23912;
						WHEN 1=>toneFreq<=31888;
						WHEN 2=>toneFreq<=47774;
						WHEN 3=>toneFreq<=0;
					END CASE;
					IF loseMusicCnt<3 THEN
						IF toneCnt>=toneFreq THEN
							toneCnt<=0;
							beep<=NOT beep;
						ELSE
							toneCnt<=toneCnt+1;
						END IF;
					ELSE
						beep<='0';
					END IF;
				END IF;
			ELSE--��Ϸ��������׶Σ�״̬���㣬������������
				toneCnt<=0;
				stateMiss<=0;
				stateGet<=0;
				soundCnt<=0;
				musicCnt<=0;
				gameMusicCnt<=0;
				winMusicCnt<=0;
				loseMusicCnt<=0;
				beep<='0';
			END IF;
			TONE_OUT<=beep;
		END IF;
	END PROCESS;

END player;