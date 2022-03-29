-- PL/SQL : SQL 프로그래밍. SQL만으로는 구현이 어렵거나 구현 불가능한 작업들을 수행하기 위해서 제공하는 프로그래밍 언어
    -- 키워드
        -- DECLARE(선언부) : 변수, 상수, 커서 등 선언 [선택]
        -- BEGIN (실행부) : 조건문, 반복문, DML, 함수 [필수]
        -- EXCEPTION : 예외 해결 [선택]
    -- 실행 결과 화면에 출력
        SET SERVEROUTPUT ON;
    -- [문제] HELLO 출력
        BEGIN
          DBMS_OUTPUT.PUT_LINE('Hello! PL/SQL');
        END;
        /
        
    DECLARE
      -- 변수 선언
      v_empno NUMBER(4) := 7788;
      v_ename VARCHAR2(10);
    BEGIN
      v_ename := 'SCOTT';
      DBMS_OUTPUT.PUT_LINE('v_empno : ' || v_empno);
      DBMS_OUTPUT.PUT_LINE('v_ename : ' || v_ename);
    END;
    /
    
    DECLARE
      -- 상수 선언
      v_tax CONSTANT NUMBER(1) := 3;
    BEGIN
      DBMS_OUTPUT.PUT_LINE('v_tax : ' || v_tax);
    END;
    /
    
    DECLARE
      -- 변수 기본값 지정
      v_deptno NUMBER(2) DEFAULT 10;
    BEGIN
      DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno);
    END;
    /
    
    DECLARE
      -- NOT NULL 지정
      v_deptno NUMBER(2) NOT NULL := 10;
    BEGIN
      DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno);
    END;
    /
    
-- IF
    -- IF ~ THEN ~ ELSE ~ END IF
    -- IF ~ THEN ~ ELSIF ~ END IF
        -- [문제] v_number 변수에 값 13을 대입 후 홀수인지 짝수인지 출력
            DECLARE
              v_number NUMBER := 13;
            BEGIN
              IF MOD(v_number, 2) = 0 THEN
                DBMS_OUTPUT.PUT_LINE(v_number || ' : 짝수입니다');
              ELSE
                DBMS_OUTPUT.PUT_LINE(v_number || ' : 홀수입니다');
                END IF;
            END;
            /
        -- [문제] v_number 변수에 점수 대입 후 학점 출력
            DECLARE
              v_number NUMBER := 87;
            BEGIN
              IF v_number >= 90 THEN
                DBMS_OUTPUT.PUT_LINE('A');
              ELSIF v_number >= 80 THEN
                DBMS_OUTPUT.PUT_LINE('B');
              ELSIF v_number >= 70 THEN
                DBMS_OUTPUT.PUT_LINE('C');
              ELSIF v_number >= 60 THEN
                DBMS_OUTPUT.PUT_LINE('D');
              ELSIF v_number >= 50 THEN
                DBMS_OUTPUT.PUT_LINE('E');
              ELSE
                DBMS_OUTPUT.PUT_LINE('F');
                END IF;
            END;
            /
        
        -- [문제] CASE ~ WITH문으로 학점 출력
            DECLARE
              v_score NUMBER := 77;
            BEGIN
                CASE TRUNC(v_score / 10)
                WHEN 10 THEN DBMS_OUTPUT.PUT_LINE('A');
                WHEN 9 THEN DBMS_OUTPUT.PUT_LINE('B');
                WHEN 8 THEN DBMS_OUTPUT.PUT_LINE('C');
                WHEN 7 THEN DBMS_OUTPUT.PUT_LINE('D');
                WHEN 6 THEN DBMS_OUTPUT.PUT_LINE('E');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('F');
                END CASE;
            END;
            /
    
