-- 관계형 데이터베이스 관리 시스템(RDBMS) 중 MariaDB 설치 후 사용 
-- DB 생성 - CREATE DATABASE DB명
-- CREATE DATABASE mydb;
-- USE mydb;
-- SHOW DATABASES; -- DB명 목록 보기
-- DB 삭제 - DROP DATABASE DB명
-- 스키마, 정규화에 대한 이해 필요

-- 테이블 생성
-- CREATE TABLE TABLE명(칼럼명 자료형...제약조건...)
-- SQL 규칙은 명령문과 테이블 명은 모두 대문자를 사용한다
CREATE TABLE test (NO INT, NAME CHAR(10)); 
DESC test;
SHOW TABLES;
DROP TABLE test;

CREATE TABLE test(NO INT PRIMARY KEY, NAME VARCHAR(10) NOT NULL,tel VARCHAR(15), inwon INT, addr TEXT) CHARSET=UTF8;

DESC test;

-- 자료 추가
-- INSERT INTO 테이블명(칼럼명...) VALUES(자료...)
INSERT INTO test(NO,NAME,tel,inwon,addr) VALUES(1,'인사과','111-1111',3,'역삼 1동');
INSERT INTO test VALUES(2,'영업과','111-222',5,'역삼 1동');
INSERT INTO test(NO,NAME) VALUES(3,'자재과');
INSERT INTO test(NAME,NO) VALUES('판매과',4);

SELECT * FROM test; -- 모든 행 출력 
SELECT * FROM test WHERE NO=1; -- 조건에 맞는 행 출력


-- INSERT INTO test(NO,tel) VALUES(4,'111-5555');
-- INSERT INTO test(NO,NAME) VALUES(5,'자재과는 일이 매우 많은 그런 부서입니다'); -- 데이터 길이보다 길 경우 오류
-- INSERT INTO test VALUES(5, '111-5555'); -- 입력 자료의 갯수와 열 갯수 불일치

-- 자료 수정
-- UPDATE INTO 테이블명 SET 칼럼명=수정값,...where 조건
UPDATE test SET tel='666-6666' WHERE NO=1;
UPDATE test SET inwon=12,tel='666-7777' WHERE NO=3;
UPDATE test SET tel=null WHERE NO=3; -- 문자열에 따옴표 없이 null값을 그냥 쓰면 된다 
-- UPDATE test SET name=null WHERE NO=3; -- not null을 null로 설정할 경우  오류 
UPDATE test SET NO=9 WHERE NO=3; -- 문법상의 문제는 없지만 기본키 칼럼은 수정에서 제외해야한다

SELECT * FROM test;

-- 자료 삭제
-- DELETE 테이블명 WHERE 조건
DELETE FROM test WHERE NAME='영업과';

DELETE FROM test; -- 조건 추가 가능한 모든 행 삭제 속도가 느리다
TRUNCATE TABLE test; -- 조건없이 모든 행  삭제
DROP TABLE test; -- 테이블 삭제, 구조가 사라짐

-- SQL도 로컬 수정 내역을 커밋으로 데이터베이스에 적용시켜주어야 한다 .
-- 무결성 제약조건 : 잘못된 자료의 입력을 방지할 목적으로 테이블 생성 시 제한조건 부여 
-- domain constraint : 칼럼 생성시 각 칼럼의 이름, 성격, null 허용 여부 지정
-- PRIMARY KEY CONSTRAINT : 중복을 허용하지 않을 칼럼에 부여 
-- 사용자 정의 constraint : check, unique, foreign key ...

-- 기본키 제약조건 - 중복자료 입력 방지
-- 방법 1 - 칼럼 레벨 : 칼럼 선언시 제약조건 부여 (pk의 이름은 DBMS가 준다)
CREATE TABLE aa(bun INT PRIMARY KEY, irum VARCHAR(10) NOT null); -- domain  constraint도 적용 
DESC aa;
SHOW INDEX FROM aa;
SELECT * FROM information_schema.table_constraints WHERE TABLE_NAME='aa';
DROP TABLE aa;
-- 방법 2 - 테이블 레벨 : 칼럼을 모두 정의한 후 제약조건 부여

