package generator

import (
	"data-generator/models"
	"fmt"
	"time"

	"github.com/jaswdr/faker"
)

const (
	min         = 80000000000
	max         = 90000000000
	yearLogin   = 2023
	yearProduct = 2022
	timeLayout  = "01-02-2006"
)

func GenerateUser(userNumber int, dateLoadString string) models.User {
	fake := faker.New()

	phoneNumber := fake.IntBetween(min, max)

	dayOfMonth := fake.Time().DayOfMonth()
	month := fake.IntBetween(1, 12)
	date := fmt.Sprintf("%d-%d-%d", dayOfMonth, month, yearLogin)

	dateLogin, _ := time.Parse(timeLayout, date)
	dateLoad, _ := time.Parse(timeLayout, dateLoadString)

	return models.User{User_number: userNumber,
		User_name:         fake.Person().FirstName(),
		User_email:        fake.Internet().Email(),
		User_phone_number: phoneNumber,
		Date_login:        dateLogin,
		Date_load:         dateLoad}
}

func GenerateProduct(productNumber int, dateLoadString string) models.Product {
	fake := faker.New()

	description := fmt.Sprintf("Fuel Type:%s, Transmission:%s",
		fake.Car().FuelType(),
		fake.Car().TransmissionGear())
	dayOfMonth := fake.Time().DayOfMonth()
	month := fake.Time().Month()
	date := fmt.Sprintf("%d-%d-%d", dayOfMonth, month, yearProduct)

	dateProduct, _ := time.Parse(timeLayout, date)
	dateLoad, _ := time.Parse(timeLayout, dateLoadString)

	return models.Product{Product_number: productNumber,
		Product_name:        fake.Car().Maker(),
		Product_description: description,
		Product_category:    fake.Car().Category(),
		Date_product:        dateProduct,
		Date_load:           dateLoad}
}

func GenerateOrder(orderNumber int, dateLoadString string, user models.User, product models.Product) models.Order {
	fake := faker.New()

	description := fake.Address().State()
	dayOfMonth := fake.Time().DayOfMonth()
	month := fake.Time().Month()

	date := fmt.Sprintf("%d-%d-%d", dayOfMonth, month, yearProduct)

	dateOrder, _ := time.Parse(timeLayout, date)
	dateLoad, _ := time.Parse(timeLayout, dateLoadString)

	return models.Order{Order_number: orderNumber,
		Product_number:    product.Product_number,
		User_number:       user.User_number,
		Order_description: description,
		Date_order:        dateOrder,
		Date_load:         dateLoad}
}