-- 반복문
    -- LOOP ~ END LOOP
        DECLARE
            v_deptno NUMBER := 0;
        BEGIN
            LOOP
                DBMS_OUTPUT.PUT_LINE('현재 v_deptno : ' || v_deptno);
                v_deptno := v_deptno + 1;
                EXIT WHEN v_deptno > 4;
            END LOOP;
        END;
        /
    -- WHILE LOOP ~ END LOOP
        DECLARE
            v_deptno NUMBER := 0;
        BEGIN
            WHILE v_deptno < 4 LOOP
                DBMS_OUTPUT.PUT_LINE('현재 v_deptno : ' || v_deptno);
                v_deptno := v_deptno + 1;
            END LOOP;
        END;
        /
    -- FOR LOOP
        BEGIN
            FOR i IN 0..4 LOOP -- 시작값..종료값
                DBMS_OUTPUT.PUT_LINE('현재 i : ' || i);
            END LOOP;
        END;
        /
        
        BEGIN
            FOR i IN REVERSE 0..4 LOOP
                DBMS_OUTPUT.PUT_LINE('현재 i : ' || i);
            END LOOP;
        END;
        /
        
        BEGIN
            FOR i IN 1..10 LOOP
                IF MOD(i, 2) = 1 THEN
                    DBMS_OUTPUT.PUT_LINE(i);
                END IF;
            END LOOP;
        END;
        /
    -- CURSOR FOR LOOP : 자동 OPEN, FETCH, CLOSE
        DECLARE
            CURSOR c1 IS
                SELECT deptno, dname, loc
                FROM dept;
        BEGIN
            FOR c1_rec IN c1 LOOP
                DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || c1_rec.deptno || ' DNAME : ' || c1_rec.dname || ' LOC : ' || c1_rec.loc);
            END LOOP;
        END;
        /
        
        DECLARE
            -- 사용자가 입력한 부서 번호를 저장하는 변수 선언
            v_deptno DEPT.DEPTNO%TYPE;
            -- 명시적 커서 선언
            CURSOR c1(p_deptno DEPT.DEPTNO%TYPE) IS
                SELECT deptno, dname, loc
                FROM dept
                WHERE deptno = p_deptno;
        BEGIN
            -- input_deptno에 부서번호 입력 받고 v_deptno에 대입
            v_deptno := &input_deptno;
            
            -- 자동 OPEN, FETCH, CLOSE
            FOR c1_rec IN c1(v_deptno) LOOP
                DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || c1_rec.deptno || ' DNAME : ' || c1_rec.dname || ' LOC : ' || c1_rec.loc);
            END LOOP;
        END;
        /
        -- 커서 : DML문 실행 시 해당 SQL문을 처리하는 정보를 저장한 메모리 공간. 결과값이 몇 개인지 알 수 없을 경우
        -- SELECT ~ INTO 방식 : 결과값이 하나일 때 사용
            -- 변수 타입 선언 시 특정 테이블의 컬럼 값 참조
            DECLARE
              v_deptno dept.deptno%TYPE := 50;
            BEGIN
              DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno);
            END;
            /
            -- 변수 타입 선언 시 특정 테이블의 하나의 컬럼이 아닌 행 구조 전체 참조
            DECLARE
              v_dept_row dept%ROWTYPE;
            BEGIN
              SELECT deptno, dname, loc INTO v_dept_row
              FROM dept
              WHERE deptno = 40;
              DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || v_dept_row.deptno);
              DBMS_OUTPUT.PUT_LINE('DNAME : ' || v_dept_row.dname);
              DBMS_OUTPUT.PUT_LINE('LOC : ' || v_dept_row.loc);
            END;
            /
        -- 1) 명시적 커서 : 커서 선언(DECLARE) > 커서 열기(OPEN) > 커서에서 읽어온 데이터 사용(FETCH) > 커서 닫기(CLOSE)
            DECLARE
                v_dept_row dept%ROWTYPE; -- 커서 데이터를 입력할 변수 선언
                CURSOR c1 IS -- 커서 선언
                    SELECT deptno, dname, loc
                    FROM dept
                    WHERE deptno = 40;
            BEGIN
                OPEN c1; -- 커서 열기
                FETCH c1 INTO v_dept_row; -- 읽어온 데이터 사용
                DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || v_dept_row.deptno);
                DBMS_OUTPUT.PUT_LINE('DNAME : ' || v_dept_row.dname);
                DBMS_OUTPUT.PUT_LINE('LOC : ' || v_dept_row.loc);
                CLOSE c1; -- 커서 닫기
            END;
            /
            -- 여러 행이 조회되는 경우
                DECLARE
                    v_dept_row dept%ROWTYPE; -- 커서 데이터를 입력할 변수 선언
                    CURSOR c1 IS -- 커서 선언
                        SELECT deptno, dname, loc
                        FROM dept;
                BEGIN
                    OPEN c1; -- 커서 열기
                    LOOP
                        FETCH c1 INTO v_dept_row; -- 읽어온 데이터 사용
                        EXIT WHEN c1%NOTFOUND; -- 커서에서 더 이상 읽어올 행이 없을 때까지
                        DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || v_dept_row.deptno);
                        DBMS_OUTPUT.PUT_LINE('DNAME : ' || v_dept_row.dname);
                        DBMS_OUTPUT.PUT_LINE('LOC : ' || v_dept_row.loc);
                    END LOOP;
                    CLOSE c1; -- 커서 닫기
                END;
                /
                
        -- 2) 묵시적 커서 : 커서 선언 없이 사용
            -- SQL%ROWCOUNT : 묵시적 커서 안에 추출된 행이 있으면 행의 수 출력
            -- SQL%FOUND : 묵시적 커서 안에 추출된 행이 있으면 TRUE, 없으면 FALSE (cf) SQL%NOTFOUND : 명시적 커서 안에 추출된 행이 있으면 TRUE, 없으면 FALSE)
            -- SQL%ISOPEN : 자동으로 SQL문을 실행한 후 CLOSE 되기 때문에 항상 FALSE
            BEGIN
                UPDATE dept_temp SET dname = 'DATEBASE' WHERE deptno = 60;
                DBMS_OUTPUT.PUT_LINE('갱신된 행의 수 : ' || SQL%ROWCOUNT);
                IF SQL%FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('갱신 대상 행 존재 여부 : TRUE');
                ELSE DBMS_OUTPUT.PUT_LINE('갱신 대상 행 존재 여부 : FALSE');
                END IF;
                IF SQL%ISOPEN THEN
                    DBMS_OUTPUT.PUT_LINE('커서 OPEN 여부 : TRUE');
                ELSE DBMS_OUTPUT.PUT_LINE('커서 OPEN 여부 : FALSE');
                END IF;
            END;
            /
            
