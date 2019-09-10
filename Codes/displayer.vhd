--��ʾģ��ĳ������
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;
USE IEEE.STD_LOGIC_ARITH;

--��ʾģ��Ľӿ����
ENTITY displayer IS
	PORT(
		CLK_DISP:IN STD_LOGIC;--ϵͳʱ��
		FLG_PWR:IN STD_LOGIC;--���뿪��״̬
		FLG_CHK:IN STD_LOGIC;
		FLG_WT:IN STD_LOGIC;
		FLG_INIT:IN STD_LOGIC;
		FLG_GAME:IN STD_LOGIC;
		FLG_RESULT:IN STD_LOGIC;
		--�ĸ�ģ�鴦������״̬
		FLG_WIN:IN STD_LOGIC;--�����ʾ����Ӯ���
		FLG_BULLET:IN STD_LOGIC;--�ӵ��Ƿ��ڷ���״̬
		STATE_CHK:IN INTEGER RANGE 0 TO 7;--�Լ���ɨ����Ϣ
		STATE_INIT:IN INTEGER RANGE 0 TO 7;--������ʾ״̬��Ϣ
		STATE_GAME_TARGET:IN INTEGER RANGE 0 TO 9;	--�ƶ���λ����Ϣ
		STATE_GAME_BULLET:IN INTEGER RANGE 0 TO 6;--�ӵ�λ����Ϣ
		STATE_GAME_TIME_LEFT:IN INTEGER RANGE 0 TO 40;--��Ϸ�����еĵ���ʱ��Ϣ
		STATE_GAME_SCORE:IN INTEGER RANGE 0 TO 19;--��Ϸ�����еļƷ���Ϣ
		RESULT_TIME_LEFT:IN INTEGER RANGE 0 TO 40;--�����ʾ��ʣ��ʱ����Ϣ
		RESULT_SCORE:IN INTEGER RANGE 0 TO 19;--�����ʾ���ܷ���Ϣ
		LED0_OUT:OUT STD_LOGIC;--��Դָʾ��
		CAT_OUT:OUT STD_LOGIC_VECTOR(0 TO 7);--�����ѡͨ�ź�
		DIGIT_OUT:OUT STD_LOGIC_VECTOR(0 TO 7);--�������ʾ�ź�
		ROW_OUT:OUT STD_LOGIC_VECTOR(0 TO 7);--������ѡͨ�ź�
		COLR_OUT:OUT STD_LOGIC_VECTOR(0 TO 7);--��ɫ������ѡͨ�ź�
		COLG_OUT:OUT STD_LOGIC_VECTOR(0 TO 7)--��ɫ������ѡͨ�ź�
	);
END ENTITY;

ARCHITECTURE display OF displayer IS
	
	SIGNAL clkInitCnt:INTEGER RANGE 0 TO 799;--������ʾ�׶ο���ɨ�����ڵķ�Ƶ������
	SIGNAL rowInitCnt:INTEGER RANGE 0 TO 99;--������ʾ�׶ο�����ѡͨ�ķ�Ƶ������
	SIGNAL clkGameCnt:INTEGER RANGE 0 TO 199;--��Ϸ�������Լ������ʾʱ������ɨ�����ڵķ�Ƶ������
	SIGNAL rowGameCnt:INTEGER RANGE 0 TO 7;--��Ϸ�������Լ������ʾʱ������ѡͨ�źŵ�ѭ��������
	SIGNAL digitTime1:INTEGER RANGE 0 TO 4;--����ʱʮλ����ʮ������ֵ
	SIGNAL digitTime2:INTEGER RANGE 0 TO 9;--����ʱ��λ����ʮ������ֵ
	SIGNAL digitScore1:INTEGER RANGE 0 TO 1;--����ʮλ����ʮ������ֵ
	SIGNAL digitScore2:INTEGER RANGE 0 TO 9;--������λ����ʮ������ֵ
	SIGNAL binaryTime1:STD_LOGIC_VECTOR(0 TO 7);
	SIGNAL binaryTime2:STD_LOGIC_VECTOR(0 TO 7);
	SIGNAL binaryScore1:STD_LOGIC_VECTOR(0 TO 7);
	SIGNAL binaryScore2:STD_LOGIC_VECTOR(0 TO 7);--��Ӧ�������ź�
	SIGNAL clkSparkCnt:INTEGER RANGE 0 TO 24999999;--�����ʾʱ�����������ÿ0.5����˸һ�εķ�Ƶ������
	
