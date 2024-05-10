package storage

import (
	"data-generator/config"
	"data-generator/models"
	"database/sql"
	"fmt"
	"runtime"

	_ "github.com/lib/pq"
)

type Storage struct {
	db *sql.DB
}

func New(cfg config.Config) (*Storage, error) {
	// connection string
	conn := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.Db)
	// connect to db
	db, err := sql.Open("postgres", conn)
	if err != nil {
		return nil, err
	}
	db.SetMaxOpenConns(runtime.GOMAXPROCS(0))
	return &Storage{db: db}, nil
}

func (s *Storage) SaveUser(user models.User) error {
	insertStatment := `INSERT INTO stage.user(
		user_number, 
		user_name,
		user_email,
		user_phone_number,
		date_login,
		date_load) 
	VALUES ($1, $2, $3, $4, $5, $6)`

	_, err := s.db.Exec(insertStatment,
		user.User_number,
		user.User_name,
		user.User_email,
		user.User_phone_number,
		user.Date_login,
		user.Date_load)
	return err
}

func (s *Storage) SaveOrder(order models.Order) error {
	insertStatment := `INSERT INTO stage.order(
		order_number,
		product_number,
		user_number,
		order_description,
		date_order,
		date_load)
	VALUES ($1, $2, $3, $4, $5, $6)`

	_, err := s.db.Exec(insertStatment,
		order.Order_number,
		order.Product_number,
		order.User_number,
		order.Order_description,
		order.Date_order,
		order.Date_load)
	return err
}

func (s *Storage) SaveProduct(product models.Product) error {
	insertStatment := `INSERT INTO stage.product(
		product_number, 
		product_name,
		product_description,
		product_category,
		date_product,
		date_load) 
	VALUES ($1, $2, $3, $4, $5, $6)`

	_, err := s.db.Exec(insertStatment,
		product.Product_number,
		product.Product_name,
		product.Product_description,
		product.Product_category,
		product.Date_product,
		product.Date_load)
	return err
}