-- 저장 서브 프로그램 : 이름 지정, 저장, 저장할 때 한 번 컴파일, 공유해서 사용 가능, 다른 응용프로그램에서 호출 가능
    -- 저장 프로시저 : SQL문에서는 사용 불가
    -- 저장 함수 : 저장 프로시저를 함수로 만들면 SQL문에서 사용 가능
    -- 트리거 : 특정 상황이 발생할 때 자동으로 연달아 수행할 기능을 구현하는 데 사용 (ex) 휴면계정인 사람이 로그인 했을 때 그 계정 정보를 삭제 테이블에서 원 테이블로 자동으로 이동)
    -- 패키지 : 저장 서브 프로그램을 그룹화

-- 프로시저
    CREATE PROCEDURE pro_noparam
    IS
        v_empno NUMBER(4) := 7788;
        v_ename VARCHAR2(10);
    BEGIN
        v_ename := 'SCOTT';
        DBMS_OUTPUT.PUT_LINE('v_empno : ' || v_empno);
        DBMS_OUTPUT.PUT_LINE('v_ename : ' || v_ename);
    END;
    /
    
    -- PROCEDURE 실행
        EXECUTE pro_noparam;
    
    -- 다른 PL/SQL 블록에서 프로시저 실행
        BEGIN
            pro_noparam;
        END;
        /
        
    -- 프로시저 작성 시 파라미터가 존재하는 경우
        -- IN (기본값)
            CREATE OR REPLACE PROCEDURE pro_param_in
            (
                param1 IN NUMBER,
                param2 NUMBER,
                param3 NUMBER := 3,
                param4 NUMBER DEFAULT 4
            )
            IS
            BEGIN
                DBMS_OUTPUT.PUT_LINE('param1 : ' || param1);
                DBMS_OUTPUT.PUT_LINE('param2 : ' || param2);
                DBMS_OUTPUT.PUT_LINE('param3 : ' || param3);
                DBMS_OUTPUT.PUT_LINE('param4 : ' || param4);
            END;
            /
            
            EXECUTE pro_param_in(1, 2);
            EXECUTE pro_param_in(5, 6, 7, 8);
            EXECUTE pro_param_in(1);
            
        -- OUT : 값을 내보냄 (return)
            CREATE OR REPLACE PROCEDURE pro_param_out
            (
                in_empno IN emp.empno%TYPE, -- %TYPE : 해당 테이블의 해당 컬럼 속성 타입을 그대로 사용하겠다는 의미
                out_ename OUT emp.ename%TYPE,
                out_sal OUT emp.sal%TYPE
            )
            IS
            BEGIN
                SELECT ename, sal INTO out_ename, out_sal
                FROM emp
                WHERE empno = in_empno;
            END;
            /
            
            DECLARE
                v_ename emp.ename%TYPE;
                v_sal emp.sal%TYPE;
            BEGIN
                pro_param_out(7369, v_ename, v_sal);
                DBMS_OUTPUT.PUT_LINE('ename : ' || v_ename);
                DBMS_OUTPUT.PUT_LINE('sal : ' || v_sal);
            END;
            /
        
        -- IN & OUT
            CREATE OR REPLACE PROCEDURE pro_param_in_out
            (
                in_out_no IN OUT NUMBER
            )
            IS
            BEGIN
                in_out_no := in_out_no * 2;
            END;
            /
            
            DECLARE
                no NUMBER;
            BEGIN
                no := 5;
                pro_param_in_out(no);
                DBMS_OUTPUT.PUT_LINE('no : ' || no);
            END;
            /