CREATE TABLE aa(bun INT, irum VARCHAR(10) NOT NULL, CONSTRAINT aa_bun_pk PRIMARY KEY(bun));
DESC aa;

-- check 제약조건 : 특정 칼럼에 입력되는 자료의 값을 검사

CREATE TABLE aa(bun INT, irum VARCHAR(10),nai INT CHECK(nai >= 20));
INSERT INTO aa VALUES(1,'tom',33);
INSERT INTO aa VALUES(1,'tom',13); -- check 제약 조건에 걸림
SELECT * FROM aa;

-- unique 제약조건 : 특정 칼럼에 입력되는 자료의 값의 중복을 불허함
CREATE TABLE aa(bun INT, irum VARCHAR(10) UNIQUE);
INSERT INTO aa VALUES(1,'tom');
INSERT INTO aa VALUES(1,'james');
INSERT INTO aa VALUES(3,'tom'); -- 중복된 이름값 제약조건에 걸림

-- foreign key(FK) - 외래키 제약조건 : 다른 테이블의 칼럼값 참조 fk의 대상은 pk 이다 기본 테이블을 참조시키는 제약조건
-- on delete cascade : 부모 테이블의 행이 삭제 되는 경우 참조하고 있는 자식 테이블의 종속행 자동삭제

CREATE TABLE sawon(bun INT PRIMARY KEY, irum VARCHAR(10), buser CHAR(10));
INSERT INTO sawon VALUES(1,'한국인','인사과');
INSERT INTO sawon VALUES(2,'한송이','자재과');
INSERT INTO sawon VALUES(3,'한사람','판매과');
SELECT * FROM sawon;

CREATE TABLE gajok(CODE INT PRIMARY KEY, NAME VARCHAR(10), birth DATETIME,sawon_bun INT,FOREIGN KEY(sawon_bun) REFERENCES sawon(bun));
DESC gajok;
INSERT INTO gajok VALUES(100, '지구인', '1980-1-12', 1);
INSERT INTO gajok VALUES(200, '우주인', '1982-10-12', 2);
INSERT INTO gajok VALUES(300, '이기자', '1986-12-12', 5); -- 외래키의 참조 불가 에러
SELECT * FROM gajok;
DELETE FROM gajok WHERE CODE = 200;
DELETE FROM sawon WHERE bun=1; -- 외래키로 참조중인 행은 삭제 불가 외래키가 있는참조테이블 행부터 삭제 가능
DROP TmydbmydbmydbABLE sawon; -- 테이블 삭제도 불가능하다 
DROP TABLE gajok;

-- default : 특정 칼럼에 초기지 부여 제약조건은 아님 NULL이 입력되는것을 방지하는 것을 목적

CREATE TABLE aa(bun INT, irum VARCHAR(10), jus VARCHAR(30) DEFAULT '역삼동');
DESC aa;
INSERT INTO aa VALUES(1,'김밥','서초3동');
INSERT INTO aa(bun) VALUES(2);
SELECT *FROM aa;
DROP TABLE aa;

-- 숫자 자동 증가 (auto_increment) - 단 오라클은 auto_increment 대신 sequence를 사용 INT 키에 특히 PRIMARY KEY에 많이 사용한다 
-- RDBMS에 따라 auto_increment 가 아니라 autoincrement 인 경우도 있다
CREATE TABLE aa(bun INT AUTO_INCREMENT PRIMARY KEY, irum VARCHAR(10));
DESC aa;
INSERT INTO aa VALUES(1,'공기밥');
SELECT *FROM aa;
INSERT INTO aa(irum) VALUES('주먹밥');