BEGIN
	
	PROCESS(CLK_DISP)
	BEGIN
		IF CLK_DISP'EVENT AND CLK_DISP='1' THEN
			IF FLG_PWR='0' THEN--���뿪�عر�ʱ��LED0������ܡ�����ȫ��
				LED0_OUT<='0';
				DIGIT_OUT<="00000000";
				CAT_OUT<="11111111";
				COLR_OUT<="00000000";
				COLG_OUT<="00000000";
				ROW_OUT<="11111111";
			ELSE
				LED0_OUT<='1';--���뿪�ش�ʱ��LED0����
				IF FLG_CHK='1' THEN--��������Լ�״̬
					DIGIT_OUT<="11111111";--�������ʾ��8.��
					COLR_OUT<="11111111";--��ɫ�������ȫ��ѡͨ
					COLG_OUT<="00000000";--��ɫ������о���ѡͨ
					CASE STATE_CHK IS--�����Լ�ģ������Ĳ�����0��7��������ɫ����ѡͨ��һ�У��Լ������ѡͨ��һλ
						WHEN 0=>CAT_OUT<="11111110";ROW_OUT<="11111110";
						WHEN 1=>CAT_OUT<="11111101";ROW_OUT<="11111101";
						WHEN 2=>CAT_OUT<="11111011";ROW_OUT<="11111011";
						WHEN 3=>CAT_OUT<="11110111";ROW_OUT<="11110111";
						WHEN 4=>CAT_OUT<="11101111";ROW_OUT<="11101111";
						WHEN 5=>CAT_OUT<="11011111";ROW_OUT<="11011111";
						WHEN 6=>CAT_OUT<="10111111";ROW_OUT<="10111111";
						WHEN 7=>CAT_OUT<="01111111";ROW_OUT<="01111111";
					END CASE;
				ELSIF FLG_INIT='1' THEN--������ʾ�׶�
					DIGIT_OUT<="00000000";--�ر������
					CAT_OUT<="11111111";
					IF clkInitCnt=799 THEN
						clkInitCnt<=0;
					ELSE
						clkInitCnt<=clkInitCnt+1;
					END IF;
					IF rowInitCnt=99 THEN
						rowInitCnt<=0;
					ELSE
						rowInitCnt<=rowInitCnt+1;
					END IF;
					IF clkInitCnt>700-STATE_INIT*100 THEN--�ɽ�����ʾģ���״̬����STATE_INIT��������ѡͨ�źŵ�ռ�ձȣ�STATE_INIT��0��7��ѡͨʱ����������������ʾ�𽥱���
						IF rowInitCnt>=50 THEN--����ѡͨ����ĵ�һ�к͵ڶ��У�������ǹ����ʾ
							COLG_OUT<="00111000";
							COLR_OUT<="00000000";
							ROW_OUT<="01111111";
						ELSE
							COLG_OUT<="00010000";
							COLR_OUT<="00000000";
							ROW_OUT<="10111111";
						END IF;
					ELSE
						COLG_OUT<="00000000";
						COLR_OUT<="00000000";
						ROW_OUT<="11111111";
					END IF;
				ELSIF FLG_GAME='1' THEN--��Ϸ�������������ʱ
					IF clkGameCnt=199 THEN
						clkGameCnt<=0;
						IF rowGameCnt=7 THEN
							rowGameCnt<=0;
						ELSE
							rowGameCnt<=rowGameCnt+1;
						END IF;
					ELSE
						clkGameCnt<=clkGameCnt+1;
					END IF;
					digitTime1<=STATE_GAME_TIME_LEFT/10;--���㵹��ʱ�������ʮλ�������λ����
					digitTime2<=STATE_GAME_TIME_LEFT MOD 10;
					digitScore1<=STATE_GAME_SCORE/10;
					digitScore2<=STATE_GAME_SCORE MOD 10;
					CASE digitTime1 IS
						WHEN 4=>binaryTime1<="01100110";--�������
						WHEN 3=>binaryTime1<="11110010";
						WHEN 2=>binaryTime1<="11011010";
						WHEN 1=>binaryTime1<="01100000";
						WHEN 0=>binaryTime1<="11111100";
					END CASE;
					CASE digitTime2 IS
						WHEN 9=>binaryTime2<="11110110";
						WHEN 8=>binaryTime2<="11111110";
						WHEN 7=>binaryTime2<="11100000";
						WHEN 6=>binaryTime2<="10111110";
						WHEN 5=>binaryTime2<="10110110";
						WHEN 4=>binaryTime2<="01100110";
						WHEN 3=>binaryTime2<="11110010";
						WHEN 2=>binaryTime2<="11011010";
						WHEN 1=>binaryTime2<="01100000";
						WHEN 0=>binaryTime2<="11111100";
					END CASE;
					CASE digitScore1 IS
						WHEN 1=>binaryScore1<="01100000";
						WHEN 0=>binaryScore1<="11111100";
					END CASE;
					CASE digitScore2 IS
						WHEN 9=>binaryScore2<="11110110";
						WHEN 8=>binaryScore2<="11111110";
						WHEN 7=>binaryScore2<="11100000";
						WHEN 6=>binaryScore2<="10111110";
						WHEN 5=>binaryScore2<="10110110";
						WHEN 4=>binaryScore2<="01100110";
						WHEN 3=>binaryScore2<="11110010";
						WHEN 2=>binaryScore2<="11011010";
						WHEN 1=>binaryScore2<="01100000";
						WHEN 0=>binaryScore2<="11111100";
					END CASE;
					--rowGameCntѭ������������ɨ��ѡͨ�����һ�����ڰ���
					IF rowGameCnt=0 THEN--���Ƶ����һ�У���ʾ����ܵ�һλ
						CAT_OUT<="11111110";
						DIGIT_OUT<=binaryTime1;
						ROW_OUT<="11111110";
						COLG_OUT<="00000000";
						IF STATE_GAME_BULLET=6 THEN--�����ӵ�λ����е�λ�÷��������
							CASE STATE_GAME_TARGET IS--����Ҫ���ư�Ҳ��Ҫ�����ӵ������
								WHEN 0=>COLR_OUT<="10010000";
								WHEN 1=>COLR_OUT<="11010000";
								WHEN 2=>COLR_OUT<="11110000";
								WHEN 3=>COLR_OUT<="01110000";
								WHEN 4=>COLR_OUT<="00111000";
								WHEN 5=>COLR_OUT<="00011100";
								WHEN 6=>COLR_OUT<="00011110";
								WHEN 7=>COLR_OUT<="00010111";
								WHEN 8=>COLR_OUT<="00010011";
								WHEN 9=>COLR_OUT<="00010001";
							END CASE;
						ELSE
							CASE STATE_GAME_TARGET IS--ֻ��Ҫ���ưе����
								WHEN 0=>COLR_OUT<="10000000";
								WHEN 1=>COLR_OUT<="11000000";
								WHEN 2=>COLR_OUT<="11100000";
								WHEN 3=>COLR_OUT<="01110000";
								WHEN 4=>COLR_OUT<="00111000";
								WHEN 5=>COLR_OUT<="00011100";
								WHEN 6=>COLR_OUT<="00001110";
								WHEN 7=>COLR_OUT<="00000111";
								WHEN 8=>COLR_OUT<="00000011";
								WHEN 9=>COLR_OUT<="00000001";
							END CASE;
						END IF;
					ELSIF rowGameCnt=1 THEN--����ڶ��У�����ܵڶ�λ
						CAT_OUT<="11111101";
						DIGIT_OUT<=binaryTime2;
						ROW_OUT<="11111101";
						COLG_OUT<="00000000";
						IF STATE_GAME_BULLET=5 THEN--�����ӵ�λ�þ����Ƿ����
							COLR_OUT<="00010000";
						ELSE
							COLR_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=2 THEN--�����Դ�����
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						ROW_OUT<="11111011";
						COLG_OUT<="00000000";
						IF STATE_GAME_BULLET=4 THEN
							COLR_OUT<="00010000";
						ELSE
							COLR_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=3 THEN
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						ROW_OUT<="11110111";
						COLG_OUT<="00000000";
						IF STATE_GAME_BULLET=3 THEN
							COLR_OUT<="00010000";
						ELSE
							COLR_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=4 THEN
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						ROW_OUT<="11101111";
						COLG_OUT<="00000000";
						IF STATE_GAME_BULLET=2 THEN
							COLR_OUT<="00010000";
						ELSE
							COLR_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=5 THEN
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						ROW_OUT<="11011111";
						COLG_OUT<="00000000";
						IF STATE_GAME_BULLET=1 THEN
							COLR_OUT<="00010000";
						ELSE
							COLR_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=6 THEN
						CAT_OUT<="10111111";
						DIGIT_OUT<=binaryScore1;
						ROW_OUT<="10111111";
						COLG_OUT<="00010000";--��������У��������ǹǹ��
						IF STATE_GAME_BULLET=0 AND FLG_BULLET='1' THEN--�����ӵ�����״̬�����Ƿ�����ӵ�
							COLR_OUT<="00010000";
						ELSE
							COLR_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=7 THEN
						CAT_OUT<="01111111";
						DIGIT_OUT<=binaryScore2;
						ROW_OUT<="01111111";
						COLG_OUT<="00111000";--����ڰ��У��������ǹǹ��
						COLR_OUT<="00000000";
					END IF;
				ELSIF FLG_RESULT='1' THEN--�����ʾģ��
					IF clkGameCnt=199 THEN--ÿ200��ϵͳʱ�����ڣ�����һ������ܼ������ѡͨλ�á�����Ƶ�ʲ��˹��ߣ���������ʱ���صĲ�ͬ�������ܻ������ʾЧ���Ĵ���
						clkGameCnt<=0;
						IF rowGameCnt=7 THEN
							rowGameCnt<=0;
						ELSE
							rowGameCnt<=rowGameCnt+1;
						END IF;
					ELSE
						clkGameCnt<=clkGameCnt+1;
					END IF;
					IF clkSparkCnt=24999999 THEN
						clkSparkCnt<=0;
					ELSE
						clkSparkCnt<=clkSparkCnt+1;
					END IF;
					digitTime1<=RESULT_TIME_LEFT/10;--����ʱ��������ĸ�λ���֡�ʮλ������Ϣ
					digitTime2<=RESULT_TIME_LEFT MOD 10;
					digitScore1<=RESULT_SCORE/10;
					digitScore2<=RESULT_SCORE MOD 10;
					CASE digitTime1 IS--��������
						WHEN 4=>binaryTime1<="01100110";
						WHEN 3=>binaryTime1<="11110010";
						WHEN 2=>binaryTime1<="11011010";
						WHEN 1=>binaryTime1<="01100000";
						WHEN 0=>binaryTime1<="11111100";
					END CASE;
					CASE digitTime2 IS
						WHEN 9=>binaryTime2<="11110110";
						WHEN 8=>binaryTime2<="11111110";
						WHEN 7=>binaryTime2<="11100000";
						WHEN 6=>binaryTime2<="10111110";
						WHEN 5=>binaryTime2<="10110110";
						WHEN 4=>binaryTime2<="01100110";
						WHEN 3=>binaryTime2<="11110010";
						WHEN 2=>binaryTime2<="11011010";
						WHEN 1=>binaryTime2<="01100000";
						WHEN 0=>binaryTime2<="11111100";
					END CASE;
					CASE digitScore1 IS
						WHEN 1=>binaryScore1<="01100000";
						WHEN 0=>binaryScore1<="11111100";
					END CASE;
					CASE digitScore2 IS
						WHEN 9=>binaryScore2<="11110110";
						WHEN 8=>binaryScore2<="11111110";
						WHEN 7=>binaryScore2<="11100000";
						WHEN 6=>binaryScore2<="10111110";
						WHEN 5=>binaryScore2<="10110110";
						WHEN 4=>binaryScore2<="01100110";
						WHEN 3=>binaryScore2<="11110010";
						WHEN 2=>binaryScore2<="11011010";
						WHEN 1=>binaryScore2<="01100000";
						WHEN 0=>binaryScore2<="11111100";
					END CASE;
					IF rowGameCnt=0 THEN--����ܡ�������λ������ɨ��
						DIGIT_OUT<=binaryTime1;
						ROW_OUT<="11111110";
						IF FLG_WIN='1' THEN
							CAT_OUT<="11111110";
							COLR_OUT<="00000000";--ʤ��ʱ����ɫ����رգ���ɫ������ƶԹ�
							COLG_OUT<="00000001";
						ELSE
							IF clkSparkCnt<12500000 THEN--ʧ��ʱ�������ʱ����Ϣ��˸
								CAT_OUT<="11111110";
							ELSE
								CAT_OUT<="11111111";
							END IF;
							COLR_OUT<="10000001";
							COLG_OUT<="00000000";
						END IF;
					--�����Դ�����
					ELSIF rowGameCnt=1 THEN
						DIGIT_OUT<=binaryTime2;
						ROW_OUT<="11111101";
						IF FLG_WIN='1' THEN
							CAT_OUT<="11111101";
							COLR_OUT<="00000000";
							COLG_OUT<="00000010";
						ELSE
							IF clkSparkCnt<12500000 THEN
								CAT_OUT<="11111101";
							ELSE
								CAT_OUT<="11111111";
							END IF;
							COLR_OUT<="01000010";
							COLG_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=2 THEN
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						COLG_OUT<="00000000";
						ROW_OUT<="11111011";
						IF FLG_WIN='1' THEN
							COLR_OUT<="00000000";
						ELSE
							COLR_OUT<="00100100";
						END IF;
					ELSIF rowGameCnt=3 THEN
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						ROW_OUT<="11110111";
						IF FLG_WIN='1' THEN
							COLR_OUT<="00000000";
							COLG_OUT<="00000100";
						ELSE
							COLR_OUT<="00011000";
							COLG_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=4 THEN
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						ROW_OUT<="11101111";
						IF FLG_WIN='1' THEN
							COLR_OUT<="00000000";
							COLG_OUT<="10000000";
						ELSE
							COLR_OUT<="00011000";
							COLG_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=5 THEN
						CAT_OUT<="11111111";
						DIGIT_OUT<="00000000";
						ROW_OUT<="11011111";
						IF FLG_WIN='1' THEN
							COLR_OUT<="00000000";
							COLG_OUT<="01001000";
						ELSE
							COLR_OUT<="00100100";
							COLG_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=6 THEN
						DIGIT_OUT<=binaryScore1;
						ROW_OUT<="10111111";
						IF FLG_WIN='1' THEN
							IF clkSparkCnt<12500000 THEN
								CAT_OUT<="10111111";
							ELSE
								CAT_OUT<="11111111";
							END IF;
							COLR_OUT<="00000000";
							COLG_OUT<="00100000";
						ELSE
							CAT_OUT<="10111111";
							COLR_OUT<="01000010";
							COLG_OUT<="00000000";
						END IF;
					ELSIF rowGameCnt=7 THEN
						DIGIT_OUT<=binaryScore2;
						ROW_OUT<="01111111";
						IF FLG_WIN='1' THEN
							IF clkSparkCnt<12500000 THEN--ʤ��ʱ��������˸��ʾ
								CAT_OUT<="01111111";
							ELSE
								CAT_OUT<="11111111";
							END IF;
							COLR_OUT<="00000000";
							COLG_OUT<="00010000";
						ELSE
							CAT_OUT<="01111111";
							COLR_OUT<="10000001";
							COLG_OUT<="00000000";
						END IF;
					END IF;
				ELSE
					CAT_OUT<="11111111";
					DIGIT_OUT<="00000000";
					ROW_OUT<="11111111";
					COLG_OUT<="00000000";
					COLR_OUT<="00000000";
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
END display;