-- 트리거
    -- DML 트리거
    -- CREATE OR REPLACE TRIGGER 트리거명
    -- BEFORE | AFTER
    -- INSERT | UPDATE | DELETE ON 테이블명
    -- DECLARE
    -- BEGIN
    -- END
        CREATE TABLE emp_trg as SELECT * FROM emp;
        
    -- 주말에 사원 정보 추가, 수정, 삭제 시 에러나게 프로그램 작성하기
        CREATE OR REPLACE TRIGGER emp_trg_weekend
        BEFORE
        INSERT or UPDATE or DELETE ON emp_trg
        BEGIN
            IF TO_CHAR(SYSDATE, 'DY') IN ('토', '일') THEN
                IF INSERTING THEN
                    RAISE_APPLICATION_ERROR(-30000, '주말 사원정보 추가 불가');
                ELSIF UPDATING THEN
                    RAISE_APPLICATION_ERROR(-30001, '주말 사원정보 수정 불가');
                ELSIF DELETING THEN
                    RAISE_APPLICATION_ERROR(-30002, '주말 사원정보 삭제 불가');
                ELSE
                    RAISE_APPLICATION_ERROR(-30003, '주말 사원정보 변경 불가');
                END IF;
            END IF;
        END;
        /
        
        UPDATE emp_trg SET sal = 3500 WHERE empno = 7369;
        DELETE FROM emp_trg WHERE empno = 7369;

    -- 트리거 발생 저장 테이블 생성 (로그 남기기)
        CREATE TABLE emp_trg_log(
            tablename VARCHAR2(20), -- DML 수행된 테이블 이름
            dml_type VARCHAR2(10), -- DML 명령어 종류
            empno NUMBER(4), -- DML 대상 사원 번호
            user_name VARCHAR2(30), -- DML 수행한 user명
            change_date DATE -- DML 시도 날짜
        );
        
        CREATE OR REPLACE TRIGGER emp_trg_weekend_log
        AFTER
        INSERT or UPDATE or DELETE ON emp_trg
        FOR EACH ROW -- 행별로 각각 실행하겠다는 의미
        BEGIN
            IF INSERTING THEN
                INSERT INTO emp_trg_log VALUES('emp_trg', 'insert', :new.empno, SYS_CONTEXT('userenv', 'session_user'), SYSDATE);
            ELSIF UPDATING THEN
                INSERT INTO emp_trg_log VALUES('emp_trg', 'update', :old.empno, SYS_CONTEXT('userenv', 'session_user'), SYSDATE);
            ELSIF DELETING THEN
                INSERT INTO emp_trg_log VALUES('emp_trg', 'delete', :old.empno, SYS_CONTEXT('userenv', 'session_user'), SYSDATE);
            END IF;
        END;
        /
        
        INSERT INTO emp_trg VALUES(9999, 'test_tmp', 'CLERK', 7788, '2018-03-03', 1200, NULL, 20);
        SELECT * FROM emp_trg_log;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        