package generator

import (
	"data-generator/models"
	"fmt"
	"math/rand"
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
	source := rand.NewSource(rand.Int63())
	fake := faker.NewWithSeed(source)

	phoneNumber := fake.IntBetween(min, max)

	date := getDate(fake)
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
	source := rand.NewSource(rand.Int63())
	fake := faker.NewWithSeed(source)

	fuelType := fake.Car().FuelType()
	gearType := fake.Car().TransmissionGear()

	date := getDate(fake)
	dateProduct, _ := time.Parse(timeLayout, date)
	dateLoad, _ := time.Parse(timeLayout, dateLoadString)

	return models.Product{Product_number: productNumber,
		Product_name:     fake.Car().Maker(),
		Fuel_type:        fuelType,
		Gear_type:        gearType,
		Product_category: fake.Car().Category(),
		Date_product:     dateProduct,
		Date_load:        dateLoad}
}

func GenerateOrder(orderNumber int, dateLoadString string, user models.User, product models.Product) models.Order {
	source := rand.NewSource(rand.Int63())
	fake := faker.NewWithSeed(source)

	description := fake.Address().State()

	date := getDate(fake)
	dateOrder, _ := time.Parse(timeLayout, date)
	dateLoad, _ := time.Parse(timeLayout, dateLoadString)

	return models.Order{Order_number: orderNumber,
		Product_number:    product.Product_number,
		User_number:       user.User_number,
		Order_description: description,
		Date_order:        dateOrder,
		Date_load:         dateLoad}
}

func getDate(fake faker.Faker) string {
	dayOfMonth := fmt.Sprintf("%d", fake.Int16Between(1, 28))
	if len(dayOfMonth) == 1 {
		dayOfMonth = fmt.Sprintf("0%s", dayOfMonth)
	}
	month := fmt.Sprintf("%d", fake.Int16Between(1, 12))
	if len(month) == 1 {
		month = fmt.Sprintf("0%s", month)
	}
	date := fmt.Sprintf("%s-%s-%d", month, dayOfMonth, yearProduct)
	return date
}
