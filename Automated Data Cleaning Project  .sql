-- Automated Data Cleaning

select * from us_household_income;

select * from ushouseholdincome_back_up;



delimiter $$
drop procedure if exists Copy_and_Clean_Data;
CREATE PROCEDURE Copy_and_Clean_Data()
BEGIN
 -- Creating the table
	CREATE TABLE if not exists `us_household_income_Cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` int DEFAULT NULL,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	  `TimeStamp` timestamp DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
	-- COPY DATA to NEW TABLE
	insert into
	us_household_income_Cleaned
	select * , current_timestamp
	from ushouseholdincome_back_up;
    
	-- Remove Duplicates
	DELETE FROM us_household_income_Cleaned
	WHERE 
		row_id IN (
		SELECT row_id
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id,`TimeStamp`
				ORDER BY id, `TimeStamp`) AS row_num
		FROM 
			us_household_income_Cleaned
	) duplicates
	WHERE 
		row_num > 1
	);

	-- Fixing some data quality issues by fixing typos and general standardization
	UPDATE us_household_income_Cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE us_household_income_Cleaned
	SET County = UPPER(County);

	UPDATE us_household_income_Cleaned
	SET City = UPPER(City);

	UPDATE us_household_income_Cleaned
	SET Place = UPPER(Place);

	UPDATE us_household_income_Cleaned
	SET State_Name = UPPER(State_Name);

	UPDATE us_household_income_Cleaned
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE us_household_income_Cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';
END $$
delimiter ;

call Copy_and_Clean_Data();

-- CREATE EVENT
DROP EVENT run_data_cleaning;
CREATE EVENT run_data_cleaning
	ON schedule every 2 minute
    DO call Copy_and_Clean_Data();

-- CREATE TRIGGER
DELIMITER $$
create trigger Transfer_clean_data
	AFTER INSERT ON ushouseholdincome_back_up
	FOR EACH ROW
    
    BEGIN
		call Copy_and_Clean_Data();
    END $$
    DELIMITER ;
;

INSERT INTO ushouseholdincome_back_up 
(`row_id`, `id`, `State_Code`, `State_Name`, `State_ab`, `County`, `City`, `Place`, `Type`, `Primary`, `Zip_Code`, `Area_Code`, `ALand`, `AWater`, `Lat`, `Lon`)
VALUES (121671, 37025904, 37, 'NORTH Carolina', 'NC', 'Alamance Country', 'Charlotte', 'Alamance', 'Track', 'Track', 28215, 980, 24011255, 98062070, 35.2661197, -80.6865346);




-- Debugging OR Checking SP WORKS

	SELECT row_id,id,row_num
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id
				ORDER BY id) AS row_num
		FROM 
			us_household_income_Cleaned
	) duplicates
	WHERE 
		row_num > 1
	;
    
    SELECT count(row_id)
    from us_household_income_Cleaned;
    
    SELECT State_Name, count(State_Name)
    from us_household_income_Cleaned
    GROUP BY State_Name;