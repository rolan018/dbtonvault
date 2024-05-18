package config

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"strconv"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Host     string `yaml:"host" env-required:"true"`
	Port     int    `yaml:"port" env-required:"true"`
	User     string `yaml:"user" env-required:"true"`
	Password string `yaml:"password" env-required:"true"`
	Db       string `yaml:"db" env-required:"true"`
}

func EnvLoad() Config {

	cfg, err := loadArgs()
	if err == nil {
		return cfg
	}
	cfg, err = loadConfig()
	if err == nil {
		return cfg
	}
	fmt.Println(err)
	panic("provide config path option or CONFIG_PATH env. or hostname port username password db")
}

// load arguments from command line
func loadArgs() (Config, error) {
	arguments := os.Args
	if len(arguments) < 6 {
		return Config{}, errors.New("provide: hostname port username password db")
	}
	host := arguments[1]
	port, err := strconv.Atoi(arguments[2])
	if err != nil {
		return Config{}, errors.New("provide valid port")
	}
	user := arguments[3]
	pass := arguments[4]
	database := arguments[5]

	return Config{Host: host, Port: port, User: user, Password: pass, Db: database}, nil
}

func loadConfig() (Config, error) {
	var cfg Config

	path := loadConfigPath()

	if _, err := os.Stat(path); os.IsNotExist(err) {
		return Config{}, errors.New("config file doesn't exist: " + path)
	}

	if err := cleanenv.ReadConfig(path, &cfg); err != nil {
		return Config{}, errors.New("Failed to read config: " + err.Error())
	}
	return cfg, nil
}

// Load config from path
// priority: flag -> env. -> default
func loadConfigPath() string {
	var res string

	// --config="path/to/config.yaml"
	flag.StringVar(&res, "config", "", "path to config file")
	flag.Parse()

	if res == "" {
		res = os.Getenv("CONFIG_PATH")
	}
	if res == "" {
		res = "../data-generator/config/config.yaml"
	}

	return res
}
