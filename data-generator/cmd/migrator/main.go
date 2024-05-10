package main

import (
	migrator "data-generator/cmd/migrator/psqlmigrator"
	"data-generator/config"
	"database/sql"
	"embed"
	"fmt"
)

const (
	migrationsDir = "migrations"
	// mode must be up or down
	mode = "up"
)

//go:embed migrations/*.sql
var MigrationsFS embed.FS

func main() {
	cfg := config.EnvLoad()

	// Create Migrator
	migrator := migrator.NewMigrator(MigrationsFS, migrationsDir)

	// Get the DB instance
	connectionStr := fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable",
		cfg.User,
		cfg.Password,
		cfg.Host,
		cfg.Port,
		cfg.Db)
	conn, err := sql.Open("postgres", connectionStr)
	if err != nil {
		panic(err)
	}

	defer conn.Close()

	// Apply migrations
	if mode == "up" {
		err = migrator.UpMigrations(conn)
	} else if mode == "down" {
		err = migrator.DownMigrations(conn)
	} else {
		panic("mode parameter must be up or down")
	}
	if err != nil {
		panic(err)
	}

	fmt.Printf("Migrations applied!!")
}
