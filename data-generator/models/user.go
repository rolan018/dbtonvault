package models

import "time"

type User struct {
	User_number       int
	User_name         string
	User_email        string
	User_phone_number int
	Date_login        time.Time
	Date_load         time.Time
}
