package mongo

import (
	"time"

	"github.com/plutoshe/knowledge/helper"
	"gopkg.in/mgo.v2"
)

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

type RecordItem struct {
	RecordId   *string    `json:"record_id" bson:"_id"`
	Front      *[]Content `json:"front" bson:"front"`
	Back       *[]Content `json:"back" bson:"back"`
	CreateAt   *time.Time `json:"create_at" bson:"create_at"`
	ReviewDate *time.Time `json:"review_date" bson:"review_date"`
	Tags       *[]string  `json:"tags" bson:"tags"`
	Reminder   *int       `json:"reminder", bson:"reminder"`
}

type Content struct {
	Form string `json:"form" bson:"form"`
	Data string `json:"data" bson:"data"`
}
