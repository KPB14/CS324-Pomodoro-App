
DROP TABLE IF EXISTS PasswordResetTokens;
DROP TABLE IF EXISTS UserSessions;
DROP TABLE IF EXISTS UserSettings;
DROP TABLE IF EXISTS Subtasks;
DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
	users_id INT AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(100) NOT NULL UNIQUE,
	display_name VARCHAR(50),
	password_hash VARCHAR(255) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE Tasks (
	task_id INT AUTO_INCREMENT PRIMARY KEY, 
	users_id INT NOT NULL,
	title VARCHAR(100) NOT NULL,
	description VARCHAR(255),
	priority ENUM('Low','Medium','High') ,
	due_date DATETIME, 
	is_completed BOOLEAN DEFAULT FALSE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	completed_at DATETIME DEFAULT NULL, 
	focus_duration INT DEFAULT NULL,
	short_break_duration INT DEFAULT NULL, 
	long_break_duration INT DEFAULT NULL,
	
	-- Constraints 
	CONSTRAINT chk_task_focus
	CHECK (focus_duration IS NULL OR focus_duration > 0),
	
	CONSTRAINT chk_task_shortbreak
	CHECK (short_break_duration IS NULL OR short_break_duration > 0),
	
	CONSTRAINT chk_task_longbreak
	CHECK (long_break_duration IS NULL OR long_break_duration > 0),
	
	-- Foreign Keys
	FOREIGN KEY (users_id)
		REFERENCES Users(users_id)
		ON DELETE CASCADE
		

	
);

CREATE TABLE Subtasks (
	subtask_id INT AUTO_INCREMENT PRIMARY KEY,
	task_id INT NOT NULL,
	title VARCHAR(100) NOT NULL,
	description VARCHAR(255), 
	priority ENUM('Low','Medium','High'),
	due_date DATETIME,
	is_completed BOOLEAN DEFAULT FALSE,
	completed_at DATETIME DEFAULT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	focus_duration INT DEFAULT NULL,
	short_break_duration INT DEFAULT NULL,
	long_break_duration INT DEFAULT NULL,
	
	-- Constraints 
	CONSTRAINT chk_subtask_focus
	CHECK (focus_duration IS NULL OR focus_duration > 0),
	
	CONSTRAINT chk_subtask_shortbreak
	CHECK (short_break_duration IS NULL OR short_break_duration > 0),
	
	CONSTRAINT chk_subtask_longbreak
	CHECK (long_break_duration IS NULL OR long_break_duration > 0),
	-- Foreign Keys
	FOREIGN KEY (task_id)
		REFERENCES Tasks(task_id)
		ON DELETE CASCADE
		

	
);

CREATE TABLE UserSettings (
	users_id INT PRIMARY KEY,
	focus_duration INT NOT NULL DEFAULT  25,
	short_break_duration INT NOT NULL DEFAULT 5,
	long_break_duration INT NOT NULL DEFAULT 15,
	sound_enabled BOOLEAN NOT NULL DEFAULT FALSE,
	reminders_enabled BOOLEAN NOT NULL DEFAULT FALSE,
	current_task_id INT DEFAULT NULL,
	current_subtask_id INT DEFAULT NULL,
	
	-- Constraints 
	CONSTRAINT chk_settings_focus
	CHECK (focus_duration > 0),
	
	CONSTRAINT chk_settings_shortbreak
	CHECK (short_break_duration > 0),
	
	CONSTRAINT chk_settings_longbreak
	CHECK (long_break_duration > 0),
	
	-- Foreign Keys
	FOREIGN KEY (users_id)
		REFERENCES Users(users_id)
		ON DELETE CASCADE,
		
	FOREIGN KEY (current_task_id)
		REFERENCES Tasks(task_id)
		ON DELETE SET NULL,
	
	FOREIGN KEY (current_subtask_id)
		REFERENCES Subtasks(subtask_id)
		ON DELETE SET NULL


);

CREATE TABLE UserSessions (
	session_id INT AUTO_INCREMENT PRIMARY KEY,
	users_id INT NOT NULL,
	task_id INT NULL,
	subtask_id INT NULL,
	duration_minutes INT NOT NULL,
	completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	
	-- Constraints 
	CONSTRAINT chk_session_duration
	CHECK (duration_minutes > 0),
	
	-- Indexes
	INDEX indx_sessions_user_date (users_id, completed_at),

	-- Foreign Keys
	FOREIGN KEY (users_id)
		REFERENCES Users(users_id)
		ON DELETE CASCADE,
	
	FOREIGN KEY (task_id)
		REFERENCES Tasks(task_id)
		ON DELETE SET NULL,
		
	FOREIGN KEY (subtask_id) 
		REFERENCES Subtasks(subtask_id)
		ON DELETE SET NULL
);

CREATE TABLE PasswordResetTokens(
	reset_id INT AUTO_INCREMENT PRIMARY KEY,
	users_id INT NOT NULL,
	token_hash CHAR(64) NOT NULL UNIQUE,
	expires_at DATETIME NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	
	FOREIGN KEY (users_id)
		REFERENCES Users(users_id)
		ON DELETE CASCADE
);



