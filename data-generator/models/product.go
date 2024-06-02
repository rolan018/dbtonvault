package models

import "time"

type Product struct {
	Product_number   int
	Product_name     string
	Fuel_type        string
	Gear_type        string
	Product_category string
	Date_product     time.Time
	Date_load        time.Time
}
