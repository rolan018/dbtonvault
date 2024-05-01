package generator

import (
	"data-generator/models"
	"fmt"

	"github.com/jaswdr/faker"
)

const (
	min         = 80000000000
	max         = 90000000000
	yearLogin   = 2023
	yearProduct = 2022
)

func GenerateUser(userNumber int, dateLoad string) models.User {
	fake := faker.New()

	phoneNumber := fake.IntBetween(min, max)

	dayOfMonth := fake.Time().DayOfMonth()
	month := fake.Time().Month()
	dateLogin := fmt.Sprintf("%d-%d-%d", dayOfMonth, month, yearLogin)

	return models.User{User_number: userNumber,
		User_name:         fake.Person().FirstName(),
		User_email:        fake.Internet().Email(),
		User_phone_number: phoneNumber,
		Date_login:        dateLogin,
		Date_load:         dateLoad}
}

func GenerateProduct(productNumber int, dateLoad string) models.Product {
	fake := faker.New()

	description := fmt.Sprintf("Fuel Type:%s, Transmission:%s",
		fake.Car().FuelType(),
		fake.Car().TransmissionGear())
	dayOfMonth := fake.Time().DayOfMonth()
	month := fake.Time().Month()
	dateProduct := fmt.Sprintf("%d-%d-%d", dayOfMonth, month, yearProduct)

	return models.Product{Product_number: productNumber,
		Product_name:        fake.Car().Maker(),
		Product_description: description,
		Product_category:    fake.Car().Category(),
		Date_product:        dateProduct,
		Date_load:           dateLoad}
}

func GenerateOrder(orderNumber int, dateLoad string) models.Product {
	fake := faker.New()

	description := fmt.Sprintf("Fuel Type:%s, Transmission:%s",
		fake.Car().FuelType(),
		fake.Car().TransmissionGear())
	dayOfMonth := fake.Time().DayOfMonth()
	month := fake.Time().Month()
	dateProduct := fmt.Sprintf("%d-%d-%d", dayOfMonth, month, yearProduct)

	return models.Product{Product_number: productNumber,
		Product_name:        fake.Car().Maker(),
		Product_description: description,
		Product_category:    fake.Car().Category(),
		Date_product:        dateProduct,
		Date_load:           dateLoad}
}
