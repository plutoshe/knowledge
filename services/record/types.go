package record

import (
	"github.com/plutoshe/knowledge/storage/mongo"
)

// addition interface type
type AddtionContent struct {
	Form  string `json:"Form"`
	Data  string `json:"Data"`
	Cover int    `json:"Cover"`
}

type AddtionBody struct {
	FrontContent []mongo.Content `json:"FrontContent"`
	BackContent  []mongo.Content `json:"BackContent"`
	Tags         []string        `json:"Tags"`
	Reminder     int             `json:"Reminder"`
	ReviewDate   int64           `json:"ReviewDate"`
	CreateDate   int64           `json:"CreateDate"`
	RememberDate int64           `json:"RememberDate"`
}

// review query type
