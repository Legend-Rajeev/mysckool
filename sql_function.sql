DELIMITER $$

--
-- Create function `UC_Words`
--
CREATE FUNCTION UC_Words( str VARCHAR(255) )
  RETURNS VARCHAR(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
     BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END
$$

--
-- Create function `ucfirst`
--
CREATE FUNCTION ucfirst(param_string varchar (255))
  RETURNS VARCHAR(255) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    CONCAT(UCASE(LEFT(param_string, 1)), LCASE(SUBSTRING(param_string, 2))) INTO var_name;
  RETURN var_name;
END
$$

--
-- Create function `msplit`
--
CREATE FUNCTION msplit(genattime varchar(255),noo int)
  RETURNS VARCHAR(255) CHARSET utf8
BEGIN
  SET @str = SUBSTRING(genattime FROM 1 FOR CHAR_LENGTH(genattime) - 3),@numb=noo ,@lens= LENGTH(@str), @char = '',@return_str = '';
             
  IF((@lens DIV  @numb) > 0 ) then
  myloop: WHILE @lens > 0 DO
        SET @char = '';
        SET @char = left(@str,@numb);
        SET @lens =  @lens-  @numb;
        SET @str = SUBSTRING(@str, @numb+1,  LENGTH(@str));
       SET @return_str = IF(LENGTH(@return_str) < 1,@char,CONCAT(@return_str,',',@char));
  -- SET @return_str = @str;
            -- LEAVE myloop;
  END WHILE;
   ELSE  SET @return_str = NULL; END IF;
  RETURN @return_str;
END
$$

--
-- Create function `datForm`
--
CREATE FUNCTION datForm(param_date varchar(20), param_format varchar(20), param_toformat varchar(20))
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    DATE_FORMAT(STR_TO_DATE(param_date, param_format), param_toformat) INTO var_name;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getfeecfgtype`
--
CREATE FUNCTION getfeecfgtype(param_feetypesID int)
  RETURNS VARCHAR(30) CHARSET utf8
BEGIN
  DECLARE var_name varchar(30);
  SELECT
   `type` INTO var_name 
  FROM feeconfig
  WHERE feetypesID = param_feetypesID GROUP BY `type` ORDER BY feeconfigID desc LIMIT 1;
  RETURN var_name;
END
$$

--
-- Create function `getfee`
--
CREATE FUNCTION getfee(para_feetypesID int,para_classesID int,para_schoolyearID int)
  RETURNS DOUBLE(6, 2)
BEGIN
DECLARE var_name DOUBLE(6,2);
  SELECT fee INTO var_name
    FROM feeconfig
    WHERE feetypesID = para_feetypesID AND classesID=para_classesID AND schoolyearID=para_schoolyearID;
  RETURN var_name;
END
$$

DELIMITER ;

DELIMITER $$

--
-- Create function `gettpfee`
--
CREATE FUNCTION gettpfee(para_studentID int, para_genattime VARCHAR(255))
  RETURNS DOUBLE(10, 0)
BEGIN
DECLARE var_name DOUBLE(10,0);
  SELECT SUM(pfee) INTO var_name
    FROM feegen
    WHERE studentID = para_studentID AND genattime = para_genattime;
  RETURN var_name;
END
$$

--
-- Create function `gettfee`
--
CREATE FUNCTION gettfee(para_studentID int, para_genattime VARCHAR(255))
  RETURNS DOUBLE(10, 0)
BEGIN
DECLARE var_name DOUBLE(10,0);
  SELECT SUM(tfee) INTO var_name
    FROM feegen
    WHERE studentID = para_studentID AND genattime=para_genattime;
  RETURN var_name;
END
$$

--
-- Create function `getfeelatefine`
--
CREATE FUNCTION getfeelatefine(param_studentID int , param_yyyymm varchar(20))
  RETURNS DECIMAL(6, 2)
BEGIN
DECLARE var_name DOUBLE(6,2);
  SELECT dfee INTO var_name
    FROM feegen
    WHERE studentID = param_studentID AND yyyymm=param_yyyymm AND feetypesID=12 ;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getFeetypesname`
--
CREATE FUNCTION getFeetypesname(param_feetypeID int)
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  SELECT
    feetypes INTO var_name
  FROM feetypes
  WHERE feetypesID = param_feetypeID;
  RETURN var_name;
END
$$

--
-- Create function `getfeetypesIDdel`
--
CREATE FUNCTION getfeetypesIDdel(param_feetypes VARCHAR(220))
  RETURNS INT(11)
BEGIN
  DECLARE var_name int;
  SELECT
    feetypesID INTO var_name
  FROM feetypes
  WHERE feetypes = `param_feetypes`;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `gethostelstatus`
--
CREATE FUNCTION gethostelstatus(param_studentID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
     IF(COUNT(studentID)>0, "1", "0") INTO var_name
  FROM hmember
  WHERE studentID = param_studentID AND active=1;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getschoolyear`
--
CREATE FUNCTION getschoolyear(param_schoolyearID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT schoolyear INTO var_name
  FROM schoolyear
  WHERE schoolyearID = param_schoolyearID;
  RETURN var_name;
END
$$

DELIMITER ;

DELIMITER $$

--
-- Create function `getstudentgroup`
--
CREATE FUNCTION getstudentgroup(param_groupID int(2))
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    `group` INTO var_name
  FROM studentgroup
  WHERE studentgroupID = param_groupID;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `gettransportstatus`
--
CREATE FUNCTION gettransportstatus(param_studentID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
     IF(COUNT(studentID)>0, "1", "0") INTO var_name
  FROM tmember
  WHERE studentID = param_studentID AND active=1;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getusertype`
--
CREATE FUNCTION getusertype(param_usertypeID INT)
  RETURNS VARCHAR(30) CHARSET utf8
BEGIN
  DECLARE var_name varchar(30);
  SELECT
    usertype INTO var_name
  FROM usertype
  WHERE usertypeID = param_usertypeID;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getclassesdel`
--
CREATE FUNCTION getclassesdel(`param_classes` VARCHAR(20))
  RETURNS INT(11)
BEGIN
  DECLARE var_name int;
  SELECT
    classesID INTO var_name
  FROM classes
  WHERE classes = param_classes;
  RETURN var_name;
END
$$

--
-- Create function `getclasses`
--
CREATE FUNCTION getclasses(param_classesID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    classes INTO var_name
  FROM classes
  WHERE classesID = param_classesID;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getsectiondel`
--
CREATE FUNCTION getsectiondel(`param_classesID` INT, `param_section` VARCHAR(20))
  RETURNS INT(11)
BEGIN
  DECLARE var_name int;
  SELECT
    sectionID INTO var_name
  FROM section
  WHERE classesID = param_classesID AND LCASE(section) = LCASE(param_section);
  RETURN var_name;
END
$$

--
-- Create function `getsection`
--
CREATE FUNCTION getsection(param_sectionID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    section INTO var_name
  FROM section
  WHERE sectionID = param_sectionID;
  RETURN var_name;
END
$$

DELIMITER ;



DELIMITER $$

--
-- Create function `getstuphone`
--
CREATE FUNCTION getstuphone(param_studentID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    phone INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getstudentname`
--
CREATE FUNCTION getstudentname(param_studentID int)
  RETURNS VARCHAR(90) CHARSET utf8
BEGIN
  DECLARE var_name varchar(90);
  SELECT
    name INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getstudent`
--
CREATE FUNCTION getstudent(param_studentID int)
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  SELECT CONCAT('"',student.name, '","',student.sex, '","',student.email, '","',student.phone, '","',student.roll,'","',student.active,'","',IF(student.registerNO IS NULL OR student.registerNO = '', 'NA', student.registerNO),'"') INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getsectionID`
--
CREATE FUNCTION getsectionID(param_studentID INT)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
DECLARE var_name VARCHAR(20);
  SELECT sectionID INTO var_name
    FROM student
    WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getroll`
--
CREATE FUNCTION getroll(param_studentID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    roll INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getregisterNO`
--
CREATE FUNCTION getregisterNO(param_studentID int)
  RETURNS VARCHAR(40) CHARSET utf8
BEGIN
  DECLARE var_name varchar(40);
  SELECT
    registerNO INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getphone`
--
CREATE FUNCTION getphone(param_usertypeID int(11),param_userID int(11))
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  IF param_usertypeID = 1 THEN
    SELECT
      phone INTO var_name
    FROM systemadmin
    WHERE systemadminID = param_userID;
  ELSEIF param_usertypeID = 2 THEN
    SELECT
      phone INTO var_name
    FROM teacher
    WHERE teacherID = param_userID;
  ELSEIF param_usertypeID = 3 THEN
    SELECT
      phone INTO var_name
    FROM student
    WHERE studentID = param_userID;
   
  ELSEIF param_usertypeID > 4 THEN
    SELECT
      phone INTO var_name
    FROM `user`
    WHERE userID = param_userID;
  ELSE
    SET var_name = NULL;

  END IF;
  RETURN var_name;
END
$$

--
-- Create function `getparentname`
--
CREATE FUNCTION getparentname(param_studentID int)
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  SELECT
    guardianname INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getname`
--
CREATE FUNCTION getname(param_userID int, param_usertypeID int)
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  IF param_usertypeID = 1 THEN
    SELECT
      `name` INTO var_name
    FROM systemadmin
    WHERE systemadminID = param_userID;
  ELSEIF param_usertypeID = 2 THEN
    SELECT
      `name` INTO var_name
    FROM teacher
    WHERE teacherID = param_userID;
  ELSEIF param_usertypeID = 3 THEN
    SELECT
      `name` INTO var_name
    FROM student
    WHERE studentID = param_userID;
  ELSEIF param_usertypeID = 4 THEN
    SELECT
      `name` INTO var_name
    FROM parents
    WHERE parentsID = param_userID;
  ELSEIF param_usertypeID > 4 THEN
    SELECT
      `name` INTO var_name
    FROM `user`
    WHERE userID = param_userID;
  ELSE
    SET var_name = NULL;

  END IF;
  RETURN var_name;
END
$$

--
-- Create function `getmothername`
--
CREATE FUNCTION getmothername(param_studentID INT)
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  SELECT
    mother_name INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getfathername`
--
CREATE FUNCTION getfathername(param_studentID INT)
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  SELECT
    father_name INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getemployeeID`
--
CREATE FUNCTION getemployeeID(param_usertypeID int(11),param_userID int(11))
  RETURNS VARCHAR(80) CHARSET utf8
BEGIN
  DECLARE var_name varchar(80);
  IF param_usertypeID = 1 THEN
    SELECT
      employeecode INTO var_name
    FROM systemadmin
    WHERE systemadminID = param_userID;
  ELSEIF param_usertypeID = 2 THEN
    SELECT
      employeecode INTO var_name
    FROM teacher
    WHERE teacherID = param_userID;
  ELSEIF param_usertypeID = 3 THEN
    SELECT
      registerNO INTO var_name
    FROM student
    WHERE studentID = param_userID;
   
  ELSEIF param_usertypeID > 4 THEN
    SELECT
      employeecode INTO var_name
    FROM `user`
    WHERE userID = param_userID;
  ELSE
    SET var_name = NULL;

  END IF;
  RETURN var_name;
END
$$

--
-- Create function `getclassesID`
--
CREATE FUNCTION getclassesID(param_studentID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
    classesID INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

--
-- Create function `getactive`
--
CREATE FUNCTION getactive(param_studentID int)
  RETURNS INT(11)
BEGIN
  DECLARE var_name int;
  SELECT
    active INTO var_name
  FROM student
  WHERE studentID = param_studentID;
  RETURN var_name;
END
$$

DELIMITER ;

DELIMITER $$

--
-- Create function `getstudentexamno`
--
CREATE FUNCTION getstudentexamno(param_studentID int(11),param_school int(3))
  RETURNS VARCHAR(10) CHARSET utf8
BEGIN
  DECLARE var_name varchar(10);
  SELECT
    studentexamno INTO var_name
  FROM studentclasses
  WHERE studentID = param_studentID AND schoolyearID=param_school;
  RETURN var_name;
END
$$

DELIMITER ;

--
-- Create table `studenthouse`
--
CREATE TABLE studenthouse (
  studenthouseID INT(11) NOT NULL AUTO_INCREMENT,
  sortname VARCHAR(6) DEFAULT NULL,
  house VARCHAR(40) NOT NULL,
  PRIMARY KEY (studenthouseID)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

DELIMITER $$

--
-- Create function `gethousedel`
--
CREATE FUNCTION gethousedel(param_housename varchar(255))
  RETURNS INT(11)
BEGIN
  DECLARE var_name INT;
  SELECT
    studenthouseID INTO var_name
  FROM studenthouse
  WHERE house = param_housename;
  RETURN var_name;
END
$$

--
-- Create function `gethouse`
--
CREATE FUNCTION gethouse(param_studenthouseID int)
  RETURNS VARCHAR(40) CHARSET utf8
BEGIN
  DECLARE var_name varchar(40);
  SELECT
    house INTO var_name
  FROM studenthouse
  WHERE studenthouseID = param_studenthouseID;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getsubject`
--
CREATE FUNCTION getsubject(param_subjectID int)
  RETURNS VARCHAR(50) CHARSET utf8
BEGIN
  DECLARE var_name varchar(50);
  SELECT
    `subject` INTO var_name
  FROM `subject`
  WHERE subjectID = param_subjectID;
  RETURN var_name;
END
$$

DELIMITER ;

DELIMITER $$

--
-- Create function `getexamparentID`
--
CREATE FUNCTION getexamparentID(pexamID int(3))
  RETURNS INT(3)
BEGIN
  DECLARE var_name int(3);
  SELECT
    examparentID INTO var_name
  FROM exam
  WHERE examID = pexamID;
  RETURN var_name;
END
$$

--
-- Create function `getexam`
--
CREATE FUNCTION getexam(pexamID int (3))
  RETURNS VARCHAR(30) CHARSET utf8
BEGIN
  DECLARE var_name varchar(30);
  SELECT
    exam INTO var_name
  FROM exam
  WHERE examID = pexamID;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getactivityName`
--
CREATE FUNCTION getactivityName(`param_activitieID` INT)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name VARCHAR(20);
  SELECT
    title INTO var_name
  FROM activitiescategory
  WHERE `activitiescategoryID` = param_activitieID;
  RETURN var_name;
END
$$

DELIMITER ;


DELIMITER $$

--
-- Create function `getlibrarystatus`
--
CREATE FUNCTION getlibrarystatus(param_studentID int)
  RETURNS VARCHAR(20) CHARSET utf8
BEGIN
  DECLARE var_name varchar(20);
  SELECT
     IF(COUNT(studentID)>0, "1", "0") INTO var_name
  FROM lmember
  WHERE studentID = param_studentID AND active=1;
  RETURN var_name;
END
$$

DELIMITER ;
