package mongo

import (
	"time"

	"github.com/plutoshe/knowledge/helper"
	"gopkg.in/mgo.v2"
)

// Type config

type ReviewIndex struct {
	IndexName    string    `json:"index_name" bson:"index_name"`
	CreateDate   time.Time `json:"create_date" bson:"create_date"`
	ReviewDate   int       `json:"review_date" bson:"review_date"`
	RememberDate time.Time `json:"remember_date" bson:"remember_date"`
	ReviewItems  []string  `json:"review_items" bson:"review_items"`
}

// Mongo config
type IndexMongo struct {
	IndexMongoDB   string
	IndexMongoColl string
	IndexMongoAddr string
	IndexSession   *mgo.Session
	ReviewIndex    string
	RelinkNum      int
}

func NewIndexMongo(IndexMongoAddr, IndexMongoDB, IndexMongoColl string, relinkNum int) *IndexMongo {
	return &IndexMongo{
		IndexMongoAddr: IndexMongoAddr,
		IndexMongoDB:   IndexMongoDB,
		IndexMongoColl: IndexMongoColl,
		IndexSession:   helper.MustCreateMongoSession(IndexMongoAddr),
		RelinkNum:      relinkNum,
	}
}

func (r *IndexMongo) Close() {
	r.IndexSession.Close()
}
