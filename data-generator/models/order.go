package models

import "time"

type Order struct {
	Order_number      int
	Product_number    int
	User_number       int
	Order_description string
	Date_order        time.Time
	Date_load         time.Time
}
