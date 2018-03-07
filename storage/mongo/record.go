package mongo

import (
	"time"

	"github.com/plutoshe/knowledge/helper"
	"gopkg.in/mgo.v2"
)

type RecordItem struct {
	RecordId     string    `json:"RecordId" bson:"_id"`
	Front        []Content `json:"Front" bson:"front"`
	Back         []Content `json:"Back" bson:"back"`
	CreateDate   time.Time `json:"CreateDate" bson:"create_date"`
	ReviewDate   time.Time `json:"review_date" bson:"review_date"`
	RememberDate time.Time `json:"RememberDate" bson:"remember_date"`
	Tags         []string  `json:"Tags" bson:"tags"`
	Reminder     int       `json:"Reminder" bson:"reminder"`
}

type Content struct {
	Form  string `json:"form" bson:"form"`
	Data  string `json:"data" bson:"data"`
	Cover int    `json:"Cover"`
}

type RecordMongo struct {
	RecordMongoDB   string
	RecordMongoColl string
	RecordMongoAddr string
	RecordSession   *mgo.Session
	// waitGroup       sync.WaitGroup
	RelinkNum int
}

func NewRecordMongo(recordMongoAddr, recordMongoDB, recordMongoColl string, relinkNum int) *RecordMongo {
	return &RecordMongo{
		RecordMongoAddr: recordMongoAddr,
		RecordMongoDB:   recordMongoDB,
		RecordMongoColl: recordMongoColl,
		RecordSession:   helper.MustCreateMongoSession(recordMongoAddr),
		RelinkNum:       relinkNum,
	}
}

func (r *RecordMongo) Close() {
	r.RecordSession.Close()
}
